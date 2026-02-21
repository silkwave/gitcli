#!/bin/bash
# ==============================================================================
# Git 전역 설정(git config)을 위한 스크립트
#
# 기능:
# 이 스크립트는 Git 사용 환경을 개선하기 위한 다양한 전역 설정을 적용합니다.
# 각 설정은 이미 적용되었는지 확인 후, 적용되지 않은 경우에만 추가됩니다.
#
# 설정 항목:
# 1. 사용자 정보 (user.name, user.email)
# 2. 핵심 동작 (core.*) - autocrlf, quotepath, pager 등
# 3. UI 및 색상 (color.ui)
# 4. 성능 최적화 (core.preloadIndex, core.fscache)
# 5. 국제화(i18n) 및 인코딩
# 6. 유용한 단축키 (alias)
#
# 사용법:
#   ./setup-git-config.sh
# ==============================================================================

# --- 색상 및 메시지 변수 ---
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'
C_NC='\033[0m'

info() { echo -e "${C_BLUE}[INFO]${C_NC} $1"; }
ok() { echo -e "${C_GREEN}[OK]${C_NC} $1"; }
warn() { echo -e "${C_YELLOW}[WARN]${C_NC} $1"; }
ask() { read -p "$(echo -e "${C_YELLOW}[Q]${C_NC} $1")" val; }

# --- 함수 정의 ---

# git config 값을 설정하는 함수 (이미 존재하면 건너뜀)
set_git_config() {
    local key="$1"
    local value="$2"
    
    # 현재 설정된 값 확인
    local current_value
    current_value=$(git config --global --get "$key")
    
    if [ "$current_value" = "$value" ]; then
        info "'$key' 설정이 이미 올바르게 지정되어 있습니다."
    else
        git config --global "$key" "$value"
        ok "'$key' 설정을 '$value'(으)로 지정했습니다."
    fi
}

# --- 메인 실행 로직 ---
main() {
    echo "🚀 Git 전역 설정(git config)을 시작합니다."
    echo

    # --- 1. 사용자 정보 ---
    info "--- 사용자 정보 설정 ---"
    USER_NAME=$(git config --global user.name)
    if [ -z "$USER_NAME" ]; then
        warn "Git 사용자 이름이 설정되지 않았습니다."
        ask "사용할 이름을 입력하세요: "
        set_git_config "user.name" "$val"
    else
        ok "사용자 이름: $USER_NAME"
    fi

    USER_EMAIL=$(git config --global user.email)
    if [ -z "$USER_EMAIL" ]; then
        warn "Git 사용자 이메일이 설정되지 않았습니다."
        ask "사용할 이메일을 입력하세요: "
        set_git_config "user.email" "$val"
    else
        ok "사용자 이메일: $USER_EMAIL"
    fi
    echo

    # --- 2. 핵심 동작 설정 (core) ---
    info "--- 핵심 동작 설정 ---"
    set_git_config "core.autocrlf" "false"      # 줄바꿈 문자(CRLF) 자동 변환 비활성화
    set_git_config "core.quotepath" "false"     # 파일 경로의 한글 깨짐 방지
    set_git_config "core.pager" "less -F -X"  # git log 등 긴 내용 출력 시 less 동작 방식 제어
    echo

    # --- 3. UI 및 색상 ---
    info "--- UI 및 색상 설정 ---"
    set_git_config "color.ui" "auto"            # Git 명령어 출력에 색상 자동 적용
    echo

    # --- 4. 성능 최적화 ---
    info "--- 성능 최적화 설정 ---"
    set_git_config "core.preloadIndex" "true"   # 인덱스를 미리 로드하여 성능 향상
    set_git_config "core.fscache" "true"        # 파일 시스템 캐시를 사용하여 성능 향상 (Mac/Linux)
    echo

    # --- 5. 국제화(i18n) 및 인코딩 ---
    info "--- 국제화(i18n) 및 인코딩 설정 ---"
    set_git_config "i18n.commitEncoding" "utf-8" # 커밋 메시지 인코딩
    set_git_config "i18n.logOutputEncoding" "utf-8" # 로그 출력 인코딩
    echo

    # --- 6. 단축키 (Alias) 설정 ---
    info "--- 단축키(Alias) 설정 ---"
    set_git_config "alias.st" "status"
    set_git_config "alias.lg" "log --oneline --graph --decorate --all"
    set_git_config "alias.br" "branch -vv"
    set_git_config "alias.co" "checkout"
    set_git_config "alias.ci" "commit"
    set_git_config "alias.last" "log -1 HEAD"
    echo

    ok "모든 Git 전역 설정이 완료되었습니다."
    echo
    info "적용된 설정을 확인하려면 'git config --global --list' 명령어를 사용하세요."
}

# 스크립트 실행
main
