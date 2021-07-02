#include <unistd.h>
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

extern void int_to_byte8(int, unsigned char*);
extern void int_to_byte2(int, unsigned char*);

/* Calls getcwd and copies over the contents of cwdbuf.
 */
void ffigetcwd(unsigned char* c, long clen, unsigned char* a, long alen)
{
    char cwdbuf[16384] = {'\0'};

    /* 2 bytes for the length and 16382 for the string: */
    assert(16384 <= alen);

    getcwd(cwdbuf, 16382);

    /* copy over the string and set the length */
    int i = 0;
    while ((a[i + 2] = cwdbuf[i]) != '\0') { i++; }
    int_to_byte2(i, &a[0]);
}

/* Calls realpath and copies over the contents of resolved_name.
 */
void ffirealpath(unsigned char* c, long clen, unsigned char* a, long alen)
{
    char resolved_name[16384] = {'\0'};
    /* 2 bytes for the length and 16382 for the string: */
    assert(16384 <= alen);

    /* copy over the thing (can't trust it's a cstring) */
    char fname[clen + 1];
    fname[clen] = '\0';
    for (int i = 0; i < clen; i++) {
        fname[i] = c[i];
    }

    if ((realpath(fname, resolved_name)) == NULL) {
        fprintf(stderr, "realpath: unable to resolve '%s'.\n", fname);
        exit(1);
    }

    /* copy over the resolved path and set the length */
    int i = 0;
    while ((a[i + 2] = resolved_name[i]) != '\0') { i++; }
    int_to_byte2(i, &a[0]);
}

