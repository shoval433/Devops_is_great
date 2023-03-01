FROM python:3.10.10-alpine3.17
WORKDIR /test
# Install dependencies
COPY ./req.txt .
RUN pip install -r req.txt
COPY ./pytest.py .
RUN mkdir logging
ENV ip=localhost
ENV port=80
ENTRYPOINT  python3 pytest.py ${ip} ${port} && cat test.log >> logging/test.log 
