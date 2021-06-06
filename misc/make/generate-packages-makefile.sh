### Generate the dependency Makefile for the given packages

## sh generate-dependency-makefile.sh packages
##
## Print to standard output the packages Makefile for `packages'.  It
## will have a target for every package in `packages', and for every
## compiled file in each of those packages.  The rule for a package
## target ensures that all the files in the package are compiled.

PATH=/bin:/usr/bin
set -o errexit

program="$0"
usage="Usage: sh ${program} packages"
if test $# -eq 0; then
    printf "${usage}\n" >&2
    exit 1
fi
packages="$@"
make='${MAKE} --file=${_COQ_MAKEFILE} --no-print-directory'

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
    vofiles="${vofiles} ${summary}"
    printf "\n${package}: \${_COQ_MAKEFILE}\n"
    printf "\t${make} ${vofiles}\n"
    for file in ${vofiles}; do
        target="$(printf "${file}" \
                         | sed -e 's@^UniMath/@@' \
                               -e 's@\.vo$@@' \
                               -e 's@/@.@g')"
        printf "\n${target}: \${_COQ_MAKEFILE}\n"
        printf "\t${make} ${file}\n"
    done
done

### End of file
