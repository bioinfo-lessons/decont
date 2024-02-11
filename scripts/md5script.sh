#!/bin/bash

# Check inputs, if  no inputs or enough ERROR

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

url=$1
file_name=$(basename "$url")

mkdir -p data/md5_files

# Descargar el archivo MD5
if wget -P data/md5_files "${url}.md5"; then
    # Obtener el nombre del archivo desde la URL
    md5_remote=$(cat "data/md5_files/${file_name}.md5" | awk '{print $1}')

    # Verificar si el archivo local existe antes de calcular el hash
    if [ -e "data/${file_name}" ]; then
        md5_local=$(md5sum "data/${file_name}" | cut -d' ' -f1)

        # Comparar los valores MD5
        if [ "$md5_remote" == "$md5_local" ]; then
            echo -e "\n\033[1mMESSAGE: The integrity of ${file_name} is valid.\033[0m\n"
        else
            echo -e "\n\033[1mMESSAGE: The integrity of ${file_name} does not match. The file might be corrupt.\033[0m\n"
        fi
    else
        echo -e "\n\033[1mMESSAGE: Local file not found. Unable to verify integrity.\033[0m\n"
    fi
else
    echo -e "\n\033[1mMESSAGE: Failed to download the MD5 file.\033[0m\n"
fi
