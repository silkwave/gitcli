# Git 명령어 요약

이 문서는 자주 사용하는 Git 명령어와 작업 흐름을 정리한 요약본입니다.

---

## 1. Git 기본 설정

Git을 처음 사용하거나 로컬 환경을 구성할 때 유용한 명령어들입니다.

```sh
# Git이 사용할 기본 편집기 지정 (VSCode 추천)
git config --global core.editor "code --wait"
# git config --global core.editor "notepad"
# git config --global core.editor "nano"

# Git 인증 정보 저장 방식 설정
# 1. OS 인증 관리자 사용 (추천, 안전)
git config --global credential.helper manager
# 2. 평문 파일로 저장 (비추천, 보안 취약)
# git config --global credential.helper store
# git config --global --unset credential.helper # 설정 해제

# Git 출력 화면 Pager 비활성화 (긴 로그 전체 출력)
git config --global core.pager cat

# WSL 사용 시, 다른 OS의 파일 시스템에 있는 저장소를 안전하게 처리하도록 설정
git config --global --add safe.directory '*'
```

---

## 2. 한글 환경 설정

Git 사용 시 터미널이나 커밋 로그에서 한글이 깨지는 현상을 방지합니다.

```sh
# 1. Git 설정 (모든 OS 공통)
git config --global core.quotepath false      # 파일명이 한글로 표시되도록 설정
git config --global i18n.commitEncoding utf-8 # 커밋 메시지 인코딩을 UTF-8로 지정
git config --global i18n.logOutputEncoding utf-8# 로그 출력 인코딩을 UTF-8로 지정

# 2. Git Bash (Windows) 추가 설정
# 홈 디렉토리의 ~/.bashrc 파일에 아래 내용 추가
export LANG=ko_KR.UTF-8
export LC_ALL=ko_KR.UTF-8
```

---

## 3. 일반적인 작업 흐름

일상적인 Git 버전 관리 작업의 표준 순서 예시입니다.

```sh
# 1. 원격 저장소의 최신 변경사항을 가져옴 (삭제된 원격 브랜치 정보도 함께 갱신)
git fetch --all --prune

# 2. 현재 작업 디렉토리의 상태를 확인
git status

# 3. 원격 'dev' 브랜치의 변경사항을 현재 브랜치로 가져와 통합
git pull origin dev

# 4. 변경된 모든 파일을 스테이징 (커밋 준비)
git add .

# 5. 스테이징된 파일들을 커밋 (자동 커밋 메시지 예시)
T=$(date "+%Y-%m-%d %H:%M:%S");
S=$(git status -s | head -n 1);
git commit -m "자동 커밋 - $T: $S";

# 6. 로컬 커밋을 원격 'dev' 브랜치에 푸시
git push origin dev
```

---

## 4. 커밋 및 브랜치 되돌리기 (Reset & Revert)

실수로 만든 커밋을 취소하거나 브랜치 상태를 과거로 되돌립니다.

### 4.1. 특정 커밋 되돌리기

*   **`git reset --soft HEAD~1`**: 마지막 커밋을 취소합니다. 변경 내용은 **Staging Area에 보존**됩니다. (커밋 메시지만 수정할 때 유용)
*   **`git reset --mixed HEAD~1`**: 마지막 커밋과 스테이징을 함께 취소합니다. 변경 내용은 **Working Directory에 보존**됩니다.
*   **`git reset --hard <commit_hash>`**: 특정 커밋 시점으로 완전히 되돌아갑니다. 이후의 모든 변경 이력이 삭제되므로 **사용에 각별히 주의해야 합니다.**

### 4.2. 로컬 브랜치를 원격 브랜치 상태로 강제 초기화 (주의!)

로컬의 모든 변경사항을 버리고, 원격 브랜치의 상태로 강제로 덮어씁니다.

```sh
git fetch origin
git reset --hard origin/main
```

### 4.3. `reset --hard` 복구하기

`git reflog`를 사용하면 실수로 `reset --hard`를 실행했더라도 이전 상태로 복구할 수 있습니다.

