
# Git 작업 흐름 요약

## 1. `dev` 브랜치 가져오기
`dev` 브랜치를 최신 상태로 업데이트:
```sh
git checkout dev
git pull origin dev
```

## 2. 새로운 브랜치로 이동
`dev_silkwave` 브랜치를 생성하거나 해당 브랜치로 이동:
```sh
git checkout dev_silkwave
```

## 3. `dev` 브랜치 병합
최신 `dev` 브랜치 내용을 `dev_silkwave` 브랜치로 병합:
```sh
git merge dev
```

## 4. 변경 사항 확인 (선택 사항)
현재 브랜치의 변경 사항을 확인:
```sh
git diff
```

## 5. 수정, 스테이징 및 커밋
변경된 파일을 추가하고 커밋:
```sh
git add .
git commit -m "커밋 메시지"
```

## 6. 원격 저장소로 푸시
`dev_silkwave` 브랜치를 원격 저장소로 푸시:
```sh
git push origin dev_silkwave
```

## 7. GitLab에서 머지 요청 생성
1. [GitLab](http://gitlab.com/)에 접속.
2. 상단 메뉴에서 **Create merge requests** 클릭.
3. **Approve** 클릭.
4. **Merge** 클릭.

## 8. 변경 사항 취소 또는 복구
### 스테이징 영역 복구
```sh
git restore --staged
```
### 파일 복구
```sh
git restore
```
### 변경 사항 되돌리기
```sh
git reset --hard
```

## 9. `dev` 브랜치와 비교 (선택 사항)
현재 브랜치와 `dev` 브랜치의 변경 사항 비교:
```sh
git diff dev
```

---

**참고:** 작업 수행 전 변경 사항과 브랜치 이름을 반드시 확인하세요.
