ARG Version=22.04

FROM ubuntu:$Version

WORKDIR /var/www/nodeapp

RUN apt update && \
    apt install -y curl gnupg2 ca-certificates lsb-release nginx && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt install -y nodejs && \
    apt clean && rm -rf /var/lib/apt/lists/*


COPY . .
COPY default.conf /etc/nginx/sites-available/default


RUN npm install


EXPOSE 80
EXPOSE 443

CMD bash -c "npm start & service nginx start && tail -f /dev/null"
