FROM node:22-alpine3.20

WORKDIR /app

# Install nginx
RUN apk add --no-cache nginx && mkdir -p /run/nginx

# Copy package files first for layer caching
COPY package.json package-lock.json ./

# Force all transitive brace-expansion versions to 4.0.1
RUN npm install npm-force-resolutions --save-dev && \
    npx npm-force-resolutions && \
    npm ci --omit=dev

# Now copy the rest of your app
COPY . .

# Copy nginx config
COPY default.conf /etc/nginx/http.d/default.conf

EXPOSE 80

CMD ["sh", "-c", "npm start & nginx -g 'daemon off;'"]
