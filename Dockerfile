FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /var/www/nodeapp

# Install essential services and Node.js
RUN apt update && \
    apt upgrade -y && \
    apt install -y curl ca-certificates nginx && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt install -y nodejs && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Copy application code and config
COPY . .
COPY default.conf /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Install Node dependencies
RUN npm install --omit=dev

# Expose ports
EXPOSE 80

# Start Nginx and Node app together
CMD bash -c "npm start & nginx -g 'daemon off;'"
