
# Git 작업 흐름 요약

```sh
## 1. `dev` 브랜치 가져오기
`dev` 브랜치를 최신 상태로 업데이트:
git checkout dev
git pull origin dev

## 2. 새로운 브랜치로 이동
`dev_silkwave` 브랜치를 생성하거나 해당 브랜치로 이동:
git checkout dev_silkwave


## 3. `dev` 브랜치 병합
최신 `dev` 브랜치 내용을 `dev_silkwave` 브랜치로 병합:
git merge dev

## 4. 변경 사항 확인 (선택 사항)
현재 브랜치의 변경 사항을 확인:
git diff


## 5. 수정, 스테이징 및 커밋
변경된 파일을 추가하고 커밋:
git add .
git commit -m "커밋 메시지"

## 6. 원격 저장소로 푸시
`dev_silkwave` 브랜치를 원격 저장소로 푸시:
git push origin dev_silkwave

## 7. GitLab에서 머지 요청 생성

# 1. [GitLab](https://github.com/silkwave/)에 접속.
# 2. 상단 메뉴에서 **Create merge requests** 클릭.
# 3. **Approve** 클릭.
# 4. **Merge** 클릭.
```

##  `dev` 브랜치와 비교 (선택 사항)
현재 브랜치와 `dev` 브랜치의 변경 사항 비교:
```sh
git diff dev
```

### 리모트 저장소의 URL이 출력됩니다
```sh
git remote get-url origin
```

### 파일명 한글 깨짐 해결
```sh
git config --global core.quotepath false

git config --global i18n.commitencoding utf-8
git config --global i18n.logoutputencoding utf-8

git log --encoding=utf-8

git log --oneline --all --graph 



```
### 특정 커밋 되돌리기
```sh
# 현재 상태 확인 (추가된 파일, 변경된 파일, 커밋 상태 등 확인)
git status

# 커밋 로그 확인 (한 줄 요약 형식으로 커밋 기록 확인)
git log --oneline

# 마지막 커밋만 취소 (파일 변경 사항은 그대로 남기고 커밋만 되돌림)
git reset --soft HEAD~1   # 커밋만 취소 (파일 변경 사항 유지)

# 마지막 커밋 + 스테이징된 상태 취소 (파일 변경 사항은 유지, 스테이징 해제)
git reset --mixed HEAD~1  # 커밋 + 스테이징 취소 (파일 변경 사항 유지)

# 원격 저장소에서 feature 브랜치 삭제 (origin/feature)
git push origin --delete feature  # 원격 브랜치 삭제 (origin/<branch_name>)


```

### 스태시에서 저장했던 변경 사항을 다시 적용
```sh

# 현재 변경 사항을 스태시에 저장 (작업 도중이므로 "WIP" 태그 추가)
git stash push -m "WIP: feature 작업 중"

# GitLab에서 최신 코드 가져오기 (원격 저장소에서 최신 상태를 fetch)
git fetch origin

# GitLab에서 main 브랜치의 최신 코드 받아오기 (git pull)
git pull origin main  

# 스태시에서 저장했던 변경 사항을 다시 적용
git stash pop


```


###  로컬 브랜치를 원격 main 브랜치 상태로 강제 초기화
```sh

# 이 브랜치에 대한 추적 정보를 설정하려면 다음과 같이 할 수 있습니다:
git branch --set-upstream-to=origin/dev dev2 

#또는 브랜치 전환 시 바로 설정:
git checkout -b dev2 origin/dev

#Merge 방식 (기본적이고 안전한 방식) 로컬과 원격의 히스토리를 병합(Merge) 하려면
git config pull.rebase false
git pull origin dev
git log --oneline --all --graph 

#git config에 --global 옵션을 추가하면 앞으로 모든 저장소에 동일한 방식이 적용됩니다.
git config --global pull.rebase false

# 1. 병합(Merge) 방식으로 원격 저장소의 변경 사항을 가져오고 병합하기
git pull --no-ff origin main

# 2. 리베이스(Rebase) 방식으로 깔끔하게 커밋 히스토리 정리하면서 가져오기
git pull --rebase origin main

# 또는 수동으로 리베이스 진행하기
git rebase origin/main

# 리베이스 도중 문제가 생겼을 때 리베이스 중단 및 이전 상태로 복원
git rebase --abort

# 원격 저장소의 최신 정보를 가져오기 (병합이나 변경 없이)
git fetch origin

# 로컬 브랜치를 원격 main 브랜치의 상태로 강제로 초기화 (주의: 로컬 변경 사항은 모두 사라짐)
git reset --hard origin/main

#git reflog 사용하기 (되살릴 수 있는 가장 일반적인 방법)
git reflog

#여기서 HEAD@{1}이 reset 명령어 직전 상태입니다. 해당 시점으로 돌아가려면:
git reset --hard HEAD@{1}

#또는 커밋 해시 직접 지정:
git reset --hard e4f5g6h

되돌릴 커밋이 올바른지 먼저 확인하고 싶다면:
git show 81af509

#현재 상태를 실수로 덮어쓰기 전에 백업해두고 싶다면:
git branch backup-before-reset
# 로컬 브랜치를 원격 main 브랜치의 상태로 강제로 초기화 (주의: 로컬 변경 사항은 모두 사라짐)
git reset --hard origin/main
#만약 문제가 생기면 언제든지 백업 브랜치로 복원할 수 있습니다:
git checkout backup-before-reset
#또는 완전히 되돌리기:
git reset --hard backup-before-reset




```

