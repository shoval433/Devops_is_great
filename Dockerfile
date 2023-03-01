FROM python:3.10.10-alpine3.17
WORKDIR /app
# Install dependencies
COPY ./req.txt .
RUN pip install -r req.txt
COPY ./main.py .
ENTRYPOINT python3 main.py