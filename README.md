# GitHub Daily Commit (잔디심기)

GitHub 기여도 그래프에 잔디를 심기 위한 완전 자동화 스크립트입니다. 커밋 생성부터 Pull Request, 코드 리뷰, 머지까지 모든 과정이 자동으로 진행되어 바로 기여도 그래프에 반영됩니다.

## 주요 기능

- ✅ 일일 자동 커밋 생성 (1-10개 랜덤)
- ✅ Pull Request 자동 생성
- ✅ 코드 리뷰 자동 추가
- ✅ **PR 자동 머지** (커밋을 main 브랜치에 자동 반영)
- ✅ 브랜치 자동 생성 및 관리
- ✅ 로컬/원격 브랜치 자동 동기화
- ✅ 사용한 브랜치 자동 삭제

## 사전 요구사항

### 1. GitHub CLI 설치
GitHub CLI (`gh`)가 설치되어 있어야 합니다:

**macOS:**
```bash
brew install gh
```

**Linux:**
```bash
# Debian/Ubuntu
sudo apt install gh

# 또는 공식 설치 스크립트 사용
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

**Windows:**
```powershell
winget install GitHub.cli
```

### 2. GitHub CLI 인증
```bash
gh auth login
```

인증 방법을 선택하고 지시에 따라 진행하세요.

## 설정 방법

### 1. 저장소 클론
```bash
git clone https://github.com/yourusername/daily.git
cd daily
```

### 2. 스크립트 실행 권한 부여
```bash
chmod +x daily_commit.sh
```

### 3. 스크립트 경로 수정
`daily_commit.sh` 파일에서 `REPO_DIR` 변수를 실제 저장소 경로로 수정하세요:
```bash
REPO_DIR="/home/yourusername/daily"
```

### 4. Crontab 설정
매일 자동으로 커밋하려면 crontab에 등록하세요:
```bash
crontab -e
```

다음 줄을 추가 (매일 오전 9시에 실행):
```
0 9 * * * /home/yourusername/daily/daily_commit.sh >> /home/yourusername/daily/cron.log 2>&1
```

### 5. Git 설정 확인
Git 사용자 정보가 설정되어 있는지 확인:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## 동작 방식

1. **로컬 동기화**: main 브랜치를 원격 저장소와 동기화합니다
2. **브랜치 생성**: 매일 새로운 브랜치를 생성합니다 (`daily-update-YYYY-MM-DD`)
3. **커밋 생성**: 1-10개의 랜덤 커밋을 생성합니다
4. **브랜치 푸시**: 생성된 브랜치를 원격 저장소에 푸시합니다
5. **PR 생성**: 자동으로 Pull Request를 생성합니다
6. **코드 리뷰**: PR에 코드 리뷰 댓글을 자동으로 추가합니다
7. **PR 자동 머지**: PR을 main 브랜치에 자동으로 머지합니다 (이 단계에서 커밋이 기여도 그래프에 반영됩니다!)
8. **정리 작업**: 로컬 브랜치를 다시 동기화하고, 사용한 원격 브랜치를 삭제합니다

## 파일 구조
- `daily_commit.sh`: 일일 커밋, PR, 코드 리뷰를 생성하는 메인 스크립트
- `daily.txt`: 커밋 기록이 저장되는 파일
- `setup_crontab.sh`: crontab 설정을 도와주는 스크립트
- `cron.log`: crontab 실행 로그 (선택사항)

## 주의사항
- 이 스크립트는 매일 실행되어 GitHub에 커밋, PR, 코드 리뷰를 생성하고 자동으로 머지합니다
- **PR이 자동으로 머지되므로**, 커밋이 즉시 main 브랜치에 반영되고 기여도 그래프에 표시됩니다
- 저장소가 공개되어 있다면 다른 사람들도 볼 수 있습니다
- 네트워크 연결이 필요합니다
- GitHub CLI 인증이 필요합니다 (`gh auth login`)
- 동일한 날짜에 여러 번 실행하면 기존 PR을 업데이트합니다
- main 브랜치는 항상 원격과 동기화되므로, main에서 직접 작업하지 마세요