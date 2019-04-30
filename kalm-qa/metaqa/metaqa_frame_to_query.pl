:- dynamic metaqa_query_id/1.

sentence_to_metaqa_query(Sentence) :-
    retractall(serialized_drs_fact(_,_)),
    retractall(query_word(_)),
    (metaqa_query_id(X)
     ->
     Y is X + 1,
     retractall(metaqa_query_id(_)),
     assert(metaqa_query_id(Y))
     ;
     assert(metaqa_query_id(1))
    ), 
    parse_and_serialize(Sentence),
    findall(WordID,query_word(WordID),L),
    (basics:length(L,1)
     ->
     %initialize_metaqa_rule_head(L),
     (extract_frame_and_serialize(1)
      ->
      true
      ;
      write(Sentence),
      write('\n')
     )
     ;
     write(Sentence),
     write('\n')
    ).

initialize_metaqa_rule_head([WordID]) :-
    open('metaqa\\metaqa_query.txt',append,Stream),
    metaqa_query_id(QID),
    fmt_write(Stream,"q(%S,W%S) :- ",args(QID,WordID)),
    close(Stream).

initialize_metaqa_rule_head(Stream,[WordID]) :-
    metaqa_query_id(QID),
    fmt_write(Stream,"q(%S,W%S) :- ",args(QID,WordID)).

remove_invalid_metaqa_frame_list([frame_tuple(FrameName,FEList)|Rest],FilteredFrameList) :-
	(is_valid_metaqa_frame_element_list(FEList)
	 ->
	 remove_invalid_metaqa_frame_list(Rest,NewRest),
	 FilteredFrameList = [frame_tuple(FrameName,FEList)|NewRest]
	 ;
	 remove_invalid_metaqa_frame_list(Rest,FilteredFrameList)
	).
remove_invalid_metaqa_frame_list([],[]).

filter_metaqa_frame_list([frame_tuple(FrameName,FEList)|Rest],InEqualityList,FilteredFrameList) :-
	((FrameName == 'Movie';FrameName == 'Coop')
	 ->
	 filter_metaqa_frame_list(Rest,InEqualityList,NewRest),
	 FilteredFrameList = [frame_tuple(FrameName,FEList)|NewRest]
	 ;
	 FrameName == 'InEquality'
	 ->
	 filter_metaqa_frame_list(Rest,InEqualityListRest,FilteredFrameList),
	 InEqualityList = [frame_tuple(FrameName,FEList)|InEqualityListRest]
	 ;
	 filter_metaqa_frame_list(Rest,InEqualityList,FilteredFrameList)
	).
filter_metaqa_frame_list([],[],[]).

is_valid_metaqa_frame_element_list([pair(FEName, FE, _, _)|Rest]) :-
	metaqa_fe(FEName, FE),
	is_valid_metaqa_frame_element_list(Rest).
is_valid_metaqa_frame_element_list([]).

remove_redundant_fe_from_metaqa_frame(frame_tuple(FN,FEList),frame_tuple(FN,NewFEList)) :-
    remove_redundant_metaqa_fe(FEList,NewFEList).    

remove_redundant_metaqa_fe(FEList,NewFEList) :-
    (basics:length(FEList,3)
     ->
     machine:parsort(FEList,[desc(3)],0,FEList2),
     remove_redundant_metaqa_fe_helper(FEList2,NewFEList2),
     rearrange_cleaned_metaqa_fe(NewFEList2,NewFEList)
     ;
     NewFEList = FEList
    ).

rearrange_cleaned_metaqa_fe([FE1,FE2],NewFEList) :-
    (FE2 = pair('Film',_,_,_)
     ->
     NewFEList = [FE2,FE1]
     ;
     FE1 = pair('Writer',_,_,_),FE2 = pair('Actor',_,_,_)
     ->
     NewFEList = [FE2,FE1]
     ;
     FE1 = pair('Director',_,_,_),FE2 = pair('Actor',_,_,_)
     ->
     NewFEList = [FE2,FE1]
     ;
     NewFEList = [FE1,FE2]
    ). 

remove_redundant_metaqa_fe_helper([pair(FEName,FE,Index,PredicateName)|Rest],NewRest2) :-
    (redundant_metaqa_fe(FEName,FE)
     ->
     NewRest2 = Rest 
     ;
     NewRest2 = [pair(FEName,FE,Index,PredicateName)|NewRest],
     remove_redundant_metaqa_fe_helper(Rest, NewRest)
    ).

