FROM node:22-alpine

WORKDIR /app
# 의존성 설치 
COPY package*.json ./
RUN npm ci
# 소스 복사
COPY . .

# vite 기본 포트
EXPOSE 5173

# 컨테이너 밖에서 접속 가능하게 
# CMD와 ENTRYPOINT차이점
# npm run dev
CMD ["npm", "run", "dev","--","--host","0.0.0.0", "--port", "5173"]