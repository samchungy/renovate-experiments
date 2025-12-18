ARG BASE_IMAGE

###

FROM ${BASE_IMAGE} AS build

COPY . .

RUN pnpm install --offline
RUN pnpm build
RUN pnpm --filter api --prod --offline deploy api

###

FROM gcr.io/distroless/nodejs22-debian12@sha256:5c65bac666660d114d2d7588e39333e92b4a1685ba66bdf3c6faaedab2b4be6e AS runtime

WORKDIR /workdir

COPY --from=build /workdir/api .

ENV NODE_ENV=production

# https://nodejs.org/api/cli.html#cli_node_options_options
ENV NODE_OPTIONS=--enable-source-maps

ARG PORT=8001
ENV PORT=${PORT}
EXPOSE ${PORT}

CMD ["./lib/listen.js"]
