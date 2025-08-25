/* PR preprocessor/103026 */
/* { dg-do compile } */

int main() {
    int isAdmin = 0;
    /*â® } â¦if (isAdmin)â© â¦ begin admins only */
/* { dg-warning "bidirectional" "" { target *-*-* } .-1 } */
        __builtin_printf("You are an admin.\n");
    /* end admins only â® { â¦*/
/* { dg-warning "bidirectional" "" { target *-*-* } .-1 } */
    return 0;
}
