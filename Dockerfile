# Multi-stage build para otimização de tamanho e segurança DevSecOps
FROM node:22-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Imagem final de runtime enxuta e segura com Nginx Alpine
FROM nginx:1.27-alpine AS runner
RUN rm -rf /etc/nginx/conf.d/*
COPY nginx.lab.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]