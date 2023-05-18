FROM node:20.2.0-alpine3.17

WORKDIR /app

COPY package.json package-lock.json .
RUN npm i --ci

COPY unleash.js .

ENV NODE_ENV production

EXPOSE 4242

CMD ["node", "unleash.js"]
