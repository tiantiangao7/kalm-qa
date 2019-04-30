:- dynamic(fn_synonym/5).
:- index(fn_synonym/5,trie).
fn_synonym(X, Y, _, X, Y).
lvp(Lexem,POS,'Movie',[pair('Film','[adj->verb,verb->subject]',required),pair('Release Year','[adj->verb,verb->pp,pp_constraint(in,pp->dep)]',required)]) :- fn_synonym('released','property','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->subject]',required),pair('Actor','[verb->object]',required)]) :- fn_synonym('share','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->pp,pp_constraint(with,pp->dep)]',required),pair('Actor','[verb->object]',required)]) :- fn_synonym('share','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Writer','[self]',required)]) :- fn_synonym('writer','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Director','[object->verb,verb->subject]',required)]) :- fn_synonym('director','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Writer','[verb->subject]',required)]) :- fn_synonym('write','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Director','[verb->subject]',required)]) :- fn_synonym('direct','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[adj->verb,verb->subject]',required),pair('Actor','[adj->verb,verb->pp,pp_constraint(by,pp->dep)]',required)]) :- fn_synonym('acted','property','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[adj->verb,verb->pp,pp_constraint(in,pp->dep)]',required),pair('Actor','[adj->verb,verb->pp,pp_constraint(by,pp->dep)]',required)]) :- fn_synonym('acted','property','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Director','[dep->pp,pp_constraint(as,pp->verb),verb->subject]',required)]) :- fn_synonym('director','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Actor','[verb->subject]',required)]) :- fn_synonym('star','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Actor','[self]',required)]) :- fn_synonym('actor','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->subject]',required),pair('Genre','[verb->object]',required)]) :- fn_synonym('be','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Director','[self]',required)]) :- fn_synonym('director','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Genre','[verb->subject]',required)]) :- fn_synonym('be','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->subject]',required),pair('Release Year','[verb->pp,pp_constraint(in,pp->dep)]',required)]) :- fn_synonym('release','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->subject]',required),pair('Director','[verb->object]',required)]) :- fn_synonym('share','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->pp,pp_constraint(with,pp->dep)]',required),pair('Director','[verb->object]',required)]) :- fn_synonym('share','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->subject]',required),pair('Language','[verb->pp,pp_constraint(in,pp->dep)]',required)]) :- fn_synonym('be','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[object->verb,verb->pp,pp_constraint(in,pp->dep)]',required),pair('Actor','[object->verb,verb->subject]',required)]) :- fn_synonym('actor','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->pp,pp_constraint(in,pp->dep)]',required),pair('Actor','[verb->subject]',required)]) :- fn_synonym('star','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Writer','[object->verb,verb->subject]',required)]) :- fn_synonym('screenwriter','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Release Year','[subject->verb,verb->object]',required)]) :- fn_synonym('release-date','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[subject->verb,verb->pp,pp_constraint(in,pp->dep)]',required),pair('Language','[subject->verb,verb->object]',required)]) :- fn_synonym('language','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Actor','[verb->subject]',required)]) :- fn_synonym('star','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Actor','[self]',required)]) :- fn_synonym('actor','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Writer','[verb->pp,pp_constraint(for,pp->dep)]',required)]) :- fn_synonym('direct','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->subject]',required),pair('Genre','[verb->pp,pp_constraint(in,pp->dep)]',required)]) :- fn_synonym('be','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Director','[verb->pp,pp_constraint(for,pp->dep)]',required)]) :- fn_synonym('star','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Release Year','[subject->verb,verb->object]',required)]) :- fn_synonym('release-year','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->subject]',required),pair('Language','[verb->pp,pp_constraint(in,pp->dep)]',required)]) :- fn_synonym('be','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->subject]',required),pair('Writer','[verb->object]',required)]) :- fn_synonym('share','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->pp,pp_constraint(with,pp->dep)]',required),pair('Writer','[verb->object]',required)]) :- fn_synonym('share','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Writer','[self]',required)]) :- fn_synonym('screenwriter','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Writer','[verb->pp,pp_constraint(for,pp->dep)]',required)]) :- fn_synonym('star','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->pp,pp_constraint(in,pp->dep)]',required),pair('Actor','[verb->subject]',required)]) :- fn_synonym('act','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->subject]',required),pair('Genre','[verb->pp,pp_constraint(under,pp->dep)]',required)]) :- fn_synonym('fall','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->subject]',required),pair('Actor','[verb->object]',required)]) :- fn_synonym('star','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Genre','[subject->verb,verb->object]',required)]) :- fn_synonym('genre','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Writer','[dep->pp,pp_constraint(as,pp->verb),verb->subject]',required)]) :- fn_synonym('screenwriter','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Writer','[dep->pp,pp_constraint(as,pp->verb),verb->subject]',required)]) :- fn_synonym('writer','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->pp,pp_constraint(in,pp->dep)]',required),pair('Actor','[verb->subject]',required)]) :- fn_synonym('appear','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Director','[object->verb,verb->subject]',required),pair('Director','[self]',required)]) :- fn_synonym('director','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Actor','[object->verb,verb->subject]',required),pair('Actor','[self]',required)]) :- fn_synonym('actor','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Writer','[object->verb,verb->subject]',required),pair('Writer','[self]',required)]) :- fn_synonym('writer','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Writer','[object->verb,verb->subject]',required),pair('Writer','[self]',required)]) :- fn_synonym('screenwriter','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Language','[object->verb,verb->subject]',required),pair('Language','[self]',required)]) :- fn_synonym('language','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Genre','[object->verb,verb->subject]',required),pair('Genre','[self]',required)]) :- fn_synonym('genre','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Genre','[object->verb,verb->subject]',required),pair('Genre','[self]',required)]) :- fn_synonym('type','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Release Year','[object->verb,verb->subject]',required),pair('Release Year','[self]',required)]) :- fn_synonym('release-year','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Release Year','[object->verb,verb->subject]',required),pair('Release Year','[self]',required)]) :- fn_synonym('release-date','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Writer','[dep->pp,pp_constraint(as,pp->verb),verb->subject]',required),pair('Writer','[self]',required)]) :- fn_synonym('screenwriter','object','Movie',Lexem,POS).
fn_synonym('screenwriter','object','Movie','scriptwriter','object').
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Writer','[dep->pp,pp_constraint(as,pp->verb),verb->subject]',required),pair('Writer','[self]',required)]) :- fn_synonym('writer','object','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[lobject->rel,rel->robject]',required),pair('Director','[dep->pp,pp_constraint(as,pp->verb),verb->subject]',required),pair('Director','[self]',required)]) :- fn_synonym('director','object','Movie',Lexem,POS).
lvp(Lexem,POS,'InEquality',[pair('Film','[verb->subject]',required),pair('Film','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('share','predicate','InEquality',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->subject]',required),pair('Director','[verb->object]',required)]) :- fn_synonym('have','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->subject]',required),pair('Writer','[verb->object]',required)]) :- fn_synonym('have','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->subject]',required),pair('Actor','[verb->object]',required)]) :- fn_synonym('have','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Writer','[verb->subject]',required)]) :- fn_synonym('co-write','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Writer','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('co-write','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Coop',[pair('Actor','[verb->subject]',required),pair('Actor','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('co-star','predicate','Coop',Lexem,POS).
lvp(Lexem,POS,'Coop',[pair('Actor','[verb->subject]',required),pair('Actor','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('star','predicate','Coop',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Director','[verb->subject]',required)]) :- fn_synonym('co-direct','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Director','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('co-direct','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Coop',[pair('Actor','[object->verb,verb->subject]',required),pair('Actor','[lobject->rel,rel->robject]',required)]) :- fn_synonym('co-star','object','Coop',Lexem,POS).
lvp(Lexem,POS,'Coop',[pair('Writer','[object->verb,verb->subject]',required),pair('Writer','[lobject->rel,rel->robject]',required)]) :- fn_synonym('co-writer','object','Coop',Lexem,POS).
lvp(Lexem,POS,'Coop',[pair('Director','[object->verb,verb->subject]',required),pair('Director','[lobject->rel,rel->robject]',required)]) :- fn_synonym('co-director','object','Coop',Lexem,POS).
lvp(Lexem,POS,'Coop',[pair('Actor','[verb->subject]',required),pair('Actor','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('act','predicate','Coop',Lexem,POS).
lvp(Lexem,POS,'Coop',[pair('Actor','[object->verb,verb->subject]',required),pair('Director','[lobject->rel,rel->robject]',required)]) :- fn_synonym('actor','object','Coop',Lexem,POS).
lvp(Lexem,POS,'Coop',[pair('Actor','[object->verb,verb->subject]',required),pair('Writer','[lobject->rel,rel->robject]',required)]) :- fn_synonym('actor','object','Coop',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Writer','[verb->subject]',required)]) :- fn_synonym('write','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Writer','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('write','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->pp,pp_constraint(in,pp->dep)]',required),pair('Actor','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('appear','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->pp,pp_constraint(for,pp->dep)]',required),pair('Writer','[verb->subject]',required)]) :- fn_synonym('write','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Director','[verb->pp,pp_constraint(for,pp->dep)]',required),pair('Director','[verb->pp,pp_constraint(for,pp->clause_verb),verb->object]',required)]) :- fn_synonym('star','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Writer','[verb->pp,pp_constraint(for,pp->dep)]',required),pair('Writer','[verb->pp,pp_constraint(for,pp->clause_verb),verb->object]',required)]) :- fn_synonym('star','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'Coop',[pair('Actor','[object->verb,verb->subject]',required),pair('Writer','[lobject->rel,rel->robject]',required),pair('Writer','[lobject->rel,rel->clause_verb,verb->object]',required)]) :- fn_synonym('actor','object','Coop',Lexem,POS).
lvp(Lexem,POS,'Coop',[pair('Actor','[object->verb,verb->subject]',required),pair('Director','[lobject->rel,rel->robject]',required),pair('Director','[lobject->rel,rel->clause_verb,verb->object]',required)]) :- fn_synonym('actor','object','Coop',Lexem,POS).
lvp(Lexem,POS,'Movie',[pair('Film','[verb->object]',required),pair('Director','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('direct','predicate','Movie',Lexem,POS).
lvp(Lexem,POS,'InEquality',[pair('Film','[verb->subject]',required),pair('Film','[verb->rel,rel->robject]',required)]) :- fn_synonym('share','predicate','InEquality',Lexem,POS).
fn_synonym('share','predicate','InEquality','have','predicate').
lvp(Lexem,POS,'InEquality',[pair('Writer','[verb->subject]',required),pair('Writer','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('co-write','predicate','InEquality',Lexem,POS).
lvp(Lexem,POS,'InEquality',[pair('Director','[verb->subject]',required),pair('Director','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('co-direct','predicate','InEquality',Lexem,POS).
lvp(Lexem,POS,'InEquality',[pair('Actor','[verb->subject]',required),pair('Actor','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('appear','predicate','InEquality',Lexem,POS).
lvp(Lexem,POS,'InEquality',[pair('Film','[adv->verb,verb->sub_rel,rel->robject]',required),pair('Film','[adv->verb,verb->object]',required)]) :- fn_synonym('also','modifier_adv','InEquality',Lexem,POS).
lvp(Lexem,POS,'InEquality',[pair('Film','[adv->verb,verb->sub_rel,rel->robject]',required),pair('Film','[adv->pp,pp_constraint(in,pp->dep)]',required)]) :- fn_synonym('also','modifier_adv','InEquality',Lexem,POS).
lvp(Lexem,POS,'InEquality',[pair('Film','[adv->verb,verb->sub_rel,rel->robject]',required),pair('Film','[adv->verb,verb->rel,rel->robject]',required)]) :- fn_synonym('also','modifier_adv','InEquality',Lexem,POS).
lvp(Lexem,POS,'InEquality',[pair('Writer','[verb->subject]',required),pair('Writer','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('write','predicate','InEquality',Lexem,POS).
lvp(Lexem,POS,'InEquality',[pair('Director','[verb->subject]',required),pair('Director','[verb->pp,pp_constraint(with,pp->dep)]',required)]) :- fn_synonym('direct','predicate','InEquality',Lexem,POS).
%lvp(Lexem,POS,'InEquality',[pair('Film','[adj->sub_verb,verb->object]',required),pair('Film','[ladj->rel,rel->robject]',required)]) :- fn_synonym('same','property','InEquality',Lexem,POS).
