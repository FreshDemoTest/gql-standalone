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

# Install Poetry
RUN pip install --no-cache-dir poetry

# Add Poetry to the PATH
ENV PATH="/root/.local/bin:$PATH"

# Set the working directory
WORKDIR /gqlapi

# Copy the pyproject.toml and poetry.lock files to the working directory
COPY pyproject.toml poetry.lock ./

# Install dependencies without dev dependencies
RUN poetry install --no-root --no-dev

# Copy the rest of the application code to the working directory
COPY . .

# Install your local dependencies
COPY ./dist/deps/*.whl ./
RUN pip install *.whl && rm -rf *.whl

COPY ./dist/*.whl ./
RUN pip install *.whl && rm -rf *.whl

# Set environment variables for app name and port
ENV APP_NAME="gqlapi"
ENV APP_PORT="8004"

# Render requires apps to listen on $PORT, which defaults to 10000
ENV PORT=$PORT

# Expose the correct port for Render
EXPOSE $PORT

# Start the app using Render's $PORT environment variable
CMD ["python", "-m", "gqlapi.main", "serve", "--port", "$PORT"]