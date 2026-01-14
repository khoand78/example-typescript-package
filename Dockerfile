# ---------- Build stage ----------
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# ---------- Runtime stage ----------
FROM node:20-alpine

WORKDIR /app
ENV NODE_ENV=production

# Copy node_modules + built files
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY package*.json ./

CMD ["node", "dist/cjs/index.js"]
