/* pipe eix output into this to get root ebuild paths of each package
 *
 * this is free and unencumbered software released into the
 * public domain -> http://unlicense.org/
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
#define die(msg) fprintf(stderr, msg "\n"), exit(1);

#ifdef DEBUG
#define dbgprintf(...) fprintf(stderr, __VA_ARGS__)
#else
#define dbgprintf(...)
#endif

#ifndef BUFSIZE
#define BUFSIZE 0xFFFF
#endif

#ifndef MAX_ATOMS
#define MAX_ATOMS 512
#endif

#ifndef MAX_REPOS
#define MAX_REPOS 64
#endif

int main()
{
    char* buf;

    char const* atoms[MAX_ATOMS];
    size_t natoms = 0;

    char const* repos[MAX_REPOS];
    size_t nrepos = 0;

    char* line = 0;
    size_t n = 0;
    char const* p;

    buf = (char*)malloc(BUFSIZE);
    if (!buf) die("out of memory");

    n = fread(buf, 1, BUFSIZE, stdin);
    if (n >= BUFSIZE      ) die("too much input to handle");
    if (!n && !feof(stdin)) perror("fread"), exit(1);

    for (line = strtok(buf, "\n"); line; line = strtok(0, "\n"))
    {
        p = line;
        if (*p != '[' && *p != '*') continue;

        p += strcspn(p, " ") + 1;   /* [I] atom [n] */
        if (*p == '"') {            /*     ^        */
            if (nrepos >= ARRAY_SIZE(repos)) die("too many repos");
            repos[nrepos++] = line;
            dbgprintf("REPO: %s\n", line);
            continue;
        }

        if (natoms >= ARRAY_SIZE(atoms)) die("too many atoms");
        atoms[natoms++] = p;
        dbgprintf("ATOM: %s\n", p);
    }

    for (n = 0; n < natoms; ++n)
    {
        size_t i;
        char const* pkgrepo;

        p = atoms[n];                      /* [I] games-emulation/xmame [2] */
        pkgrepo = p + strcspn(p, " ");     /*     ^                     ^   */
        if (!*pkgrepo) {                   /*     p                 pkgrepo */
            printf("/usr/portage/%s\n", p);
            continue;
        }

        ++pkgrepo;

        for (i = 0; i < nrepos; ++i)
        {
            char const* repo;
            size_t repolen;

            repo = repos[i];
            repolen = strcspn(repo, " ");

            if (!strncmp(repo, pkgrepo, repolen))
            {
                pkgrepo = repo + repolen + 1;
                pkgrepo += strcspn(pkgrepo, " ") + 1;

                /* [2] "mv" /var/lib/layman/mv */
                /*          ^                  */

                printf("%s/", pkgrepo);
                fwrite(p, 1, strcspn(p, " "), stdout);
                printf("\n");
                break;
            }
        }

        if (i >= nrepos) {
            fprintf(stderr, "W: could not match %s to any repo\n", p);
        }
    }

    return 0;
}
