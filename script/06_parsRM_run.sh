#!/usr/bin/env bash

#SBATCH --time=48:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=06_parseRM
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/06_parseRM.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/06_parseRM.err
#SBATCH --partition=pibu_el8

WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course"
DATA_DIR=$WORK_DIR/data/results
PERL_SCRIPT=$WORK_DIR/script/perlScripts/parsRM.pl
REPEATMASKER_FILE=$DATA_DIR/EDTA_annotation/ERR11437320.asm.bp.p_ctg.fa.mod.EDTA.anno/ERR11437320.asm.bp.p_ctg.fa.mod.out
OUT_DIR=$DATA_DIR/divergence


PERL_MODULE=BioPerl/1.7.8-GCCcore-10.3.0

mkdir -p $OUT_DIR

cd $OUT_DIR

module add $PERL_MODULE
perl $PERL_SCRIPT -i $REPEATMASKER_FILE -l 50,1 -v

mv $REPEATMASKER_FILE.landscape* $OUT_DIR