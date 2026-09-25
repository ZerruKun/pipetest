# Этап 1: Сборка (используем стабильный LTS Node 20)
FROM node:20-alpine AS build
WORKDIR /app

# Копируем package.json из папки app (которую мы создали на хосте)
COPY app/package*.json ./
RUN npm install

# Копируем весь остальной код из папки app
COPY app/ .
RUN npm run build

# Этап 2: Запуск (используем легкий Nginx)
FROM nginx:alpine
# Копируем собранные статические файлы из этапа build в папку nginx
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]