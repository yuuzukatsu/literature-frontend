FROM node:15
WORKDIR /app
COPY build .
RUN npm install -g serve
EXPOSE 3000
CMD [ "serve", "-s", "." ]