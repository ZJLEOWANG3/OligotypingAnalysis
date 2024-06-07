#!/bin/bash
#SBATCH -J extract_NT_DB
#SBATCH -o extract_NT_DB.log
#SBATCH -p short -c 4 -N 1 --time 24:00:00

ls nt.*.tar.gz > list

## for multiple core parallel
cat list | parallel -j $SLURM_CPUS_PER_TASK tar -zxf {} 
# tar taxdb
tar -zxf taxdb.tar.gz

## for 1 core
# for i in $(cat list); do
#   tar -zxf $i
# done
