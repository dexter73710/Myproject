FROM node:22-alpine3.20

WORKDIR /app

RUN apk add --no-cache nginx && \
    mkdir -p /run/nginx

COPY . .

COPY default.conf /etc/nginx/http.d/default.conf

RUN npm ci --omit=dev || npm install --omit=dev

EXPOSE 80

CMD ["sh", "-c", "npm start & nginx -g 'daemon off;'"]
