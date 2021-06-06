### Generate the Coq project file for the project

## sh generate-coq-project-file.sh packages
##
## Print to standard output the Coq project file for building
## `packages'.

PATH=/bin:/usr/bin
set -o errexit

program="$0"
usage="Usage: sh ${program} packages"
if test $# -eq 0; then
    printf "${usage}\n" >&2
    exit 1
fi
packages="$@"

printf "# This file has been auto-generated, do not edit it.\n"

printf -- "\n-Q UniMath UniMath
-arg -indices-matter
-arg -noinit
-arg -type-in-type
-arg -w
-arg -notation-overridden\n"

for package in ${packages}; do
    directory="UniMath/${package}"
    printf "\n"
    sed -e 's@#.*@@' \
        -e '/^[[:space:]]*$/d' \
        -e "s@^[[:space:]]*@${directory}/@" \
        "${directory}/.package/files"
    printf "\n${directory}/All.v\n"
done

printf "\nUniMath/All.v\n"

### End of file
