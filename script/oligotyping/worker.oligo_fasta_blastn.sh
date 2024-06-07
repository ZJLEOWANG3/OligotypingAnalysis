#!/bin/bash

#SBATCH -N1 -c8 -pshort
#SBATCH --time 24:00:00
#SBATCH --output=output.txt
#SBATCH --error=error.txt

input_list=$1; shift;
taxid=$1;shift;

echo $taxid

blastn_dir="blastn"
blast_db="$HOME/scratch/DATABASE/BLAST/nt"
python_env_prefix="$HOME/.local/env/python-3.10.10-venv-generic"
blastx_prefix="$HOME/opt/ncbi/ncbi-blast-2.15.0+"

maxmatch=20

for fasta_full in $(cat $input_list); do

	fasta="$(basename $fasta_full)"; shift;

	. $python_env_prefix/bin/activate
	# remove gaps in input fasta
	seqmagick convert --ungap --input-format fasta \
		$fasta_full \
		$blastn_dir/$fasta.fna
	deactivate

	# blastn
	
	blast_cmd=("$blastx_prefix/bin/blastn"
		"-query" "$blastn_dir/$fasta.fna"
		"-out" "$blastn_dir/$fasta.fna.blastn"
		"-outfmt" "6 qseqid sacc pident evalue bitscore"
		"-db" "$blast_db"
		"-max_target_seqs" "$maxmatch"
		"-num_threads" "$SLURM_CPUS_PER_TASK")
	
#		"-perc_identity" "99"

	if [ -n "$taxid" ]; then
		blast_cmd+=("-taxids" "$taxid") 
	fi
	
	echo "Running blastn with command: ${blast_cmd[@]}" 1>&2
	# Run the blastn command
	"${blast_cmd[@]}"

	# blastdbcmd
	cut -f2 -d '	' $blastn_dir/$fasta.fna.blastn > $blastn_dir/$fasta.fna.blastn.hit_accs
	$blastx_prefix/bin/blastdbcmd \
		-db $blast_db \
		-dbtype nucl \
		-entry_batch $blastn_dir/$fasta.fna.blastn.hit_accs \
		-out $blastn_dir/$fasta.fna.blastn.blastdbcmd \
		-outfmt "%a	%T	%S"

done
