# ---- Build Stage ----
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files only
COPY package*.json ./

RUN npm install --legacy-peer-deps

# Copy source code
COPY . .

ARG TMDB_V3_API_KEY
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"

RUN npm run build

# ---- Deploy Stage ----
FROM nginx:stable-alpine

WORKDIR /usr/share/nginx/html
RUN rm -rf ./*

COPY --from=builder /app/dist .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

