#!/bin/sh
CPANM_LOCAL_LIB=~/.cpanm/local-lib
export PERL_CPANM_OPT="--local-lib=$CPANM_LOCAL_LIB"
export PERL5LIB="$CPANM_LOCAL_LIB/lib/perl5:$PERL5LIB"
export PATH="$CPANM_LOCAL_LIB/bin:$PATH"
unset CPANM_LOCAL_LIB
