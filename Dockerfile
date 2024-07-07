# Base image for Node.js
FROM node:18-alpine as node-build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install --silent
COPY . ./
RUN npm run build

# Base image for Python 3.10 FastAPI app
FROM python:3.10-slim-buster as python-app1

WORKDIR /app

COPY --from=node-build /app /app
RUN pip install --no-cache-dir fastapi uvicorn redis requests openai

# Base image for Python 3.9 FastAPI app with PostgreSQL client
FROM python:3.9-slim-buster

WORKDIR /app

COPY --from=python-app1 /app /app
RUN pip install --no-cache-dir fastapi uvicorn redis requests openai tiktoken langchain python-dotenv postgres psycopg2-binary pgvector

# Install PostgreSQL client
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

# Copy wait-for-postgres.sh and make it executable
COPY ./wait-for-postgres.sh /wait-for-postgres.sh
RUN chmod +x /wait-for-postgres.sh

# Expose ports
EXPOSE 3000 80

# Command to run all services sequentially
CMD ["sh", "-c", "npm run dev & /wait-for-postgres.sh postgres uvicorn app:app --host 0.0.0.0 --port 80"]
