# Multi-stage build para otimização de tamanho e segurança DevSecOps
FROM --platform=$BUILDPLATFORM node:22-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN CI=false npm run build

# Imagem final com Nginx Alpine atualizado com últimos patches de segurança
FROM nginx:alpine AS runner
RUN apk update && apk upgrade --no-cache && rm -rf /etc/nginx/conf.d/*
COPY nginx.lab.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]