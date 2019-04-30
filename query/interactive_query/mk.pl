:- compiler_options([xpp_on]).
#include "flag_defs_xsb.h"

:- machine:stat_set_flag(MAXTOINDEX_FLAG,2).
:- index(movie/4, [*(2)+3,3+4]).

?-load_dync('metaqa_fact.pl').
?-load_dyn('background.pl').
