FROM node:20-alpine3.18
RUN npm install -g pnpm
WORKDIR /app
COPY . .
RUN pnpm install
ENV NODE_ENV production
ENV PORT 3000
EXPOSE 3000
LABEL fly_launch_runtime="nodejs"
CMD ["pnpm", "run", "migrate", "&&", "pnpm", "run", "start"]
