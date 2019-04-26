# KALM QA
Authors: Tiantian Gao, Paul Fodor, Michael Kifer

# Introduction
KALM QA is a continuing project based on our previous project KALM. It extends the KALM system to process more complex queries , muti-hop English questions. The benchmarks we use is the MetaQA dataset. 

# Code

* `metaqa/original/`The original MetaQA vanilla dataset for 2-hop and 3-hop training and testing questions (https://github.com/yuyuz/MetaQA).
* `metaqa/rectified/`The rectified version of the MetaQA vanilla dataset. The original MetaQA dataset contains errorneous answers (as is discussed in our paper). We inspected the errors from the original MetaQA dataset and created a rectified version which contains the  correct answers for the multi-hop questions in MetaQA.
* `metaqa/cnl_input/` The MetaQA vanilla dataset in ACE CNL grammar. Note, this dataset only contains the multi-hop questions (not answers). It is used as the input to KALM-QA to get the corresponding queries in Prolog.
* `tools/metaqa_to_cnl/` JAVA code that converts MetaQA n-hop English questions (NL) to CNL format. The input files (e.g., 2_hop_training.pl) are found in `metaqa/cnl_input/` directory. 
* `query/template/2_hop_template` In this directory, query_template.txt contains the unique query templates for 2-hop MetaQA queries (testing). query_group_by_template.txt groups the 2-hop MetaQA queries (testing) by the query template. 2_hop_template.txt shows the query template for each query in query_group_by_template.txt
* `query/template/3_hop_template` In this directory, query_template.txt contains the unique query templates for 3-hop MetaQA queries (testing). query_group_by_template.txt groups the 3-hop MetaQA queries (testing) by the query template. 3_hop_template.txt shows the query template for each query in query_group_by_template.txt
