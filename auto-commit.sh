#!/bin/bash

# ==============================================================================
# 자동 커밋 및 'dev' 브랜치 푸시 스크립트
#
# 기능:
# 1. 현재 브랜치에 변경 사항이 있는지 확인합니다.
# 2. 사용자에게 로컬 테스트 수행 여부를 확인받습니다.
# 3. 현재 브랜치가 'dev'이거나 'feature' 브랜치가 아닌 경우 실행을 중단합니다.
# 4. 'origin/main'과 'origin/dev'에서 최신 변경 사항을 pull 합니다.
# 5. 충돌이 발생했는지 확인합니다.
# 6. 변경 사항을 자동으로 staging 하고 커밋합니다.
# 7. 커밋된 내용을 현재 브랜치에서 'origin/dev' 브랜치로 푸시합니다.
#
# 사용법:
#   ./auto-commit.sh
#
# 참고:
#   이 스크립트는 'feature' 브랜치의 변경 사항을 'dev' 브랜치로 통합하는
#   워크플로우를 자동화하기 위해 만들어졌습니다.
# ==============================================================================

# --- 색상 및 메시지 변수 ---
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'
C_NC='\033[0m' # No Color

info() { echo -e "${C_BLUE}[INFO]${C_NC} $1"; }
ok() { echo -e "${C_GREEN}[OK]${C_NC} $1"; }
warn() { echo -e "${C_YELLOW}[WARN]${C_NC} $1"; }
err() { echo -e "${C_RED}[ERROR]${C_NC} $1"; }
ask() { read -p "$(echo -e "${C_YELLOW}[Q]${C_NC} $1")" yn;
}

# --- 함수 정의 ---

# 스크립트 실행을 중단시키는 함수
abort() {
    err "$1"
    exit 1
}

# 1. 변경 사항 확인
check_initial_changes() {
    info "로컬 변경 사항을 확인합니다..."
    # --porcelain: 스크립트에서 파싱하기 좋은 형태로 출력
    GIT_STATUS=$(git status --porcelain)
    if [ -z "$GIT_STATUS" ]; then
        ok "커밋할 변경 사항이 없습니다. 작업을 종료합니다."
        exit 0
    fi
    ok "커밋할 변경 사항을 발견했습니다."
    echo "--- 변경된 파일 ---"
    echo "$GIT_STATUS"
    echo "-------------------"
}

# 2. 사용자 확인
confirm_local_test() {
    warn "git push 전 로컬 WAS/서버에서 테스트를 수행했는지 확인하세요."
    warn "테스트를 생략하면 개발 서버에 컴파일 또는 런타임 오류가 발생할 수 있습니다."
    ask "테스트를 완료했으며, 계속 진행하시겠습니까? (y/n): "
    case "$yn" in
        [Yy]*) info "사용자 확인 완료. 계속 진행합니다." ;; 
        *) abort "사용자가 작업을 취소했습니다." ;; 
    esac
}

# 3. 브랜치 정책 확인
check_branch_policy() {
    info "현재 브랜치 정책을 확인합니다..."
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    
    if [ "$CURRENT_BRANCH" = "dev" ]; then
        abort "'dev' 브랜치에서는 이 스크립트를 직접 실행할 수 없습니다."
    fi
    
    # 브랜치 이름이 'feature'로 시작하는지 확인
    if [[ ! "$CURRENT_BRANCH" =~ ^feature ]]; then
        abort "현재 브랜치('$CURRENT_BRANCH')는 'feature' 브랜치가 아닙니다. 허용된 브랜치: feature/*"
    fi
    
    ok "현재 브랜치('$CURRENT_BRANCH')는 정책에 부합합니다."
}

