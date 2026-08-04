# Obraz strony: nginx + pliki portfolio wkopiowane do srodka.
#
# Pliki trafiaja do obrazu na etapie budowania, wiec kontener nie montuje
# niczego z dysku serwera. Zrodlem jest repozytorium GitHub wskazane
# w docker-compose.yml jako kontekst budowania.

FROM nginx:stable-alpine

WORKDIR /usr/share/nginx/html

# Sama strona. LICENSES-icons.md jedzie razem z nia, bo licencje ISC i MIT
# wymagaja, zeby nota o prawach autorskich towarzyszyla kazdej kopii - a
# opublikowana strona jest kopia.
COPY index.html LICENSES-icons.md ./

# Zrzuty ekranu projektow. Wczesniej byly poza kontenerem i zwracaly 404.
COPY *.png ./

# Wprost, zeby nie zalezec od domyslnej maski w obrazie bazowym.
EXPOSE 80
