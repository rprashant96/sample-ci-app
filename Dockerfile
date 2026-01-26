# ======================
# 1) BUILD ANGULAR APP
# ======================
FROM node:22-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files first (for better layer caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Install Angular CLI globally (needed for ng command)
RUN npm install -g @angular/cli@latest

# Copy rest of the app source
COPY . .

# Build Angular in production mode
RUN ng build --configuration=production

# ======================
# 2) RUN USING NGINX
# ======================
FROM nginx:alpine

# Remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy compiled Angular files
COPY --from=build /app/dist/ /usr/share/nginx/html/

# Expose container port
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
