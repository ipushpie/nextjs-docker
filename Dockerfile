# Stage 1: Building the application
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all other files
COPY . .

# Build the application
RUN npm run build

# Stage 2: Running the application
FROM node:20-alpine AS runner

WORKDIR /app

# Set to production environment
ENV NODE_ENV production

# Copy necessary files from builder
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# Install production dependencies only
RUN npm install --production

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["node", "server.js"] 