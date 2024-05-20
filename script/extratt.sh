#!/bin/bash
#SBATCH -J extract_NT_DB
#SBATCH -o extract_NT_DB.log
#SBATCH -p short -c 4 -N 1 --time 24:00:00

ls nt.*.tar.gz > list

## for multiple core parallel
cat list | parallel -j $SLURM_CPUS_PER_TASK tar -zxf {} 
# tar the last file because there is one file that all files share, which needs to be updated
tar -zxf $(tail -n1 list)

## for 1 core
# for i in $(cat list); do
#   tar -zxf $i
# done
