#include <Arduino.h>
#include <AccelStepper.h>

// ======================================================================
// CLASS 1: STEPPER MOTOR (Quản lý cấu hình, tốc độ và phần cứng)
// ======================================================================
class StepperMotor {
  private:
    AccelStepper stepper;
    float currentMaxSpeed;
    float currentAccel;

  public:
    // Khởi tạo motor với chân STEP và DIR
    StepperMotor(uint8_t stepPin, uint8_t dirPin) 
      : stepper(AccelStepper::DRIVER, stepPin, dirPin) {
        currentMaxSpeed = 1000.0;
        currentAccel = 500.0;
    }

    // Thiết lập thông số ban đầu
    void begin(float maxSpeed, float accel) {
        currentMaxSpeed = maxSpeed;
        currentAccel = accel;
        stepper.setMaxSpeed(currentMaxSpeed);
        stepper.setAcceleration(currentAccel);
    }

    // Tăng tốc độ tối đa
    void speedUp(float increment) {
        currentMaxSpeed += increment;
        stepper.setMaxSpeed(currentMaxSpeed);
    }

    // Giảm tốc độ tối đa (có bảo vệ không cho rớt xuống dưới 1)
    void speedDown(float decrement) {
        currentMaxSpeed -= decrement;
        if (currentMaxSpeed < 1.0) currentMaxSpeed = 1.0;
        stepper.setMaxSpeed(currentMaxSpeed);
    }

    // Đổi gia tốc (độ bốc)
    void changeAcceleration(float newAccel) {
        currentAccel = newAccel;
        stepper.setAcceleration(currentAccel);
    }

    // Lệnh này cấp quyền cho Controller được phép "chạm" vào động cơ gốc
    AccelStepper& getStepper() {
        return stepper;
    }
};


// ======================================================================
// CLASS 2: STEPPER MOTOR CONTROLLER (Quản lý hành vi và điều hướng)
// ======================================================================
class StepperMotorController {
  private:
    StepperMotor& motor;      // Tham chiếu tới chiếc motor sẽ được điều khiển
    long savedTargetPosition; // Bộ nhớ tạm để lưu vị trí khi bị bấm dừng
    bool isPaused;

  public:
    // Khi khởi tạo Controller, phải giao cho nó 1 cái Motor để nó lái
    StepperMotorController(StepperMotor& myMotor) : motor(myMotor) {
        isPaused = false;
        savedTargetPosition = 0;
    }

    // 1. RA LỆNH QUAY (Theo số bước)
    void spin(long steps) {
        isPaused = false;
        motor.getStepper().move(steps);
    }

    // 2. ĐẢO CHIỀU QUAY LẬP TỨC
    void reverseDirection() {
        if (!isPaused) {
            long remainingDistance = motor.getStepper().distanceToGo();
            motor.getStepper().move(-remainingDistance);
        }
    }

    // 3. HÃM PHANH TỪ TỪ (Dừng mềm)
    void stopMotor() {
        if (!isPaused) {
            // Lưu lại tọa độ định đi tới trước khi hãm phanh
            savedTargetPosition = motor.getStepper().targetPosition(); 
            
            // Lệnh stop() tự tính toán tọa độ dừng gần nhất dựa trên gia tốc [1]
            motor.getStepper().stop(); 
            isPaused = true;
        }
    }

    // 4. TIẾP TỤC HÀNH TRÌNH
    void resumeMotor() {
        if (isPaused) {
            motor.getStepper().moveTo(savedTargetPosition);
            isPaused = false;
        }
    }

    // Kiểm tra xem đã đến đích cuối cùng chưa
    bool isFinished() {
        return motor.getStepper().distanceToGo() == 0;
    }

    // VÒNG QUÉT (BẮT BUỘC ĐỂ TRONG LOOP)
    void update() {
        motor.getStepper().run(); // Quét liên tục để motor tự nhích từng bước [2]
    }
};


// ======================================================================
// CHƯƠNG TRÌNH CHÍNH (ÁP DỤNG THỰC TẾ)
// ======================================================================

#define STEP_PIN 17
#define DIR_PIN 18

// Bước 1: Tạo đối tượng Motor (Chỉ lo setup phần cứng)
StepperMotor myNema17(STEP_PIN, DIR_PIN);

// Bước 2: Tạo đối tượng Controller và giao myNema17 cho nó điều khiển
StepperMotorController driverBoss(myNema17);

void setup() {
    Serial.begin(115200);

    // Cấu hình motor: Tốc độ 2000, gia tốc 800
    myNema17.begin(2000.0, 800.0);
    
    // Yêu cầu Controller cho xe chạy 10000 bước
    driverBoss.spin(10000);
}

void loop() {
    // Để Controller liên tục điều khiển động cơ
    driverBoss.update();

    // Hệ thống giả lập menu qua Serial Monitor
    if (Serial.available() > 0) {
        char command = Serial.read();

        // Các lệnh gửi cho CONTROLLER (Điều hướng)
        if (command == 's') { 
            Serial.println("CONTROLLER: Phanh lại!");
            driverBoss.stopMotor();
        } 
        else if (command == 'r') { 
            Serial.println("CONTROLLER: Chạy tiếp!");
            driverBoss.resumeMotor();
        }
        else if (command == 'd') { 
            Serial.println("CONTROLLER: Đổi chiều!");
            driverBoss.reverseDirection();
        }
        
        // Các lệnh gửi cho MOTOR (Cấu hình)
        else if (command == '+') { 
            Serial.println("MOTOR: Vặn ga tăng thêm 500");
            myNema17.speedUp(500.0);
        }
        else if (command == '-') { 
            Serial.println("MOTOR: Giảm ga đi 500");
            myNema17.speedDown(500.0);
        }
    }
}