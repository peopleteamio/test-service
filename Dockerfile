# Stage 1 - Build 
FROM node:alpine as build
WORKDIR /usr/src/app

COPY package*.json .
RUN npm install

COPY . .
RUN npm run build


# Stage 2 - Deploy
FROM node:alpine 
WORKDIR /usr/src/app

COPY package*.json .
RUN npm install --omit=dev

# Copy the dist folder from the previous stage
COPY --from=build /usr/src/app/dist dist

# Add metadata to the image
LABEL org.opencontainers.image.source=https://github.com/peopleteamio/test-service
LABEL org.opencontainers.image.description="The docker image built from the test-service repository."
LABEL org.opencontainers.image.licenses=MIT

EXPOSE 3000

CMD ["npm", "start"]