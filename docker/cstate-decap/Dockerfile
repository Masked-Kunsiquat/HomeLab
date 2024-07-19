# Use the official Node.js image as the base image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Install global dependencies
RUN npm install -g gatsby-cli

# Clone the cState repository
RUN git clone https://github.com/cstate/cstate.git

# Change working directory to cState
WORKDIR /usr/src/app/cstate

# Checkout the latest stable release
RUN git checkout tags/v5.0.0

# Install cState dependencies
RUN npm install

# Copy environment variables file
COPY .env .env

# Copy Decap CMS config to cState
COPY static/admin/config.yml static/admin/config.yml

# Copy custom pages
COPY src/pages src/pages

# Install Decap CMS
RUN npm install netlify-cms-app

# Expose necessary port
EXPOSE 8000

# Command to run cState and Decap CMS
CMD ["gatsby", "develop", "-H", "0.0.0.0"]

