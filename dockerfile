# Base image with Python
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create app directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --upgrade pip && \
pip install -r requirements.txt

# Copy Django project code
COPY . /app/

# DB migration 
RUN  python manage.py makemigrations && \
    python manage.py migrate

# Expose the port used by the app
EXPOSE 8000

# Start django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
