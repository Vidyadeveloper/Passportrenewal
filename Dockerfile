# ---- deps stage ----
FROM node:20-alpine AS deps
WORKDIR /app

ARG NPM_TOKEN
ENV NPM_TOKEN=$NPM_TOKEN

# Configure GitHub Packages (no 'always-auth')
# Note: no '-x' to avoid leaking the token in logs
RUN set -e; \
    npm config set @blaze-case-ai:registry https://npm.pkg.github.com; \
    npm config set //npm.pkg.github.com/:_authToken "$NPM_TOKEN"

# bring in app so preinstall/prebuild scripts can run
COPY . .

# install (not 'ci', since lockfile is out of sync)
RUN npm install --omit=dev

# scrub token from npm config
RUN npm config delete //npm.pkg.github.com/:_authToken || true; \
    npm config delete @blaze-case-ai:registry || true