###  원격 main 브랜치를 기준으로 새로운 feature 브랜치 생성
```sh

# main 브랜치로 전환
git switch main  

# 로컬 feature 브랜치를 삭제
git branch -D feature  

# 원격 저장소에서 최신 정보를 가져오기
git fetch origin

# 원격 main 브랜치를 기준으로 새로운 feature 브랜치 생성
git checkout -b feature origin/main

#  로컬 브랜치 dev_silkwave를 원격 브랜치 dev로 푸시
git push --set-upstream origin dev_silkwave:dev  

현재 브랜치가 'origin/dev_silkwave' 기반이지만, 업스트림이 없어졌습니다.
  (바로잡으려면 "git branch --unset-upstream"을 사용하십시오) 

# HTTPS로 원격 주소 변경 (간단)
git remote set-url origin https://github.com/silkwave/redis.git

```

### git bash git 리모트 web url 열기 
```sh
git_repo_url=$(git config --get remote.origin.url | sed 's/git@/https:\/\//; s/:/\//; s/\.git$//')
start "$git_repo_url"

git config --get remote.origin.url
git remote get-url origin

start https://github.com/silkwave/gitcli

```

### 원격 브랜치 삭제 실행
```sh

ssh-keygen -t rsa -b 4096 -C "silkwae24@gmail.com"
cat ~/.ssh/id_rsa.pub

https://github.com/settings/keys

git remote set-url origin git@github.com:silkwave/gitcli.git
git fetch origin
git push origin --delete dev_silkwave

git branch -d dev_silkwave


git remote -v
ssh -T git@github.com

# 로컬 브랜치의 내용을 원격 브랜치에 강제로 덮어쓰기 (주의: 원격의 커밋 히스토리가 사라질 수 있음)
git push origin main --force

  
```

### git_auto_commit.bat)
```bat

@echo off
:: [1] 사용자 설정
set "PROJECT_PATH=C:\Users\사용자이름\프로젝트폴더"
set "GITLAB_URL=https://gitlab.com/사용자명/저장소명"

:: [2] Git Bash 실행 경로 변수화 (경로가 다를 경우 수정)
set "GIT_BASH_PATH=C:\Program Files\Git\git-bash.exe"
for /f "delims=" %%G in ('where "git-bash.exe"') do set "GIT_BASH_PATH=%%G"

:: [3] Git Bash에서 실행할 명령어 정의
set "GIT_COMMANDS=^
cd \"%PROJECT_PATH%\" && ^
USER=%USERNAME% && ^
NOW=$(date '+%%Y-%%m-%%d %%H:%%M:%%S') && ^
git pull || exit 1 && ^

if git ls-files -u | grep . >/dev/null; then ^
  echo '⚠️ 충돌 발생! 최근 커밋 로그:' && ^
  git log -n 5 --oneline && ^
  echo '⛔ 충돌 해결 후 다시 실행하세요.' && ^
  exec bash; ^
else ^
  STATUS=$(git status -s) && ^
  MSG=\"자동 커밋 - $NOW by $USER%n$STATUS\" && ^
  git add . && ^
  git commit -m \"$MSG\" && ^
  git push && ^
  git status && ^
  exec bash; ^
fi"

:: [4] Git Bash 실행
start "" "%GIT_BASH_PATH%" -c "%GIT_COMMANDS%"

:: [5] GitLab 저장소 브라우저 열기
start "" "%GITLAB_URL%"




```

