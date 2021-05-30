### Makefile for the project

### ==================================================================
### Packages
### ==================================================================

## File containing the list of packages in order of dependency.
PACKAGES_FILE = misc/make/packages

## Command to remove comments and blank lines from the packages file.
define PACKAGES_SED_COMMAND =
sed \
-e 's@#.*@@' \
-e '/^[[:space:]]*$$/d' \
${PACKAGES_FILE}
endef

## The list of packages in order of dependency.
PACKAGES = $(shell ${PACKAGES_SED_COMMAND})

### ==================================================================
### Other things
### ==================================================================

COQBIN ?= ${coq}/bin/

############################################
SHOW := $(if $(VERBOSE),@true "",@echo "")
HIDE := $(if $(VERBOSE),,@)
############################################

.PHONY: all install clean distclean doc html
all: make-summary-files

COQ_PATH := -Q UniMath UniMath

# override the definition in build/CoqMakefile.make, to eliminate the -utf8 option
COQDOC := coqdoc
COQDOCFLAGS := -interpolate --charset utf-8 $(COQ_PATH)
COQDOC_OPTIONS := -toc $(COQDOCFLAGS) $(COQDOCLIBS) -utf8

PACKAGE_FILES := $(patsubst %, UniMath/%/.package/files, $(PACKAGES))

ifneq "$(INCLUDE)" "no"
include .coq_makefile_output.conf
VFILES := $(COQMF_VFILES)
VOFILES := $(VFILES:.v=.vo)
endif

all html install uninstall $(VOFILES): build/CoqMakefile.make
	$(MAKE) -f build/CoqMakefile.make $@
clean:: build/CoqMakefile.make; $(MAKE) -f build/CoqMakefile.make $@
distclean:: build/CoqMakefile.make; $(MAKE) -f build/CoqMakefile.make cleanall archclean

WARNING_FLAGS := -notation-overridden
OTHERFLAGS += $(MOREFLAGS)
OTHERFLAGS += -noinit -indices-matter -type-in-type -w '\'"$(WARNING_FLAGS)"\''
ifeq ($(VERBOSE),yes)
OTHERFLAGS += -verbose
endif
ENHANCEDDOCTARGET = enhanced-html
ENHANCEDDOCSOURCE = ${coqdoc_overlay}/share/javascript/coqdoc-overlay
ENHANCEDDOCHEADER = misc/html/header.html

FILES_FILTER := grep -vE '^[[:space:]]*(\#.*)?$$'
FILES_FILTER_2 := grep -vE '^[[:space:]]*(\#.*)?$$$$'
$(foreach P,$(PACKAGES),												\
	$(eval $P: make-summary-files build/CoqMakefile.make;								\
		  $(MAKE) -f build/CoqMakefile.make									\
			$(shell <UniMath/$P/.package/files $(FILES_FILTER) |sed "s=^\(.*\).v=UniMath/$P/\1.vo=" )	\
			UniMath/$P/All.vo))

$(foreach v,$(VFILES), $(eval $v.vo:; $(MAKE) -f build/CoqMakefile.make $v.vo))

install:all

define GENERATE_COQ_PROJECT_FILE =
${SHELL} misc/make/generate-coq-project-file.sh ${PACKAGES} > $@
endef

.coq_makefile_input: $(PACKAGE_FILES) Makefile
	${GENERATE_COQ_PROJECT_FILE}

ifdef COQBIN
build/CoqMakefile.make .coq_makefile_output.conf: $(COQBIN)coq_makefile
else
build/CoqMakefile.make .coq_makefile_output.conf: $(shell command -v coq_makefile)
endif
build/CoqMakefile.make .coq_makefile_output.conf: .coq_makefile_input
	$(COQBIN)coq_makefile -f .coq_makefile_input -o .coq_makefile_output
	mv .coq_makefile_output build/CoqMakefile.make

# "clean::" occurs also in build/CoqMakefile.make, hence both colons
clean::
	rm -f .coq_makefile_input .coq_makefile_output .coq_makefile_output.conf build/CoqMakefile.make COQC.log
	find UniMath \( -name .\*.aux -o -name \*.glob -o -name \*.d -o -name \*.vo \) -delete
	find UniMath -type d -empty -delete
clean::; rm -rf $(ENHANCEDDOCTARGET)

distclean:: clean

doc: $(GLOBFILES) $(VFILES)
	mkdir -p $(ENHANCEDDOCTARGET)
	cp $(ENHANCEDDOCSOURCE)/proofs-toggle.js $(ENHANCEDDOCTARGET)/proofs-toggle.js
	$(SHOW)COQDOC
	$(HIDE)$(COQDOC)							\
	    -toc $(COQDOCFLAGS) -html $(COQDOCLIBS) -d $(ENHANCEDDOCTARGET)	\
	    --with-header $(ENHANCEDDOCHEADER)					\
	    $(VFILES)
	sed -i'.bk' -f $(ENHANCEDDOCSOURCE)/proofs-toggle.sed $(ENHANCEDDOCTARGET)/*html

# here we assume the shell is bash, which it usually is nowadays, so we can get associative arrays:
SHELL = bash

# Here we create the files UniMath/*/All.v, with * running over the names of the packages.  Each one of these files
# will "Require Export" all of the files in its package.
define make-summary-file
make-summary-files: UniMath/$1/All.v
UniMath/$1/All.v: UniMath/$1/.package/files Makefile
	$(SHOW)'--- making $$@'
	$(HIDE)																				\
	  exec > $$@ ;																			\
	  echo "(* This file has been auto-generated, do not edit it. *)" ;												\
	  <UniMath/$1/.package/files $(FILES_FILTER_2) | grep -v '^\(.*/\)\?Tests\?.v$$$$' |sed -e "s=^=Require Export UniMath.$1.=" -e "s=/=.=g" -e s/\.v$$$$/./
endef
$(foreach P, $(PACKAGES), $(eval $(call make-summary-file,$P)))

# Here we create the file UniMath/All.v.  It will "Require Export" all of the All.v files for the various packages.
make-summary-files: UniMath/All.v
UniMath/All.v: Makefile
	$(SHOW)'--- making $@'
	$(HIDE)									\
	exec > $@ ;								\
	echo "(* This file has been auto-generated, do not edit it. *)" ;	\
	for P in $(PACKAGES);							\
	do echo "Require Export UniMath.$$P.All.";				\
	done

#################################
# targets best used with INCLUDE=no
git-clean:
	git clean -Xdfq
#################################

### End of file
