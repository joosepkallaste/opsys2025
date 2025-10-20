# Praktikum 5 Failiõigused Linuxis
Selles praktikumis uurisin lähemalt Linux failiõiguste kohta. Sain õppida: kuidas failiõigusi muuta ja ligipääsu lisada teistele kasutajatele. Lisaks sain uusi teadmisi Linuxi turvapraktika kohta ning õppisin lisaks ka Github.md vormistamise kohta. Praktikum võttis umbes 6 tundi aega ja oli üpris raske.\
5.1\
a) chmod u+rx /tmp/kaust\
   chmod u+r /tmp/kaust/minufail.txt\
b) chmod u+wx /tmp/kaust\
5.2\
chmod a=x  ei piisa, sest shell peab skripti sisu lugema. Kui failil on ainult x, aga pole r- õigust, tõlk ei saa faili avada --> Premission denied.\
Miinimum õigused skripti otseseks käivitamiseks on rx ehk lugemis- ja käivitamisõigus. Kui käivitada: sh skript.sh, piisab failile r- õigusest.\
5.3\
See on väga levinud Linuxi turvapraktika, mida nimetatakse User Private Group (UPG) süsteemiks. Kui igal kasutajal on oma isiklik grupp siis on võimalik turvaliselt jagada failiõigusi.\
5.4\
Faili grupil peab olema lugemisõigus (r) -> et grupi liige saaks faili lugeda. Kataloogil, kus fail asub, peab grupil olema x (execute) õigus -> see võimaldab grupi liikmel üldse faili juurde siseneda.
<img width="1369" height="895" alt="5 4" src="https://github.com/user-attachments/assets/20f849e2-22f2-4184-bfd3-b77464aa9af0" />
5.5\
<img width="1364" height="900" alt="5 5" src="https://github.com/user-attachments/assets/74fc5d6e-9d6e-4f15-9d9e-faa6704882e1" />
5.6\
Jah, setuid-i kasutamine võib vähendada süsteemi turvalisust.
Kui programm, millel on setuid õigused, sisaldab vigu või turvaauke, saab pahatahtlik kasutaja selle kaudu kõrgemaid õigusi (nt root) endale hankida.
peeter (faili omanik)\
5.7
1. root
2. opetaja
3. gre\
Kõik teised kasutajad — nt joosep, jukuisa — ei saa gre faile kustutada, isegi kui neil on kirjutusõigus kataloogile, sest sticky bit takistab seda.\
5.8
```
# file: hinded.txt
# owner: opetaja
# group: opetaja
user::rw-
group::---
group:direktor:rw-
mask::rw-
other::---
```
5.9\
Ainult root kasutaja saab faili atribuute muuta või eemaldada. Faili saab kustutada siis kui kõigepealt eemaldad immutable atribuudi. (sudo chattr -i testfail-2, 
sudo rm testfail-2)
