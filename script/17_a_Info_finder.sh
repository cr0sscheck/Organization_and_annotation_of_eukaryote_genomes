#!/usr/bin/env bash
#SBATCH --time=48:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=Counting
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/Counting.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/Counting.err
#SBATCH --partition=pibu_el8


WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"
GENESPACE_RDS=$WORK_DIR/gene_annotation/comparative_genomics
OUTPUT_PREFIX=output_prefix
R_SCRIPT=$WORK_DIR/../script/17_b_generate_core_acc_specific.R
R_MODULE=R-bundle-IBU/2023072800-foss-2021a-R-4.2.1
ACCESSION=Kyr_1

cd $WORK_DIR

# All genes from GFF
grep -P "\tgene\t" /data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data/gene_annotation/final/assembly.all.maker.noseq.renamed.gff \
  | awk -F'[;=]' '{print $2}' > /data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data/all_genes.txt

echo "grappling done."

cut -f1 $WORK_DIR/gene_annotation/functional_annotation/blastp.tair10.besthits > $WORK_DIR/tair10_hits.txt
cut -f1 $WORK_DIR/gene_annotation/functional_annotation/blastp.viridiplantae.besthits > $WORK_DIR/uniprot_hits.txt

# Combine both
cat $WORK_DIR/tair10_hits.txt uniprot_hits.txt | sort | uniq > $WORK_DIR/genes_with_hits.txt

comm -23 <(sort $WORK_DIR/all_genes.txt) <(sort $WORK_DIR/genes_with_hits.txt) > $WORK_DIR/genes_without_hits.txt

echo "[INFO] Generated genes_with_hits.txt and genes_without_hits.txt"

module load $R_MODULE 
Rscript $R_SCRIPT $GENESPACE_RDS $ACCESSION