# 4. 원격 브랜치 Pull
pull_remote_changes() {
    info "원격 저장소의 최신 변경 사항을 가져옵니다..."
    
    info "pulling from 'origin main'..."
    git pull origin main || abort "'origin/main' 브랜치 pull에 실패했습니다. 충돌을 수동으로 해결하세요."
    ok "'origin/main' pull 완료."

    info "pulling from 'origin dev'..."
    git pull origin dev || abort "'origin/dev' 브랜치 pull에 실패했습니다. 충돌을 수동으로 해결하세요."
    ok "'origin/dev' pull 완료."
}

# 5. 충돌 확인 및 처리
check_merge_conflicts() {
    info "병합 충돌이 있는지 확인합니다..."
    # ls-files -u: unmerged files(충돌 파일) 목록을 보여줌
    UNMERGED_FILES=$(git ls-files -u)
    if [ -n "$UNMERGED_FILES" ]; then
        warn "병합 충돌이 발생했습니다. 아래 파일들을 확인하고 수동으로 해결하세요."
        echo "$UNMERGED_FILES"
        warn "모든 충돌을 해결한 후 변경 사항을 Staging 영역에 추가해주세요."
        ask "충돌을 해결하고 Staging 영역에 추가하셨습니까? (y/n): "
        case "$yn" in
            [Yy]*) 
                info "충돌 해결 및 Staging 확인. 계속 진행합니다." 
                # 충돌 해결 후 추가 변경 사항이 없는지 다시 확인
                GIT_STATUS_AFTER_RESOLVE=$(git status --porcelain)
                if [ -n "$GIT_STATUS_AFTER_RESOLVE" ]; then
                    if git ls-files -u | grep . >/dev/null; then
                        abort "아직 해결되지 않은 충돌이 남아있습니다. 다시 확인해주세요."
                    fi
                fi
                ;;
            *) abort "사용자가 작업을 취소했습니다." ;;
        esac
    fi
    ok "병합 충돌이 없습니다."
}

# 6. 커밋 및 푸시
commit_and_push() {
    info "변경 사항을 커밋하고 푸시합니다."
    
    # Pull 이후 변경 사항이 없을 수도 있으므로 다시 확인
    GIT_STATUS_AGAIN=$(git status --porcelain)
    if [ -z "$GIT_STATUS_AGAIN" ]; then
        ok "Pull 이후 새로운 변경 사항이 없습니다. 작업을 종료합니다."
        exit 0
    fi
    
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    
    info "변경 사항을 staging 합니다..."
    git add .
    
    info "변경 사항을 커밋합니다..."
    # 커밋 메시지에 변경된 파일 목록 상위 5개를 요약해서 추가
    COMMIT_SUMMARY=$(echo "$GIT_STATUS_AGAIN" | head -n 5 | tr '\n' ' ' | sed 's/ $//')
    COMMIT_MESSAGE="auto-commit: $CURRENT_BRANCH - $COMMIT_SUMMARY ($TIMESTAMP)"
    
    git commit -m "$COMMIT_MESSAGE" || abort "커밋에 실패했습니다."
    ok "커밋 완료: $COMMIT_MESSAGE"
    
    info "현재 브랜치('$CURRENT_BRANCH')를 'origin/dev'로 푸시합니다..."
    # --set-upstream: 로컬 브랜치가 origin/dev를 추적하도록 설정
    # $CURRENT_BRANCH:dev : 로컬 $CURRENT_BRANCH를 리모트 dev 브랜치로 푸시
    git push --set-upstream origin "$CURRENT_BRANCH:dev" || abort "'origin/dev'로 푸시하는데 실패했습니다."
    
    ok "푸시 완료!"
}

# --- 메인 실행 로직 ---
main() {
    # Git 저장소 루트 디렉토리에서 실행되는지 확인
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        abort "Git 저장소 디렉토리에서 스크립트를 실행해야 합니다."
    fi

    check_initial_changes
    confirm_local_test
    check_branch_policy
    pull_remote_changes
    check_merge_conflicts
    commit_and_push
    
    echo
    info "최종 브랜치 상태:"
    git branch -vv
    echo
    ok "모든 작업이 성공적으로 완료되었습니다."
}

# 스크립트 실행
main