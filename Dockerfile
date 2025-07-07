FROM node:22-alpine3.20

# Set working directory
WORKDIR /app

# Install Nginx only (no curl, gnupg, etc.)
RUN apk add --no-cache nginx && \
    mkdir -p /run/nginx

# Copy app code
COPY . .

# Copy Nginx config
COPY default.conf /etc/nginx/http.d/default.conf

# Install only production dependencies
RUN npm ci --omit=dev || npm install --omit=dev

# Expose only needed port
EXPOSE 80

# Start both services
CMD ["sh", "-c", "npm start & nginx -g 'daemon off;'"]
