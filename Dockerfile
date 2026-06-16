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

FROM public.ecr.aws/seek-hirer-granite/distroless-node-24

FROM gcr.io/distroless/nodejs22-debian12

FROM public.ecr.aws/seek-hirer-granite/distroless-node-24@sha256:811802da2d3a864d14563405a51c1321bf57f13d244aa85bdb04c7dee385224b AS runtime

WORKDIR /workdir

COPY --from=build /workdir/api .

ENV NODE_ENV=production

# https://nodejs.org/api/cli.html#cli_node_options_options
ENV NODE_OPTIONS=--enable-source-maps

ARG PORT=8001
ENV PORT=${PORT}
EXPOSE ${PORT}

CMD ["./lib/listen.js"]
