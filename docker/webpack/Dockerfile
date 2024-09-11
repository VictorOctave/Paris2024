FROM node:20

RUN apt-get update && apt-get install -y nodejs && apt-get install -y git && apt-get clean

CMD yarn install && yarn run watch
