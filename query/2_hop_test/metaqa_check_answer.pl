are_equal(Index,Answer) :-
    (setof(X,q(Index,X),L)
     ->
     sort(L, L2),
     sort(Answer, A2),
     (L2 == A2
      ->
      open('metaqa_result.txt',append,Stream),
      write(Stream,Index),
      write(Stream,' succeeds.\n'),
      close(Stream)
      ;
      open('metaqa_result.txt',append,Stream),
      write(Stream,Index),
      write(Stream,' failed.\n'),
      close(Stream)
     ) 
     ;
     open('metaqa_result.txt',append,Stream),
     write(Stream,Index),
     write(Stream,' failed.\n'),
     close(Stream)
    ).
