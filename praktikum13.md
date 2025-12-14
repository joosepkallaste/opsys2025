# Praktikum13 - Skriptimine Linuxis
---
Selles praktikumis õppisin skriptima ja kirjutasime esimesed skriptid. Syntaks tundus palju raskem kui pyhtonil aga õpitav. Praktikum oli väga huvitav ja kaua oodatud. Aega kulus tunduvalt vähem kui eelnevatel.  

---

## 3.
```bash
#!/bin/sh
echo "Sisesta oma nimi: "
read nimi
echo "Sisesta oma erialanimi: "
read erialanimi
echo "Sisesta oma matriklinumber"
read matriklinumber
echo "$nimi oppib erialal $erialanimi ja tema matriklinumber on $matriklinumber"
```
<img width="1919" height="1078" alt="image" src="https://github.com/user-attachments/assets/c3c9c2c9-ab3f-4ec4-b8d3-98e35f33d5b8" />

---

## 4.
```bash
#!/bin/bash
old="$1"
new="$2"
shopt -s nullglob

for file in *."$old"; do
  mv "$file" "${file%.$old}.$new"
done
```
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/747f5319-14ac-4cdf-b032-8825b5dcf08e" />

---

## 5.
```bash
#!/bin/bash
protsess="$1"

IFS=$'\n'

for line in $(ps -A); do
  cmd=$(echo " $line" | tr -s ' ' | cut -d ' ' -f5)

  if [ "$protsess" = "$cmd" ]; then
    pid=$(echo " $line" | tr -s ' ' | cut -d ' ' -f2)
    echo "$pid $cmd"
  fi
done
```
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/5b29e6d4-1519-47cf-9b14-90cf20d82726" />

---

## 6.
```bash
#!/bin/bash
a="$1"
b="$2"

astmesse() {

  alus="$1"
  aste="$2"

  if [ "$aste" -eq 0 ]; then
    echo 1
  else
    rek=$(astmesse "$alus" $((aste - 1)))
    echo $((alus * rek))
  fi
}

echo "$a^$b = $(astmesse $a $b)"
```
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/440e3450-7039-458d-a710-2aa086091c41" />

---

## 7. 
<img width="1616" height="1079" alt="image" src="https://github.com/user-attachments/assets/9494b6a8-cb25-487f-a214-4c66403dc8d2" />
<img width="1635" height="1071" alt="image" src="https://github.com/user-attachments/assets/3b43aae0-79de-4e57-986d-9362a9e5be9d" />

