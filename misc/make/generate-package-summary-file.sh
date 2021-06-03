### Generate the summary files for the given package of the project

## sh generate-package-summary-file.sh package
##
## Print to standard output the summary file for `package'.

PATH=/bin:/usr/bin
set -o errexit

program="$0"
usage="Usage: sh ${program} package"
if test $# -ne 1; then
    printf "${usage}\n" >&2
    exit 1
fi
package="$1"

printf "(* This file has been auto-generated, do not edit it. *)\n"
sed -e 's@#.*@@' \
    -e '/^[[:space:]]*$/d' \
    -e '/Test[s]*\.v$/d' \
    -e 's@/@.@g' \
    -e 's@\.v$@.@' \
    -e "s@^[[:space:]]*@Require Export UniMath.${package}.@" \
    "UniMath/${package}/.package/files"

### End of file
