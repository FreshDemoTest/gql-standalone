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

COPY ./dist/deps/*.whl ./
RUN pip install *.whl && rm -rf *.whl

COPY ./dist/*.whl ./
RUN pip install *.whl && rm -rf *.whl

# Add Poetry to the PATH
ENV PATH="/root/.local/bin:$PATH"

# Set the working directory
WORKDIR /pt

# Copy the pyproject.toml and poetry.lock files to the working directory
COPY pyproject.toml poetry.lock ./

# Install dependencies
RUN poetry install --no-root --no-dev

# Copy the rest of the application code to the working directory
COPY . .

ENV APP_NAME "gqlapi"
ENV APP_PORT "8004"

EXPOSE 8004
CMD ["python", "-m", "gqlapi.main", "serve"]