*   **`git reflog`**: `HEAD`의 지난 기록들을 확인합니다.
*   **`git reset --hard HEAD@{1}`**: 돌아가고 싶은 시점(예: `HEAD@{1}`)으로 다시 강제 이동합니다.
*   **`git branch backup-before-reset`**: 만약을 위해, 복구 작업 전 현재 상태를 백업 브랜치로 만들어 두는 것이 안전합니다.

---

## 5. 브랜치 관리

브랜치를 새로 만들거나, 삭제, 전환하고 원격 브랜치와의 추적 관계를 설정합니다.

```sh
# 모든 로컬 및 원격 브랜치 목록을 표시
git branch -a

# 원격 'dev' 브랜치를 기반으로 로컬에 'feature-task' 브랜치를 생성하고 즉시 전환
git switch -c feature-task origin/dev

# 현재 로컬 브랜치가 특정 원격 브랜치를 추적하도록 설정
git branch --set-upstream-to=origin/dev

# 각 로컬 브랜치가 어떤 원격 브랜치를 추적하고 있는지 확인
git branch -vv

# 모든 브랜치의 추적 관계만 간단히 확인
git for-each-ref --format="%(refname:short) -> %(upstream:short)" refs/heads/

# 로컬 브랜치 삭제
git branch -d <branch_name> # 병합이 완료된 브랜치만 삭제
git branch -D <branch_name> # 병합 여부와 상관없이 강제 삭제

# 원격 브랜치 삭제
git push origin --delete <branch_name>

# 두 브랜치 간의 코드 차이점을 비교
git diff <branch1>..<branch2>
```

### 5.1. 로컬 브랜치를 다른 이름의 원격 브랜치로 푸시

로컬 브랜치(`dev_silkwave` 등)를 원격 저장소의 다른 이름(`dev` 등)으로 푸시하며, 동시에 업스트림(추적) 관계를 설정합니다.

```sh
# 사용법: git push --set-upstream <원격저장소> <로컬브랜치>:<원격브랜치>
git push --set-upstream origin dev_silkwave:dev
```

---

## 6. 원격 저장소 (Remotes)

연결된 원격 저장소의 정보를 확인하고 관리합니다.

```sh
# 등록된 모든 원격 저장소의 이름과 URL을 확인
git remote -v

# 'origin' 원격 저장소의 URL을 확인
git remote get-url origin

# 'origin' 원격 저장소의 URL을 변경 (HTTPS 예시)
git remote set-url origin https://github.com/user/repo.git

# SSH 주소로 변경 및 접속 테스트
# git remote set-url origin git@github.com:user/repo.git
# ssh -T git@github.com

# 현재 Git 저장소의 원격 URL을 웹 브라우저로 열기 (Git Bash)
git_repo_url=$(git config --get remote.origin.url | sed 's/git@/https:\/\//; s/:/\//; s/\.git$//')
start "$git_repo_url"      # windows
wslview "$git_repo_url"    # wsl2 

```

---

## 7. Stash (임시 저장)

현재 작업 내용을 커밋하지 않고 잠시 다른 브랜치로 이동해야 할 때, 변경사항을 임시로 저장합니다.

```sh
# 현재 변경사항을 메시지와 함께 스태시에 저장
git stash push -m "WIP: 작업 내용 임시 저장"

# 스태시 목록 확인
git stash list

# 가장 최근의 스태시를 적용하고, 목록에서 해당 스태시를 삭제
git stash pop

# 가장 최근의 스태시를 적용하되, 목록에는 그대로 남겨둠
git stash apply
```

---

## 8. Git 동기화 상태 및 해결 방법

로컬과 원격 브랜치 간의 동기화 상태를 확인하고 필요한 조치를 합니다. `git status` 명령어로 아래와 같은 상태 메시지를 확인할 수 있습니다.

*   **`Your branch is up to date with 'origin/dev'.`**
    *   **의미:** 로컬과 원격 브랜치가 완전히 동일한 상태입니다. (조치 불필요)
*   **`Your branch is ahead of 'origin/dev' by N commits.`**
    *   **의미:** 로컬 브랜치에만 존재하는 커밋이 N개 있습니다.
    *   **해결:** `git push` 명령으로 로컬 커밋을 원격 저장소에 반영합니다.