remove_redundant_metaqa_fe_helper([],[]).

redundant_metaqa_fe('Actor','actor').
redundant_metaqa_fe('Writer','writer').
redundant_metaqa_fe('Writer','screenwriter').
redundant_metaqa_fe('Genre','genre').
redundant_metaqa_fe('Genre','type').
redundant_metaqa_fe('Director','director').
redundant_metaqa_fe('Language','language').

framelist_to_metaqa_query([],_,_) :-
	!.

framelist_to_metaqa_query(FrameList,InEqualityList,DRSFacts) :-
    open('metaqa\\metaqa_query.txt',append,Stream),
    framelist_dicjunctive_form_to_metaqa_query(Stream,FrameList,InEqualityList,DRSFacts),
    close(Stream).

framelist_dicjunctive_form_to_metaqa_query(Stream,[FrameList],InEqualityList,DRSFacts) :-
	findall(WordID,query_word(WordID),L),
    initialize_metaqa_rule_head(Stream,L),
    framelist_to_metaqa_query_helper(Stream,FrameList,DRSFacts),
    inequality_framelist_to_metaqa_query(Stream,InEqualityList,DRSFacts),
    write(Stream,'.\n').

framelist_dicjunctive_form_to_metaqa_query(Stream,[FrameList1,FrameList2|Rest],
										   InEqualityList,DRSFacts) :-
    findall(WordID,query_word(WordID),L),
    initialize_metaqa_rule_head(Stream,L),
    framelist_to_metaqa_query_helper(Stream,FrameList1,DRSFacts),
    inequality_framelist_to_metaqa_query(Stream,InEqualityList,DRSFacts),
    write(Stream,'.\n'),
    framelist_dicjunctive_form_to_metaqa_query(Stream,[FrameList2|Rest],DRSFacts).

framelist_to_metaqa_query_helper(Stream,
	[frame_tuple(FrameName,FEList),Frame2|Rest],DRSFacts) :-
	(FrameName == 'Movie'
	 ->
     write(Stream,'movie(')
     ;
     write(Stream,'coop(')
    ),
    remove_redundant_metaqa_fe(FEList,NewFEList),
    felist_to_metaqa_query(Stream,NewFEList,DRSFacts),
    write(Stream,'),'),
    framelist_to_metaqa_query_helper(Stream,[Frame2|Rest],DRSFacts).

framelist_to_metaqa_query_helper(Stream,[frame_tuple(FrameName,FEList)],DRSFacts) :-
    (FrameName == 'Movie'
	 ->
     write(Stream,'movie(')
     ;
     write(Stream,'coop(')
    ),
    remove_redundant_metaqa_fe(FEList,NewFEList),
    felist_to_metaqa_query(Stream,NewFEList,DRSFacts),
    write(Stream,')').

metaqa_term_serialization_preprocess([],[]).
metaqa_term_serialization_preprocess([H|Rest],Result) :-
    metaqa_term_serialization_preprocess(Rest,Result2),
    (H == 39
     ->
     Result = [92,39|Result2]
     ;
     Result = [H|Result2]
    ).

felist_to_metaqa_query(Stream,[pair(FEName,FE,Index,PredicateName),FE2|Rest],DRSFacts) :-
    Index = _/WordID,
    pos(PredicateName,POS),
    (get_predicate_from_word_index(DRSFacts,Index,_-Index)
     ->
     true
     ;
     write(Stream,'Error in getting object from index.\n')
    ),
    (POS == ne
     ->
     atom_codes(FE,Code1),
     metaqa_term_serialization_preprocess(Code1,Code2),
     atom_codes(FERevised,Code2),
     (FEName == 'Film'
      ->
      fmt_write(Stream,"\'%S\',(\'%S\',I%S),",args(FEName,FERevised,WordID))
      ;
      fmt_write(Stream,"\'%S\',\'%S\',",args(FEName,FERevised))
     ) 
     ;
     (FEName == 'Film'
      ->
      fmt_write(Stream,"\'%S\',(W%S,I%S),",args(FEName,WordID,WordID))
      ;
      fmt_write(Stream,"\'%S\',W%S,",args(FEName,WordID))
     )
    ),
    felist_to_metaqa_query(Stream,[FE2|Rest],DRSFacts).

