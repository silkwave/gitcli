
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

# 원격 저장소에서 최신 정보를 가져오기
git fetch origin

# 로컬 브랜치를 원격 main 브랜치 상태로 강제 초기화
git reset --hard origin/main


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
  
```