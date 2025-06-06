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
RUN npm ci --only=production && npm cache clean --force

# Copy semua file aplikasi + credentials
COPY --chown=nodejs:nodejs . .
COPY config/g-04-450802-839e68f5387a.json /app/config/

# Environment variables (default)
ENV NODE_ENV=production
ENV PORT=8080

# Expose port
EXPOSE 8080

# Gunakan non-root user
USER nodejs

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Start aplikasi
CMD ["dumb-init", "node", "server.js"]