felist_to_metaqa_query(Stream,[pair(FEName,FE,Index,PredicateName)],DRSFacts) :-
    Index = _/WordID,
    pos(PredicateName,POS),
    (get_predicate_from_word_index(DRSFacts,Index,_-Index)
     ->
     true
     ;
     write(Stream,'Error in getting object from index.\n')
    ),
    (POS == ne
     ->
     atom_codes(FE,Code1),
     metaqa_term_serialization_preprocess(Code1,Code2),
     atom_codes(FERevised,Code2),
     (FEName == 'Film'
      ->
      fmt_write(Stream,"\'%S\',(\'%S\',I%S)",args(FEName,FERevised,WordID))
      ;
      fmt_write(Stream,"\'%S\',\'%S\'",args(FEName,FERevised))
     )
     ;
     (FEName == 'Film'
      ->
      fmt_write(Stream,"\'%S\',(W%S,I%S)",args(FEName,WordID,WordID))
      ;
      fmt_write(Stream,"\'%S\',W%S",args(FEName,WordID))
     )
    ).

inequality_framelist_to_metaqa_query(Stream,[
    frame_tuple('InEquality',[pair('Film',_,Index1,_),
    pair('Film',_,Index2,_)])|Rest],DRSFacts) :-
    !,
    Index1 = _/WordID1,
    Index2 = _/WordID2,
    fmt_write(Stream,",I%S \\\= I%S",args(WordID1,WordID2)),
    inequality_framelist_to_metaqa_query(Stream,Rest,DRSFacts).

inequality_framelist_to_metaqa_query(Stream,[
    frame_tuple('InEquality',[pair(_,FE1,Index1,PredicateName1),
    pair(_,FE2,Index2,PredicateName2)])|Rest],DRSFacts) :-
    Index1 = _/WordID1,
    Index2 = _/WordID2,
    pos(PredicateName1,POS1),
    pos(PredicateName2,POS2),
    (POS1 == n, POS2 == n
     ->
     fmt_write(Stream,",W%S \\\= W%S",args(WordID1,WordID2))
     ;
     POS1 == ne, POS2 == n
     ->
     atom_codes(FE1,Code1),
     metaqa_term_serialization_preprocess(Code1,Code2),
     atom_codes(FERevised,Code2),
     fmt_write(Stream,",\'%S\' \\\= W%S",args(FERevised,WordID2))
     ;
     POS1 == n, POS2 == ne
     ->
     atom_codes(FE2,Code1),
     metaqa_term_serialization_preprocess(Code1,Code2),
     atom_codes(FERevised,Code2),
     fmt_write(Stream,",W%S \\\= \'%S\'",args(WordID1,FERevised))
     ;
     true
    ),
    inequality_framelist_to_metaqa_query(Stream,Rest,DRSFacts).
inequality_framelist_to_metaqa_query(_,[],_).    

has_subset_role_filler(frame_tuple(_,[pair(_,FE,Index,_)|Rest1]),frame_tuple(_,FEList2)) :-
    basics:member(pair(_,FE,Index,_),FEList2),
    has_subset_role_filler(frame_tuple(_,Rest1),frame_tuple(_,FEList2)).    
has_subset_role_filler(frame_tuple(_,[]),frame_tuple(_,_)).

disjunctive_metaqa_frame_helper(_,[],[],[]).
disjunctive_metaqa_frame_helper(Frame1,[Frame2|Rest],R1,R2) :-
	remove_redundant_fe_from_metaqa_frame(Frame1,NewFrame1),
	remove_redundant_fe_from_metaqa_frame(Frame2,NewFrame2),
    (has_subset_role_filler(NewFrame2,NewFrame1)
     ->
     disjunctive_metaqa_frame_helper(Frame1,Rest,RestR1,R2),
     R1 = [Frame2|RestR1]
     ;
     disjunctive_metaqa_frame_helper(Frame1,Rest,R1,RestR2),
     R2 = [Frame2|RestR2]
    ).

find_disjunctive_metaqa_frame([Frame1|Rest],Result) :-
    disjunctive_metaqa_frame_helper(Frame1,Rest,DisjunctiveFrameList,NonDisjunctiveFrameList),
    find_disjunctive_metaqa_frame(NonDisjunctiveFrameList,Rest2),
    %write([Frame1|DisjunctiveFrameList]),
    %write('\n'),
    Result = [[Frame1|DisjunctiveFrameList]|Rest2].
