notepad.exe .git/config

"C:\Program Files\Git\git-bash.exe" --cd="C:\Project\test"

git config --local --edit
#로컬 브랜치에서 아직 push 하지 않은 커밋 목록을 확인
git log origin/dev.. --oneline --graph --decorate


[alias]
  st = status
  lg = log --oneline --graph --decorate --all 
 
  
git config --local alias.auto-commit '!bash -c '\'' 
S=$(git status -s);
[ -z "$S" ] && { echo "[OK] 변경 사항 없음"; exit 0; };
echo "[CHK] git push 전 로컬 WAS 수행 하세요. 개발서버에서 컴파일 오류가 발생할 수 있습니다.";
read -p "[QST] 로컬 WAS 수행 하셨습니까? 계속 진행하시겠습니까? (y/n): " yn;
case $yn in
  [Yy]* ) echo "[INFO] 계속 진행합니다." ;;
  *     ) echo "[STOP] 사용자가 작업을 취소했습니다."; exit 1 ;;
esac;
T=$(date "+%Y-%m-%d %H:%M:%S");
B=$(git rev-parse --abbrev-ref HEAD);
if [ "$B" = "dev" ]; then
  echo "[ERR] dev 브랜치에서는 auto-commit을 사용할 수 없습니다."; exit 1;
fi;
echo "$B" | grep -Eq "^feature.*$" || { echo "[ERR] 허용되지 않은 브랜치입니다: $B"; exit 1; }
echo "[PULL] origin/main에서 pull 중...";
git pull origin main || { echo "[FAIL] main pull 실패"; exit 1; };
echo "[PULL] origin/dev에서 pull 중...";
git pull origin dev || { echo "[FAIL] dev pull 실패"; exit 1; };
echo "[CHK] 충돌 확인 중...";
git ls-files -u | grep . >/dev/null && { echo "[!!] 충돌 발생"; git log -n 3 --oneline; exit 1; };
echo "[STS] 변경 사항 확인 중...";
S=$(git status -s);
[ -z "$S" ] && { echo "[OK] 변경 사항 없음"; exit 0; };
echo "[ADD] 변경 사항 staging 중...";
git add .;
echo "[CMT] 커밋 중...";
SHORT_S=$(echo "$S" | head -n 5 | tr "\n" " ");
git commit -m "자동 커밋 - $T by ($B) - $SHORT_S";
echo "[PUSH] dev 브랜치로 push 중...";
git push --set-upstream origin "$B":dev;
echo "[DONE] 자동 커밋 완료";
git branch -vv;
'\'''



git config --local --get alias.auto-commit

  
.git/config    
git config --list --show-origin

git config --global --edit
git auto-commit

# 현재 LANG 환경변수 확인 (ko_KR.UTF-8 이어야 한글 출력 정상)
echo $LANG  

# LANG, LC_ALL 환경변수 한글 UTF-8 로 설정
export LANG=ko_KR.UTF-8
export LC_ALL=ko_KR.UTF-8

# 커밋 메시지 인코딩을 UTF-8 로 설정
git config --global i18n.commitEncoding utf-8

# 로그 출력 인코딩을 UTF-8 로 설정
git config --global i18n.logOutputEncoding utf-8

# 경로명 한글을 이스케이프 없이 그대로 보여주기
git config --global core.quotepath false

# 인덱스 미리 로드 설정 (성능 향상)
git config --global core.preloadIndex true

# 파일 시스템 캐시 활성화 (성능 향상)
git config --global core.fscache true

# less pager 옵션 설정: 내용이 화면보다 적으면 바로 종료, 출력 유지
git config --global core.pager "less -F -X"
