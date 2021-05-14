# package name
PACKAGE = noindentafter
# formatting tools
TEX = tex
LATEX = pdflatex-dev --synctex=1
INDEX = texindy -C utf8
define run_latex
  $(LATEX) "\let\tudfinalflag\relax\let\tudxdyflag\relax\input{$(1)}"
endef
define run_texindy
	$(INDEX) -M tudscrdoc-ind.xdy -o $(1).ind $(1)-xdy.idx
	$(INDEX) -M tudscrdoc-gls.xdy -o $(1).gls $(1)-xdy.glo
endef

include utils_fs.mak
include utils_tex.mak

# source files and package version
SRC__FILE := $(PACKAGE).dtx
SRC_FILES := $(sort $(SRC__FILE) $(wildcard *.dtx))
AUX_FILES := $(wildcard Makefile*) $(wildcard *.mak) $(wildcard *.bat)
SRC_DIRS  := $(sort $(dir $(SRC_FILES) $(AUX_FILES)))
SRC_DIRS  := $(filter-out ./, $(SRC_DIRS))

# created files
OUT_FILES := $(PACKAGE).sty
DOC__FILE := $(PACKAGE).pdf
DOC_FILES := $(DOC__FILE)


# parse version information
VERSION := $(strip $(call get_version, $(SRC__FILE)))
$(info ------------------------------------------------)
$(info This is version $(VERSION) of package $(PACKAGE))
$(info ------------------------------------------------)


# release files and folders
MD_FILES    := $(wildcard ../*.md)
RLS_DIR     := ../release_$(VERSION)/
GIT_DIR     := $(RLS_DIR)GitHub/
CTAN_DIR    := $(RLS_DIR)CTAN/
# TDS folders
TDS_SUFFIX := latex/$(PACKAGE)/
TDS_DOC_DIR := doc/$(TDS_SUFFIX)
TDS_TEX_DIR := tex/$(TDS_SUFFIX)
TDS_SRC_DIR := source/$(TDS_SUFFIX)
TDS_EXM_DIR := source/$(TDS_SUFFIX)examples/
TDS_DIRS    := $(TDS_DOC_DIR) $(TDS_TEX_DIR) $(TDS_SRC_DIR) $(TDS_EXM_DIR)
# installation folder
TEXMF_HOME  := $(shell kpsewhich --var-value=TEXMFHOME)/


# temporary directories which can be deleted in any case
TMP_DIRS := $(sort $(dir $(wildcard */)))
TMP_DIRS := $(filter-out $(SRC_DIRS), $(TMP_DIRS))
# temporary files which are created within source directories
TMP_FILES := $(wildcard *.* $(TMP_FILES))
TMP_FILES += $(foreach DIR,$(SRC_DIRS),$(wildcard $(DIR)*.*))
TMP_FILES := $(filter-out $(SRC_FILES) $(AUX_FILES) $(OUT_FILES) $(DOC_FILES), $(TMP_FILES))



%.sty: $(SRC__FILE)
	$(TEX) $<

%.pdf: $(SRC__FILE) package
	$(call run_latex, $<)
	$(call run_latex, $<)
	$(call run_texindy, $*)
	$(call run_latex, $<)


.PHONY: $(PACKAGE) package doc all purge clean release install uninstall

# creates package files only
package: $(OUT_FILES)
$(PACKAGE): package

# creates complete documentation
doc:  $(PACKAGE) $(DOC_FILES)

# creating package files and update documentation
all: $(PACKAGE) doc

# removes all temporary files
purge:
	$(call rm_dirs,$(TMP_DIRS))
	$(call rm_files,$(TMP_FILES))

# addtionally removes package files and documentation
clean: purge
	$(call rm_files,$(OUT_FILES))
	$(call rm_files,$(DOC_FILES))

# creates zip files for CTAN and GitHub from TDS folder structure
release: $(PACKAGE) doc
	$(call rm_dirs,$(RLS_DIR))
	$(call copy_tds,$(GIT_DIR))
	$(call copy_tds,$(CTAN_DIR)$(PACKAGE)/,$(TDS_SUFFIX))
	$(call cp_files,$(CTAN_DIR)$(PACKAGE)/$(subst $(TDS_SUFFIX),,$(TDS_DOC_DIR))README.md,$(CTAN_DIR)$(PACKAGE))
	cd $(GIT_DIR) && zip -r $(PACKAGE)_$(VERSION).zip *
	cd $(CTAN_DIR) && zip -r -D $(PACKAGE).zip * \
		-x "$(PACKAGE)/$(subst $(TDS_SUFFIX),,$(TDS_TEX_DIR))*.*" "$(PACKAGE)/$(subst $(TDS_SUFFIX),,$(TDS_DOC_DIR))README.md"
	$(call rm_tds,$(RLS_DIR))
	$(call rm_tds,$(GIT_DIR))
	$(call rm_dirs,$(CTAN_DIR)$(PACKAGE)/)

# installs all files in TDS folder structur in TEXMF_HOME
install: $(PACKAGE) doc
	$(call copy_tds,$(TEXMF_HOME))
	texhash

# removes all installed files from TEXMF_HOME
uninstall:
	$(call rm_dirs,$(addprefix $(TEXMF_HOME),$(TDS_DIRS)))
	texhash
