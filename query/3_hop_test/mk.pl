:- compiler_options([xpp_on]).
#include "flag_defs_xsb.h"

?-ensure_loaded('metaqa_check_answer.pl').

:- machine:stat_set_flag(MAXTOINDEX_FLAG,2).
:- index(movie/4, [*(2)+3,3+4]).

?-load_dync('metaqa_fact.pl').
?-load_dyn('metaqa_query.pl').
?-ensure_loaded('metaqa_answer.pl').
