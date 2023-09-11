# Use Alpine Linux as the base image
FROM ubuntu:latest

# Set the working directory to /app
WORKDIR /app

ENV TERM xterm-256color

# Install git and update the package index
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y -qq git \
    sudo \
    apt-utils \ 
    bash \
    dialog

# Clone your GitHub repository to the /app/ directory
RUN git clone https://github.com/Beesoc/easy-linux.git /app/

# Copy your installer script to the container
COPY wordlists/ /wordlists/

# Source the .envrc file to set environment variables
RUN . /app/.envrc

# Create symlinks to redirect /opt/easy-linux/ to /app/
RUN ln -s /app/ /opt/easy-linux \
    && ln -s /backup/ /opt/backup \
    && ln -s /compiled/ /$HOME/compiled \
    && ln -s /wordlists/ /usr/share/wordlists

# Install dependencies and set up the environment (you may need to customize this part)
RUN apt update && apt install -y -qq \
    nano \
    xauth \
    xterm \
    gnome-terminal 
    # Add any other dependencies your installer script requires here

# Run chmod +x on *.sh files in /app, /app/install, /app/support, and /app/support/misc
RUN find /app -type f -name "*.sh" -exec chmod +x {} \;

# Run the touch and chown commands
RUN touch /app/support/.last_update \
    && chown -vR $USER:0 /app/support/.last_update

# Expose any ports if needed
# EXPOSE 80

# Define the command to run your installer script
CMD ["/opt/easy-linux/install/menu-master.sh"]
