# Use an official Nginx image as the base image
FROM nginx:alpine

# Set the working directory
WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy the React build files to the Nginx web root
COPY build/ .

# Expose port 80
EXPOSE 80

# Start Nginx server when the container runs
CMD ["nginx", "-g", "daemon off;"]
