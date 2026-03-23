FROM python:3.10-slim

# Prevent Python from writing .pyc files & buffer stdout
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies required for dlib and OpenCV
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . /app/

# Expose the default port (Render will override if needed)
EXPOSE 8000

# Start Gunicorn server (using string format to allow variable expansion if needed)
CMD gunicorn face_detection_system.wsgi:application --bind 0.0.0.0:${PORT:-8000}
