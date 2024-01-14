#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Usage : $0 <list_of_urls> <contaminants_url>"
	exit 1
fi

list_of_urls=$(cat $1)
contaminants_url=$(cat $2)

#Download all the files specified in data/filenames

#for url in $list_of_urls #TODO
#do
#         bash scripts/download.sh $url data
#done

carpeta="data"
archivos=$(find "$carpeta" -type f -name "*.fastq.gz")

if [ -z "$archivos" ]; then
    wget -P data -i data/urls.txt
else
    for url in $list_of_urls; do
        archivo_base=$(basename "$url")
        
        if echo "$archivos" | grep -q "$archivo_base"; then
            echo -e "WARNING: $archivo_base is already downloaded\n"
        else
            wget -P data "$url"
        fi
    done
fi

for url in $list_of_urls
do
	bash scripts/md5script.sh $url
done

rm -R data/md5_files

# Download the contaminants fasta file, uncompress it, and
# filter to remove all small nuclear RNAs

bash scripts/download.sh $contaminants_url res yes


archivo="res/contaminants.fasta"
contenido_filtrado=$(grep -v "small nuclear" $archivo)
echo "$contenido_filtrado" > res/contaminants.fasta
gzip -fk res/contaminants.fasta

# Create the log file
log_file="log/pipeline.log"


# Index the contaminants file

echo "Starting indexing of contaminants..." > "$log_file"
bash scripts/index.sh res/contaminants.fasta res/contaminants_idx
cat res/contaminants_idx/Log.out >> "$log_file"
rm -r res/contaminants_idx/Log.out

echo "Indexing finished" >> "$log_file"
# Merge the samples into a single file

list_of_sample_ids=$(ls -1 data/*.fastq.gz | grep -E "/[A-Z][^\]*$" | xargs -I {} basename {} | cut -d"-" -f1| sort | uniq)

mkdir -p out/merged

# Merge fastqs
for sid in $list_of_sample_ids #TODO
do
    bash scripts/merge_fastqs.sh data out/merged $sid
done

# TODO: run cutadapt for all merged files
mkdir -p out/trimmed
mkdir -p log/cutadapt


echo "Startig trimmed..." >> "$log_file"

# Trimmed: Execute cutadapt
for sid in $list_of_sample_ids
do
	 cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
	 -o out/trimmed/"$sid".trimmed.fastq.gz out/merged/"$sid".fastq.gz \
	> log/cutadapt/"$sid".log
	echo "$sid" >> "$log_file"
	cat log/cutadapt/"$sid".log >> "$log_file"
done



echo "Trimmed finished" >> "$log_file"
echo "Starting alignment..." >> "$log_file"

# TODO: run STAR for all trimmed files
mkdir -p out/star

for fname in out/trimmed/*.fastq.gz
do
    # you will need to obtain the sample ID from the filename
    base_name=$(basename "$fname")
    sid=$(echo "$base_name" | sed 's/\.trimmed\.fastq\.gz$//')
    mkdir -p out/star/$sid
    STAR --runThreadN 4 --genomeDir res/contaminants_idx \
        --outReadsUnmapped Fastx --readFilesIn out/trimmed/"$sid".trimmed.fastq.gz \
       --readFilesCommand gunzip -c --outFileNamePrefix "out/star/$sid/"
    echo "$sid" >> "$log_file"
    cat out/star/"$sid"/Log.out >> "$log_file"
done 

echo "Alignment finished" >> "$log_file"

# TODO: create a log file containing information from cutadapt and star logs
# (this should be a single log file, and information should be *appended* to it on each run)
# - cutadapt: Reads with adapters and total basepairs
# - star: Percentages of uniquely mapped reads, reads mapped to multiple loci, and to too many loci
# tip: use grep to filter the lines you're interested in

