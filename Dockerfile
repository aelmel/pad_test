# ---------------------------------------------
# 1) BUILD STAGE
# ---------------------------------------------
FROM hexpm/elixir:1.17.3-erlang-25.2.3-alpine-3.21.0 AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    git \
    python3 \
    curl \
    ca-certificates

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /app

# Set build ENV
ENV MIX_ENV=prod

# Install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# Copy assets
COPY priv priv
COPY assets assets

# Compile assets
RUN mix assets.deploy

# Compile and release
COPY lib lib
RUN mix compile
RUN mix release
# ---------------------------------------------
# 2) RUN STAGE
# ---------------------------------------------
FROM alpine:3.21 AS app

RUN apk add --no-cache \
    libstdc++ \
    openssl \
    ncurses-libs \
    ca-certificates

WORKDIR /app

# Copy the release from the builder stage
COPY --from=builder /app/_build/prod/rel/pad_test ./

# Set the environment variables
ENV HOME=/app \
    PORT=4000 \
    HOST=0.0.0.0 \
    SECRET_KEY_BASE=dLU81jFqCnQHh3WXqXs1YiWGmqtH4RcH5TVKCLSeKR2GK9TTRgEkMsqQ1Vy4f/rt

CMD ["bin/pad_test", "start"]
