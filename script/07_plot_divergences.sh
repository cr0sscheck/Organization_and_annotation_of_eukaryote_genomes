#!/usr/bin/env bash

#SBATCH --time=48:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=06_b_plot_parseRM
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/06_b_plot_parseRM.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/06_b_plot_parseRM.err
#SBATCH --partition=pibu_el8

WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course"
DATA_DIR=$WORK_DIR/data/results
DIV_DATA=$DATA_DIR/divergence/*.landscape.Div.Rname.tab
PLOT_DIR=$DATA_DIR/plots

R_MODULE=R-bundle-IBU/2023072800-foss-2021a-R-4.2.1

mkdir -p $PLOT_DIR
cd $PLOT_DIR

module load $R_MODULE 
Rscript $WORK_DIR/script/06_plot_div.R $DIV_DATA