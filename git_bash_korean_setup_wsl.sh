#!/bin/bash
# ============================================
# Git Bash 한글 환경 + WSL safe.directory 자동 설정
# ============================================

echo "===== Git Bash 한글 환경 + WSL safe.directory 설정 시작 ====="

# 1️⃣ Git Bash UTF-8 환경 변수 설정
BASHRC="$HOME/.bashrc"
if ! grep -q "Git Bash UTF-8 + 한글" "$BASHRC"; then
    cat << 'EOF' >> "$BASHRC"

# ===============================
# Git Bash UTF-8 + 한글 환경 설정
# ===============================
export LANG=ko_KR.UTF-8
export LC_ALL=ko_KR.UTF-8
EOF
    echo "✔ UTF-8 환경 변수 추가 완료 (~/.bashrc)"
else
    echo "✔ UTF-8 환경 변수 이미 설정됨"
fi

# 2️⃣ Git i18n 및 한글 깨짐 방지 설정
git config --global core.quotepath false
git config --global i18n.commitEncoding utf-8
git config --global i18n.logOutputEncoding utf-8
git config --global i18n.ui true
echo "✔ Git 한글 깨짐 방지 및 메시지 로케일 설정 완료"

# 3️⃣ WSL 마운트 경로 자동 safe.directory 등록
# 전체 WSL 홈 디렉터리를 안전 디렉터리로 설정 (권장 X, 보안 주의)
git config --global --add safe.directory '*'

# 4️⃣ 적용
source "$BASHRC"
echo "✔ ~/.bashrc 적용 완료"

# 5️⃣ 안내
echo "===== 설정 완료 ====="
echo "Git Bash 재시작 후 git status, git log 등 명령어에서 한글 메시지 확인"
echo "WSL 마운트 경로를 사용하는 리포지토리에서 dubious ownership 경고가 사라졌는지 확인"
echo "Git Bash 폰트가 한글 지원 폰트(D2Coding, NanumGothicCoding)인지 확인"
