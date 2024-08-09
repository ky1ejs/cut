# This stage requires all deps in order to build the dist folder
FROM node:22-alpine3.19 AS builder

RUN npm install -g pnpm
WORKDIR /app
COPY package*.json .
COPY prisma ./prisma
RUN pnpm install 
COPY . .
RUN pnpm codegen:graphql && pnpm run build

###########################################
# This stage installs production dependencies only.
# I found if I ran pnpm install --prod as a RUN command within the actual image, 
# it would make a layer of 600mb in size!! Running in a separate layer reduces the size
# to just 67mb.
# I found this by asking ChatGPT:
# | "The node_modules directory in my container is huge, 600mb! 
# | When I run outside of docker, it's only 197mb. Why could this be?"
# 
# and it responded with a few points, including:
# "Docker image layers: Docker uses layered filesystems, and each instruction in your 
# Dockerfile creates a new layer in the image. If your node_modules directory is 
# large and you're copying it into the Docker image, it becomes a part of the image 
# layers. This can lead to a larger image size, especially if node_modules contains 
# a lot of files.

FROM node:22-alpine3.19 as deps

ENV NODE_ENV production
WORKDIR /app
COPY package*.json .
COPY prisma ./prisma
COPY graphql ./graphql
RUN npm install -g pnpm && pnpm install --prod

###########################################

FROM node:20-alpine3.18

ENV NODE_ENV production
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=deps /app/package*.json ./
COPY --from=deps /app/prisma ./prisma
COPY --from=deps /app/graphql ./graphql
COPY --from=deps /app/node_modules ./node_modules
RUN npm install -g pnpm

ENV PORT 3000
EXPOSE 3000
LABEL fly_launch_runtime="nodejs"

CMD ["pnpm", "run", "migrate:start"]
