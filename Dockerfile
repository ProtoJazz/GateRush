# ─── 1) BUILD STAGE ───────────────────────────────────────────────────────────────
ARG ELIXIR_VERSION=1.14.2
ARG OTP_VERSION=25.3.2
ARG DEBIAN_VERSION=bullseye-slim

FROM hexpm/elixir:1.14.5-otp-25-slim AS builder

# install OS & Node deps
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential git curl \
                        nodejs npm \
 && rm -rf /var/lib/apt/lists/*

# install hex + rebar
RUN mix local.hex --force \
 && mix local.rebar --force

WORKDIR /app
ENV MIX_ENV=prod

# fetch & compile Elixir deps
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod \
 && mix deps.compile

# pull in your assets, install JS deps, build them
COPY assets assets
RUN cd assets \
 && npm ci \
 && cd .. \
 && mix assets.deploy     # calls your alias: tailwind gate_rush --minify, esbuild gate_rush --minify, phx.digest

# bring in the rest of your app code + runtime config
COPY lib lib
COPY priv priv
COPY config/config.exs config/
COPY config/runtime.exs config/

# produce the release
RUN mix release

# ─── 2) RELEASE STAGE ─────────────────────────────────────────────────────────────
FROM debian:bullseye-slim

# minimal OS deps for runtime
RUN apt-get update \
 && apt-get install -y --no-install-recommends openssl libstdc++6 ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ENV MIX_ENV=prod
ENV LANG=C.UTF-8

# copy only the release from builder
COPY --from=builder /app/_build/prod/rel/gate_rush ./

# run as non-root
USER nobody

# start the app
CMD ["/app/bin/gate_rush", "start"]
