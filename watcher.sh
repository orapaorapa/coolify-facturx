#!/bin/sh
set -eu

echo "Demarrage du watcher Factur-X"

cd /data

while true; do
  found_any=0

  for f in *.pdf; do
    [ -e "$f" ] || continue

    base="${f%.pdf}"

    case "$f" in
      facturx_*) continue ;;
    esac

    if [ -f "${base}.xml" ] && [ ! -f "facturx_${base}.pdf" ]; then
      echo "Conversion de ${base}"

      java -Xmx1G -Dfile.encoding=UTF-8 -jar /opt/mustang/Mustang-CLI.jar \
        --action combine \
        --source "${base}.pdf" \
        --xml "${base}.xml" \
        --out "facturx_${base}.pdf" \
      && echo "OK : facturx_${base}.pdf cree" \
      || echo "ECHEC : ${base}"

      found_any=1
    fi
  done

  if [ "$found_any" -eq 0 ]; then
    echo "Aucun nouveau fichier a traiter"
  fi

  sleep 10
done
