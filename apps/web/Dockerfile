FROM oven/bun:latest AS base

# Generate a partial monorepo with a pruned lockfile for a target workspace.
# Assuming "web" is the name entered in the project's package.json: { name: "web" }
FROM base AS prune
WORKDIR /app
RUN --mount=type=cache,id=pnpm,target=/pnpm/store bun install -g turbo@^2.5.6
COPY . .
RUN turbo prune web --docker

# Add lockfile and package.json's of isolated subworkspace
FROM base AS installer
WORKDIR /app
# First install the dependencies (as they change less often)
COPY --from=prune /app/out/json/ .
# COPY --from=prune /app/out/pnpm-lock.yaml .
RUN bun install --frozen-lockfile

# Build the project
FROM installer AS installer-prod
COPY --from=prune /app/out/full/ .
RUN bunx turbo run build

# Run the project in production mode
FROM base AS runner
WORKDIR /app
# Don't run production as root
RUN addgroup --system --gid 1001 web-group
RUN adduser --system --uid 1001 web-user
USER web-user

# Copy the entire project structure with dependencies and build artifacts
COPY --from=installer --chown=web-user:web-group /app/node_modules ./node_modules
COPY --from=prune --chown=web-user:web-group /app/out/json/ .
COPY --from=installer-prod --chown=web-user:web-group /app/apps/web/build ./apps/web/build
COPY --from=installer-prod --chown=web-user:web-group /app/apps/web/node_modules ./apps/web/node_modules

EXPOSE 3000
ENV NODE_ENV=production

CMD ["bun", "apps/web/build"]