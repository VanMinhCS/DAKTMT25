import cv2
import time
import numpy as np
from ultralytics import YOLO
import argparse
import os
from datetime import datetime

def detect_leaf_disease_camera():
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='Detect leaf diseases via camera using YOLOv11')
    parser.add_argument('--model', type=str, default='plant_disease.pt', help='Path to the model file')
    parser.add_argument('--conf', type=float, default=0.25, help='Confidence threshold')
    parser.add_argument('--camera', type=int, default=0, help='Camera ID (0 is the default camera)')
    parser.add_argument('--save', action='store_true', help='Save the resulting video')
    parser.add_argument('--show-fps', action='store_true', help='Show FPS')
    args = parser.parse_args()
    
    # Load the model
    try:
        print(f"Loading model from {args.model}...")
        model = YOLO(args.model)
        print("Model loaded successfully!")
    except Exception as e:
        print(f"Error loading model: {e}")
        return
    
    # Initialize camera
    try:
        print(f"Connecting to camera {args.camera}...")
        cap = cv2.VideoCapture(args.camera)
        if not cap.isOpened():
            print("Error: Could not connect to camera.")
            return
            
        # Get frame size information
        frame_width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
        frame_height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
        fps = int(cap.get(cv2.CAP_PROP_FPS))
        
        print(f"Connected to camera: {frame_width}x{frame_height} @ {fps}fps")
    except Exception as e:
        print(f"Error initializing camera: {e}")
        return
        
    # Prepare video writer if saving is enabled
    output_video = None
    if args.save:
        os.makedirs("detections", exist_ok=True)
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        output_path = f"detections/leaf_disease_{timestamp}.mp4"
        
        # Initialize VideoWriter with H264 codec
        fourcc = cv2.VideoWriter_fourcc(*'mp4v')
        output_video = cv2.VideoWriter(output_path, fourcc, fps, (frame_width, frame_height))
        print(f"Video will be saved to: {output_path}")

    # Colors for different leaf disease classes (HSV for better distinction)
    np.random.seed(42)
    colors = {}  # Dictionary to store colors for each class
    
    # Variables for FPS calculation
    prev_time = 0
    fps_array = []
    
    print("Press 'q' to quit, 's' to take a snapshot")
    
    try:
        while True:
            # Read frame from camera
            ret, frame = cap.read()
            if not ret:
                print("Could not read frame from camera.")
                break
                
            # Start time measurement
            current_time = time.time()
            
            # Perform prediction
            results = model(frame, conf=args.conf)
            result = results[0]  # Get the first result
            
            # Calculate and display FPS
            if args.show_fps:
                fps = 1.0 / (current_time - prev_time) if (current_time - prev_time) > 0 else 0
                fps_array.append(fps)
                if len(fps_array) > 30:  # Average over 30 frames
                    fps_array.pop(0)
                avg_fps = sum(fps_array) / len(fps_array)
                prev_time = current_time
                
                # Display FPS
                cv2.putText(frame, f"FPS: {avg_fps:.1f}", (20, 40), cv2.FONT_HERSHEY_SIMPLEX, 
                           1, (0, 255, 0), 2)
                
            # Draw bounding boxes and labels
            boxes = result.boxes
            for box in boxes:
                # Get coordinates
                x1, y1, x2, y2 = box.xyxy[0].cpu().numpy().astype(int)
                
                # Get class and disease name
                cls_id = int(box.cls[0].item())
                class_name = result.names[cls_id]
                
                # Get confidence score
                confidence = box.conf[0].item()
                
                # Create color for the class if it doesn't exist
                if cls_id not in colors:
                    colors[cls_id] = (np.random.randint(0, 255), 
                                    np.random.randint(0, 255), 
                                    np.random.randint(0, 255))
                
                # Draw bounding box
                color = colors[cls_id]
                cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
                
                # Display label with disease name and confidence
                label = f"{class_name} ({confidence:.2f})"
                text_size = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.6, 2)[0]
                
                # Create a background for the text
                cv2.rectangle(frame, (x1, y1 - text_size[1] - 10), (x1 + text_size[0], y1), color, -1)
                cv2.putText(frame, label, (x1, y1 - 5), cv2.FONT_HERSHEY_SIMPLEX, 
                           0.6, (255, 255, 255), 2)
            
            # Display the number of detected diseases
            num_detections = len(boxes)
            detection_text = f"Detections: {num_detections} leaf diseases"
            cv2.putText(frame, detection_text, (20, frame_height - 20), 
                       cv2.FONT_HERSHEY_SIMPLEX, 0.8, (255, 255, 255), 2)
            
            # Show the frame
            cv2.imshow("Plant Disease Detection", frame)
            
            # Save video if enabled
            if args.save and output_video is not None:
                output_video.write(frame)
                
            # Check for key presses
            key = cv2.waitKey(1) & 0xFF
            if key == ord('q'):  # Press 'q' to quit
                print("Exiting...")
                break
            elif key == ord('s'):  # Press 's' to take a snapshot
                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                os.makedirs("snapshots", exist_ok=True)
                snapshot_path = f"snapshots/leaf_{timestamp}.jpg"
                cv2.imwrite(snapshot_path, frame)
                print(f"Snapshot saved to: {snapshot_path}")
                
    except KeyboardInterrupt:
        print("Program interrupted by user.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    finally:
        # Release resources
        if cap is not None:
            cap.release()
        if output_video is not None:
            output_video.release()
        cv2.destroyAllWindows()
        print("Camera closed and resources released.")

if __name__ == "__main__":
    detect_leaf_disease_camera()