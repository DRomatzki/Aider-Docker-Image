# Use a minimal base image
FROM python:3.11-slim

# Adding environment variables
ENV OPENAI_API_KEY="1234567890asdfghj"
ENV OLLAMA_API_BASE="http://host.docker.internal:11434"

# Create a non-root user and group
ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} appgroup && \
    useradd -m -u ${UID} -g appgroup appuser

# Create necessary directories and change ownership
RUN mkdir -p /home/appuser/config /home/appuser/app && \
    chown -R appuser:appgroup /home/appuser

# Initialise the source list and install necessary dependencies
RUN echo "deb http://deb.debian.org/debian bookworm main" > /etc/apt/sources.list.d/debian.list && \
    apt-get update && \
    apt-get install -y libportaudio2 git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch to the non-root user
USER appuser

# Set home directory for the non-root user
WORKDIR /home/appuser

# Copy necessary files and change ownership
COPY --chown=appuser:appgroup ./config/aider.conf.yml /home/appuser/config/.aider.conf.yml
COPY --chown=appuser:appgroup ./config/aider.model.settings.yml /home/appuser/config/aider.model.settings.yml
COPY --chown=appuser:appgroup ./config/aider.model.metadata.json /home/appuser/config/aider.model.metadata.json
COPY --chown=appuser:appgroup entrypoint.sh /home/appuser/entrypoint.sh
RUN chmod +x /home/appuser/entrypoint.sh

# Run Git configuration
RUN git config --global user.name <Your_git_username> && \  
    git config --global user.email <Your_email_address>

# Add the user-specific Python package directory to the PATH
ENV PATH=/home/appuser/.local/bin:$PATH

# Install necessary packages as the non-root user
RUN python -m pip install --user --upgrade pip

# Clone the aider repository and install it
RUN git clone https://github.com/paul-gauthier/aider.git /home/appuser/aider && \
    python -m pip install --user /home/appuser/aider && \
    python -m pip install --user -e /home/appuser/aider[help] && \
    python -m pip install --user -e /home/appuser/aider[browser] && \
    python -m pip install --user -e /home/appuser/aider[playwright]

# Switch to root user temporarily to install Playwright and its dependencies globally
USER root
RUN python -m pip install playwright && \
    playwright install --with-deps chromium

# Switch back to the non-root user
USER appuser

# Set the default working directory for future instructions
WORKDIR /home/appuser/app

# Use the entrypoint script to run the application
ENTRYPOINT ["/home/appuser/entrypoint.sh"]
CMD ["aider", "--config", "/home/appuser/config/.aider.conf.yml"]

