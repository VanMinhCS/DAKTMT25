/* PR preprocessor/103026 */
/* { dg-do compile { target { c || c++11 } } } */
/* { dg-options "-Wbidi-chars=any" } */
/* Test raw strings.  */

const char *s1 = R"(a b c LREâª 1 2 3 PDFâ¬ x y z)";
/* { dg-warning "U\\+202A" "" { target *-*-* } .-1 } */
const char *s2 = R"(a b c RLEâ« 1 2 3 PDFâ¬ x y z)";
/* { dg-warning "U\\+202B" "" { target *-*-* } .-1 } */
const char *s3 = R"(a b c LROâ­ 1 2 3 PDFâ¬ x y z)";
/* { dg-warning "U\\+202D" "" { target *-*-* } .-1 } */
const char *s4 = R"(a b c RLOâ® 1 2 3 PDFâ¬ x y z)";
/* { dg-warning "U\\+202E" "" { target *-*-* } .-1 } */
const char *s7 = R"(a b c FSIâ¨ 1 2 3 PDIâ© x y) z";
/* { dg-warning "U\\+2068" "" { target *-*-* } .-1 } */
const char *s8 = R"(a b c PDIâ© x y )z";
/* { dg-warning "U\\+2069" "" { target *-*-* } .-1 } */
const char *s9 = R"(a b c PDFâ¬ x y z)";
/* { dg-warning "U\\+202C" "" { target *-*-* } .-1 } */
