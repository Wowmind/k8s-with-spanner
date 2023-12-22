FROM node:18 AS build-env
COPY . /app
WORKDIR /app

RUN npm ci --omit=dev
RUN npm run build

FROM gcr.io/distroless/nodejs18-debian11
COPY --from=build-env /app /app
WORKDIR /app

CMD [ "./src/server.js" ]
