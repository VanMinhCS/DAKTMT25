/* PR preprocessor/103026 */
/* { dg-do compile } */
/* { dg-options "-Wbidi-chars=unpaired" } */
/* Test that we warn when mixing UCN and UTF-8.  */

int LRE_âª_PDF_\u202c;
/* { dg-warning "mismatch" "" { target *-*-* } .-1 } */
int LRE_\u202a_PDF_â¬_;
/* { dg-warning "mismatch" "" { target *-*-* } .-1 } */
const char *s1 = "LRE_âª_PDF_\u202c";
/* { dg-warning "mismatch" "" { target *-*-* } .-1 } */
const char *s2 = "LRE_\u202a_PDF_â¬";
/* { dg-warning "mismatch" "" { target *-*-* } .-1 } */
