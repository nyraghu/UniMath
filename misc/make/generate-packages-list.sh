### Generate the list of packages from the given packages file

## sh generate-packages-list.sh packages-file
##
## Print to standard output the list of packages contained in
## `packages-file'.

PATH=/bin:/usr/bin
set -o errexit

program="$0"
usage="Usage: sh ${program} packages-file"
if test $# -ne 1; then
    printf "${usage}\n" >&2
    exit 1
fi
packages_file="$1"

sed -e 's@#.*@@' \
    -e '/^[[:space:]]*$/d' \
    ${packages_file}

### End of file
