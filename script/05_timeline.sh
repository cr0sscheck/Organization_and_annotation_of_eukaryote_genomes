#!/usr/bin/env bash

#SBATCH --time=48:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=05_visualisation
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/05_visualisation.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/05_visualisation.err
#SBATCH --partition=pibu_el8


WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data/results"
ASSEMBLY="/data/users/amroczek/annotation_assembly_course/data/hifisam_assembly/ERR11437320.asm.bp.p_ctg.fa"
ASSEMBLY_FAI=/data/users/amroczek/annotation_assembly_course/data/hifisam_assembly/ERR11437320.asm.bp.p_ctg.fa.fai
TE_ANNOTATION=$WORK_DIR/EDTA_annotation/*.fa.mod.EDTA.TEanno.gff3
PLOT_DIR=$WORK_DIR/plots
R_MODULE=R-bundle-IBU/2023072800-foss-2021a-R-4.2.1
SAMTOOLS_IMG=/containers/apptainer/samtools-1.19.sif 

mkdir -p $PLOT_DIR

cd $WORK_DIR

# Indexing assembly
apptainer exec --bind /data $SAMTOOLS_IMG \
samtools faidx $ASSEMBLY

module load $R_MODULE 
cd $PLOT_DIR

# Creating plots through R script
Rscript /data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/script/05_annotation_circle.R \
$TE_ANNOTATION $ASSEMBLY_FAI