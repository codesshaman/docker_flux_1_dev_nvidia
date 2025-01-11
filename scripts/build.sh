#!/bin/bash
PYTHON_VERSION="$(grep "PYTHON_VERSION" .env | sed -r 's/.{,15}//')"
DIR="/home/${USER}/.local/lib/$PYTHON_VERSION/site-packages/"

cd flux
git pull
cd ..

if [ ! -d "$DIR" ]; then
  mkdir -p "$DIR"
  echo "Папка $DIR была успешно создана."
else
  echo "Папка $DIR уже существует."
fi
