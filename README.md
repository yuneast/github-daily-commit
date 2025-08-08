# GitHub Daily Commit (잔디심기)

GitHub 기여도 그래프에 잔디를 심기 위한 자동 커밋 스크립트입니다.

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

## 파일 구조
- `daily_commit.sh`: 일일 커밋을 생성하는 메인 스크립트
- `daily.txt`: 커밋 기록이 저장되는 파일
- `cron.log`: crontab 실행 로그 (선택사항)

## 주의사항
- 이 스크립트는 매일 실행되어 GitHub에 푸시합니다
- 저장소가 공개되어 있다면 다른 사람들도 볼 수 있습니다
- 네트워크 연결이 필요합니다