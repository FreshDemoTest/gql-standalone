FROM python:3.10.11-slim-buster

# install Dependencies
RUN apt-get update \
    && apt-get install -y git \
    python3-dev \
    gcc \
    libglib2.0-0 \
    libsm6 \
    libxrender-dev \
    libpq-dev \
    ruby-full \
    && rm -rf /var/lib/apt/lists/*


RUN echo "INSTALL POETRY..."
# Install Poetry
RUN pip install --no-cache-dir poetry

# Add Poetry to the PATH
ENV PATH="/root/.local/bin:$PATH"

RUN echo "Set PYTHONPATH to include the lib directory..."
# Set the PYTHONPATH to include the lib directory
ENV PYTHONPATH="/_gqlapi/lib:${PYTHONPATH}"

# Set the working directory
WORKDIR /_gqlapi

# Copy the pyproject.toml and poetry.lock files to the working directory
COPY pyproject.toml poetry.lock ./

# Install dependencies without dev dependencies
RUN poetry install --no-root --no-dev

# Copy the rest of the application code to the working directory
COPY . .

# Expose the correct port for Render
EXPOSE 8004

# Start the app using Render's $PORT environment variable
CMD ["python", "-m", "gqlapi.main", "serve", "--host", "0.0.0.0", "--port", "${PORT:-8004}"]