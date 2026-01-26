FROM node:20
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npx ng build --configuration=production --browser
RUN npx ng build --configuration=production --server

EXPOSE 4000
CMD ["node", "dist/YOUR_APP/server/main.js"]
