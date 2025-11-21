#!/usr/bin/env bash
#SBATCH --time=48:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=02_LTR
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/02_LTR_2.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/02_LTR_2.err
#SBATCH --partition=pibu_el8

WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"
PLOT_DIR=$WORK_DIR/results/plots
LTRRT_ANNOTATION=$WORK_DIR/results/EDTA_annotation/ERR11437320.asm.bp.p_ctg.fa.mod.EDTA.raw/ERR11437320.asm.bp.p_ctg.fa.mod.LTR.intact.raw.gff3
LTRRT_LIBRARY=$WORK_DIR/results/EDTA_annotation/ERR11437320.asm.bp.p_ctg.fa.mod.EDTA.raw/ERR11437320.asm.bp.p_ctg.fa.mod.LTR.raw.fa
OUT_DIR=$WORK_DIR/results/EDTA_annotation
TSV_FILE=$OUT_DIR/*.fa.mod.LTR.raw.fa.rexdb-plant.cls.tsv

TE_sorter_image=/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif
R_MODULE=R-bundle-IBU/2023072800-foss-2021a-R-4.2.1

cd $OUT_DIR

#classifie the raw LTR candidates by protein domains using the RexDB-plant database.
apptainer exec --bind /data $TE_sorter_image \
TEsorter *.fa.mod.EDTA.raw/*.mod.LTR.raw.fa -db rexdb-plant

cd $PLOT_DIR

# Plot the number of LTR-RTs in each clade with their corresponding percent identity
module load $R_MODULE 
Rscript $WORK_DIR/../script/02_b_full_length_LTRs_identity.R \
$LTRRT_ANNOTATION $TSV_FILE \