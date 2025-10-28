#!/usr/bin/env bash
#SBATCH --time=48:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=02_LTR
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/02_LTR.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/02_LTR.err
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"
TE_sorter_image=/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif

cd $WORKDIR/results/EDTA_annotation

apptainer exec --bind /data $TE_sorter_image \
TEsorter *.fa.mod.EDTA.raw/*.mod.LTR.raw.fa -db rexdb-plant