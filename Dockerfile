ARG BASE_IMAGE

###

FROM ${BASE_IMAGE} AS build

COPY . .

RUN pnpm install --offline
RUN pnpm build
RUN pnpm --filter api --prod --offline deploy api

###

FROM gcr.io/distroless/nodejs22-debian13@sha256:8d51366a376060a6483bafebf6d33e982afe5530fb1acf0c15a1df75c93a312b AS runtime

WORKDIR /workdir

COPY --from=build /workdir/api .

ENV NODE_ENV=production

# https://nodejs.org/api/cli.html#cli_node_options_options
ENV NODE_OPTIONS=--enable-source-maps

ARG PORT=8001
ENV PORT=${PORT}
EXPOSE ${PORT}

CMD ["./lib/listen.js"]
