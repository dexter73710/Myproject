ARG Version=22.04
FROM ubuntu:$Version

# Set working directory
WORKDIR /var/www/nodeapp

# Install dependencies and security updates
RUN apt update && \
    apt upgrade -y && \
    apt install -y \
        curl \
        gnupg2 \
        ca-certificates \
        lsb-release \
        nginx && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt install -y nodejs && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Copy application files
COPY . .

# Copy and enable Nginx config
COPY default.conf /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Install Node.js dependencies
RUN npm install

# Expose required ports
EXPOSE 80 443

# Start Node and Nginx properly
CMD bash -c "npm start & nginx -g 'daemon off;'"
