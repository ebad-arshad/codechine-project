# Stage 1
FROM alpine:3.14 AS builder
WORKDIR /app

COPY index.html health.html db.html app.css script.js ./

# -------------------------Multi-Stage-Build--------------------------------

# Stage 2: Production Nginx Environment
FROM nginx:1.28.2-alpine-slim

# Remove default static assets provided by Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copy our custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the HTML/CSS/JS files from the builder stage
COPY --from=builder /app /usr/share/nginx/html/

# Expose Port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]