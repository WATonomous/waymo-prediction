# Waymo Prediction
Containerized research environment for the Waymo Motion Prediction Challenge.


## Setup
### Initialization
Run the following before using docker compose to fix ownership while inside a development container:

```bash
$ ./initialize.sh
```

This only needs to be done once. Confirm that you're project is initialized by checking the `.env` file. It should contain something like:

```
COMPOSE_PROJECT_NAME=waymo-pred-eddyzhou
FIXUID=1670
FIXGID=100
USERNAME=eddyzhou
WANDB_MODE=offline
```

### Accessing Waymo Data
TBD