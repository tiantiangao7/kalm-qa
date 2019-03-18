# KALM QA
Authors: Tiantian Gao, Paul Fodor, Michael Kifer

# Introduction
KALM QA is a continuing project based on our previous project KALM. It extends the KALM system to process more complex queries , muti-hop English questions. The benchmarks we use is the MetaQA dataset. 

# Code
* `rectified_metaqa_dataset/` The rectified version of the MetaQA vanilla dataset. The original MetaQA dataset contains errors for the answers. We manually inspected the errors from the original MetaQA dataset and created a new data which contains the correct answers for each multi-hop question.
* `metaqa_in_cnl/` The rectified version of the MetaQA vanilla dataset in CNL grammar. Note, this dataset only contains the multi-hop questions (not answers). It is used as the input to KALM-QA to get the corresponding queries in Prolog.
* `metaqa_to_cnl_queries/` JAVA code that converts a metaqa n-hop English question to CNL format.
