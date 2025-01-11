# Используем образ Python 3.10 на базе Debian 12
FROM python:3.10-slim-bullseye

# Установка необходимых пакетов
RUN apt update && apt install -y \
    python3-dev \
    python3-pip \
    build-essential \
#     gcc \
#     g++ \
    git \
#     libffi-dev \
#     libomp-dev \
#     make \
#     bash \
#     curl \
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
WORKDIR /home/flux

# Копирование flux
COPY flux/. /home/flux

# Настройка прав на каталог, чтобы избежать ошибок записи
RUN chown -R flux:flux /home/flux/src/flux && \
    chmod -R 777 /home/flux

# Переключаемся на non-root пользователя после установки зависимостей
USER flux

# Создаём виртуальное окружение и устанавливаем зависимости от имени root
RUN python3 -m venv .venv && \
    . .venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -e ".[all]"

# Настройка переменных окружения для non-root пользователя
RUN echo "export PYTHONUSERBASE=/home/flux/.local" >> /home/flux/.bashrc && \
    echo "export PATH=/home/flux/.local/bin:$PATH" >> /home/flux/.bashrc

# Запускаем
# CMD ["/bin/bash"]
CMD ["tail", "-f", "/dev/null"]
