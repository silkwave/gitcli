# Git 명령 모음 (가독성 정리)

> 자주 쓰는 Git 명령을 보기 좋게 정리한 참고입니다. 복사해서 사용하세요. ✅

---

## 목차
1. [빠른 명령(Quick)](#빠른-명령)
2. [설정(Encoding / Credential / Editor)](#설정)
3. [브랜치와 동기화(Branch & Sync)](#브랜치와-동기화)
4. [되돌리기 & 복구(Reset / Reflog)](#되돌리기--복구)
5. [스태시(Stash)](#스태시)
6. [리베이스 vs 머지](#리베이스-vs-머지)
7. [충돌 해결(Conflict)](#충돌-해결)
8. [유용한 Alias / 팁](#유용한-alias--팁)

---

## 빠른 명령
- 최근 커밋 취소 (커밋 해제, 파일은 유지)
```sh
git reset --mixed HEAD~1
```
- 특정 커밋으로 강제 이동 (주의: 로컬 이력 변경)
```sh
git reset --hard <commit-ish>
```
- 리모트 강제 반영 (fetch 강제)
```sh
git fetch -f
```
- 전체 브랜치 보기
```sh
git branch -a
```
- 기본 상태 확인 / 원격 동기화
```sh
git status
git fetch origin
git pull origin <branch>
```
- 자동 커밋 예시
```sh
T=$(date "+%Y-%m-%d %H:%M:%S");
S=$(git status -s);
SHORT_S=$(echo "$S" | head -n 1 | tr "\n" " ");
git add .
git commit -m "자동 커밋 - $T  $SHORT_S";
```
- 로컬 강제 정리 (주의: 복구 불가)
```sh
git clean -fd
```

---

## 설정 (Encoding / Credential / Editor) 🔧
- 인증 정보 로컬 평문 저장 (비추천)
```sh
git config --global credential.helper store
```
- OS Keychain 사용 (권장)
```sh
git config --global credential.helper manager
```
- Git 기본 pager 끄기
```sh
git config --global core.pager cat
```
- 에디터 설정
```sh
git config --global core.editor "code --wait"  # VSCode
```

### 한글 환경 (WSL / Git Bash)
```sh
# .bashrc에 추가
export LANG=ko_KR.UTF-8
export LC_ALL=ko_KR.UTF-8

git config --global core.quotepath false
git config --global i18n.commitEncoding utf-8
git config --global i18n.logOutputEncoding utf-8
git config --global i18n.ui true
echo "Git Bash 한글 환경 설정 완료!"
```

> Tip: 파일명/커밋 메시지 한글 깨짐이 있을 때 `git log --encoding=utf-8` 로 확인하세요. 💡

---

## 브랜치와 동기화
- 로컬 브랜치를 원격 브랜치로 설정
```sh
git branch --set-upstream-to=origin/<remote> <local>
# 또는 브랜치 생성 시 바로 설정
git checkout -b <local> origin/<remote>
```
- 로컬 커밋을 원격에 푸시 (추적 브랜치가 없을 때)
```sh
git push --set-upstream origin <local>:<remote>
```
- 원격 브랜치 삭제
```sh
git push origin --delete <branch>
```
- 로컬 브랜치를 원격 기준으로 초기화 (주의: 로컬 변경 삭제)
```sh
git reset --hard origin/<branch>
```

### 동기화 상태 (예시와 해결 방법)
- Up to date: 아무 조치 불필요
- Ahead by N commits: `git push origin <branch>`
- Behind by N commits: `git pull origin <branch>` 또는 `git fetch && git merge`
- Diverged: `git pull`(merge) 또는 `git fetch && git rebase origin/<branch>` (공개 이력엔 주의)

---

## 되돌리기 & 복구
- 커밋만 되돌리기 (수정사항 유지)
```sh
git reset --soft HEAD~1
```
- 커밋 + 스테이징 해제
```sh
git reset --mixed HEAD~1
```
- 최근 작업 복구 (reflog 유용)
```sh
git reflog
git reset --hard HEAD@{1}
```
- 특정 커밋으로 되돌리기 확인
```sh
git show <commit>
```

---

## 스태시
- 저장
```sh
git stash push -m "WIP: 설명"
```
- 적용
```sh
git stash pop
```

---

## 리베이스 vs 머지
- Merge: 기본적이고 안전 (공개 이력 유지)
```sh
git pull --no-ff origin main
```
- Rebase: 히스토리 정리 (공개된 히스토리는 피하세요)
```sh
git pull --rebase origin main
# 또는
git rebase origin/main
```
- 리베이스 중단
```sh
git rebase --abort
```

---

## 충돌 해결 (간단 단계) ⚔️
1. 충돌 확인: `git status` 또는 pull/merge 중 메시지 확인
2. 파일 열어 충돌 마커(<<<<<<<, =======, >>>>>>>) 수정
3. 수정 저장 후 `git add <file>`
4. `git commit` (필요 시 메시지 작성)
5. `git push origin <branch>`

> 충돌 파일에는 반드시 충돌 마커를 제거하고 최종 상태만 남겨야 합니다.

---

## 충돌 해결 상세 예시 🔧

- 예시 충돌 표시
```diff
<<<<<<< HEAD
내 변경: printf("Hello from local\n");
=======
원격 변경: printf("Hello from remote\n");
>>>>>>> origin/dev
```

- 실전 단계 (예시 재현)
```sh
# 1) 예시로 충돌 만들기
git checkout -b feature/conflict origin/dev
# (로컬) 파일 수정, 커밋
echo 'printf("Hello from local\n");' > hello.c
git add hello.c && git commit -m "local: hello"

# (원격 브랜치에서 변경된 것으로 가정) 다른 브랜치에서 수정 후 push 했다고 가정
# 2) 병합 시 충돌 확인
git checkout dev
git merge feature/conflict  # 또는 git pull origin dev
# 충돌 발생 -> git status 로 파일 확인
```
- 해결 절차
  1. `git status`로 충돌 파일 확인
  2. 에디터로 열어 충돌 마커(<<<<<<<, =======, >>>>>>>)를 손보며 최종 코드를 만듭니다.
  3. `git add <file>`
  4. `git merge --continue` 또는 `git rebase --continue` (또는 `git commit`)
  5. `git push origin <branch>`

- mergetool 예시 (meld)
```sh
# meld 등록
git config --global merge.tool meld
# 충돌 시
git mergetool
```

- VSCode 병합 에디터
```sh
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd "code --wait $MERGED"
# 충돌 시
git mergetool --tool=vscode
```

- 빠른 대체(한쪽 버전으로 덮어쓰기)
```sh
# 내(현재) 버전 유지
git checkout --ours <file>
git add <file>

# 원격(타깃) 버전으로 덮어쓰기
git checkout --theirs <file>
git add <file>
```

- 주의: 충돌 마커(<<<<<<<, =======, >>>>>>>)는 반드시 제거해야 합니다.

---

## 고급 복구 (reflog / bisect / revert) 🔍

- reflog로 최근 HEAD 추적 및 복구
```sh
git reflog
# 예: 직전 상태로 복원
git reset --hard HEAD@{1}
```

- `git revert` vs `git reset` (간단)
  - `git revert <commit>`: 되돌림을 새로운 커밋으로 추가 (안전)
  - `git reset --hard <commit>`: 브랜치 포인터 이동(이력 변경, 주의)

- git bisect (실전 예시)
```sh
# 1) 간단한 테스트 스크립트 만들기 (성공=0, 실패!=0)
cat > test.sh <<'EOF'
#!/bin/sh
# 예: 특정 문자열이 있는 커밋을 bad로 판단
if grep -q "BUG" -- hello.c 2>/dev/null; then
  exit 1
else
  exit 0
fi
EOF
chmod +x test.sh

# 2) bisect 시작
git bisect start
git bisect bad                # 현재 버전이 문제 있음
git bisect good <known-good-commit>

# 3) 자동으로 테스트 실행
git bisect run ./test.sh

# bisect 완료 후
git bisect reset
```

- 결과: `git bisect`가 문제를 일으킨 최초 커밋을 알려줍니다. 이후 `git show <bad-commit>`로 원인 확인.

---

## SSH / PAT / 인증 관련 팁 🔐
- SSH 키 생성 (권장: ed25519)
```sh
ssh-keygen -t ed25519 -C "your_email@example.com"
# 공개키 확인
cat ~/.ssh/id_ed25519.pub
```
- ssh-agent에 키 등록
```sh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```
- GitHub/GitLab에 공개키 복사 후 등록
- HTTPS 사용 시: PAT(Personal Access Token) 권장 (비밀번호 대신 사용)
  - PAT을 사용할 땐 credential helper(보안 저장소)를 사용하세요.
```sh
# Git Credential Manager Core (권장)
git config --global credential.helper manager-core
# 또는 운영체제에 맞는 secure helper 사용
```
- 절대 추천하지 않음: `credential.helper store` (평문 저장)

> 요약: 개인 토큰(PAT) 또는 SSH 키를 사용하고, `manager-core` 등의 보안형 credential helper를 활용하세요.

---

## 유용한 Alias / 스크립트 예시
- 편한 alias 설정 (`~/.gitconfig`에 추가)
```ini
[alias]
  brvv = branch -vv
  track = "!f() { git checkout -b $1 origin/$1 || git branch --set-upstream-to=origin/$1 $1; }; f"
```
- 원격 리포지토리 URL 열기 (Git Bash 등)
```sh
git_repo_url=$(git config --get remote.origin.url | sed 's/git@/https:\/\//; s/:/\//; s/\.git$//')
# mac: open "$git_repo_url"  / Windows: start "$git_repo_url"
```

---

## 주의사항 & 팁 ⚠️
- `git reset --hard` / `git clean -fd` / `git push --force`는 되돌리기 어려우니 사용 전 백업(브랜치 생성)을 권장합니다. ✅
- 공개된 브랜치에서는 리베이스 사용을 신중히 하세요.

---

주요 명령을 유지하고 중복을 제거해 항목별로 정리했습니다. 더 자세한 내용을 원하시면 알려주세요. ✨