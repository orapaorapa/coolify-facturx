#!/bin/sh
set -eu

echo "Demarrage du watcher Factur-X"

cd /data

while true; do
  found_any=0

  for f in *.pdf *.PDF; do
    [ -e "$f" ] || continue

    base=$(echo "$f" | sed 's/\.[pP][dD][fF]$//')

    case "$f" in
      facturx_*) continue ;;
    esac

    if [ -f "${base}.xml" ] && [ ! -f "facturx_${base}.pdf" ]; then
      echo "Conversion de ${base}"

      rm -f "facturx_${base}.pdf"

      java -Xmx1G -Dfile.encoding=UTF-8 -jar /opt/mustang/Mustang-CLI.jar \
        --action combine \
        --source "${f}" \
        --source-xml "${base}.xml" \
        --out "facturx_${base}.pdf" \
        --format fx \
        --version 2 \
        --profile EN16931 \
        --no-additional-attachments

      if [ -f "facturx_${base}.pdf" ]; then
        echo "OK : facturx_${base}.pdf cree"
      else
        echo "ECHEC : ${base}"
      fi

      found_any=1
    fi
  done

  if [ "$found_any" -eq 0 ]; then
    echo "Aucun nouveau fichier a traiter"
  fi

  sleep 10
done
