# -----------------------
# 1) BUILD ANGULAR APP
# -----------------------
FROM node:20-alpine AS build

WORKDIR /app

# Install build tools for node-gyp etc.
RUN apk add --no-cache python3 make g++ bash git

# Copy package files
COPY package*.json ./

# Install Angular CLI + full dev dependencies for CLI-only Angular 18
RUN npm install \
    @angular/cli@18 \
    @angular-devkit/build-angular@18 \
    typescript \
    zone.js \
    rxjs \
    --save-dev --force

# Copy the rest of your app source code
COPY . .

# Add local ng to PATH
ENV PATH="/app/node_modules/.bin:${PATH}"

# Build Angular production
RUN npx ng build --configuration production

# -----------------------
# 2) SERVE WITH NGINX
# -----------------------
FROM nginx:alpine

# Remove default nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy build output from build stage
COPY --from=build /app/dist/ /usr/share/nginx/html/

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
