FROM nginx:latest

# Remove the default Nginx web page
RUN rm -rf /usr/share/nginx/html/*

# Copy the entire website
COPY . /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
