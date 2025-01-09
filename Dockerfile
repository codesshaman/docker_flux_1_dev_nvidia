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
RUN useradd -m -s /bin/bash flux

# Настройка прав на директорию
RUN mkdir -p /home/flux/.local/lib/python3.10/site-packages && \
    chown -R flux:flux /home/flux/.local

# Настройка переменных окружения для non-root пользователя
RUN echo "export PYTHONUSERBASE=/home/flux/.local" >> /home/flux/.bashrc && \
    echo "export PATH=/home/flux/.local/bin:$PATH" >> /home/flux/.bashrc

# Создание рабочей директории для flux
WORKDIR /flux

# Копирование flux
COPY flux/* /home/flux

# Переключение на non-root пользователя
USER flux

# Установка зависимостей для PyTorch
RUN pip install torch==2.0.1 --find-links https://download.pytorch.org/whl/cpu && \
    pip install -r requirements.txt

# Команда для запуска приложения
CMD ["python3", "launch.py", "--skip-torch-cuda-test"]
