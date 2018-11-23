FROM node:6.14.4-alpine as builder

WORKDIR /app

COPY ./app /app/

RUN mkdir /www \
    && npm install \
    && npm run build \
    && cp -r dist/* /www \
    && cp -r nginx.conf /nginx.conf \
    && rm -rf /app


FROM nginx:stable-alpine

COPY --from=builder /www /usr/share/nginx/html

COPY --from=builder /nginx.conf /etc/nginx/nginx.conf

RUN apk update \
    && apk add --no-cache bash \
    bash-completion \
    && rm -rf /var/cache/apk/*