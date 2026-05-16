FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y git dnsutils && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN python3 setup.py build_ext --inplace

ENTRYPOINT ["python3", "envkiller.py"]
