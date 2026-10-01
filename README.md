# infra

Deployment and infrastructure configuration for the Gaming Castle microservices. Docker Compose lives here; service source code and each service's Dockerfile stay in the `backend` repository.

## Prerequisites

- Docker
- Docker Compose v2 (the `docker compose` command)

## Local setup

Clone `backend` and `infra` as sibling directories:

```text
project/
  backend/
  infra/
```

From the `infra` directory, copy `.env.example` to `.env` and replace the placeholder values with local secrets. Do not commit `.env`.

```sh
cp .env.example .env
docker compose up --build
```

The API gateway is available at `http://localhost:8080`. The backend services
are published on ports 8081 through 8086: user, booking, payment, tournament,
loyalty, and notification, respectively. Eureka is available at
`http://localhost:8761`. Inspect service status with `docker compose ps` and
logs with `docker compose logs <service>`.

Stop the services and retain database data with:

```sh
docker compose down
```

Reset the database volume as well:

```sh
docker compose down -v
```

## Adding a new service

1. Add the service's Dockerfile beside its source code in `backend`.
2. Add one service block to this repository's `docker-compose.yml`, including its image and backend-relative build context.
3. Add the required environment variables and health-aware `depends_on` entries; put local secrets in `.env` only.
4. Run `docker compose config` and `docker compose up --build` to validate and start the service.# infra
Infrastructure as Code — Docker, docker-compose, CI/CD pipeline and deployment scripts
