# Organization_and_annotation_of_eukaryote_genomes
In this repository, you will find all the code to reproduce my analysis for the genome annotation of an eukaryote genome lecture. Datasets used are from PacBio HiFi reads (WGS) and Illumina reads (RNA-seq) from the previous lecture, available on the [annotation and assembly repository](../../../../cr0sscheck/Annotation-and-assembly-course).

## Steps  
### Transposable elements (TE) annotation and classification
First, The TEs are annotate with EDTA in this script: [01_EDTA_run](script/01_EDTA_run.sh). Then, the raw LTR candidates have been  classified by protein domains using the RexDB-plant database in [02_LTR_RTs](script/02_a_LTR_RTs.sh) and the plots are generated to show the distribution of LTR identities per clade within the Copia and Gypsy superfamilies in [R script](script/02_b_full_length_LTRs_identity.R) 

### annotate genes (using the MAKER pipeline)

### Orthology based gene functional annotation and genome comparisons

### Comparing Genomes
