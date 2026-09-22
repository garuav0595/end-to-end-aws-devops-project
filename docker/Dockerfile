FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup -S devopsgroup && adduser -S devopsuser -G devopsgroup
COPY --from=builder --chown=devopsuser:devopsgroup /app/dist ./dist
COPY --from=builder --chown=devopsuser:devopsgroup /app/node_modules ./node_modules
USER devopsuser
EXPOSE 3000
CMD ["node", "dist/main.js"]
