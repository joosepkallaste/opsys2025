# Praktikum 7 - Haakimine
Praktikumis õppisin USB-andmekandjaid Linuxis käsitsi haakima ja uurisin nende partitsioonistruktuuri. Vaatlesin, miks uued kettad vajavad lähtestamist, ning võrdlesin GPT ja MBR partitsiooniskeeme. Kasutasin mount käsu erinevaid parameetreid, mille abil Ubuntu tuvastas faili­süsteemi tüübi automaatselt (vfat). Kokkuvõttes sain praktilise kogemuse failisüsteemide tuvastamise ja andmekandjate ühendamisega.
## 1. Miks uued andmekandjad vajavad lähtestamist?

Uutel andmekandjatel puudub toimiv partitsioonitabel, mistõttu operatsioonisüsteem ei tea, kuidas ketta sektoreid struktuuriks jagada. Lähtestamine loob vajaliku skeemi (nt GPT), mille abil saab OS luua partitsioone ja vormindada need failisüsteemiga. Lisaks eemaldab lähtestamine võimalikud vanad või vigased metaandmed, mis takistaksid ketta korrektset kasutamist.

---

## 2. GPT tehnilised eelised võrreldes MBR-iga

1. **Suuremate ketaste tugi** – GPT toetab >2 TB kettaid, MBR mitte.  
2. **Rohkem partitsioone** – kuni 128 partitsiooni ilma extended/logical keerukusteta.  
3. **Usaldusväärsem struktuur** – metaandmed salvestatakse nii ketta algusesse kui lõppu, pakkudes varukoopiat vigade olukorras.  
4. **UEFI tugi** – GPT võimaldab kaasaegset UEFI boot’i, kiiremat alglaadimist ja Secure Boot funktsionaalsust.

---

## 3. Link
https://kodut.ut.ee/~joosep-gre/opsys/hdd.png

---

## 4. 
<img width="956" height="1005" alt="image" src="https://github.com/user-attachments/assets/3f366a84-8867-4538-8b57-0d41c00360c6" />

---

## 5. Mida mõjutavad `mount` käsu parameetrid `-o ro` ja `-t auto`?

- `-o ro` — haagib failisüsteemi **read-only** režiimis (ainult lugemine).
- `-t auto` — Ubuntu tuvastab failisüsteemi tüübi **automaatselt**.

---

## 6. Millise väärtusega asendas Ubuntu `auto` parameetri?

Ubuntu tuvastas failisüsteemi tüübiks:

- **vfat**

---

## 7. 
<img width="1364" height="891" alt="4902a40b-19a1-4028-9d21-d0f54e63064d" src="https://github.com/user-attachments/assets/9eafa223-186f-4952-8bdb-ad02dbb7e764" />


