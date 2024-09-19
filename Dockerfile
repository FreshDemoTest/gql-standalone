FROM python:3.10.11-slim-buster

RUN echo "APT UPDATE..."
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

RUN echo "ADD POETRY TO PATH..."
# Add Poetry to the PATH
ENV PATH="/root/.local/bin:$PATH"

RUN echo "Create gql directory..."
# Set the working directory
WORKDIR /_gqlapi

RUN echo "Copy the pyproject.toml and poetry.lock files to the working directory..."
# Copy the pyproject.toml and poetry.lock files to the working directory
COPY pyproject.toml poetry.lock ./

RUN echo "Install dependencies without dev dependencies..."
# Install dependencies without dev dependencies
RUN poetry install --no-root --no-dev

RUN echo "Copy the rest of the application code to the working directory..."
# Copy the rest of the application code to the working directory
COPY . .

RUN echo "Set environment variables for app name and port..."

# Expose the correct port for Render
EXPOSE 8004

# Start the app using Render's $PORT environment variable
CMD ["python", "-m", "gqlapi.main", "serve", "--host", "0.0.0.0", "--port", "${PORT:-8004}"]