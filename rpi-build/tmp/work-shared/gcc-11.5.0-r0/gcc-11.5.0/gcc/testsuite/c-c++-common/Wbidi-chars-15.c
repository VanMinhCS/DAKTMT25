/* PR preprocessor/103026 */
/* { dg-do compile } */
/* { dg-options "-Wbidi-chars=unpaired" } */
/* Test unpaired bidi control chars in multiline comments.  */

/*
 * LREâª end
 */
/* { dg-warning "unpaired" "" { target *-*-* } .-2 } */
/*
 * RLEâ« end
 */
/* { dg-warning "unpaired" "" { target *-*-* } .-2 } */
/*
 * LROâ­ end
 */
/* { dg-warning "unpaired" "" { target *-*-* } .-2 } */
/*
 * RLOâ® end
 */
/* { dg-warning "unpaired" "" { target *-*-* } .-2 } */
/*
 * LRIâ¦ end
 */
/* { dg-warning "unpaired" "" { target *-*-* } .-2 } */
/*
 * RLIâ§ end
 */
/* { dg-warning "unpaired" "" { target *-*-* } .-2 } */
/*
 * FSIâ¨ end
 */
/* { dg-warning "unpaired" "" { target *-*-* } .-2 } */
/* LREâª
   PDFâ¬ */
/* { dg-warning "unpaired" "" { target *-*-* } .-2 } */
/* FSIâ¨
   PDIâ© */
/* { dg-warning "unpaired" "" { target *-*-* } .-2 } */

/* LRE<âª>
 *
 */
/* { dg-warning "unpaired" "" { target *-*-* } .-3 } */

/*
 * LRE<âª>
 */
/* { dg-warning "unpaired" "" { target *-*-* } .-2 } */

/*
 *
 * LRE<âª> */
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */

/* RLI<â§> */ /* PDI<â©> */
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
/* LRE<âª> */ /* PDF<â¬> */
/* { dg-warning "unpaired" "" { target *-*-* } .-1 } */
