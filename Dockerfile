FROM node:22-alpine3.20

WORKDIR /app

# Install nginx
RUN apk add --no-cache nginx && mkdir -p /run/nginx

# Copy package.json and lock file first (for clean layer caching)
COPY package.json package-lock.json ./

# Install npm-force-resolutions to resolve transitive CVEs
RUN npm install npm-force-resolutions --save-dev && \
    npx npm-force-resolutions && \
    npm ci --omit=dev

# Now copy rest of the app
COPY . .

# Copy Nginx config
COPY default.conf /etc/nginx/http.d/default.conf

EXPOSE 80

CMD ["sh", "-c", "npm start & nginx -g 'daemon off;'"]
