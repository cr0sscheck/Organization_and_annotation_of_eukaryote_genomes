#!/usr/bin/env bash
#SBATCH --time=48:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=01_EDTA
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/01_EDTA.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/01_EDTA.err
#SBATCH --partition=pibu_el8

TE_sorter_image=/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif