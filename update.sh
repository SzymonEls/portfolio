#!/usr/bin/env bash
#
# Skrypt wdrozeniowy portfolio - pobiera pliki z GitHuba i zastepuje nimi
# zawartosc katalogu. Uruchamiany przez container-updater, ktory czyta kod
# wyjscia: 0 oznacza wdrozenie udane, cokolwiek innego - blad.
#
# Uzycie:  ./update.sh [galaz]     (domyslnie main)

# -e   przerwij przy pierwszym bledzie, zeby updater dostal niezerowy kod
# -u   niezdefiniowana zmienna to blad, a nie pusty ciag
# -o pipefail  blad w srodku potoku nie ginie
set -euo pipefail

BRANCH="${1:-main}"

# Katalog skryptu, a nie katalog wywolania - updater moze go uruchomic skadkolwiek.
cd "$(dirname "$0")"

if [ ! -d .git ]; then
    echo "Blad: $(pwd) nie jest repozytorium git." >&2
    exit 1
fi

echo "Pobieram galaz $BRANCH z origin..."
git fetch --prune origin "$BRANCH"

# reset --hard, a nie pull: pull probuje scalac i przy lokalnych zmianach
# na serwerze zatrzymalby sie na konflikcie. Tu katalog ma byc wierna kopia
# tego, co jest na GitHubie, wiec nadpisujemy bez pytania.
echo "Zastepuje pliki wersja z origin/$BRANCH..."
git reset --hard "origin/$BRANCH"

# Pliki nieznane repozytorium (np. zdjecia usuniete w nowszym commicie) zostaja
# na dysku. Zeby katalog byl dokladna kopia repo, odkomentuj ponizsza linie.
# Uwaga: skasuje z tego katalogu WSZYSTKO, czego nie ma w repozytorium.
# git clean -fd

echo "Wdrozono $(git rev-parse --short HEAD) ($(git log -1 --pretty=%s))"
