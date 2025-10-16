5.1\
a) chmod u+rx /tmp/kaust\
   chmod u+r /tmp/kaust/minufail.txt\
b) chmod u+wx /tmp/kaust\
5.2\
chmod a=x  ei piisa, sest shell peab skripti sisu lugema. Kui failil on ainult x, aga pole r- õigust, tõlk ei saa faili avada --> Premission denied.\
Miinimum õigused skripti otseseks käivitamiseks on rx ehk lugemis- ja käivitamisõigus. Kui käivitada: sh skript.sh, piisab failile r- õigusest.\
5.3\
See on väga levinud Linuxi turvapraktika, mida nimetatakse User Private Group (UPG) süsteemiks. Kui igal kasutajal on oma isiklik grupp siis on võimalik turvaliselt jagada failiõigusi. 
