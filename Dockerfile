# Используем образ Python 3.10 на базе Debian 12
FROM python:3.10-slim-bullseye

# Установка необходимых пакетов
RUN apt update && apt install -y \
    python3-dev \
    python3-pip \
    gcc \
    g++ \
    git \
    libffi-dev \
    libomp-dev \
    make \
    bash \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Установка и обновление pip
RUN python3 -m ensurepip && \
    python3 -m pip install --upgrade pip

# Создание non-root пользователя
RUN useradd -m -s /bin/bash diffustion

# Настройка прав на директорию
RUN mkdir -p /home/diffustion/.local/lib/python3.10/site-packages && \
    chown -R diffustion:diffustion /home/diffustion/.local

# Настройка переменных окружения для non-root пользователя
RUN echo "export PYTHONUSERBASE=/home/diffustion/.local" >> /home/diffustion/.bashrc && \
    echo "export PATH=/home/diffustion/.local/bin:$PATH" >> /home/diffustion/.bashrc

# Создание рабочей директории для stable-diffusion gui
WORKDIR /stable-diffusion-webui

# Копирование stable-diffusion gui
COPY stable-diffusion-webui/* /stable-diffusion-webui

# Переключение на non-root пользователя
USER diffustion

# Установка зависимостей для PyTorch
RUN pip install torch==2.0.1 --find-links https://download.pytorch.org/whl/cpu && \
    pip install -r requirements.txt

# Команда для запуска приложения
CMD ["python3", "launch.py", "--skip-torch-cuda-test"]
