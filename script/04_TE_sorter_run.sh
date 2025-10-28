#!/usr/bin/env bash
#SBATCH --time=48:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=04_TEsorter
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/04_TEsorter.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/04_TEsorter.err
#SBATCH --partition=pibu_el8

WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"
TE_LIB=$WORK_DIR/results/EDTA_annotation/*.fa.mod.EDTA.TElib.fa
TE_ANNOTATION=$WORK_DIR/results/EDTA_annotation/ERR11437320.asm.bp.p_ctg.fa.mod.EDTA.TEanno.gff3
TE_ANNOTATION_CLADES=$WORK_DIR/results/EDTA_annotation/*.TEanno.gff3
OUT_DIR=$WORK_DIR/results
COPIA_SEQ_FILE=$OUT_DIR/Copia_sequences.fa
GYPSY_SEQ_FILE=$OUT_DIR/Gypsy_sequences.fa

COPIA_CLS="${COPIA_SEQ_FILE##*/}.rexdb-plant.cls.tsv"
GYPSY_CLS="${GYPSY_SEQ_FILE##*/}.rexdb-plant.cls.tsv"

SEQKIT_MODULE=SeqKit/2.6.1
TE_sorter_image=/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif

mkdir -p $OUT_DIR

module load $SEQKIT_MODULE
# Extract Copia sequences
seqkit grep -r -p "Copia" $TE_LIB > $COPIA_SEQ_FILE
# Extract Gypsy sequences
seqkit grep -r -p "Gypsy" $TE_LIB > $GYPSY_SEQ_FILE

cd $OUT_DIR

apptainer exec --bind /data $TE_sorter_image \
TEsorter $COPIA_SEQ_FILE -db rexdb-plant
apptainer exec --bind /data $TE_sorter_image \
TEsorter $GYPSY_SEQ_FILE -db rexdb-plant

CLS_ALL="$OUT_DIR/te_clades.cls.tsv"
{
  head -n 1 "$COPIA_CLS"
  tail -n +2 "$COPIA_CLS"
  tail -n +2 "$GYPSY_CLS"
} > "$CLS_ALL"

# Append order/superfamily/clade to EDTA GFF using awk
awk -F'\t' -v OFS='\t' -v CLS="$CLS_ALL" '
BEGIN{
  # Read TEsorter table
  while ((getline line < CLS) > 0) {
    if (line ~ /^[[:space:]]*$/) continue
    split(line, f, "\t")
    if (f[1] ~ /TE_/) {
      key = f[1]
      sub(/#.*/, "", key)          # TE_00000100_INT#LTR/Gypsy -> TE_00000100_INT
      ORD[key] = f[2]              # Order
      SF[key]  = f[3]              # Superfamily
      CLA[key] = (f[4] != "" ? f[4] : "")  # Clade (may be empty)
    }
  }
  close(CLS)
}
# Keep comment lines
/^#/ { print; next }

{
  attrs=$9
  teid=""
  # Find the TE id in attributes (EDTA uses Name=..., sometimes Target=...)
  if (match(attrs, /Name=([^;]+)/, m))      teid = m[1]
  else if (match(attrs, /Target=([^;]+)/, m)) teid = m[1]

  add = ";clade="
  if (teid != "" && (teid in SF)) {
    # Append new annotations, preserving existing attributes
    add = add CLA[teid]
  }
  attrs = attrs add
  $9 = attrs
  print
}
' "$TE_ANNOTATION" > "$TE_ANNOTATION_CLADES"
