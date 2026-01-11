#!/bin/bash
# ================================================================
# Git Bash 한글 환경 및 WSL 'safe.directory' 자동 설정 스크립트
#
# 이 스크립트는 Git Bash 및 WSL 환경에서 한글 사용과 관련된
# 일반적인 문제들을 해결하기 위한 설정들을 자동화합니다.
#
# 주요 기능:
# 1. ~/.bashrc: UTF-8 로케일 변수(LANG, LC_ALL)를 설정하여 한글 깨짐을 방지합니다.
# 2. Git 전역 설정:
#    - 사용자 정보(이름, 이메일)를 설정합니다.
#    - OS 간의 줄바꿈 문자 차이로 인한 문제를 방지합니다 (core.autocrlf=false).
#    - 파일 경로의 한글이 깨지지 않도록 합니다 (core.quotepath=false).
#    - 커밋 및 로그 메시지의 인코딩을 UTF-8로 지정합니다.
# 3. WSL 'dubious ownership' 오류 해결:
#    - WSL 파일 시스템에서 Git 저장소를 사용할 때 발생하는 소유권 문제를
#      해결하기 위해 모든 디렉터리를 안전한 것으로 등록합니다.
#
# [주의] 'safe.directory = *' 설정은 보안상 위험을 초래할 수 있으므로
#        신뢰할 수 있는 환경에서만 사용하시기 바랍니다.
# ================================================================

echo "🚀 Git Bash 한글 및 WSL 환경 설정을 시작합니다."
echo

# --- 1. Git Bash UTF-8 환경 변수 설정 ---
echo "⚙️  1. ~/.bashrc 파일에 UTF-8 환경 변수를 설정합니다..."
BASHRC_FILE="$HOME/.bashrc"
BASHRC_MARKER="# Git Bash Korean Language Setting"

if grep -qF -- "$BASHRC_MARKER" "$BASHRC_FILE"; then
    echo "  ✔️  이미 ~/.bashrc 파일에 한글 환경 설정이 존재합니다."
else
    cat << EOF >> "$BASHRC_FILE"

# ===================================
$BASHRC_MARKER
# ===================================
export LANG=ko_KR.UTF-8
export LC_ALL=ko_KR.UTF-8
EOF
    echo "  ✅  ~/.bashrc 파일에 UTF-8 환경 변수를 추가했습니다."
    # 현재 세션에도 즉시 적용
    source "$BASHRC_FILE"
    echo "  ℹ️  현재 세션에 설정을 적용했습니다."
fi
echo

# --- 2. Git 전역 설정 ---
echo "⚙️  2. Git 전역 설정을 구성합니다..."

# 기본 사용자 정보 및 편의 기능
git config --global user.name "silkwave"
git config --global user.email "silkwave24@gmail.com"
git config --global core.autocrlf false   # 줄바꿈 자동 변환 방지
git config --global color.ui auto         # 터미널 출력 색상 활성화
git config --global credential.helper store # 자격 증명 캐시 (선택 사항)

# 한글 깨짐 방지 설정
git config --global core.quotepath false
git config --global i18n.commitEncoding utf-8
git config --global i18n.logOutputEncoding utf-8

echo "  ✅  Git 기본 설정 및 한글 관련 설정을 완료했습니다."
echo

# --- 3. WSL 'dubious ownership' 오류 해결 설정 ---
echo "⚙️  3. WSL 'dubious ownership' 오류 해결을 위한 설정을 추가합니다..."
echo "  ⚠️  [주의] 모든 디렉터리('*')를 Git 안전 디렉터리로 추가합니다."
echo "      이 설정은 편리하지만, 보안상 위험할 수 있습니다."

if git config --global --get-all safe.directory | grep -q '^\*$'; then
    echo "  ✔️  이미 'safe.directory = *' 설정이 존재합니다."
else
    git config --global --add safe.directory '*'
    echo "  ✅  'safe.directory = *' 설정을 추가했습니다."
fi
echo

# --- 4. 최종 확인 및 안내 ---
echo "👍 모든 설정이 완료되었습니다."
echo "-------------------------------------------------"
echo "현재 적용된 주요 Git 설정:"
git config --global --list | grep -E 'user|core|i18n|credential|color|safe'
echo "-------------------------------------------------"
echo
echo "💡 [중요] 변경 사항을 완전히 적용하려면 열려 있는 모든 Git Bash 창을 닫고 새로 시작하세요."
echo "   재시작 후 다음을 확인해 보세요:"
echo "   1. 'git status', 'git log' 등 명령어의 메시지가 한글로 표시되는지 확인"
echo "   2. WSL 마운트 경로의 Git 저장소에서 'dubious ownership' 오류가 발생하는지 확인"
echo "   3. 터미널 폰트가 한글을 지원하는지 확인 (예: D2Coding, 나눔고딕코딩)"
echo

echo "🎉 설정 완료!"