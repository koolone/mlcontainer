curl http://localhost:8080/ping
curl -d '{"text":"Hello world, this is a ML demo!", "k": 1}' -H "Content-Type: application/json" -X POST http://localhost:8080/invocations

