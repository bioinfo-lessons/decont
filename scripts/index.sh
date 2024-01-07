# This script should index the genome file specified in the first argument ($1),
# creating the index in a directory specified by the second argument ($2).

# The STAR command is provided for you. You should replace the parts surrounded
# by "<>" and uncomment it.

file_input=$1
directory_output=$2

# Asegúrate de que directory_output tenga un valor válido.
if [ -z "$directory_output" ]; then
    echo "Error: La variable directory_output está vacía."
    exit 1
fi

mkdir -p "$directory_output"

 STAR --runThreadN 4 --runMode genomeGenerate --genomeDir "$directory_output" \
 --genomeFastaFiles "$file_input" --genomeSAindexNbases 9