*   **`Your branch is behind 'origin/dev' by N commits.`**
    *   **의미:** 원격 브랜치에만 존재하는 커밋이 N개 있습니다.
    *   **해결:** `git pull` 명령으로 원격 변경사항을 가져와 로컬 브랜치에 병합합니다.
*   **`Your branch and 'origin/dev' have diverged.`**
    *   **의미:** 로컬과 원격 브랜치가 각자 다른 커밋 히스토리를 가지고 있습니다.
    *   **해결:** `git pull`을 실행하여 원격 변경사항을 병합하고, 충돌 발생 시 해결합니다. 또는 `git pull --rebase`로 히스토리를 정리할 수 있습니다.

### 8.1. 추가적인 동기화 상태 확인

```sh
# 각 브랜치의 추적 상태와 원격과의 커밋 차이를 함께 확인
git branch -vv

# 로컬과 원격 브랜치의 커밋 히스토리를 그래프 형태로 비교
git log --graph --oneline main...origin/main
```

### 8.2. 다양한 Pull 및 Rebase 전략

*   **Merge 방식 (기본, 안전):** 원격 변경사항을 가져와 병합(Merge) 커밋을 생성하며, 커밋 히스토리에 병합 기록이 명확하게 남습니다.
    ```sh
    git pull origin main

    # --no-ff 플래그: Fast-forward가 가능해도 강제로 Merge 커밋을 생성
    git pull --no-ff origin main
    ```
*   **Rebase 방식 (히스토리 정리):** 로컬 커밋들을 대상 브랜치(`main` 등)의 최신 커밋 위로 재배치하여, 커밋 히스토리를 깔끔하게 한 줄로 만듭니다.
    ```sh
    git pull --rebase origin main
    ```
*   **수동 Rebase:** `fetch` 후 수동으로 `rebase`를 진행할 수도 있습니다.
    ```sh
    git fetch origin
    git rebase origin/main
    ```
    *   **Rebase 중단:** 리베이스 도중 문제가 발생하면, 아래 명령어로 중단하고 이전 상태로 복원할 수 있습니다.
        ```sh
        git rebase --abort
        ```

---

## 9. Git 충돌 해결 (Conflict Resolution)

`git pull` 또는 `git merge` 시 충돌이 발생했을 때 해결하는 일반적인 순서입니다.

1.  **충돌 파일 확인:** `git status`로 어떤 파일에서 충돌이 발생했는지 확인합니다.
2.  **파일 수정:** 편집기로 충돌 파일을 열면, 아래와 같이 충돌 구간이 표시됩니다.
    ```
    <<<<<<< HEAD
    (A: 현재 브랜치의 변경 내용)
    =======
    (B: 병합하려는 브랜치의 변경 내용)
    >>>>>>> some-branch-name
    ```
    `<<<<<<<`, `=======`, `>>>>>>>` 표시를 모두 삭제하고, 두 코드(A, B)를 비교하여 최종적으로 남길 코드를 완성합니다.
3.  **파일 스테이징:** 수정 완료된 파일을 `git add` 하여 충돌이 해결되었음을 알립니다.
    ```sh
    git add <충돌_해결한_파일명>
    ```
4.  **커밋:** 병합 커밋을 완료합니다.
    ```sh
    git commit
    ```
5.  **푸시:** 해결된 내용을 원격 저장소에 푸시합니다.
    ```sh
    git push
    ```

### 9.1. 고급 충돌 해결

*   **방법 1: `checkout` 사용 (전통적인 방식)**
    *   **원격(Theirs) 버전으로 덮어쓰기:** 충돌 발생 시, 내 로컬 변경사항을 무시하고 원격(theirs) 저장소의 내용을 가져와 파일을 덮어씁니다.
        ```sh
        git restore --source=theirs <path/to/file>

        # 해결된 파일을 스테이징하고 커밋
        git add <path/to/file>
        git commit -m "chore: Resolve conflict by accepting theirs"
        ```
    *   **로컬(Ours) 버전으로 덮어쓰기:** 반대로, 원격 변경사항을 무시하고 내 로컬(ours) 파일의 내용을 그대로 적용합니다.
        ```sh
        git restore --source=ours <path/to/file>

        # 해결된 파일을 스테이징하고 커밋
        git add <path/to/file>
        git commit -m "chore: Resolve conflict by accepting ours"
        ```

