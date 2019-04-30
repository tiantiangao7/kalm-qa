coop('Actor',A1,'Actor',A2) :- movie('Film',(X,I),'Actor',A1),movie('Film',(X,I),'Actor',A2), A1 \= A2.
coop('Writer',A1,'Writer',A2) :- movie('Film',(X,I),'Writer',A1),movie('Film',(X,I),'Writer',A2), A1 \= A2.
coop('Director',A1,'Director',A2) :- movie('Film',(X,I),'Director',A1),movie('Film',(X,I),'Director',A2), A1 \= A2.
coop('Actor',A1,'Writer',A2) :- movie('Film',(X,I),'Actor',A1),movie('Film',(X,I),'Writer',A2), A1 \= A2.
coop('Actor',A1,'Director',A2) :- movie('Film',(X,I),'Actor',A1),movie('Film',(X,I),'Director',A2), A1 \= A2.