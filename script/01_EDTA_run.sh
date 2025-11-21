#!/usr/bin/env bash
#SBATCH --time=48:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=01_EDTA
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/01_EDTA.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/01_EDTA.err
#SBATCH --partition=pibu_el8


WORKDIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"
EDTA2_image="/data/courses/assembly-annotation-course/CDS_annotation/containers/EDTA2.2.sif"
assembly_hifiasm="/data/users/amroczek/annotation_assembly_course/data/hifisam_assembly/ERR11437320.asm.bp.p_ctg.fa"
cds_annotation="/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_cds_20110103_representative_gene_model_updated"

mkdir -p $WORKDIR/results/EDTA_annotation
cd $WORKDIR/results/EDTA_annotation

#Run EDTA on my hifiasm genome assembly where CDS_annotation is used to remove
#every TE candidates that overlap known gene.
#step all means you gonna run the entire EDTA pipeline: TE discovery, filtering, classification, and annotation.
#and anno 1 means you gonna generate a final genome annotation.
apptainer exec --bind /data $EDTA2_image \
EDTA.pl \
    --genome $assembly_hifiasm \
    --species others \
    --step all \
    --sensitive 1 \
    --cds $cds_annotation \
    --anno 1 \
    --threads $SLURM_CPUS_PER_TASK