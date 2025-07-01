# Use official Python base image
FROM python:3.11-slim

# Set work directory inside the container
WORKDIR /app

# Copy only relevant files
COPY ./main.py /app/
COPY ./requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 8000

# Run FastAPI app with uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

