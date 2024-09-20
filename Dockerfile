FROM python:3.10.11-slim-buster

# install Dependencies
RUN apt-get update && apt-get install -y curl && \
    curl -sSL https://install.python-poetry.org | python3 - && \
    apt-get remove -y curl && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*


RUN echo "INSTALL POETRY..."
# Install Poetry
RUN pip install --no-cache-dir poetry

# Add Poetry to the PATH
ENV PATH="/root/.local/bin:$PATH"

# Set the working directory
WORKDIR /gqlapi_app

# Copy the pyproject.toml and poetry.lock files to the working directory
COPY pyproject.toml poetry.lock ./

# Install dependencies with dev dependencies
RUN poetry install --with dev

# Copy the rest of the application code to the working directory
COPY . .

# Expose the correct port for Render
EXPOSE 8004

# Start the app using Render's $PORT environment variable
CMD ["python", "-m", "gqlapi.main", "serve", "--host", "0.0.0.0", "--port", "8004"]