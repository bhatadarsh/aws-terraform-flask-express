//generate a simple express app which does "hello world" on the root route

const express = require('express');
const app = express();
const port = 3000;
app.get('/', (req, res) => {
  res.send('Hello World!');
}
);
app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
}   
);


//write a docker file for this express app

/*
# Use the official Node.js image as the base image
FROM node:14    
# Set the working directory in the container

WORKDIR /usr/src/app
# Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install the dependencies
RUN npm install
# Copy the rest of the application code to the working directory
COPY . .
# Expose the port that the app listens on
EXPOSE 3000
# Start the application
CMD ["node", "index.js"]
*/

