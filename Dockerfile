# Этап 1: Сборка
FROM node:20-alpine AS build
WORKDIR /app

# Копируем package.json из папки app (которую мы создали на хосте)
COPY app/package*.json ./
RUN npm install

# Копируем весь остальной код из папки app
COPY app/ .

# Восстанавливаем права на исполнение для всех скриптов npm
RUN chmod -R +x node_modules/.bin

# Собираем проект
RUN npm run build

# Этап 2: Запуск (используем легкий Nginx)
FROM nginx:alpine
# Копируем собранные статические файлы из этапа build в папку nginx
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]