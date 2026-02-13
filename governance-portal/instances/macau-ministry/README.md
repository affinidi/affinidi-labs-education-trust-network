# Macau Ministry Governance Portal

Admin web portal for managing the Macau Ministry of Education Trust Registry.

## Configuration

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Update the `.env` file with your specific configuration.

## Running

Start the portal:
```bash
docker-compose up -d
```

Access the portal at: http://localhost:3402

## Backend Service

This portal connects to the Macau Trust Registry API (Rust service) running on port 3233.
Make sure the Trust Registry API is running before starting this portal.

## Features

- View all records in the trust registry
- Create new assertion records
- Update existing records
- Delete records
- Test Recognition and Authorization queries
