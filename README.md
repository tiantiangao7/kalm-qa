# KALM-QA
Authors: Tiantian Gao, Paul Fodor, Michael Kifer

# Introduction
KALM-QA is the question answering part of KALM (https://github.com/tiantiangao7/kalm). It is capable of answering complex multi-hop questions. We tested KALM-QA on the MetaQA dataset and achieves 100% accuracy.

# Code

* `metaqa/original/`The original MetaQA vanilla dataset for 2-hop and 3-hop training and testing questions (https://github.com/yuyuz/MetaQA).
* `metaqa/rectified/`The rectified version of the MetaQA vanilla dataset. The original MetaQA dataset contains errorneous answers (as is discussed in our paper). We inspected the errors from the original MetaQA dataset and created a rectified version which contains the  correct answers for the multi-hop questions in MetaQA.
* `metaqa/cnl_input/` The MetaQA vanilla dataset in ACE CNL grammar. Note, this dataset only contains the multi-hop questions (not answers). It is used as the input to KALM-QA to get the corresponding queries in Prolog.
* `tools/metaqa_to_cnl/` JAVA code that converts MetaQA n-hop English questions (NL) to CNL format. The input files (e.g., 2_hop_training.pl) are found in `metaqa/cnl_input/` directory. 
* `tools/intermediate_query_processing/MetaQABatch.java` JAVA code that processes the intermediate MetaQA Prolog query generated by the Prolog program. This program replaces singleton variables with anonymous variables. 
* `query/template/2_hop_template/` In this directory, query_template.txt contains the unique query templates for 2-hop MetaQA queries (testing). query_group_by_template.txt groups the 2-hop MetaQA queries (testing) by the query template. 2_hop_template.txt shows the query template for each query in query_group_by_template.txt.
* `query/template/3_hop_template/` In this directory, query_template.txt contains the unique query templates for 3-hop MetaQA queries (testing). query_group_by_template.txt groups the 3-hop MetaQA queries (testing) by the query template. 3_hop_template.txt shows the query template for each query in query_group_by_template.txt.
* `query/2_hop_test/` This directory contains the MetaQA 2-hop Prolog queries (metaqa_query.pl), MetaQA KB encoded in Prolog (metaqa_fact.pl), MetaQA 2-hop testing question-answer pairs encoded in Prolog (metaqa_answer.pl), background rules (background.pl), a program checking whether the query returns the correct answers (metaqa_check_answer.pl), an entrypoint program (mk.pl). By running the program, it will generate a file containing the results which compares KALM-QA answers with MetaQA answers (metaqa_result.txt). **Note that** the question-answer pairs are from the original MetaQA vanilla dataset. As is discussed in the paper, there are errors in this dataset. As a result, once you run the program, you may find the mismatches between KALM-QA answers and MetaQA answers. Error analysis will be displayed in a separate directory. The directories `2_hop_training`, `3_hop_testing`, and `3_hop_training` follow the same structure.
* `error_analysis/2_hop` This directory contains the errors for 2-hop testing data. total_errors.txt has all the errors. fild_id_errors.txt has the errors that are caused by the issue where MetaQA doesn't distinguish the different films that share the same film ID. others_error.txt has all the rest errors caused by unknown reasons. We have manually checked 736 (50%) of the "other errors" and added the reasons why MetaQA doesn't return the correct answers. The analysis is in metaqa_error_analysis.txt.
* `error_analysis/3_hop` This directory contains the errors for 3-hop testing data. total_errors.txt has all the errors. fild_id_errors.txt has the errors that are caused by the issue where MetaQA doesn't distinguish the different films that share the same film ID. others_error.txt has all the rest errors caused by unknown reasons. We have manually checked 1628 (50%) of the "other errors" and added the reasons why MetaQA doesn't return the correct answers. The analysis is in metaqa_error_analysis.txt.
* `kalm-qa/` The source code for KALM-QA (Prolog).

# Dependency
  XSB 3.7. The installation guide can be found in http://xsb.sourceforge.net/.

# How to convert MetaQA queries to CNL in Prolog format?
Run the Java program ``tools/metaqa_to_cnl/src/main/java/edu/stonybrook/cs/main/Main.java``. The input file is placed under ``metaqa/original/``. These files are from the original MetaQA dataset (e.g., qa_train.txt, qa_test.txt). 

# How to generate MetaQA queries?
1. Run Java program ``tools/metaqa_to_cnl/src/main/java/edu/stonybrook/cs/main/Main.java`` to convert NL metaqa queries to CNL queries, where the output ``metaqa_query.txt``.
2. Run the Java program tools/intermediate_query_processing/MetaQABatch.java. This step is used to remove singleton variables. The input file is ``metaqa_query.txt``. The output is a Prolog file. 
3. The entry point to KALM-QA is kalm-qa/mk.pl. The last line specifies the location of the input metaqa file in Prolog format (`2_hop_test.pl`, `2_hop_training.pl`, `3_hop_test.pl`, `3_hop_training.pl`). The output is saved in `kalm-qa/metaqa/metaqa_query.txt`. **Note that** each time before running the program, metaqa_query.txt has to be empty.

# How to train KALM-QA parser?
```
cd kalm-qa`
xsb
['mk.pl'].
?- learn_lvp('John appears in a movie.',1/2,'Movie',[pair('Actor',1/1,required),pair('Film',1/4,required)],[],LVP).
```
Step 4 shows how to compose an annotated sentences (training sentence). By running the query in step 4, an lvp is automatically generated and added to `kalm-qa/semanticparsing/data/lvp.pl`.

# How to interactively query MetaQA KB?
```
cd query/interactive_query
xsb
['mk.pl'].
?- movie('Film',(W5,I5),'Director',W2),movie('Film',(W5,I5),'Actor','John Krasinski').
```

# How to run MetaQA test set?
```
cd query/2_hop_test
xsb
['mk.pl'].
```
The result is saved in metaqa_result.txt.
