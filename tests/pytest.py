#!/usr/bin/python3
import sys
import requests
import datetime
import pytest

def test_receive_string(ip_address, port, string="Devops is great"):
    # Checks if the string and the request are good
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
    test_receive_string(ip_address, port)
        