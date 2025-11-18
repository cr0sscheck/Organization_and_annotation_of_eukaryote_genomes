#!/usr/bin/env bash
#SBATCH --job-name=Busco
#SBATCH --partition=pibu_el8
#SBATCH --time=05:00:00
#SBATCH --cpus-per-task=10
#SBATCH --mem=16G
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/Busco_plot.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/Busco_plot.err

WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"
LOGDIR=$WORK_DIR/../../logs
# Path to the directory of the input files
ANNODIR=$WORK_DIR/annotation_qc
OUTDIR=$ANNODIR/busco

# Create the directory for the error and output file if not present
mkdir -p "$LOGDIR"

# Create the directory output if not present
mkdir -p "$OUTDIR"

# Change to output directory
cd "$OUTDIR"

# Load BUSCO module
module load BUSCO/5.4.2-foss-2021a

#generate_plot.py -wd "$OUTDIR/proteins"
#generate_plot.py -wd "$OUTDIR/transcriptome"

#combined plot
mkdir -p "$OUTDIR/combined_summaries"
cp "$OUTDIR/proteins"/short_summary*.txt "$OUTDIR/combined_summaries/"
cp "$OUTDIR/transcriptome"/short_summary*.txt "$OUTDIR/combined_summaries/"

generate_plot.py -wd "$OUTDIR/combined_summaries"