# KALM QA
Authors: Tiantian Gao, Paul Fodor, Michael Kifer

# Introduction
KALM QA is a continuing project based on our previous project KALM. It extends the KALM system to process more complex queries , muti-hop English questions. The benchmarks we use is the MetaQA dataset. 

# Code
* `metaqa/`

   `rectified_dataset/`
* `rectified_metaqa_dataset/` The rectified version of the MetaQA vanilla dataset. The original MetaQA dataset contains errors for answers. We inspected the errors from the original MetaQA dataset and created a rectified version which contains the correct answers for each multi-hop question.
* `metaqa_in_cnl/` The MetaQA vanilla dataset in ACE CNL grammar. Note, this dataset only contains the multi-hop questions (not answers). It is used as the input to KALM-QA to get the corresponding queries in Prolog.
* `metaqa_to_cnl_queries/` JAVA code that converts each MetaQA n-hop English question (NL) to CNL format.
* `query_correctness/2_hop_template` In this directory, query_template.txt contains the unique query templates for 2-hop MetaQA queries (testing). query_group_by_template.txt groups the 2-hop MetaQA queries (testing) by the query template. 2_hop_template.txt shows the query template for each query in query_group_by_template.txt
* `query_correctness/3_hop_template` In this directory, query_template.txt contains the unique query templates for 3-hop MetaQA queries (testing). query_group_by_template.txt groups the 3-hop MetaQA queries (testing) by the query template. 3_hop_template.txt shows the query template for each query in query_group_by_template.txt
