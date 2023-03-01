#!/usr/bin/python3
import sys
import requests
import logging
import datetime

def test_receive_string(ip_address, port, string="Devops is great"):
    url = f"http://{ip_address}:{port}/"
    expected_string = string
    response = requests.get(url)
    assert response.status_code == 200,"Unexpected status code: {}".format(response.status_code)
    assert response.text == expected_string, "Unexpected string: {}".format(response.text)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 pytest.py <ip_address> <port>")
        sys.exit(1)

    ip_address = sys.argv[1]
    port = int(sys.argv[2])
    logging.basicConfig(filename="test.log", level=logging.INFO)
    try:
        test_receive_string(ip_address, port)
        logging.info(f"{datetime.datetime.now()}: Test passed for {ip_address}:{port}")
    except AssertionError as e:
        logging.warning(f"{datetime.datetime.now()}: Test failed for {ip_address}:{port} ; ERRO: {e}")
       