#!/usr/bin/env bash

#SBATCH --time=48:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=08_maker
#SBATCH -o /data/users/amroczek/annotation_assembly_course/logs/08_maker.out
#SBATCH -e /data/users/amroczek/annotation_assembly_course/logs/08_maker.err
#SBATCH --partition=pibu_el8

COURSE_DIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORK_DIR="/data/users/amroczek/annotation_assembly_course/Organisation_and_annotation_course/data"
OUT_DIR=$WORK_DIR/gene_annotation
REPEATMASKER_DIR="/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"
MAKER_IMG=/data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif


cd $OUT_DIR

module load OpenMPI/4.1.1-GCC-10.3.0
module load AUGUSTUS/3.4.0-foss-2021a

mpiexec --oversubscribe -n 50 apptainer exec \
--bind $SCRATCH:/TMP --bind $COURSE_DIR --bind $AUGUSTUS_CONFIG_PATH --bind $REPEATMASKER_DIR --bind /data \
$MAKER_IMG \
maker -mpi --ignore_nfs_tmp -TMP /TMP maker_opts.ctl maker_bopts.ctl maker_evm.ctl maker_exe.ctl