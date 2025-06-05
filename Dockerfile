# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Add dummy package.json to simulate a real build process
COPY package*.json ./
RUN npm install

# Add app source (index.html and static assets)
COPY . .

# Simulate build step (in real projects: npm run build)
RUN mkdir -p build && cp index.html build/

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Create non-root user for security
RUN addgroup -g 3001 appgroup && adduser -D -u 1001 -G appgroup appuser

WORKDIR /usr/share/nginx/html

COPY --from=builder /app/build ./
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Fix permissions so appuser can write to /var/run (where nginx.pid lives)
RUN mkdir -p /var/run && chown -R 1001:3001 /var/run && \
    chown -R 1001:3001 /usr/share/nginx/html && \
    chown -R 1001:3001 /var/cache/nginx

USER appuser

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
