### Generate the combinded summary file for the given packages

## sh generate-combinded-summary-file.sh packages
##
## Print to standard output the combined summary file for `packages'.

PATH=/bin:/usr/bin
set -o errexit

program="$0"
usage="Usage: sh ${program} packages"
if test $# -eq 0; then
    printf "${usage}\n" >&2
    exit 1
fi
packages="$@"

printf "(* This file has been auto-generated, do not edit it. *)\n"
for package in ${packages}; do
    printf "Require Export UniMath.${package}.All.\n"
done

### End of file
