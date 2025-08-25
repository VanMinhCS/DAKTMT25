/* PR preprocessor/103026 */
/* { dg-do compile } */
/* { dg-options "-Wbidi-chars=unpaired" } */
/* Test nesting of bidi chars in various contexts.  */

/* Terminated by the wrong char:  */
/* a b c LREâª 1 2 3 PDIâ© x y z */
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* a b c RLEâ« 1 2 3 PDIâ© x y  z*/
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* a b c LROâ­ 1 2 3 PDIâ© x y z */
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* a b c RLOâ® 1 2 3 PDIâ© x y z */
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* a b c LRIâ¦ 1 2 3 PDFâ¬ x y z */
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* a b c RLIâ§ 1 2 3 PDFâ¬ x y z */
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* a b c FSIâ¨ 1 2 3 PDFâ¬ x y  z*/
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */

/* LREâª PDFâ¬ */
/* LREâª LREâª PDFâ¬ PDFâ¬ */
/* PDFâ¬ LREâª PDFâ¬ */
/* LREâª PDFâ¬ LREâª PDFâ¬ */
/* LREâª LREâª PDFâ¬ */
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* PDFâ¬ LREâª */
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */

// a b c LREâª 1 2 3 PDIâ© x y z
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
// a b c RLEâ« 1 2 3 PDIâ© x y  z*/
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
// a b c LROâ­ 1 2 3 PDIâ© x y z 
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
// a b c RLOâ® 1 2 3 PDIâ© x y z 
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
// a b c LRIâ¦ 1 2 3 PDFâ¬ x y z 
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
// a b c RLIâ§ 1 2 3 PDFâ¬ x y z 
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
// a b c FSIâ¨ 1 2 3 PDFâ¬ x y  z
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */

// LREâª PDFâ¬ 
// LREâª LREâª PDFâ¬ PDFâ¬
// PDFâ¬ LREâª PDFâ¬
// LREâª PDFâ¬ LREâª PDFâ¬
// LREâª LREâª PDFâ¬
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
// PDFâ¬ LREâª
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */

void
g1 ()
{
  const char *s1 = "a b c LREâª 1 2 3 PDIâ© x y z";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s2 = "a b c LRE\u202a 1 2 3 PDI\u2069 x y z";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s3 = "a b c RLEâ« 1 2 3 PDIâ© x y ";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s4 = "a b c RLE\u202b 1 2 3 PDI\u2069 x y z";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s5 = "a b c LROâ­ 1 2 3 PDIâ© x y z";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s6 = "a b c LRO\u202d 1 2 3 PDI\u2069 x y z";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s7 = "a b c RLOâ® 1 2 3 PDIâ© x y z";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s8 = "a b c RLO\u202e 1 2 3 PDI\u2069 x y z";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s9 = "a b c LRIâ¦ 1 2 3 PDFâ¬ x y z";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s10 = "a b c LRI\u2066 1 2 3 PDF\u202c x y z";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s11 = "a b c RLIâ§ 1 2 3 PDFâ¬ x y z\
    ";
/* { dg-warning "unpaired" "" { target *-*-* } .-2 } */
  const char *s12 = "a b c RLI\u2067 1 2 3 PDF\u202c x y z";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s13 = "a b c FSIâ¨ 1 2 3 PDFâ¬ x y z";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s14 = "a b c FSI\u2068 1 2 3 PDF\u202c x y z";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s15 = "PDFâ¬ LREâª";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s16 = "PDF\u202c LRE\u202a";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s17 = "LREâª PDFâ¬";
  const char *s18 = "LRE\u202a PDF\u202c";
  const char *s19 = "LREâª LREâª PDFâ¬ PDFâ¬";
  const char *s20 = "LRE\u202a LRE\u202a PDF\u202c PDF\u202c";
  const char *s21 = "PDFâ¬ LREâª PDFâ¬";
  const char *s22 = "PDF\u202c LRE\u202a PDF\u202c";
  const char *s23 = "LREâª LREâª PDFâ¬";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s24 = "LRE\u202a LRE\u202a PDF\u202c";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s25 = "PDFâ¬ LREâª";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s26 = "PDF\u202c LRE\u202a";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s27 = "PDFâ¬ LRE\u202a";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
  const char *s28 = "PDF\u202c LREâª";
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
}

int aLREâªbPDIâ©;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int A\u202aB\u2069C;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int aRLEâ«bPDIâ©;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int a\u202bB\u2069c;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int aLROâ­bPDIâ©;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int a\u202db\u2069c2;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int aRLOâ®bPDIâ©;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int a\u202eb\u2069;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int aLRIâ¦bPDFâ¬;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int a\u2066b\u202c;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int aRLIâ§bPDFâ¬c
;
/* { dg-warning "unpaired" "" { target *-*-* } .-2 } */
int a\u2067b\u202c;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int aFSIâ¨bPDFâ¬;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int a\u2068b\u202c;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int aFSIâ¨bPD\u202C;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int aFSI\u2068bPDFâ¬_;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int aLREâªbPDFâ¬b; 
int A\u202aB\u202c;
int a_LREâª_LREâª_b_PDFâ¬_PDFâ¬;
int A\u202aA\u202aB\u202cB\u202c;
int aPDFâ¬bLREadPDFâ¬;
int a_\u202C_\u202a_\u202c;
int a_LREâª_b_PDFâ¬_c_LREâª_PDFâ¬;
int a_\u202a_\u202c_\u202a_\u202c_;
int a_LREâª_b_PDFâ¬_c_LREâª;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
int a_\u202a_\u202c_\u202a_;
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
