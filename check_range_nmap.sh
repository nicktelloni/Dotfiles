
#!/bin/bash

# Impostazioni
PORT=80
OUTPUT_FILE="porte_aperte.txt"
NMAP_OUTPUT_DIR="nmap_results"
TIMEOUT=1

# Crea la directory per i risultati di nmap
mkdir -p "$NMAP_OUTPUT_DIR"

> "$OUTPUT_FILE"

echo "Avvio scansione sulla porta $PORT per il range 10.3.0.0/19 (da 10.3.0.1 a 10.3.31.254)..."

for third in {0..31}
do
  for fourth in {0..255}
  do
    if [[ $third -eq 0 && $fourth -eq 0 ]] || [[ $third -eq 31 && $fourth -eq 255 ]]; then
      continue
    fi

    IP="10.3.${third}.${fourth}"

    (
      if nc -z -w $TIMEOUT "$IP" $PORT &>/dev/null; then
        echo "Porta $PORT aperta su: $IP"
        echo "$IP" >> "$OUTPUT_FILE"

        # Esegue nmap -A e salva output in file dedicato
        nmap -A "$IP" > "$NMAP_OUTPUT_DIR/${IP//./_}.txt"
      fi
    ) &

  done
 done

wait

echo "Scansione e monitoraggio con nmap completati."
