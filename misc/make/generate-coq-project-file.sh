### Generate the Coq project file for the project

## sh generate-coq-project-file.sh packages
##
## Print to standard output the Coq project file for building
## `packages'.

PATH=/bin:/usr/bin
set -o errexit

packages="$@"

printf "INSTALLDEFAULTROOT = UniMath
-Q UniMath UniMath
-arg -indices-matter
-arg -noinit
-arg -type-in-type
-arg -w
-arg -notation-overridden\n"

for package in ${packages}; do
    sed -e 's@#.*@@' \
        -e '/^[[:space:]]*$/d' \
        -e "s@^[[:space:]]*@UniMath/${package}/@" \
        "UniMath/${package}/.package/files"
    printf "UniMath/${package}/All.v\n"
done

printf "UniMath/All.v\n"

### End of file
