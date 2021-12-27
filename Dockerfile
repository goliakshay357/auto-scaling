FROM node:16-slim as base

LABEL org.opencontainers.image.authors=admin@canvasbird.org
LABEL org.opencontainers.image.title="Canvasboard backend Dockerfile"
LABEL org.opencontainers.image.licenses=MIT

ENV NODE_ENV=production
EXPOSE 3000
ENV PORT 3000
WORKDIR /app
COPY package*.json ./
RUN npm config list

RUN npm ci && npm cache clean --force
ENV PATH /app/node_modules/.bin:$PATH
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]
CMD ["node", "index.js"]


FROM base as dev
ENV NODE_ENV=development
RUN apt-get update -qq && apt-get install -qy \ 
    ca-certificates \
    bzip2 \
    curl \
    libfontconfig \
    --no-install-recommends
RUN npm config list
RUN npm install --only=development \
    && npm cache clean --force
USER node
CMD ["nodemon", "index.js"]


FROM dev as test
COPY . .
RUN npm audit
ARG MICROSCANNER_TOKEN
ADD https://get.aquasec.com/microscanner /
USER root
RUN chmod +x /microscanner
RUN /microscanner $MICROSCANNER_TOKEN --continue-on-failure

FROM test as remove-files
RUN rm -rf ./node_modules

FROM base as prod
COPY --from=remove-files /app /app
HEALTHCHECK CMD curl http://127.0.0.1/ || exit 1
USER node