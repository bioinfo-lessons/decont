# This script should merge all files from a given sample (the sample id is
# provided in the third argument ($3)) into a single file, which should be
# stored in the output directory specified by the second argument ($2).
#
# The directory containing the samples is indicated by the first argument ($1).

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_directory> <output_directory> <sample_id>"
    exit 1
fi

initial_directory=$1
output_directory=$2
sample_id=$3

zcat "$initial_directory"/"$sample_id"*.fastq.gz > "$output_directory"/"$sample_id".fastq

gzip "$output_directory"/"$sample_id".fastq



