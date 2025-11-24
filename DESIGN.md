# DESIGN.md

## Project Overview
This project provisions an AWS EC2 instance and deploys a REST service that converts pounds (lbs) 
to kilograms (kg). The service is accessible over HTTP through a minimal API and is managed as a 
systemd service for reliability. Nginx is used as a reverse proxy to route external traffic on port 80 
to the application on port 8080.

---

## Learning Objectives
- Provision and secure a VM in AWS EC2.
- Expose a minimal REST API over HTTP.
- Run the service reliably with systemd.

---

## Technology Stack
- **AWS EC2 (t3.micro, Ubuntu 24.04 LTS / Amazon Linux 2023)**: Cloud virtual machine to host the service.
- **Node.js + Express**: Chosen for its simplicity and speed in building REST APIs.
- **Morgan**: Middleware for HTTP request logging.
- **systemd**: Ensures the service runs automatically on boot and restarts on failure.
- **Nginx**: Reverse proxy forwarding traffic from port 80 → 8080.
- **curl/Postman**: Used for manual API testing.

---

## Architecture
1. **Client** → makes request to `http://<PUBLIC_IP>/convert?lbs=<number>`
2. **Nginx** → receives request on port 80 and proxies it to `127.0.0.1:8080`
3. **Express App (Node.js)** → processes request, performs validation, returns JSON
4. **systemd** → keeps the service running, restarts on failure
5. **AWS Security Group** → only allows SSH (22) and HTTP (80) from IPs

---

## Here is the directory tree with Node.Js installed:
```
|->DESIGN.md
|->README.md
|->server.js
|->package-lock.json
|->package.json
|->node_modules
```
---

## API Specification
GET /convert?lbs=<number>
**Endpoint**

### Query Parameters/Data Types
- **lbs** (required, float)
  - The weight in pounds to be converted.
  - Must be:
    - Non-negative (`lbs >= 0`)
    - Finite (not `NaN`, `Infinity`, or `-Infinity`)

### Response Format
- **Content-Type:** `application/json`
- Responses always follow a JSON object structure.

---

### Success Response
- **Status Code:** `200 OK`
- **Example Request:** http://<PUBLIC_IP>:8080/convert?lbs=150

- **Example Response:**
```json
{
  "lbs": 150,
  "kg": 68.039,
  "formula": "kg = lbs * 0.45359237"
}

