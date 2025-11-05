#!/usr/bin/env bash

#SBATCH --time=4:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=09_maker_out
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/09_maker_out.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/09_maker_out.err
#SBATCH --partition=pibu_el8


COURSE_DIR=/data/courses/assembly-annotation-course/CDS_annotation
WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"
MAKER_OUTPUT_DIR=$WORK_DIR/gene_annotation/*.maker.output
MAKER_BIN=$COURSE_DIR/softwares/Maker_v3.01.03/src/bin
DATASTORE_INDEX_LOG=$MAKER_OUTPUT_DIR/*_master_datastore_index.log

OUT_DIR=$WORK_DIR/gene_annotation
OUT_ALL_GFF=$OUT_DIR/assembly.all.maker.gff
OUT_NOSEQ_ALL_GFF=$OUT_DIR/assembly.all.maker.noseq.gff
OUT_ASSEMBLY_FOLDER=$OUT_DIR

mkdir -p $OUT_DIR/final

$MAKER_BIN/gff3_merge -s -d $DATASTORE_INDEX_LOG > $OUT_ALL_GFF
$MAKER_BIN/gff3_merge -n -s -d $DATASTORE_INDEX_LOG > assembly.all.maker.noseq.gff
$MAKER_BIN/fasta_merge -d $DATASTORE_INDEX_LOG -o $OUT_ASSEMBLY_FOLDER