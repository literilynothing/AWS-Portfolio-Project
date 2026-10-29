# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set the working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create a non-root user and group for running the application
RUN groupadd -g 1000 appgroup && useradd -r -u 1000 -g appgroup appuser
COPY --chown=appuser:appgroup . .
USER appuser:appgroup

# Expose the port the app uses and defines the command to run the application
EXPOSE 8000
CMD ["python", "app.py"]