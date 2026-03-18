# Bloomp — синхронизация с GitHub (initial commit)
# Запустите после установки Git: https://git-scm.com/download/win

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "=== Bloomp: синхронизация с GitHub ===" -ForegroundColor Cyan

# Проверка Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "ОШИБКА: Git не найден. Установите: https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

# Инициализация (если не репозиторий)
if (-not (Test-Path .git)) {
    Write-Host "Инициализация репозитория..." -ForegroundColor Yellow
    git init
}

# Добавление и коммит
Write-Host "Добавление файлов..." -ForegroundColor Yellow
git add .

$status = git status --porcelain
if (-not $status) {
    Write-Host "Нет изменений для коммита." -ForegroundColor Gray
} else {
    Write-Host "Создание коммита 'initial commit'..." -ForegroundColor Yellow
    git commit -m "initial commit"
}

# Remote
Write-Host "Настройка remote..." -ForegroundColor Yellow
if (-not (git remote get-url origin 2>$null)) {
    git remote add origin https://github.com/akkulss-del/bloomp.git
} else {
    git remote set-url origin https://github.com/akkulss-del/bloomp.git
}

# Push
Write-Host "Отправка на GitHub..." -ForegroundColor Yellow
git branch -M main
git push -u origin main

Write-Host "`n=== Готово! ===" -ForegroundColor Green
