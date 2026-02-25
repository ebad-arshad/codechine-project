# Secure 3-Tier DevOps To-Do Stack

This project is a production-ready To-Do application built to demonstrate shift-left container orchestration. I implemented Google Distroless runtimes, non-root execution, and strict network segmentation.

---

## Tech Stack

| Component | Technology | Role |
| :--- | :--- | :--- |
| **Frontend** | Nginx (Alpine) | Reverse Proxy & Static File Serving |
| **Backend** | Node.js 20 | REST API |
| **Database** | Binami-Hardened MongoDB | Persistent Data Store |
| **Runtime** | Docker Compose | Container Orchestration |
| **Security** | Google Distroless | Minimal Attack Surface Runtime |

---

## Key Security Features

### 1. Multi-Stage Builds & Distroless Images
The backend utilizes a **Multi-Stage Docker build** to separate the build environment from the runtime. 
* The final production image is built on **Google Distroless**.
* **Why?** It contains zero shell access (`sh`, `bash`), no package managers (`npm`, `apk`), and no unnecessary binaries, making it nearly impossible for an attacker to perform lateral movement.

### 2. Non-Root Execution (Principle of Least Privilege)
Standard containers often run as `root`, which is a major security risk. 
* **Backend:** Explicitly configured to run as `USER 1000`.
* **Database:** Utilizes a hardened **Bitnami** image, pre-configured to run as a non-privileged user.
* **Benefit:** Even in the event of a container breakout, the attacker lacks root privileges on the host machine.

### 3. Network Segmentation (Dual-Bridge Isolation)
Instead of a single flat network, this project implements **Network Segmentation** via two distinct Docker bridges:
* **`frontend-nw`**: Connects Nginx (Gateway) to the Node.js Backend.
* **`backend-nw`**: Connects the Node.js Backend to the Database.
* **The Result:** The Database is physically isolated from the Frontend. A breach at the web layer does not provide a direct path to the data layer.

### 4. Immutable Image Pinning
To ensure **Deterministic Builds** and protect against supply-chain attacks, the MongoDB image is pinned using its unique **SHA256 Content Addressable Identifier (Digest)**. This guarantees the image used in production is exactly the one that was verified.

---

## Observability & Health Probes

The stack includes custom health probes designed for DevOps monitoring tools:
* `/api/health`: Provides application heartbeat and uptime status.
* `/api/db`: Performs a real-time connection handshake with the MongoDB instance.
* **Monitoring UI:** Dedicated pages located at `/status/health` and `/status/db` allow for manual verification of system status.

---

## How to Run Locally

### Prerequisites
* Docker & Docker Compose installed.

### Steps
1. **Clone the repository:**
    ```bash
    git clone https://github.com/ebad-arshad/codechine-project.git
    cd codechine-project

2. **Start the services:**
    ```bash
    docker-compose up --build

3. **Access Endpoints:**
- Application: http://localhost:80
- Health Page: http://localhost:80/status/health
- DB Status Page: http://localhost:80/status/db