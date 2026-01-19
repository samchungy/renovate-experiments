ARG BASE_IMAGE

###

FROM public.ecr.aws/docker/library/node:22-alpine AS build

COPY . .

RUN pnpm install --offline
RUN pnpm build
RUN pnpm --filter api --prod --offline deploy api

###

FROM gcr.io/distroless/nodejs22-debian12@sha256:b25d2acae94fcf57d27f3ac29135ecdce9c0be1e8585ef52262f0dde6b36ce72 AS runtime

WORKDIR /workdir

COPY --from=build /workdir/api .

ENV NODE_ENV=production

# https://nodejs.org/api/cli.html#cli_node_options_options
ENV NODE_OPTIONS=--enable-source-maps

ARG PORT=8001
ENV PORT=${PORT}
EXPOSE ${PORT}

CMD ["./lib/listen.js"]