*   **방법 2: `restore` 사용 (최신 방식)**
    *   **특정 브랜치에서 단일 파일 복원:** 충돌 해결뿐만 아니라, 특정 파일을 원하는 브랜치의 버전으로 되돌릴 때 유용합니다.
        ```sh
        # 원격 최신 정보를 먼저 가져옴
        git fetch origin

        # 'origin/dev' 브랜치 버전으로 특정 파일을 복원
        git restore --source=origin/dev -- <path/to/file>

        # 복원된 파일을 스테이징하고 커밋
        git add <path/to/file>
        git commit -m "chore: Restore file from origin/dev"
        ```
    *   **특정 브랜치로 전체 디렉토리 복원 (매우 강력! 주의!):** 현재 디렉토리의 모든 내용을 특정 브랜치의 상태로 덮어씁니다. `reset --hard`와 유사하게 모든 로컬 변경사항이 사라질 수 있습니다.
        ```sh
        # [주의] 현재 디렉토리의 모든 파일(Working Tree)을 'origin/main' 상태로 복원
        git restore --source=origin/main -- .

        # [매우 강력! 주의!] Staging Area와 Working Tree 모두를 'origin/main' 상태로 복원
        git restore --source=origin/main --staged --worktree -- .
        ```

---

## 10. 줄바꿈(LF ↔ CRLF) 문제 (Windows / Mac / Linux) 🔁

**증상:** 수정하지 않은 파일이 변경된 것으로 인식되거나, `pull` 또는 `merge` 시 불필요한 충돌이 발생합니다. 주된 원인은 OS마다 다른 줄바꿈 문자(LF vs CRLF) 차이입니다.

### 10.1. 확인 방법

```sh
# 현재 Git 설정 확인 (글로벌/로컬)
git config --global core.autocrlf
git config core.autocrlf

# 줄바꿈 문자로 인한 잠재적 문제 검사
git diff --check
```

### 10.2. 권장 설정

*   **Windows:** `git config --global core.autocrlf true`
*   **Mac/Linux:** `git config --global core.autocrlf input`

또는, 저장소에 `.gitattributes` 파일을 추가하여 모든 팀원이 동일한 규칙을 따르도록 강제하는 것이 가장 좋습니다 (권장).

#### .gitattributes 예시 (저장소 루트에 추가)

```
# 모든 텍스트 파일의 줄바꿈을 Git 내부에서 자동으로 정규화(LF)
* text=auto

# 특정 확장자는 항상 LF로 유지
*.sh text eol=lf
*.py text eol=lf

# Windows용 배치 파일은 CRLF로 유지
*.bat text eol=crlf
```

### 10.3. 저장소의 모든 파일 줄바꿈 정규화

1.  `.gitattributes` 파일 추가 및 커밋
    ```sh
    echo "* text=auto" >> .gitattributes
    git add .gitattributes
    git commit -m "chore: add .gitattributes for line endings"
    ```
2.  모든 파일의 줄바꿈을 규칙에 맞게 재정규화 (권장)
    ```sh
    git add --renormalize .
    git commit -m "chore: normalize line endings"
    ```
3.  (대체 방법) Git 캐시를 비우고 다시 체크아웃 — **주의해서 사용하세요.**
    ```sh
    git rm --cached -r .
    git reset --hard
    ```

### 10.4. 임시 회피책

**주의:** 근본적인 해결책이 아니며, 급하게 `pull`을 받아야 할 때 임시로 사용하는 방법입니다.

```sh
git stash push -u
git pull --rebase
git stash pop
```

**요약:** 개인 PC에서는 `core.autocrlf`를 OS에 맞게 설정하고, 협업 프로젝트에서는 `.gitattributes` 파일로 줄바꿈 규칙을 명시하여 불필요한 충돌을 예방할 수 있습니다.

---
## 11. 고급 스킬 및 유용한 팁

### 11.1. 대화형 스테이징 (Interactive Staging)
하나의 파일 내에서 일부 변경사항만 선택하여 커밋하고 싶을 때 사용합니다.

