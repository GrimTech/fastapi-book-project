# Use a Python base image
FROM python:3.11-slim

# Install Nginx and Supervisord (to manage multiple processes)
RUN apt-get update && \
    apt-get install -y nginx supervisor && \
    rm -rf /var/lib/apt/lists/*

# Copy Nginx config
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Copy Supervisord config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy FastAPI app
WORKDIR /app
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port Nginx listens on (default: 80)
EXPOSE 80

# Start Supervisord to manage Nginx and FastAPI
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]