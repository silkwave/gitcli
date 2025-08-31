
# Git 작업 흐름 요약

```sh
git reset --mixed HEAD~1           # 최근 커밋 취소하고, 파일은 수정된 상태로 남김
git reset HEAD~1                   # 기본값이라서 --mixed 생략 가능

git reset --hard abc1234           # 커밋 이력 유지 안 함 (HEAD를 특정 커밋으로 이동)
git reset --hard origin/dev  (사용주의)


git fetch --all --recurse-submodules=no --progress --prune

git status 

git pull --no-stat -v --progress origin main

git add .
T=$(date "+%Y-%m-%d %H:%M:%S");
S=$(git status -s);
SHORT_S=$(echo "$S" | head -n 1 | tr "\n" " ");
git commit -m "자동 커밋 - $T  $SHORT_S";

git push --set-upstream origin dev_silkwave:dev  

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
git checkout -b dev3 origin/dev

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

#1. 로컬 브랜치 fea-123에서 원격 브랜치 fea-dev를 추적하도록 설정
git checkout fea-123
git branch --set-upstream-to=origin/fea-dev

2. 처음부터 다르게 추적하려면 (없는 로컬 브랜치 생성 포함)
git checkout -b fea-123 origin/fea-dev

#확인: 추적 브랜치가 잘 설정되었는지 확인
git branch -vv

#참고: 자주 쓰는 명령어 alias 등록 (선택)
#.gitconfig에 다음처럼 추가하면 CLI가 더 편해집니다:
[alias]
  track = "!f() { git checkout -b $1 origin/$1 || git branch --set-upstream-to=origin/$1 $1; }; f"
  brvv = branch -vv
  upstream = "!git for-each-ref --format='%(refname:short) -> %(upstream:short)' refs/heads/"

#사용 예:
git track feature/login
git brvv
git upstream

#모든 브랜치 추적 관계 한눈에 보기
git for-each-ref --format="%(refname:short) -> %(upstream:short)" refs/heads/

#추적 브랜치 제거
git branch --unset-upstream


```


#Git 브랜치 동기화 상태 및 해결 방법
```

============================================================
git status
On branch dev
Your branch is up to date with 'origin/dev'.

nothing to commit, working tree clean

의미: 로컬 브랜치와 원격 브랜치 (origin/dev)가 완전히 동일한 상태입니다.
해결 방법: 별도의 조치가 필요 없습니다.


============================================================
 git status
On branch dev
Your branch is ahead of 'origin/dev' by 2 commits.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean

의미: 로컬 브랜치에 원격 브랜치 (origin/dev)에는 없는 커밋이 X개 있습니다.
해결 방법: 푸시 (Push) 를 통해 로컬 커밋을 원격 저장소에 반영해야 합니다.
명령어:

git push origin dev


============================================================
git status
On branch dev
Your branch is behind 'origin/dev' by 3 commits, and can be fast-forwarded.
  (use "git pull" to update your local branch)

nothing to commit, working tree clean

의미: 원격 브랜치 (origin/dev)에 로컬 브랜치에는 없는 커밋이 X개 있습니다.
해결 방법: 당겨오기 (Pull) 를 통해 원격 커밋을 로컬 브랜치에 병합해야 합니다.
명령어:

git pull origin dev

또는

git fetch origin dev
git merge origin/dev


============================================================
git status
On branch dev
Your branch and 'origin/dev' have diverged,
and have 2 and 3 different commits each, respectively.
  (use "git pull" to merge the remote branch into yours)

nothing to commit, working tree clean

의미: 로컬 브랜치와 원격 브랜치 (origin/dev)가 서로 다른 커밋을 각각 X개, Y개 가지고 있어 충돌이 발생할 수 있습니다.
해결 방법: 병합 (Merge) 또는 리베이스 (Rebase) 를 통해 변경 사항을 통합해야 합니다. 충돌이 발생하면 충돌을 해결한 후 커밋해야 합니다.

병합:

git pull origin dev

리베이스 (주의: 공개된 히스토리에는 리베이스를 피하세요):

git fetch origin dev
git rebase origin/dev

============================================================

```

#Git 충돌 해결 방법
```
충돌 발생 확인  
git pull 또는 git merge 중 충돌이 나면 Git이 어떤 파일에서 충돌이 났는지 알려줍니다.

충돌 난 파일 열기  
충돌난 파일을 텍스트 에디터나 IDE로 열어보면,

<<<<<<< HEAD  
내 로컬 변경 내용  
=======  
원격(또는 병합 대상) 변경 내용  
>>>>>>> origin/dev  

이런 식으로 구간이 표시되어 있습니다.

충돌 부분 직접 수정  
내 코드와 원격 코드 중 필요한 부분을 골라서 수정하거나, 두 코드를 합쳐서 원하는 최종 상태로 만듭니다.  
충돌 표시(<<<<<<<, =======, >>>>>>>)는 반드시 삭제해야 합니다.

수정 완료 후 저장  
수정한 파일을 저장합니다.

수정한 파일을 Git에 추가

git add <충돌해결한 파일명>

또는 모든 파일을 한꺼번에 추가하려면

git add .

충돌 해결 커밋 완료

git commit

커밋 메시지를 입력하거나 기본 메시지를 그대로 사용하면 됩니다.

푸시  
충돌 해결 커밋을 원격에 반영하려면

git push origin dev

필요하면 충돌 해결 자동화 툴이나 리베이스 충돌 해결 방법도 알려드릴게요!

```

#Git 추가적인 동기화 상태 확인 방법
```

git branch -vv
로컬 브랜치와 연결된 원격 브랜치의 이름과 함께, 각 브랜치의 최신 커밋 정보 및 로컬 브랜치가 원격 브랜치보다 얼마나 앞서거나 뒤쳐져 있는지 간략하게 보여줍니다.

============================================================

git log --graph --decorate --oneline <local_branch>...origin/<remote_branch>
git log --graph --decorate --oneline main...origin/main
로컬 브랜치와 원격 브랜치의 커밋 히스토리를 그래프 형태로 비교하여 보여줍니다. 이를 통해 두 브랜치의 관계와 동기화 상태를 시각적으로 확인할 수 있습니다.

============================================================

git branch --merged <remote_branch>
 git branch --merged origin/main
특정 원격 브랜치(<remote_branch>)로 병합된 로컬 브랜치 목록을 보여줍니다. 현재 체크아웃된 브랜치를 기준으로 병합된 브랜치를 확인하려면 <remote_branch> 자리에 HEAD를 사용합니다.

============================================================

git branch --no-merged <remote_branch>
git branch --no-merged origin/main
특정 원격 브랜치(<remote_branch>)로 아직 병합되지 않은 로컬 브랜치 목록을 보여줍니다.

============================================================

```


