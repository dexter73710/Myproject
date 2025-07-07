ARG Version=22.04
FROM ubuntu:$Version

# Set noninteractive mode to avoid user prompts
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /var/www/nodeapp

# Update packages, install only what’s needed, and clean up to reduce attack surface
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        curl \
        ca-certificates \
        nginx \
        gnupg \
        lsb-release \
        nodejs \
        npm && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy app code and nginx config
COPY . .
COPY default.conf /etc/nginx/sites-available/default

# Install Node.js dependencies
RUN npm install --omit=dev

EXPOSE 80
EXPOSE 443

# Start both Node.js and Nginx
CMD ["bash", "-c", "npm start & nginx -g 'daemon off;'"]