```sh
git add -p
# 또는
git add --patch
```
명령을 실행하면 Git이 변경된 각 부분(hunk)을 보여주며 스테이징할지(`y`), 건너뛸지(`n`), 더 작은 단위로 나눌지(`s`) 등을 대화형으로 묻습니다.

### 11.2. 최신 명령어로 브랜치/파일 관리
`checkout` 명령어는 여러 기능(브랜치 전환, 파일 복원 등)을 함께 가지고 있어 혼란을 줄 수 있습니다. 최신 Git에서는 역할이 명확히 분리된 `switch`와 `restore` 사용을 권장합니다.

*   **브랜치 전환 및 생성:** `git switch`
    ```sh
    # 'feature' 브랜치로 전환
    git switch feature

    # 'feature' 브랜치를 생성하고 즉시 전환
    git switch -c feature
    ```
*   **파일 변경사항 복원:** `git restore`
    ```sh
    # Working Directory의 파일 변경사항을 취소하고 최신 커밋 상태로 복원
    git restore <file_name>

    # Staging Area에 있는 파일을 Working Directory 상태로 되돌림 (Unstage)
    git restore --staged <file_name>
    ```

### 11.3. 브랜치 정리
작업이 완료되어 불필요해진 브랜치를 효율적으로 정리할 때 유용한 명령어입니다.

```sh
# 현재 브랜치에 완전히 병합된 로컬 브랜치 목록 보기 (삭제 대상 후보)
git branch --merged

# 현재 브랜치에 아직 병합되지 않은 로컬 브랜치 목록 보기
git branch --no-merged

# 설정된 원격 추적 브랜치(업스트림) 관계를 제거
git branch --unset-upstream
```

### 11.4. 작업 디렉토리 정리 (주의!)
커밋되지 않은 파일, 빌드 산출물 등 추적되고 있지 않은 파일(untracked files)들을 한번에 삭제하여 작업 공간을 깨끗하게 만듭니다.

```sh
# 어떤 파일과 디렉토리가 삭제될지 미리 확인 (Dry Run)
git clean -fdn

# 실제로 추적되지 않는 파일 및 디렉토리를 영구적으로 삭제 (복구 불가!)
git clean -fd
```

### 11.5. 특정 커밋 내용 상세 보기
`git log`가 여러 커밋의 요약 목록이라면, `git show`는 특정 커밋 하나가 어떤 변경사항을 포함하는지 상세히 보여줍니다.

```sh
# 가장 최근 커밋의 상세 정보(작성자, 날짜, 메시지, 코드 변경 내용) 보기
git show

# 특정 커밋의 상세 정보 보기
git show <commit_hash>
```

### 11.6. Git 별칭 (Alias) 설정하기
자주 사용하는 긴 명령어를 `.gitconfig` 파일에 나만의 단축어로 등록하여 생산성을 높일 수 있습니다.

```sh
# .gitconfig 파일에 직접 추가하거나 아래 명령을 실행하여 등록
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
# 'st' 별칭(Alias)을 'status' 명령에 연결하여 단축키로 사용
git config --global alias.st status
git config --global alias.hist "log --graph --pretty=format:'%C(yellow)%h%Creset %C(cyan)%d%Creset %s %C(bold green)(%cr)%Creset %C(blue)<%an>%Creset'"
```
*   **사용 예시:** `git st`는 `git status`와 동일하게 동작하며, `git hist`로 보기 좋게 꾸며진 로그를 출력할 수 있습니다.

```sh
rm -rf .git                            # 기존 Git 저장소 정보 및 버전 관리 삭제 (주의!)
git init                               # 현재 디렉토리를 새로운 Git 저장소로 초기화
git add .                              # 현재 디렉토리의 모든 변경 사항을 Staging Area에 추가
git commit -m "Initial commit"         # "Initial commit" 메시지로 변경 사항을 커밋
git branch -M main                     # 현재 브랜치 이름을 'main'으로 변경 (또는 생성)
git remote add origin https://github.com/silkwave/gitcli.git
git push -u origin main -f             # 원격 'origin' 저장소의 'main' 브랜치로 로컬 'main' 브랜치를 강제 푸시하고 추적 설정 (주의!)
```