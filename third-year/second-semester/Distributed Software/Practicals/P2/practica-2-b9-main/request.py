import requests

url = "http://127.0.0.1:8000/hello/Noah"
response = requests.get(url)
response.json()

print(response.content)
