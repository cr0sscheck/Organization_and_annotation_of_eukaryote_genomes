#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=16G
#SBATCH --time=1:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=16_R_prepa
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/16_R_prepa.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/16_R_prepa.err

COURSE_DIR=/data/courses/assembly-annotation-course/CDS_annotation
WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"
OUT_DIR=$WORK_DIR/gene_annotation/comparative_genomics
PEPTIDE_DIR=$OUT_DIR/peptide
BED_DIR=$OUT_DIR/bed

GFF_FILE=$WORK_DIR/gene_annotation/final/filtered.genes.renamed.gff
PROTEIN_FASTA="${WORK_DIR}/gene_annotation/final/assembly.all.maker.proteins.renamed.filtered.longest.fasta"
BED_FILE=$BED_DIR/Kyr-1.bed
FA_FILE=$PEPTIDE_DIR/Kyr-1.fa
REF_BED_FILE_SOURCE=$COURSE_DIR/data/TAIR10.bed
REF_BED_FILE=$BED_DIR/TAIR10.bed
REF_FA_FILE_SOURCE=$COURSE_DIR/data/TAIR10.fa
REF_FA_FILE=$PEPTIDE_DIR/TAIR10.fa

ACCESSIONS=(Are-6 Est-0 Taz-0)
ACCESSIONS_FA_DIR=$COURSE_DIR/data/Lian_et_al/protein/selected
ACCESSIONS_GFF_DIR=$COURSE_DIR/data/Lian_et_al/gene_gff/selected

mkdir -p $OUT_DIR $PEPTIDE_DIR $BED_DIR

# Extract positions of each gene from the filtered gff file
# Also sort by position as the GFF is not sorted for this accession
grep -P "\tgene\t" $GFF_GENES \
| awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' \
| sort -k1,1 -k2,2n \
> $BED_FILE

cp $REF_BED_FILE_SOURCE $REF_BED_FILE
cp $REF_FA_FILE_SOURCE $REF_FA_FILE

for acc in "${ACCESSIONS[@]}"; do
    acc_clean=${acc//-/_}       # Replace the - in the accesion with a _

    gff_in=$ACCESSIONS_GFF_DIR/${acc}.EVM.v3.5.ann.protein_coding_genes.gff
    bed_out=$BED_DIR/${acc_clean}.bed
    fa_in=$ACCESSIONS_FA_DIR/${acc}.protein.faa
    fa_out=$PEPTIDE_DIR/${acc_clean}.fa

    echo "Processing $acc ..."

    grep -P "\tgene\t" $gff_in | \
    awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' \
    > $bed_out

    cp $fa_in $fa_out
done

echo All files prepared in: $OUT_DIR