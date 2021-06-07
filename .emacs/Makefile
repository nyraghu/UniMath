### Makefile for tasks related to Emacs in the project

### ==================================================================
### Variables
### ==================================================================

## The tags table.
TAGS_FILE = TAGS

## The root of the physical paths of the Coq modules of the project.
COQ_ROOT = ../UniMath

## The physical paths of the Coq modules of the project.
COQ_FILES = $(shell find ${COQ_ROOT} -name '*.v')

## The file containing the regular expressions that match the
## identifiers being tagged.
REGEX_FILE = etags-regex

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

.PHONY: all
all: tags

.PHONY: tags
tags: ${TAGS_FILE}

${TAGS_FILE}: ${COQ_FILES} ${REGEX_FILE}
	etags --language=none --regex=@${REGEX_FILE} ${COQ_FILES}

.PHONY: clean
clean:
	${RM} ${TAGS_FILE}

### End of file
