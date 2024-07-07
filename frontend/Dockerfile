FROM node:18-alpine

WORKDIR /app



RUN npm install --silent

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]
