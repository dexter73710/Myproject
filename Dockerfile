FROM node:22-slim

WORKDIR /var/www/nodeapp

RUN apt update && apt upgrade -y && \
    apt install -y --no-install-recommends nginx && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY . .
COPY default.conf /etc/nginx/sites-available/default

RUN npm install

EXPOSE 80
CMD ["sh", "-c", "npm start & service nginx start && tail -f /dev/null"]
