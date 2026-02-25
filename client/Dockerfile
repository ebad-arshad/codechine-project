# Stage 1
FROM alpine:latest AS builder
WORKDIR /app

COPY index.html health.html db.html app.css script.js ./

# -------------------------Multi-Stage-Build--------------------------------

# Stage 2: Production Nginx Environment
FROM nginx:alpine

# Remove default static assets provided by Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copy our custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the HTML/CSS/JS files from the builder stage
COPY --from=builder /app/index.html /usr/share/nginx/html/
COPY --from=builder /app/health.html /usr/share/nginx/html/
COPY --from=builder /app/db.html /usr/share/nginx/html/
COPY --from=builder /app/app.css /usr/share/nginx/html/
COPY --from=builder /app/script.js /usr/share/nginx/html/

# Expose Port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]