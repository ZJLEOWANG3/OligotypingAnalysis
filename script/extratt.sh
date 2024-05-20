#!/bin/bash
#SBATCH -J extract_NT_DB
#SBATCH -o extract_NT_DB.log
#SBATCH -p short -c 1 -N 1 --time 24:00:00

ls nt.*.tar.gz > list

for i in $(cat list); do
  tar -zxf $i
done
