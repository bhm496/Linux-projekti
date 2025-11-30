 # Salt-mass-users – Palvelinten hallinta - miniprojekti

Tämän projektin tarkoitus on luoda useita Linux-käyttäjiä automaattisesti SaltStackin avulla, käyttäen idempotenttia infrastruktuuria koodina.
Projektilla voidaan nopeasti rakentaa valmiita käyttäjätilejä.

---
## 🗂 Projektin rakenne

```
salt-mass-users/
 ├── top.sls                  # Määrittää, että user_ssh tila ajetaan
 └── user_ssh/
      ├── init.sls            # Varsinainen tila joka luo käyttäjät
      └── users.sls           # Lista käyttäjistä
```

### `users.sls` – käyttäjälista

```yaml
users:
  - maija
  - teppo
  - pekka
  - lenni
  - kalle
```

Salt generoi jokaiselle automaattisesti:

- käyttäjän (`user.present`)
- kotihakemiston (`/home/<nimi>`)
- kansion `/home/<nimi>/projekti`
- oikeat omistajuudet ja käyttöoikeudet

---

⚙️ init.sls – varsinainen tila

Salt generoi jokaiselle käyttäjälle:

käyttäjätilin (user.present)

kotihakemiston (/home/<user>)

alikansion /home/<user>/projekti

oikeat käyttöoikeudet

idempotentin lopputilan

```yaml

{% for user in salt['pillar.get']('users', []) %}
{{ user }}_user:
  user.present:
    - name: {{ user }}
    - shell: /bin/bash

{{ user }}_projects_dir:
  file.directory:
    - name: /home/{{ user }}/projekti
    - user: {{ user }}
    - group: {{ user }}
    - mode: 755
    - makedirs: True
    - require:
      - user: {{ user }}_user

{% endfor %}

```


## Idempotenssi

Projektin keskeinen idea on **idempotentti tila**:

- **Ensimmäinen ajo:**  
  luo käyttäjät ja niiden `projekti`-kansiot → Salt raportoi muutoksia (`changed > 0`)
  
- **Toinen ajo:**  
  mitään ei enää muuteta → Salt raportoi `changed = 0`

Tämä todistaa, että infrastruktuuri voidaan toistaa turvallisesti.

---


## 📸 Lopputulos (ruutukaappauksille varatut paikat)

- Screenshot 1: ensimmäinen Salt-ajo (changed > 0)

<img width="900" height="1042" alt="image" src="https://github.com/user-attachments/assets/5c73ce64-c871-4f72-8503-ca1b0cbbd37e" />


<img width="419" height="1123" alt="image" src="https://github.com/user-attachments/assets/d3d5055b-4a6f-49c0-a77f-bb1c98adf8c1" />


<img width="416" height="1129" alt="image" src="https://github.com/user-attachments/assets/609941d9-2efd-4992-834d-b8318e2878f1" />


<img width="455" height="1120" alt="image" src="https://github.com/user-attachments/assets/b6de725e-f8bf-45db-964c-e8c76ce11755" />


<img width="441" height="1031" alt="image" src="https://github.com/user-attachments/assets/296e6458-f334-447b-aa74-65a10a2886e6" />


<img width="408" height="974" alt="image" src="https://github.com/user-attachments/assets/8089bd9d-56d5-4c5f-8f14-997941404262" />


  
- Screenshot 2: toinen Salt-ajo (changed = 0 / idempotentti)

<img width="671" height="688" alt="image" src="https://github.com/user-attachments/assets/df5f1f09-9de0-4f58-952f-85145b59a0c8" />

<img width="527" height="722" alt="image" src="https://github.com/user-attachments/assets/de973b36-09d2-4bd1-8a89-425bcc92a369" />

<img width="512" height="386" alt="image" src="https://github.com/user-attachments/assets/5ce3ec5c-c008-4541-b396-f6839b188642" />


  
- Screenshot 3: /home-hakemisto, jossa näkyvät käyttäjät ja **projekti**-kansiot

<img width="465" height="167" alt="image" src="https://github.com/user-attachments/assets/b67ffc70-ebad-4f3c-b6a7-e392d837fc8d" />


---

## 🚀 Projektin käyttö tyhjällä koneella

### 1) Asenna Salt

Esimerkiksi Debianissa:

```bash
sudo apt-get update
sudo apt-get install salt-minion -y
```

---

### 2) Kloonaa projekti GitHubista

```bash
git clone https://github.com/bhm496/Linux-projekti.git
cd Linux-projekti/salt-mass-users
```

---

### 3) Kopioi Saltin tilahakemistoon

Salt käyttää oletuksena `/srv/salt` -hakemistoa.

```bash
sudo cp -r user_ssh /srv/salt/
sudo cp top.sls /srv/salt/
```

---

### 4) Aja tila

```bash
sudo salt-call --local state.apply user_ssh
```

---

## ✔️ Lopputulos

Jokaiselle käyttäjälle luodaan:

- käyttäjätili
- kotihakemisto `/home/<käyttäjä>`
- alikansio `/home/<käyttäjä>/projekti`
- oikeat omistajuudet ja käyttöoikeudet

Toistettava ja turvallinen → **idempotentti tila**.

---

## 👤 Tekijät

- **Elina Perkonmäki**
- **Robabe Gouhäri**

---

## 📄 Lisenssi

Projekti on julkaistu GPL-3.0 -lisenssillä.
