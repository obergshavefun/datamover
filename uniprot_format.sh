#!/bin/bash
#PBS -j oe
#PBS -N uniprot_format
#PBS -q default
#PBS -M dslater@igb.illinois.edu
#PBS -m abe
#PBS -d /home/a-m/datamover/log

UNIPROT_DIR=${uniprot_dir}

FILE_LIST=( uniprot_sprot.fasta.gz uniprot_trembl.fasta.gz uniref100.fasta.gz uniref50.fasta.gz uniref90.fasta.gz )

echo -n "Time Started: "
date "+%Y-%m-%d %k:%M:%S"

if [ -d $UNIPROT_DIR ]; then
	cd $UNIPROT_DIR

	for i in "${FILE_LIST[@]}"; do
		if [ -e $UNIPROT_DIR/$i ] 
		then
			#Extract File
			gzip -d $UNIPROT_DIR/$i
			FASTA_NAME=`basename $i .gz`
			
			DB_NAME=`basename $FASTA_NAME .fasta`
			#Blast+ Indexing
			module load blast+
			makeblastdb -dbtype prot -in $UNIPROT_DIR/$FASTA_NAME -out $UNIPROT_DIR/blast+/$DB_NAME
			module purge
			#Blast Indexing
			module load blast
			formatdb -p T -i $UNIPROT_DIR/$FASTA_NAME -n $UNIPROT_DIR/blast/$DB_NAME
		fi
	done
else
	echo "No Uniprot Directory"

fi
echo -n "Time Finished: "
date "+%Y-%m-%d %k:%M:%S"
