
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
git status 
git log --oneline
git revert 3f5a1b7
git log --oneline
커밋 되돌리기 + 충돌 해결

되돌리는 과정에서 충돌이 발생할 수 있습니다. 이 경우:

    충돌 파일을 수정합니다.
    변경 사항을 git add로 스테이징합니다.
    git revert --continue 명령을 실행합니다.
```

### 변경 사항을 스태시에 저장
```sh
# 1. 변경 사항을 스태시에 저장
git stash push -m "WIP: 메인 페이지 UI 작업"

# 2. 브랜치 전환
git checkout feature

# 3. 작업 완료 후 다시 메인 브랜치로 돌아감
git checkout main

# 4. 저장했던 스태시 적용
git stash apply
```
