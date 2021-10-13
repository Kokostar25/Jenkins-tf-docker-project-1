FROM node:16-alpine3.11
WORKDIR /usr/src/app
COPY ./ ./
COPY --chown=node:node .  .
RUN npm install 
USER node 
EXPOSE 3000
CMD ["npm", "start"]