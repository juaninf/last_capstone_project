from fastapi import Request
from ray import serve
import ray
import sys
from transformers import pipeline
import zipfile, io
import DeepDi

# Ensure Serve HTTP proxy is exposed on port 8000
ray.init(address="auto")
serve.start(
    detached=True,
    http_options={"host": "0.0.0.0", "port": 8000}
)

@serve.deployment
class Processor:
    def __init__(self):
        self.summarizer = pipeline("text-generation", model="distilgpt2")

    async def __call__(self, request: Request):
        zip_data = await request.body()
        with zipfile.ZipFile(io.BytesIO(zip_data)) as zf:
            data = zf.read("obf_hello_linux_zip")
            key = "ced1095fbcc0c9408fe50ad8a514e33610cec939352563fa10e47ae6af55357a"
            gpu = False
            path = "obf_hello_linux"
            addresses = DeepDi.example(key, gpu, data)
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>", addresses)
            explanation = self.summarizer(f"Explain this: {addresses} from DeepDi", max_new_tokens=50)[0]['generated_text']
            sys.stdout.flush()
            return {"addresses": addresses , "explanation": explanation}

app = Processor.bind()
serve.run(app, route_prefix="/process")
