#!/bin/bash
# Скрипт для автоматичного встановлення Docker, Docker Compose, Python і Django
# Перевіряє, чи інструменти вже встановлені, щоб не дублювати установку

echo "=== Початок встановлення інструментів розробки ==="

# --- Docker ---
echo "Перевірка Docker..."
if ! command -v docker &> /dev/null; then
    echo "Docker не знайдено. Встановлюємо..."
    # Оновлюємо список пакетів
    sudo apt update
    # Встановлюємо необхідні пакети
    sudo apt install -y ca-certificates curl gnupg
    # Додаємо офіційний GPG-ключ Docker
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    # Додаємо репозиторій Docker
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    # Встановлюємо Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "Docker встановлено."
else
    echo "Docker вже встановлено."
fi

# --- Docker Compose (окремо, якщо потрібно класичний) ---
echo "Перевірка Docker Compose..."
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "Docker Compose не знайдено. Встановлюємо..."
    sudo apt install -y docker-compose-plugin
    echo "Docker Compose встановлено."
else
    echo "Docker Compose вже встановлено."
fi

# --- Python 3.9+ ---
echo "Перевірка Python..."
if ! command -v python3 &> /dev/null; then
    echo "Python3 не знайдено. Встановлюємо..."
    sudo apt update
    sudo apt install -y python3 python3-pip python3-venv
    echo "Python встановлено."
else
    # Перевіряємо версію
    PYTHON_VERSION=$(python3 --version | awk '{print $2}')
    echo "Python вже встановлено (версія $PYTHON_VERSION)."
fi

# --- Django через pip ---
echo "Перевірка Django..."
if ! python3 -m django --version &> /dev/null; then
    echo "Django не знайдено. Встановлюємо через pip..."
    # Встановлюємо pip, якщо його немає
    sudo apt install -y python3-pip python3-venv
    # Встановлюємо Django з обходом захисту системи (для навчального скрипта)
    pip3 install --break-system-packages django
    echo "Django встановлено."
else
    echo "Django вже встановлено."
fi

echo "=== Встановлення завершено ==="
echo "Перевірка версій:"
docker --version 2>/dev/null || echo "Docker: не встановлено"
docker compose version 2>/dev/null || echo "Docker Compose: не встановлено"
python3 --version 2>/dev/null || echo "Python: не встановлено"
python3 -m django --version 2>/dev/null || echo "Django: не встановлено"
