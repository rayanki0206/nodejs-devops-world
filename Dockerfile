# # Use official Node.js image from the Docker Hub
# FROM node:16

# # Create and set the working directory
# WORKDIR /app

# # Copy the package.json and package-lock.json to the container
# COPY package*.json ./

# # Install dependencies
# RUN npm install

# # Copy the rest of the app files to the container
# COPY . .

# # Expose the port the app will run on
# EXPOSE 3000

# # Start the app
# CMD ["npm", "start"]



# Use the Alpine version of Node 22 (Fast, Small, Secure)
FROM node:22-alpine

# Set the working directory
WORKDIR /app

# Step A: Copy only dependency files FIRST
# This allows Docker to 'cache' your npm install 
# unless you actually add new packages.
COPY package*.json ./

# Install only what's needed for production
RUN npm install --production

# Step B: Copy the rest of your code
COPY . .

# Expose the port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]