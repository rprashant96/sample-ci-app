# ---------- STAGE 1: Build Angular ----------
FROM node:20-alpine AS build

WORKDIR /app

# Install deps for node-gyp (optional but safe)
RUN apk add --no-cache python3 make g++ bash

# Copy and install
COPY package*.json ./
RUN npm install

# Copy all source
COPY . .

# Expose CLI locally
ENV PATH="/app/node_modules/.bin:${PATH}"

# Build Angular
RUN ng build --configuration production

# ---------- STAGE 2: Serve with Nginx ----------
FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
