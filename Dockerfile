FROM node:20.11-alpine
WORKDIR /app
COPY package.json *.lock ./
RUN yarn install
RUN npm install joi

# COPY . /app/
COPY index.js /app 
CMD ["yarn", "start"]
EXPOSE 3000
