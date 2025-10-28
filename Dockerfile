# ==== BUILDER ====
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (including dev for lockfile consistency)
RUN npm ci

# Copy source code
COPY . .

# ==== FINAL ====
FROM node:20-alpine
WORKDIR /app

# Copy node_modules from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/app.js ./

# Non-root user
USER node

EXPOSE 3000
CMD ["node", "app.js"]