### Find the initial interval bounded by a subset of a chain

## sh list-head.sh chain subset
##
## Return the initial interval of `chain' bounded by `subset'.
##
## `chain' is a totally ordered finite set, and `subset' is a subset
## of `chain'.  Returns the increasing sequence starting with the
## least element of `chain' and ending with the greatest element of
## `subset'.
##
## The argument `chain' must be supplied as a string of
## space-separated words that are the elements of the totally ordered
## set arranged in increasing order.
##
## The argument `subset' must be a string of space-separated words
## each of which is an element of `chain'.  The elements of `subset'
## need not be supplied in increasing order.
##
## The program exits with an error if some element of `subset' is not
## in `chain'.

### ==================================================================
### Preamble
### ==================================================================

PATH=/bin:/usr/bin
set -o errexit

### ==================================================================
### Usage
### ==================================================================

program="$0"
usage="Usage: sh ${program} chain subset"
if test $# -ne 2; then
    printf "${usage}\n" >&2
    exit 1
fi

chain="$1"
subset="$2"

### ==================================================================
### Process the trivial case of empty `subset'
### ==================================================================

subset="$(printf "${subset}" | sed 's@^[[:space:]]*$@@')"

if test -z "${subset}"; then
    exit 0
fi

### ==================================================================
### Index the sequence `chain'
### ==================================================================

index=0
for element in ${chain}; do
    eval ${element}_index=${index}
    index=$((${index} + 1))
done

### ==================================================================
### Find the maximum of the indices of the elements of `subset'
### ==================================================================

maximum=0

for element in ${subset}; do
    eval index=\${${element}_index}
    if test -z "${index}"; then
        printf "Error: element \"${element}\" of \"${subset}\" \
is not in \"${chain}\"\n" >&2
        exit 2
    fi
    if test ${index} -gt ${maximum}; then
        maximum=${index}
    fi
done

### ==================================================================
### Finish
### ==================================================================

result=""

for element in ${chain}; do
    eval index=\${${element}_index}
    if test ${index} -gt ${maximum}; then
        break
    fi
    result="${result} ${element}"
done

printf "${result}\n" | sed 's@^[[:space:]]*@@'

### End of file
