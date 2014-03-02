# Set OS if there is no default:
uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')
uname_O := $(shell sh -c 'uname -o 2>/dev/null || echo not')
OS = win
ifeq ($(uname_S), Darwin)
  OS = mac
endif
ifeq ($(uname_O), Cygwin)
  OS = win
endif
ifeq ($(uname_S), MINGW32_NT-6.1)
  OS = win
endif
ifeq ($(uname_S), Linux)
  OS = linux
endif

ifdef R_HOME
  R = $(R_HOME)/bin/R --vanilla
  RSCRIPT = $(R_HOME)/bin/Rscript --vanilla
else
  # R = R --arch x86_64
  R = R --vanilla
  RSCRIPT = Rscript --vanilla
endif

R_MAKEVARS_USER = $(CURDIR)/R_Makevars
export R_MAKEVARS_USER

PKG_VER := $(shell $(RSCRIPT) -e "cat(read.dcf(file = './rstan8schools/DESCRIPTION')[1, deparse(quote(Version))])")
RSTAN_8SCHOOLS_PKG := rstan8schools_$(PKG_VER).tar.gz

LINKCMD1 = ln -s ../../../stan/lib ./rstan8schools/inst/include/stanlib
LINKCMD2 = ln -s ../../../stan/src ./rstan8schools/inst/include/stansrc
LINKCMD3 = ln -s ../../../rstan/rstan/rstan/inst/include/ ./rstan8schools/inst/include/rstaninst_inc

build0: ./rstan8schools/DESCRIPTION 
	rm -rf ./rstan8schools/inst/include/stanlib
	rm -rf ./rstan8schools/inst/include/stansrc
	rm -rf ./rstan8schools/inst/include/rstaninst_inc
	$(LINKCMD1)
	$(LINKCMD2)
	$(LINKCMD3)
	cp -f rstan/rstan/rstan/src/agrad__rev__var_stack.cpp rstan8schools/src/
	cp -f rstan/rstan/rstan/src/chains.cpp rstan8schools/src/
	cp -f rstan/rstan/rstan/src/init.cpp rstan8schools/src/
	cp -f rstan/rstan/rstan/src/misc.cpp rstan8schools/src/
	sed -e '/.*CPP_stanc.*/d' -e '/.*CPP_stan_version.*/d' rstan8schools/src/init.cpp > rstan8schools/src/init0.cpp
	rm -rf rstan8schools/src/init.cpp

build $(RSTAN_8SCHOOLS_PKG):
	$(R) CMD build rstan8schools --md5  $(BUILD_OPTS) # --no-build-vignettes --no-manual

install:  $(RSTAN_8SCHOOLS_PKG) 
	$(R) CMD INSTALL $^


clean:  
	rm -rf $(RSTAN_8SCHOOLS_PKG) 
