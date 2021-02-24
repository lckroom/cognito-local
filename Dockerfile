FROM node:12-alpine as builder

WORKDIR /cognito

COPY package.json yarn.lock /cognito/
RUN yarn install --frozen-lockfile --production=false --no-progress

COPY babel.config.js tsconfig.json tsconfig.build.json /cognito/
COPY src/ /cognito/src/

RUN yarn build

########################################

FROM node:12-alpine
#LABEL description="Instant extensible high-performance GraphQL API for your PostgreSQL database https://graphile.org/postgraphile"

EXPOSE 9229
WORKDIR /cognito/
RUN mkdir /cognito/.cognito
VOLUME /cognito/.cognito

COPY --from=builder /cognito/lib/ /cognito/lib/
COPY package.json yarn.lock /cognito/
RUN yarn install --frozen-lockfile --production=true --no-progress

ENV HOST 0.0.0.0

#ENTRYPOINT ["/cognito/lib/bin/start.js"]
CMD ["node", "/cognito/lib/bin/start.js"]
