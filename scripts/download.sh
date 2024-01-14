# This script should download the file specified in the first argument ($1),
# place it in the directory specified in the second argument ($2),
# and *optionally*:
# - uncompress the downloaded file with gunzip if the third
#   argument ($3) contains the word "yes"
# - filter the sequences based on a word contained in their header lines:
#   sequences containing the specified word in their header should be **excluded**
#
# Example of the desired filtering:
#
#   > this is my sequence
#   CACTATGGGAGGACATTATAC
#   > this is my second sequence
#   CACTATGGGAGGGAGAGGAGA
#   > this is another sequence
#   CCAGGATTTACAGACTTTAAA
#
#   If $4 == "another" only the **first two sequence** should be output



# Verificar si se proporcionaron los argumentos esperados
if [ "$#" -lt 2 ]; then
    echo "Uso: $0 <url_del_archivo> <directorio_destino> [si/descomprimir] [palabra_a_filtrar]"
    exit 1
fi

# Argumentos
file_url="$1"
final_directory="$2"
tounzip="$3"
two_sequences="$4"

mkdir -p "$final_directory" # Crear directorio de destino en el caso de que este no exista

wget -P "$final_directory" "$file_url"

file_name_unzip=$(echo "$file_url" | sed 's/\.gz$//')
file_name=$(basename "$file_url")


# Descomprimir si se especifica
if [ "$tounzip" == "yes" ]; then
    # Obtener el nombre del archivo sin la extensión .gz
    file_name_unzip="${final_directory}/$(basename "$file_url" .gz)"

    # Descomprimir el archivo
    gzip -dk "$final_directory/$(basename "$file_url")"


fi


if [ -n "$two_sequences" ]; then
	if [ "$two_sequences" == "another" ]; then
		# Crear directorio de salida si no existe
		mkdir -p "${final_directory}_2seq"
		if [[ "$file_name_unzip" == *.fasta ]]; then
            		# Procesar archivos FASTA
            		awk '/^>/ {++seq; if (seq > 2) exit} 1' "${file_name_unzip}" > "${final_directory}_2seq/$(basename "$file_name_unzip")_2seq.fasta"
        	elif [[ "$file_name_unzip" == *.fastq ]]; then
            		# Procesar archivos FASTQ
            		awk '/^@/ {++seq; if (seq > 2) exit} 1' "${file_name_unzip}" > "${final_directory}_2seq/$(basename "$file_name_unzip")_2seq.fastq"
        	else
           		 echo "Formato de archivo no reconocido: $file_name_unzip"
        	fi
          	
	fi
fi
