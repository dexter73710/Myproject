# Use a minimal base image to reduce attack surface
FROM node:22.2-slim

# Set working directory
WORKDIR /usr/src/app

# Install Nginx only (no curl, gnupg2, etc.)
RUN apt-get update && \
    apt-get install -y nginx --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Copy app files
COPY . .

# Overwrite the default Nginx site config
COPY default.conf /etc/nginx/sites-available/default

# Install node modules
RUN npm install --omit=dev

# Expose ports
EXPOSE 80 443

# Start both nginx and the node app
CMD ["sh", "-c", "service nginx start && npm start"]
