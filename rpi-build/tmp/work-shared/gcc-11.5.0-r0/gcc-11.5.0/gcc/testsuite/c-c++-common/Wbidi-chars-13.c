/* PR preprocessor/103026 */
/* { dg-do compile { target { c || c++11 } } } */
/* { dg-options "-Wbidi-chars=unpaired" } */
/* Test raw strings.  */

const char *s1 = R"(a b c LREâª 1 2 3)";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
const char *s2 = R"(a b c RLEâ« 1 2 3)";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
const char *s3 = R"(a b c LROâ­ 1 2 3)";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
const char *s4 = R"(a b c FSIâ¨ 1 2 3)";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
const char *s5 = R"(a b c LRIâ¦ 1 2 3)";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
const char *s6 = R"(a b c RLIâ§ 1 2 3)";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
