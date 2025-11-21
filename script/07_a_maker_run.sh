#!/usr/bin/env bash

#SBATCH --time=48:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=08_maker
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/08_maker.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/08_maker.err
#SBATCH --partition=pibu_el8

COURSE_DIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"
OUT_DIR=$WORK_DIR/gene_annotation
REPEATMASKER_DIR="/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"
MAKER_IMG=/data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif

export PATH=$PATH:$REPEATMASKER_DIR

mkdir -p $OUT_DIR
cd $OUT_DIR

#you will create maker_opts.ctl file and you have to modify: Genome, EST Evidence, Protein Homology Evidence, Repeat Masking,
#Gene Prediction, External Application Behavior Options and MAKER Behavior Options
apptainer exec --bind /data $MAKER_IMG \
maker -CTL
