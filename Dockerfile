# Use the official Nginx image
FROM nginx:latest

# Remove the default Nginx web page
RUN rm -rf /usr/share/nginx/html/*

# Copy your HTML file into the Nginx web directory
COPY index.html /usr/share/nginx/html/

# Expose port 80 inside the container
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
