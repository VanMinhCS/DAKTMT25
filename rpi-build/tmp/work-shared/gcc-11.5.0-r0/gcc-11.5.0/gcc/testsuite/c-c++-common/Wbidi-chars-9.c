/* PR preprocessor/103026 */
/* { dg-do compile } */
/* { dg-options "-Wbidi-chars=unpaired" } */
/* Test that we properly separate bidi contexts (comment/identifier/character
   constant/string literal).  */

/* LRE ->âª<- */ int pdf_\u202c_1;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* RLE ->â«<- */ int pdf_\u202c_2;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* LRO ->â­<- */ int pdf_\u202c_3;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* RLO ->â®<- */ int pdf_\u202c_4;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* LRI ->â¦<-*/ int pdi_\u2069_1;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* RLI ->â§<- */ int pdi_\u2069_12;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* FSI ->â¨<- */ int pdi_\u2069_3;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */

const char *s1 = "LRE\u202a"; /* PDF ->â¬<- */
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* LRE ->âª<- */ const char *s2 = "PDF\u202c";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
const char *s3 = "LRE\u202a"; int pdf_\u202c_5;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int lre_\u202a; const char *s4 = "PDF\u202c";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
