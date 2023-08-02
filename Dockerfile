FROM node:18-alpine
# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY package.json package-lock.json ./
RUN npm config set fetch-retry-maxtimeout 600000 -g && npm install
ENV PATH /opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY . .
RUN chown -R node:node /opt/app
USER node
RUN ["npm", "run", "build"]
EXPOSE 5000
CMD ["npm", "run", "develop"]

# FROM node:18-alpine

# Let WatchTower know to ignore this container for checking
# LABEL com.centurylinklabs.watchtower.enable="false"

# WORKDIR /app

# COPY ./package*.json ./

# RUN npm ci

# COPY . .

# ENV NODE_ENV production

# RUN npm run build

# EXPOSE 1337

# CMD ["npm", "start"]