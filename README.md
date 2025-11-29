# Linux-projekti
## Linux kurssin miniprojekti

 projektin aloittaminen ✔

 Saltin konfigurointi ✔

 users.sls & init.sls ✔
  
 idempotenssitestaus ✔
  
 dokumentointi
 
 projektin tallennus GitHubiin ✔
 
 demokoneen luonti
 
 projektin ajaminen puhtaalla koneella

 # Salt-mass-users – Palvelinten hallinta - miniprojekti

Tämän projektin tarkoitus on luoda useita Linux-käyttäjiä automaattisesti SaltStackin avulla, käyttäen idempotenttia infrastruktuuria koodina.
Projektilla voidaan nopeasti rakentaa valmiita käyttäjätilejä esimerkiksi kehitysympäristöihin, harjoituslaitteille tai organisaation peruskoneille.

---

## 📸 Lopputulos (ruutukaappauksille varatut paikat)

- Screenshot 1: ensimmäinen Salt-ajo (changed > 0)
- Screenshot 2: toinen Salt-ajo (changed = 0 / idempotentti)
- Screenshot 3: /home-hakemisto, jossa näkyvät käyttäjät ja **projekti**-kansiot

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

## Idempotenssi

Projektin keskeinen idea on **idempotentti tila**:

- **Ensimmäinen ajo:**  
  luo käyttäjät ja niiden `projekti`-kansiot → Salt raportoi muutoksia (`changed > 0`)
  
- **Toinen ajo:**  
  mitään ei enää muuteta → Salt raportoi `changed = 0`

Tämä todistaa, että infrastruktuuri voidaan toistaa turvallisesti.

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
