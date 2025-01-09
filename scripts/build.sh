#!/bin/bash
PYTHON_VERSION="$(grep "PYTHON_VERSION" .env | sed -r 's/.{,15}//')"
DIR="/home/${USER}/.local/lib/python$PYTHON_VERSION/site-packages/"

cd stable-diffusion-webui
git pull
cd ..

if [ ! -d "$DIR" ]; then
  mkdir -p "$DIR"
  echo "Папка $DIR была успешно создана."
else
  echo "Папка $DIR уже существует."
fi
