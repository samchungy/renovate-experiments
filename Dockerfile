ARG BASE_IMAGE

###

FROM public.ecr.aws/docker/library/node:22-alpine AS build

FROM node:22-alpine AS build

FROM public.ecr.aws/docker/library/node:24-alpine AS build

COPY . .

RUN pnpm install --offline
RUN pnpm build
RUN pnpm --filter api --prod --offline deploy api

###

FROM gcr.io/distroless/nodejs24-debian13@sha256:a0e13ecaccfd00b5cdfe363e514ab1e2397ba9b10e6ffe5b868cb6bb4f95fe32

FROM gcr.io/distroless/nodejs22-debian12

FROM gcr.io/distroless/nodejs24-debian13@sha256:a0e13ecaccfd00b5cdfe363e514ab1e2397ba9b10e6ffe5b868cb6bb4f95fe32 AS runtime

WORKDIR /workdir

COPY --from=build /workdir/api .

ENV NODE_ENV=production

# https://nodejs.org/api/cli.html#cli_node_options_options
ENV NODE_OPTIONS=--enable-source-maps

ARG PORT=8001
ENV PORT=${PORT}
EXPOSE ${PORT}

CMD ["./lib/listen.js"]
