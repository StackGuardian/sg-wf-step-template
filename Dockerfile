FROM python:3.11-alpine

# make a pipe fail on the first failure
SHELL ["/bin/sh", "-o", "pipefail", "-c"]

# Install base dependencies
RUN apk add --no-cache \
    bash \
    curl \
    git \
    jq \
    openssh \
    openssl \
    ca-certificates

# Install any additional dependencies needed for your workflow step
# Example: If you need AWS CLI
# RUN pip install awscli

# Example: If you need specific system libraries
# RUN apk add --no-cache \
#     library1 \
#     library2

# Clean up unnecessary files and secure the container
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

# Set up working directory
WORKDIR /app

# Copy your workflow step script
COPY main.sh .
RUN chmod +x main.sh

# Run the workflow step script
CMD ["./main.sh"]
