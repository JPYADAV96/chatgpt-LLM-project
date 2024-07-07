version: '3.8'

services:
  node-app:
    build:
      context: .
      dockerfile: Dockerfile.node
    ports:
      - "3000:3000"
    volumes:
      - .:/app
    command: npm run dev

  python-app1:
    build:
      context: .
      dockerfile: Dockerfile.python1
    ports:
      - "8000:80"
    volumes:
      - .:/app
    command: uvicorn app:app --host 0.0.0.0 --port 80

  python-app2:
    build:
      context: .
      dockerfile: Dockerfile.python2
    ports:
      - "8080:80"
    volumes:
      - .:/app
    command: /wait-for-postgres.sh postgres uvicorn app:app --host 0.0.0.0 --port 80
