FROM node:22-slim

WORKDIR /app

# Install Nginx
RUN apt update && \
    apt install -y --no-install-recommends nginx && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Copy app files
COPY . .

# Copy nginx config
COPY default.conf /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Install Node.js dependencies
RUN npm install --omit=dev

# Expose port
EXPOSE 80

CMD bash -c "npm start & nginx -g 'daemon off;'"