find_disjunctive_metaqa_frame([],[]).    

add_fe_length_to_metaqa_frame([frame_tuple(FN,FEList)|Rest],[frame_tuple(FN,FEList,Len)|RestResult]) :-
    basics:length(FEList,Len),
	add_fe_length_to_metaqa_frame(Rest,RestResult).    
add_fe_length_to_metaqa_frame([],[]).

remove_fe_length_to_metaqa_frame([frame_tuple(FN,FEList,_)|Rest],[frame_tuple(FN,FEList)|RestResult]) :-
	remove_fe_length_to_metaqa_frame(Rest,RestResult).    
remove_fe_length_to_metaqa_frame([],[]).

metaqa_frame_disjunctive_form(FrameList1,Result) :-
    add_fe_length_to_metaqa_frame(FrameList1,FrameList2),
    machine:parsort(FrameList2,[desc(3)],1,FrameList3),
    remove_fe_length_to_metaqa_frame(FrameList3,FrameList4),
    find_disjunctive_metaqa_frame(FrameList4,Result).

metaqa_frame_conjunctive_form_helper2(Ele1,[H],[NewEle1]) :-
    (is_list(Ele1)
     ->
     basics:append(Ele1,[H],NewEle1)
     ;
     NewEle1 = [Ele1,H]
    ).

metaqa_frame_conjunctive_form_helper2(Ele1,[H,H2|T],Result) :-
    (is_list(Ele1)
     ->
     basics:append(Ele1,[H],NewEle1)
     ;
     NewEle1 = [Ele1,H]
    ),
    metaqa_frame_conjunctive_form_helper2(Ele1,[H2|T],Rest),
    Result = [NewEle1|Rest].

metaqa_frame_conjunctive_form_helper1([Ele1],EleList2,R1) :-
    metaqa_frame_conjunctive_form_helper2(Ele1,EleList2,R1).
metaqa_frame_conjunctive_form_helper1([Ele1,Ele2|T],EleList2,Result) :-
	metaqa_frame_conjunctive_form_helper2(Ele1,EleList2,R1),
	metaqa_frame_conjunctive_form_helper1([Ele2|T],EleList2,R2),
	basics:append(R1,R2,Result).

metaqa_frame_list_to_list([Ele],[[Ele]]).
metaqa_frame_list_to_list([Ele,Ele2|Rest],Result) :-
	metaqa_frame_list_to_list([Ele2|Rest],R2),
	Result = [[Ele]|R2].

metaqa_frame_conjunctive_form([L],Result) :-
    (L = [frame_tuple(_,_)|_]
     ->
	 metaqa_frame_list_to_list(L,Result)
     ;
     Result = L
    ).
metaqa_frame_conjunctive_form([L1,L2|Rest],Result) :-
    metaqa_frame_conjunctive_form_helper1(L1,L2,R1),
    basics:append([R1],Rest,NewList),
    metaqa_frame_conjunctive_form(NewList,Result).

print_metaqa_conjunctive_form([H|T]) :-
    write(H),
    write('\n'),
    print_metaqa_conjunctive_form(T).
print_metaqa_conjunctive_form([]).        

metaqa_fe(X,Y) :- 
    (metaqa_entity_kb(_,Y)
     ->
     true
     ;
     metaqa_fe_synonym(X,Y)
    ). 

metaqa_fe_synonym('Film','film').
metaqa_fe_synonym('Film','movie').
metaqa_fe_synonym('Actor','who').
metaqa_fe_synonym('Actor','actor').
metaqa_fe_synonym('Actor','person').
metaqa_fe_synonym('Writer','writer').
metaqa_fe_synonym('Writer','screenwriter').
metaqa_fe_synonym('Writer','scriptwriter').
metaqa_fe_synonym('Writer','who').
metaqa_fe_synonym('Writer','person').
metaqa_fe_synonym('Genre','genre').
metaqa_fe_synonym('Genre','type').
metaqa_fe_synonym('Director','director').
metaqa_fe_synonym('Director','who').
metaqa_fe_synonym('Director','person').
metaqa_fe_synonym('Release Year','when').
metaqa_fe_synonym('Release Year','year').
metaqa_fe_synonym('Release Year','release-date').
metaqa_fe_synonym('Release Year','release-year').
metaqa_fe_synonym('Language','language').