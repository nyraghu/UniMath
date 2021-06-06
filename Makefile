### Makefile for the project

## Build a set of packages and its documentation.

## Usage
##
## If you want to build a subset of the full set of packages of the
## project, set the environment variable `PACKAGES' to that subset in
## the shell before invoking `make', like this:
##
## $ export PACKAGES="PAdics Algebra Topology"
##
## The packages in the value of `PACKAGES' need not be in order of
## dependency.  It is however an error if any of those packages is not
## in the full set of packages, and the subsequent `make' commands
## will then fail.
##
## The packages of the project are listed in order of dependency in
## the file `misc/make/packages'.  If the environment variable
## `PACKAGES' is unset or has a blank value, `make' will assume that
## the full set of packages from this file is to be built.
##
## After setting the above environment variable if desired, execute
## the first `make' command thus:
##
## $ make makefiles
##
## This will provide shell completions for available targets in the
## subsequent `make' commands.  For example, with PACKAGES set as
## above:
##
## $ make <tab>
## Display all 453 possibilities? (y or n) <y>
## Algebra
## Algebra.All
## Algebra.Apartness
## [elided text]
## Topology.Filters
## Topology.Prelim
## Topology.Topology
## all
## clean
## distclean
## html
## makefiles
##
## $ make CategoryTheory.Chai<tab>
## CategoryTheory.Chains.Adamek   CategoryTheory.Chains.Cochains
## CategoryTheory.Chains.All      CategoryTheory.Chains.OmegaCocontFunctors
## CategoryTheory.Chains.Chains
##
## $ make CategoryTheory.Chains.Cochains
##
## This will compile the file `UniMath/CategoryTheory/Chains/Cochains.v'.
##
## Note: The output in the above examples depends on the current state
## of the project, and may be different from what is displayed here.

## Public variables
##
## PACKAGES: The set of packages that must be built.  This is the
## only public variable in this Makefile.

## Public targets
##
## makefiles: Generate various auxiliary files used by `make'.  This
## must be the first target built in any `make' session.  The files
## generated by it will be used by subsequent `make' commands.
##
## all: Compile all the Coq source files in the current set of
## packages.  This is the default target, that is, the target built by
## a `make' command which does not specify any targets.
##
## html: Create the HTML documentation for the current set of
## packages.
##
## clean: Remove the output of compilation.
##
## distclean: Run the `clean' target, and also remove all the
## auxiliary files generated by the `makefiles' target.
##
## <package>: For every package in the current set of packages, there
## is a target whose name is the same as the name of the package.
## Running this target will compile all the source files in that
## package.
##
## <module>: For every module of any package in the current set of
## packages, there is a target whose name is the logical path of the
## module sans the prefix "UniMath.".  Running this target will
## compile that module.

## Private variables and targets
##
## All variables and targets whose names begin with an underscore are
## meant for internal use in this Makefile.

### ==================================================================
### Public variables
### ==================================================================

## The current list of packages as provided by the user.

PACKAGES ?=

### ==================================================================
### Private variables
### ==================================================================

## File containing the full list of packages in order of dependency.
_PACKAGES_FILE = misc/make/packages

## Command to generate the full list of packages from the above file.
define _GENERATE_PACKAGES_LIST =
${SHELL} misc/make/generate-packages-list.sh ${_PACKAGES_FILE}
endef

## The full list of packages.
_ALL_PACKAGES ?= $(shell ${_GENERATE_PACKAGES_LIST})

## The current list of packages.
_PACKAGES = $(strip ${PACKAGES})
ifeq (${_PACKAGES},)
_PACKAGES = ${_ALL_PACKAGES}
endif

## Command to generate the ordered list of current packages.
define _GENERATE_PACKAGES_ORDER =
${SHELL} misc/make/list-head.sh "${_ALL_PACKAGES}" "${_PACKAGES}"
endef

## The ordered list of current packages.
_PACKAGES_ORDER = $(shell ${_GENERATE_PACKAGES_ORDER})

## The Coq project file.  It is automatically generated by a script in
## this project from the above ordered list of packages and the list
## of files in each of those packages.
_COQ_PROJECT_FILE = _CoqProject

## The summary file of a package.
define _PACKAGE_SUMMARY_FILE =
UniMath/$1/All.v
endef

## The combined summary file for all the current packages.
define _COMBINED_SUMMARY_FILE =
UniMath/All.v
endef

## Command to generate the above Coq project file.
define _GENERATE_COQ_PROJECT_FILE =
for _package in ${_PACKAGES_ORDER}; do \
${SHELL} misc/make/generate-package-summary-file.sh  $${_package} \
> $(call _PACKAGE_SUMMARY_FILE,$${_package}) ; \
done

${SHELL} misc/make/generate-combined-summary-file.sh ${_PACKAGES_ORDER} \
> ${_COMBINED_SUMMARY_FILE}

${SHELL} misc/make/generate-coq-project-file.sh ${_PACKAGES_ORDER} \
> ${_COQ_PROJECT_FILE}
endef

## The Coq Makefile.  It is automatically generated by the
## `coq_makefile' command from the above Coq project file.
_COQ_MAKEFILE = _CoqMakefile

## Command to generate the above Coq Makefile.
define _GENERATE_COQ_MAKEFILE =
coq_makefile -f ${_COQ_PROJECT_FILE} -o ${_COQ_MAKEFILE}
endef

## The packages Makefile.  It will have rules for building individual
## packages, and individual files in those packages.
_PACKAGES_MAKEFILE = _PackagesMakefile

## Command to generate the above packages Makefile.
define _GENERATE_PACKAGES_MAKEFILE =
${SHELL} misc/make/generate-packages-makefile.sh ${_PACKAGES_ORDER} \
> ${_PACKAGES_MAKEFILE}
endef

## Command to remove various generated files.
define _REMOVE_GENERATED_FILES =
${RM} \
${_COQ_PROJECT_FILE} \
${_COQ_MAKEFILE} \
${_COQ_MAKEFILE}.conf \
${_PACKAGES_MAKEFILE}

for _package in ${_PACKAGES_ORDER}; do \
${RM} $(call _PACKAGE_SUMMARY_FILE,$${_package}) ; \
done

${RM} ${_COMBINED_SUMMARY_FILE}
endef

## If the variable VERBOSE has a blank value, execute recipes silently
## without printing them.
ifeq ($(strip ${VERBOSE}),)
MAKEFLAGS += --silent
endif

## The default target.
.DEFAULT_GOAL = all

### ==================================================================
### Targets
### ==================================================================

.PHONY: ${_COQ_PROJECT_FILE}
${_COQ_PROJECT_FILE}:
	${_GENERATE_COQ_PROJECT_FILE}

.PHONY: ${_COQ_MAKEFILE}
${_COQ_MAKEFILE}: ${_COQ_PROJECT_FILE}
	${_GENERATE_COQ_MAKEFILE}

.PHONY: makefiles
makefiles: ${_COQ_MAKEFILE}

.PHONY: all html
all html: makefiles
	${MAKE} --file=${_COQ_MAKEFILE} --no-print-directory $@

.PHONY: clean
clean: makefiles
	${MAKE} --file=${_COQ_MAKEFILE} --no-print-directory cleanall

.PHONY: distclean
distclean: clean
	${_REMOVE_GENERATED_FILES}

### ==================================================================
### Include the packages Makefile
### ==================================================================

${_PACKAGES_MAKEFILE}:
	${_GENERATE_PACKAGES_MAKEFILE}

include ${_PACKAGES_MAKEFILE}

### End of file
