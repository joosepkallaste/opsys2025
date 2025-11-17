# Praktikum 9 - Teenused ja optimeerimine  


---


Selles praktikumis õppisin, kuidas Linuxis ja Windowsis kasutada süsteemi- ja protsessihalduse põhikäsklusi, kuidas alias -i teha mis lihtsustaks tööd, kuidas lisada ja eemaldada teenuseid. Lisaks uuendasin Ubuntut. Üleüldse leidsin praktikumist palju kaulike teadmisi. Praktikum võttis aega ~6 tundi. 


---


## 1.
**PWD=/home/joosep**

---

## 2.
<img width="1278" height="902" alt="image" src="https://github.com/user-attachments/assets/3d22c61a-7a96-4f2d-87e0-843053dadda3" />

---

## 3.
Valisin üleliigseks **simple-scan**, mis on skänneri rakendus, mida virtuaalmasinas ei kasutata, sest VM-il puudub reaalne skänneri riistvara. Seetõttu on pakett ebavajalik. 
Vabastatud kettamaht: ~286 MB
<img width="1283" height="932" alt="77611e89-f6bd-4dc2-a161-39a45590aa06" src="https://github.com/user-attachments/assets/c4bca6f5-dece-4c77-beda-bf2d4283f69b" />
<img width="1282" height="930" alt="c3652edb-b6d9-4708-ab42-d4c0296f0bba" src="https://github.com/user-attachments/assets/1351d7b6-9a66-4d8c-a8ec-7b2915463a89" />


---

## 4.
<img width="1918" height="1006" alt="image" src="https://github.com/user-attachments/assets/3bc57dad-d10d-4ba3-980e-b76626d710c4" />


---

## 5. 
Kui sama EXE-fail on nii kasutaja PATH-is kui ka süsteemi PATH-is, siis käivitatakse see fail kasutaja PATH-is olevast kaustast.  
Põhjus: Windows otsib käsuviibas programme PATH-muutuja loetelus ülevalt alla ning kasutaja PATH on kõrgema prioriteediga kui süsteemi PATH.
Seega kui fail leidub mõlemas, siis alati käivitatakse kasutaja PATH versioon.

---

## 6.
KtmRm for Distributed Transaction Coordinator (Service name: KtmRm) teenus toetab Kernel Transaction Manageri funktsioone, võimaldades süsteemil ja rakendustel teha tehingupõhiseid (transactional) operatsioone NTFS failisüsteemis ja COM+ teenustes.  
Virtuaalmasinas ei kasuta süsteem neid funktsioone, seega teenuse töötamine ei ole vajalik. Teenuse käivitustüübi võib turvaliselt määrata “Disabled”, kuna see ei mõjuta süsteemi normaalset tööd VM-is.  
Tavalises koduarvutis ei ole selle teenuse töötamine üldiselt vajalik, sest enamik kasutajaprogramme ei kasuta KTM transaktsioone.  
Teenuse võib tehniliselt panna Disabled, ilma et Windowsi igapäevane kasutus kannataks.  
Kuid enterprise tasemel rakendused (COM+, DTC, vanemad serveri komponendid) võivad seda vajada, mistõttu ei ole keelamine soovitatav ärikriitilises süsteemis. Tavalise kasutaja arvutis võib selle siiski ohutult välja lülitada.


---


## 7.
<img width="1155" height="826" alt="image" src="https://github.com/user-attachments/assets/ee59cdff-e796-43a6-9ffb-8ab4ae035a11" />


---

## 8.
<img width="1129" height="737" alt="image" src="https://github.com/user-attachments/assets/1b85e7d7-279b-4019-a5a8-db2dbf6aa1cf" />

