# Use an official Python runtime as the base image
FROM python:3.9

# Set the working directory
WORKDIR /app

# Copy the requirements file
#COPY requirements.txt .

# Install the required packages
RUN apt-get update && apt-get install -y net-tools lsof iproute2

# Copy the application code
COPY . .

# Install the application dependencies
#RUN pip install --no-cache-dir -r requirements.txt

# Expose the application port
EXPOSE 8000

# Start the application
CMD ["python", "sample.py"]
