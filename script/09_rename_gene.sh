#!/usr/bin/env bash

#SBATCH --time=48:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=10_renamed
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/10_renamed.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/10_renamed.err
#SBATCH --partition=pibu_el8

BASE_DIR=/data/users/amroczek
COURSE_DIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"
ACCESSION=Kyr-1
MAKER_BIN=$COURSE_DIR/softwares/Maker_v3.01.03/src/bin
IN_DIR=$WORK_DIR/gene_annotation
OUT_DIR=$IN_DIR/final

mkdir -p $OUT_DIR

protein=$WORK_DIR/*.all.maker.proteins.fasta
transcript=$WORK_DIR/*.all.maker.transcripts.fasta
gff=$BASE_DIR/*.all.maker.noseq.gff

protein_ren=$OUT_DIR/assembly.all.maker.proteins.renamed.fasta
transcript_ren=$OUT_DIR/assembly.all.maker.transcripts.renamed.fasta
gff_ren=$OUT_DIR/assembly.all.maker.noseq.renamed.gff

cp $gff $gff_ren
cp $protein $protein_ren
cp $transcript $transcript_ren

cd $OUT_DIR

#Rename all gene/transcript/protein IDs in the MAKER output.
$MAKER_BIN/maker_map_ids --prefix $ACCESSION --justify 7 $gff_ren > id.map
$MAKER_BIN/map_gff_ids id.map $gff_ren
$MAKER_BIN/map_fasta_ids id.map $protein_ren
$MAKER_BIN/map_fasta_ids id.map $transcript_ren