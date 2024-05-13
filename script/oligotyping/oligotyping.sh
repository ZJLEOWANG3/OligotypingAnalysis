#!/bin/bash
#SBATCH -J OLIGOTYPING
#SBATCH -pshort -N1 -c4

positions=$(cat filtered_positions)
aln="mothur2oligo.fasta"

# blast is required by oligotyping; include from non-standard path
PATH="$HOME/opt/ncbi/blast+-2.13.0/bin:$PATH"
  
entropy=$aln"-ENTROPY"
out_dir=$aln".position_oligotype."$(echo $positions | sed 's/,/_/g' | cut -c1-8)

rm -rf $out_dir # clean up old results

oligotype -M 0 -s 3 -C $positions -N $SLURM_CPUS_PER_TASK -o $out_dir \
	$aln $aln"-ENTROPY"

ln -sfT $out_dir mothur2oligo.fasta.oligo_final

script/plot.oligo_size_histogram.py \
	-p $out_dir.oligo_size_histogram.png \
	$out_dir

script/plot.oligo_abund_stackbar.py \
	-n 20 \
	-p $out_dir.oligo_abund_stackbar.png \
 	$out_dir
