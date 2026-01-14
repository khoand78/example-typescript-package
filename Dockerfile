# ---------- Build stage ----------
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source & build
COPY . .
RUN npm run build

# ---------- Runtime stage ----------
FROM node:20-alpine

WORKDIR /app
ENV NODE_ENV=production

# Install only production deps
COPY package*.json ./
RUN npm ci --omit=dev

# Copy compiled output (adjust if needed)
COPY --from=builder /app/dist ./dist
# OR if you use cjs:
# COPY --from=builder /app/cjs ./cjs

CMD ["node", "dist/index.js"]
