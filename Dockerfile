FROM python:3.8.2-alpine as base

# Builder Stage
FROM base as builder

WORKDIR /src

COPY . .
# hadolint ignore=DL3018
RUN apk add --no-cache curl libffi-dev openssl-dev python3-dev gcc musl-dev && \
    pip install \
      --upgrade --progress-bar=off -U \
      --no-cache-dir \
      --prefix=/install \
      . && \
     chmod +x src/entrypoint.sh

# Base Labels Image
FROM base as release

# hadolint ignore=DL3018
RUN apk add --no-cache curl

COPY --from=builder /install /usr/local
COPY --from=builder /src/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "labels"]
CMD [ "-v", "--help" ]
