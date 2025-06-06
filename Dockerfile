FROM node:20-alpine

# Install dumb-init untuk signal handling
RUN apk add --no-cache dumb-init

# Set working directory
WORKDIR /app

# Buat non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001

# Copy package.json terlebih dahulu
COPY package*.json ./

# Install dependencies
RUN npm ci && npm cache clean --force

# Copy semua file aplikasi
COPY --chown=nodejs:nodejs . .

# Environment variables (default)
ENV NODE_ENV=production
ENV PORT=8080

# Expose port
EXPOSE 8080

# Gunakan non-root user
USER nodejs

# Start aplikasi
CMD ["dumb-init", "node", "server.js"]

