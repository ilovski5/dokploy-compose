FROM node:20-alpine AS base

FROM base AS builder

RUN apk add --no-cache gcompat
WORKDIR /app

COPY package.json package-lock.json tsconfig.json ./
COPY src/ ./src/

RUN npm ci && \
  NODE_ENV=production npm run build && \
  npm prune --production

FROM base AS runner
WORKDIR /app

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 hono

COPY --from=builder --chown=hono:nodejs /app/dist/index.js /app/index.js

USER hono
EXPOSE 3000

CMD ["node", "/app/index.js"]
