ARG BASE_IMAGE

###

FROM public.ecr.aws/docker/library/node:22-alpine AS build

FROM node:22-alpine AS build

FROM 111111111111.dkr.ecr.ap-southeast-2.amazonaws.com/public.ecr.aws/docker/library/node:24-alpine AS build

COPY . .

RUN pnpm install --offline
RUN pnpm build
RUN pnpm --filter api --prod --offline deploy api

###

FROM public.ecr.aws/seek-hirer-granite/distroless-node-24

FROM gcr.io/distroless/nodejs22-debian12

FROM public.ecr.aws/seek-hirer-granite/distroless-node-24@sha256:e787865e1c869611d19dc330882a9f41a1a2730f94a60a1b22ee8d6f637bcf92 AS runtime

WORKDIR /workdir

COPY --from=build /workdir/api .

ENV NODE_ENV=production

# https://nodejs.org/api/cli.html#cli_node_options_options
ENV NODE_OPTIONS=--enable-source-maps

ARG PORT=8001
ENV PORT=${PORT}
EXPOSE ${PORT}

CMD ["./lib/listen.js"]
