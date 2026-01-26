# ======================
# 1) BUILD ANGULAR APP
# ======================
FROM node:20-alpine AS build

WORKDIR /app

# Install build tools
RUN apk add --no-cache python3 make g++ bash git

# Copy package files
COPY package*.json ./

# Install Angular CLI + full dev dependencies
RUN npm install \
    @angular/cli@18 @angular-devkit/build-angular@18 typescript zone.js rxjs --save-dev

# Copy the rest of your source code
COPY . .

# Ensure ng command works
ENV PATH="/app/node_modules/.bin:${PATH}"

# Build Angular in production mode
RUN npx ng build --configuration production

# ======================
# 2) SERVE VIA NGINX
# ======================
FROM nginx:alpine

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy Angular build output
COPY --from=build /app/dist/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
