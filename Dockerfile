FROM node:16-alpine as builder

WORKDIR /cognito

COPY package.json yarn.lock .yarnrc.yml /cognito/
COPY .yarn /cognito/.yarn
RUN yarn install --immutable

COPY babel.config.js tsconfig.json tsconfig.build.json /cognito/
COPY src/ /cognito/src/

RUN yarn build

########################################

FROM node:16-alpine

EXPOSE 9229
WORKDIR /cognito/
RUN mkdir /cognito/.cognito
VOLUME /cognito/.cognito

COPY --from=builder /cognito/lib/ /cognito/lib/
COPY package.json yarn.lock .yarnrc.yml /cognito/
COPY .yarn /cognito/.yarn/
RUN yarn install --immutable && rm -rf .yarn

ENV HOST 0.0.0.0

#ENTRYPOINT ["/cognito/lib/bin/start.js"]
CMD ["node", "/cognito/lib/bin/start.js"]
