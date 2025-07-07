FROM debian:bookworm-slim

ARG NODE_VERSION=22

# Set working directory
WORKDIR /var/www/nodeapp

# Install dependencies, Node.js and Nginx
RUN apt-get update && \
    apt-get install -y curl gnupg2 ca-certificates lsb-release nginx && \
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install -y nodejs && \
    apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy application code
COPY . .

# Replace Nginx default config
COPY default.conf /etc/nginx/sites-available/default

# Install Node.js dependencies
RUN npm install

# Expose ports
EXPOSE 80
EXPOSE 443

# Start services
CMD ["bash", "-c", "npm start & service nginx start && tail -f /dev/null"]
