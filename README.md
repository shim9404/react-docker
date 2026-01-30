## 리액트 프로젝트 자동배포하기(vite버전)
```sh
npm create vite@latest

frameworkt선택 - react

variant선택 - javascript

엔터 - 디폴트

엔터 - yes

```

```dockerfile
FROM node: 22-alpine

WORKDIR /app
# 의존성 설치 
COPY package*.json ./
RUN npm ci
# 소스 복사
COPY . .

# vite 기본 포트
EXPOSE 5173

# 컨테이너 밖에서 접속 가능하게 
CMD ["npm", "run", "dev","--","--host","0.0.0.0", "--port", "5173"]
```


echo "# react-docker1" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/slalom0914/react-docker1.git
git push -u origin main


### Github Actions 디플로이 파일 작성
```yml
set -e
#변수 선언하기
APP_DIR=/home/ubuntu/vite-react-app
REPO_URL="https://github.com/slalom0914/react-docker1.git"
DEV_PORT=5173
# 1)최초 1회 clone하고 이후부터는 pull하기
if [! -d "$APP_DIR/.git"]; then
  sudo mkdir -p $APP_DIR
  sudo chown -R $USER:$USER $APP_DIR
  git clone $REPO_URL $APP_DIR
fi
cd $APP_DIR
git checkout main
git pull origin main
# 2)의존성 설치 -> package-lock.json기준
npm ci

# 3)기존 서버 종료(포트 기준으로 kill하기)
# 실행 중이 아니더라도 실패하지 않도록 true옵션 추가
sudo fuser -k -n tcp ${DEV_PORT} || true

# 4)서버 백그라운드 기동
# --host 0.0.0.0 : 외부 접속 허용
# 로그는 dev.log파일로 저장
nohup npm run dev -- --host 0.0.0.0 --port ${DEV_PORT} > dev.log 2>&1 &

# 5)기동 확인(로그/포트 체크)
sleep 2
sudo fuser -n tcp ${DEV_PORT} || (echo "server not running" && exit 1)