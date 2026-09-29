# Dockerfiles in backend, docker-compose in infra

## Status

Draft

## Context

The project separates service implementation from deployment configuration. Docker setup must support local orchestration without placing service source code or service Dockerfiles in the infrastructure repository.

## Decision

Each service keeps its Dockerfile next to its code in `backend`. The `infra` repository owns the Docker Compose file and deployment configuration, with each Compose build context pointing to the corresponding backend service directory.

## Consequences

- Service code and its image build instructions remain together.
- Deployment configuration can evolve independently and can be extended one service block at a time.
- A local checkout needs `backend` and `infra` as sibling directories for the relative build contexts.

## Alternatives considered

- **Single compose inside backend:** rejected because Compose and deployment configuration belong in `infra`.
- **Dockerfile inside infra:** rejected because each service's Dockerfile belongs alongside its source code.