# phylopipe
Phylogenetic pipeline

Keep track of the species that are being removed.

## Sequence retrieval (sqs.)
1. Sequences retrieval and writting

## Database construction (sqs.)
2. Read sequences into R (new S3 object)
3. Retrieve taxonomy for the S3 object
4. Edit the taxonomy in the S3 object
5. Exclude species based on sequence lenght, taxonomy, etc
6. Add fossils and distributions (check if these calibrations still apply after processing)

## Database curation (sqs.)
6. Blast all vs all and keep significant hits

## Sequence alignment and curation (msa.)
7. Sequence alignment
8. Aliscore

## Post-alignment (pmsa.)
9. Run partitionfinder
10. Create accession table

## Tree inference (tr.)
11. Create constraint tree
12. Create starting tree (based on #11)
13. Run RAxML (create input files/run)
14. Run MrBayes (create input files/run)
15. Run iqtree (create input files/run)

## Tree dating (trd.)
16. Dating in MrBayes
17. Using PATHd-8
18. Using r8s (or similar)










