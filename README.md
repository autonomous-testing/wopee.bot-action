# Run tests by Wopee Bot using docker container

## Example usage of the action in GitHub workflow

```YAML
name: 'Example Wopee.bot run'
description: 'Example workflow to run Wopee Bot action'

on:
  workflow_dispatch:
  push:

jobs:
  run-wopee:
    name: Run Wopee.bot
    runs-on: ubuntu-latest

    steps:
        - name: Log in to the Wopee.io container registry
          uses: docker/login-action@v2
          with:
              registry: ghcr.io/autonomous-testing
              username: ${{ secrets.wopee_registry_username }}
              password: ${{ secrets.wopee_registry_password }}

        - name: Run Wopee.bot using docker
          uses: autonomous-testing/wopee.bot-action@v1
          with:
              image: ghcr.io/autonomous-testing/wopee.bot:dev # optional, default value: 'ghcr.io/autonomous-testing/wopee.bot:dev'
              container_name: my-wopee-test # optional, default value: 'wopee-runner'
              env_file: my_test.env # optional, default value: ''
```

## Customizing

### inputs

Following inputs can be used as `step.with` keys

| Name             | Type   | Default                                 | Description                                                                                                                                         |
| ---------------- | ------ | --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `image`          | String | ghcr.io/autonomous-testing/wopee.bot:dev | Full path to Wopee image                                                                                                                            |
| `container_name` | String | wopee-runner                            | Name for container within running wopee. It will be stopped first if it is already running.                                                         |
| `env_file`       | String |                                         | Path to .env file relative to current working directory. All contained variabless will be loaded into container.                                    |

## Example usage of wopee.bot.sh script

```Bash
# First login to container registry
# For GitHub container registry (ghcr.io) see https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry
export CR_PAT=YOUR_TOKEN
echo $CR_PAT | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# Optionaly select image and env file
export IMAGE=ghcr.io/autonomous-testing/wopee.bot:dev # optional, default value: ghcr.io/autonomous-testing/wopee.bot:dev
export CONTAINER_NAME=my-wopee-test # optional, default value: 'wopee-runner'
export ENV_FILE=my_test.env # optional, default value: ''

# Run Wopee
sh wopee.bot.sh
```

## Example usage of direct run in docker (NOT RECOMMENDED)

```Bash
# See the example
cat wopee.bot.sh
```

## Example usage of direct run of bot (NEVER DO THAT)

```Bash
# You have been warned
wopee_bot
```
