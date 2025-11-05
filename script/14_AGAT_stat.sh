#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=16G
#SBATCH --time=1:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=14_agat_stat
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/14_agat_stat.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/14_agat_stat.err

COURSE_DIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"
GFF_FILE=$WORK_DIR/gene_annotation/final/filtered.genes.renamed.gff
OUT_DIR=$WORK_DIR/annotation_qc/agat
OUT_FILE=$OUT_DIR/filtered.genes.renamed.gff.stat

AGAT_IMG=/containers/apptainer/agat-1.2.0.sif

mkdir -p $OUT_DIR

apptainer exec \
    --bind /data \
    $AGAT_IMG \
    agat_sp_statistics.pl -i $GFF_FILE -o $OUT_FILE