#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=30G
#SBATCH --time=24:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=17_R_run
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/17_R_run.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/17_R_run.err


WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"
R_SCRIPT=$WORK_DIR/../script/16_b_run_genespace.R
COURSE_DIR=/data/courses/assembly-annotation-course/CDS_annotation
MCSCANX_PATH=/usr/local/bin
GENESPACE_WORK_DIR=$WORK_DIR/gene_annotation/comparative_genomics
GENESPACE_IMG=$COURSE_DIR/containers/genespace_latest.sif
Kyr_1_FA=$GENESPACE_WORK_DIR/peptide/Kyr_1.fa
RUN_DIRECTORY=$WORK_DIR/gene_annotation

#Normalize the protein name from fa to bed
sed -i 's/-RA.*//' $Kyr_1_FA
sed -i 's/-RB.*//' $Kyr_1_FA

cd $RUN_DIRECTORY

apptainer exec --bind /data --bind $SCRATCH:/temp \
    $GENESPACE_IMG Rscript \
    $R_SCRIPT $GENESPACE_WORK_DIR
echo "[OK] Finished."
