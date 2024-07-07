FROM node:18-alpine

WORKDIR /app

EXPOSE 3000


RUN npm install --silent

COPY . ./

CMD ["npm", "run", "dev"]
