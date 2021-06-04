### Generate the dependency Makefile for the given packages

## sh generate-dependency-makefile.sh packages
##
## Print to standard output the dependency Makefile for `packages'.
## It will have a target for every package in `packages'.  The rule
## for that target ensures that all the files in the package are
## compiled.

PATH=/bin:/usr/bin
set -o errexit

program="$0"
usage="Usage: sh ${program} packages"
if test $# -eq 0; then
    printf "${usage}\n" >&2
    exit 1
fi
packages="$@"

printf "## This file has been auto-generated, do not edit it.\n"
for package in ${packages}; do
    directory="UniMath/${package}"
    vofiles="$(sed -e 's@#.*@@' \
                   -e '/^[[:space:]]*$/d' \
                   -e "s@^[[:space:]]*@${directory}/@" \
                   -e 's@\.v$@.vo@' \
                   "${directory}/.package/files" \
                   | tr '\n' ' ' \
                   | sed 's@[[:space:]]*$@@')"
    summary="${directory}/All.vo"
    printf "\n${package}: make-summary-files \${COQ_MAKEFILE}\n"
    printf "\t\${MAKE} -f \${COQ_MAKEFILE} ${vofiles} ${summary}\n"
done

### End of file
