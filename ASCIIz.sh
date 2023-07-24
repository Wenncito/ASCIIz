#!/bin/bash

function ctrl_c() {
  echo -e "\n\n[!] Saliendo...\n"
  exit 1
}

# Ctrl+C
trap ctrl_c INT

# Función para comprobar si un archivo es ASCII
function is_ascii() {
  if [[ -n $(file "$1" | grep "ASCII") ]]; then
    return 0
  else
    return 1
  fi
}

first_file_name="Archivo_a_descomprimir"
decompressed_file_name="$(7z l "$first_file_name" | tail -n 3 | head -n 1 | awk 'NF{print $NF}')"

7z x "$first_file_name" &>/dev/null

last_decompressed_file=""

while [ -n "$decompressed_file_name" ]; do
  echo -e "\n[+] Nuevo archivo descomprimido: $decompressed_file_name"
  7z x "$decompressed_file_name" &>/dev/null
  last_decompressed_file="$decompressed_file_name"
  decompressed_file_name="$(7z l "$decompressed_file_name" 2>/dev/null | tail -n 3 | head -n 1 | awk 'NF{print $NF}')"
done

# Comprobamos si el último archivo descomprimido es ASCII antes de usar 'cat'
if is_ascii "$last_decompressed_file"; then
  echo -e "\n[+] Contenido del último archivo (ASCII):\n"
  cat "$last_decompressed_file"
fi
