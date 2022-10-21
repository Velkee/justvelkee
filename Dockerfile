FROM node:latest as builder
WORKDIR /src

RUN npm i -g pnpm

COPY package.json pnpm-lock.yaml ./ 

RUN pnpm i

COPY svelte.config.js ./
COPY vite.config.ts ./
COPY static ./static
COPY src ./src

RUN pnpm run build

FROM node:latest
WORKDIR /src

RUN npm i -g pnpm

COPY --from=builder /src/build /src/build
COPY --from=builder /src/package.json /src

EXPOSE 3000

CMD ["pnpm", "run", "start"]