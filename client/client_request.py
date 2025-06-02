import requests, zipfile, io

with open("../obf_hello_linux", "rb") as f:
    data = f.read()

zip_buffer = io.BytesIO()
with zipfile.ZipFile(zip_buffer, mode="w") as zf:
    zf.writestr("obf_hello_linux_zip", data)

zip_buffer.seek(0)

#parallel loop
response = requests.post(
    "http://100.27.243.37:8000/process",
    data=zip_buffer.read(),
    headers={"Content-Type": "application/zip"}
)

result = response.json()
print("Addresses:", result["addresses"])
print("Explanation:", result["explanation"])
