#!/usr/bin/env bash

#SBATCH --time=48:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=12_cAED
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/12_cAED.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/12_cAED.err
#SBATCH --partition=pibu_el8

COURSE_DIR=/data/courses/assembly-annotation-course/CDS_annotation
WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"


MAKER_BIN="${COURSE_DIR}/softwares/Maker_v3.01.03/src/bin"
PERL_MODULE="BioPerl/1.7.8-GCCcore-10.3.0"
UCSC_MODULE="UCSC-Utils/448-foss-2021a"
MARIADB_MODULE="MariaDB/10.6.4-GCC-10.3.0"

# Input/Output files
GFF_IN="${WORK_DIR}/gene_annotation/final/assembly.all.maker.noseq.renamed.iprscan.gff"
GFF_FILTERED_OUT="${WORK_DIR}/gene_annotation/final/assembly.all.maker.noseq.iprscan_quality_filtered.gff"
GFF_GENIC_ONLY="${WORK_DIR}/gene_annotation/final/filtered.genes.renamed.gff"
MRNA_ID_LIST="${WORK_DIR}/gene_annotation/final/list.mRNA.ids.txt"
TRANSCRIPT_FASTA="${WORK_DIR}/gene_annotation/final/assembly.all.maker.transcripts.renamed.fasta"
PROTEIN_FASTA="${WORK_DIR}/gene_annotation/final/assembly.all.maker.proteins.renamed.fasta"
TRANSCRIPT_FASTA_OUT="${WORK_DIR}/gene_annotation/final/assembly.all.maker.transcripts.renamed.filtered.fasta"
PROTEIN_FASTA_OUT="${WORK_DIR}/gene_annotation/final/assembly.all.maker.proteins.renamed.filtered.fasta"

module load "${PERL_MODULE}"
module load "${UCSC_MODULE}"
module load "${MARIADB_MODULE}"

# Filter by AED / InterProScan
perl "${MAKER_BIN}/quality_filter.pl" -s "${GFF_IN}" > "${GFF_FILTERED_OUT}"

# Keep only gene-related features
grep -P "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" "${GFF_FILTERED_OUT}" > "${GFF_GENIC_ONLY}"
  
# Check
cut -f3 "${GFF_GENIC_ONLY}" | sort | uniq -c

# Make list of mRNA IDs (column 9: “ID=…”)
grep -P '\tmRNA\t' "${GFF_GENIC_ONLY}" \
    | awk '{print $9}' \
    | cut -d ';' -f1 \
    | sed 's/ID=//g' \
    > "${MRNA_ID_LIST}"

# Subset transcripts & proteins (faSomeRecords)
faSomeRecords "${TRANSCRIPT_FASTA}" "${MRNA_ID_LIST}" "${TRANSCRIPT_FASTA_OUT}"
faSomeRecords "${PROTEIN_FASTA}"    "${MRNA_ID_LIST}" "${PROTEIN_FASTA_OUT}"

echo "Done."