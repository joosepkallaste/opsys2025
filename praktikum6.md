# Praktikum 6 - Protsessid ja signaalid
Käes olevas praktikumis õppisin protsesside ja signaalide kohta. Praktikum aitas mõista, kuidas operatsioonisüsteemid suhtlevad programmidega, kuidas protsessid ja sündmused süsteemitasandil edastatakse ning kuidas neid saab käsurea tööriistade abil analüüsida ja juhtida.
## 5.1
<img width="1361" height="890" alt="image" src="https://github.com/user-attachments/assets/de8038b2-56a9-4fb7-8708-05022b3a7ac4" />\
## 5.2
<img width="1365" height="891" alt="be7342bc-c9aa-458a-8d3b-2b73d29eda9c" src="https://github.com/user-attachments/assets/81d8e503-ac6c-4b15-8b9d-97465699a450" />\
## 5.3
<img width="1367" height="899" alt="image" src="https://github.com/user-attachments/assets/8e580663-8555-4f72-941c-8e970117be09" />
## 5.4
**`ip a | grep inet | grep -v inet6 | awk '{print $2}' | cut -d'/' -f1 | grep -v '^127\.'`**


<img width="1367" height="866" alt="ad7e8d54-d4d3-4b09-a54f-c8cf2e952b62" src="https://github.com/user-attachments/assets/cab7b69e-1d87-4919-a993-a4259def182b" />

## 5.5

### 1) `20:48:13.548, 32, "WM_SETCURSOR", 199540, 33554433`

Sõnum teatab akent, et kursor on selle akna kohal ja aken peab määrama kursori kuju (nt nooleke, tekstikursor jne).  
**wParam = 199540** — käepide (HWND) aknale/elemendile, mille kohal kursor on (mittenull → sõnum kehtib).  
**lParam – 32 bitti:**  
- madal 16 bitti = *hit-test kood*. Meil 0x0001 = **HTCLIENT** → kursor on kliendialal.  
- kõrge 16 bitti = *algne hiireteade*. Meil 0x0200 = **WM_MOUSEMOVE** → sõnum vallandati hiire liikumisest.  
Tervikuna **lParam = 33554433 = 0x02000001 → WM_MOUSEMOVE + HTCLIENT.**

---

### 2) `20:48:13.549, 512, "WM_MOUSEMOVE", 0, 18022922`

Teavitab, et hiir liikus aknas kliendialal.  
**wParam =** klahvi-/nupulipp = 0 → nuppe ega modifikaatoreid ei hoita all.  
**lParam =** kliendikoordinaadid (x, y).  
lParam = 18022922 = 0x0113020A → x = 0x020A = **522**, y = 0x0113 = **275.**

---

### 3) `20:46:15.431, 49491, "???", 0, 0`

ID **49491 = 0xC153** asub vahemikus 0xC000…0xFFFF, mis on reserveeritud dünaamiliselt registreeritud aknasõnumitele  
(**RegisterWindowMessage**). Nende nimed on teada ainult registreerival komponendil, seetõttu näeb tööriist nime **"???"**.  
Parameetrid: **wParam = 0**, **lParam = 0** (täiendavaid andmeid ei edastatud).









