
#!/bin/bash

# this script provides some common functionality
# which can be used by runtime startup scripts.
# to use: source /tools/setup.sh

# exit immediately on error
set -e

# don't throw errors when expanding an empty directory
shopt -s nullglob

# log output as json so it will be parsed by elasticsearch
function log {
    echo "{\"level\": \"info\", \"msg\": \"${1}\"}"
}

# log output as json so it will be parsed by elasticsearch
function log_error {
    echo "{\"level\": \"error\", \"msg\": \"${1}\"}"
}

# Current environment and project
# ALIMA_PROJECT var should be set when building the image step
# ENV should be set when deploying the task definition

# directory with secrets for local development
LOCAL_VAULT=/vault/local
# default values for the above
DEFAULT_VAULT=/vault/defaults
# temporary directory to keep secrets before exporting as environment variables
TMP_VAULT=/tmp/vault
# make sure we start with an empty directory
rm -fr ${TMP_VAULT}
mkdir ${TMP_VAULT}

# get all secrets and expose them as environment variables
log "Fetching secrets from S3"
ALIMA_VAULT="alima-vault-${ENV}"

# handle both infrastructures' vaults
vault_folder="${ALIMA_PROJECT}"
aws s3 sync --only-show-errors s3://${ALIMA_VAULT}/${vault_folder}/ ${TMP_VAULT}/

# support copying secrets from a local directory, but only in the local environment.  they supercede
# any secrets from S3
if [ "${ALIMA_ENVIRONMENT}" == "local" ]
then
    if [[ -d "${LOCAL_VAULT}" && -n "$(ls -A ${LOCAL_VAULT})" ]]
    then
        log "Deploying secrets from the local vault"
        cp "${LOCAL_VAULT}"/* ${TMP_VAULT}/
    else
        if [[ -d "${DEFAULT_VAULT}"  && -n "$(ls -A ${DEFAULT_VAULT})" ]]
        then
            log "Deploying secrets from the default vault"
            cp "${DEFAULT_VAULT}"/* ${TMP_VAULT}/
        fi
    fi
fi

# export whatever secrets were copied to the temporary location
for secret_file in ${TMP_VAULT}/*
do
    # secret name == file name (all uppercase as it'll be exported as
    # an environment variable
    secret=$(basename ${secret_file})
    log "Exporting secret: ${secret}"
    if [ -n "${secret}" ]
    then
        # read the secret
        value=$(cat ${secret_file})
        eval "export ${secret}='${value}'"
    fi
done

# clean up
rm -fr ${TMP_VAULT}