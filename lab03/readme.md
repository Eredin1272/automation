# Lab 03 — Automating Python Script Execution with Cron

## Objective

Configure Cron inside a Docker container to automatically execute a Python script that retrieves currency exchange rates from an API.

## Project Structure

```text
lab03/
├── currency_exchange_rate.py
├── cronjob
├── Dockerfile
├── docker-compose.yml
├── entrypoint.sh
└── readme.md
```

**File descriptions:**

- `currency_exchange_rate.py` — retrieves exchange rates from the API and saves results as JSON.
- `cronjob` — defines the schedule for automatic script execution.
- `Dockerfile` — installs Python dependencies and Cron.
- `docker-compose.yml` — builds and runs the Docker container.
- `entrypoint.sh` — starts Cron and monitors its logs.
- `readme.md` — project documentation.

## Cron Schedule

| Schedule | Task |
|---|---|
| Daily at 06:00 | Get the MDL to EUR exchange rate for the previous day |
| Friday at 17:00 | Get the MDL to USD exchange rate for 7 days earlier |

Timezone: `Europe/Chisinau`.

## Requirements

- Docker Desktop
- Docker Compose
- Running Currency Exchange Rate API on port `8080`

## Build and Run

First, start the API service from Lab 02.

Then navigate to `lab03` and run:

```bash
docker compose up -d --build
```

Check the container:

```bash
docker ps
```

## Verify Cron Execution

View the Cron log:

```bash
docker compose exec currency-cron cat /var/log/cron.log
```

When using Git Bash on Windows, use:

```bash
MSYS_NO_PATHCONV=1 docker exec currency-cron cat /var/log/cron.log
```

View container logs:

```bash
docker compose logs -f
```

For testing, the Cron schedule can temporarily be changed to run every minute using `* * * * *`.

After editing `cronjob`, rebuild and recreate the container:

```bash
docker compose up -d --build --force-recreate
```

Check the generated JSON files:

```bash
MSYS_NO_PATHCONV=1 docker exec currency-cron ls -l /app/data/
```

## Notes

The API from Lab 02 supports dates from `2025-01-01` to `2025-09-15`. Requests outside this range may return errors.

Cron execution was successfully tested using the date `2025-01-01`.

Generated JSON files are stored inside the container and may be lost when the container is recreated.

## Stop Container

```bash
docker compose down
```