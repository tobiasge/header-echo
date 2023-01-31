# Header echo

Header echo is just a simple FastAPI server run inside a container that returns request data as JSON for GET, PUT, POST and DELETE send to any URL.

## Usage

To start the container use these commands:
```bash
docker pull ghcr.io/tobiasge/header-echo:latest
docker run -it --rm -p 8080:8080 ghcr.io/tobiasge/header-echo:latest
```

## Example output
Use curl to test the connection. Optionally you can format the output with `jq`.
```bash
curl -s http://localhost:8080/
```
```bash
curl -s http://localhost:8080/ | jq
```
```JSON
{
  "full_path": "/",
  "method": "GET",
  "params": {},
  "headers": {
    "host": "localhost:8080",
    "user-agent": "curl/7.74.0",
    "accept": "*/*"
  },
  "body": ""
}
```
