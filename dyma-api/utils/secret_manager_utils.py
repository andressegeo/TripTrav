"""This module contains utils secret manager"""
from IPython import embed
import logging
import os
from google.cloud import secretmanager


def access_secret_version(secret_id: str, project_nb: str, version_id="latest") -> str:
    """Access to secret manager.

    Arguments:
        secret_id (str) -- secret id.
        project_id (str) -- project id.
        version_id (str) -- secret version.
    """
    # Create the Secret Manager client.
    client = secretmanager.SecretManagerServiceClient()

    # Build the resource name of the secret version.
    name = f"projects/{project_nb}/secrets/{secret_id}/versions/{version_id}"
    # Access the secret version.
    response = client.access_secret_version(name=name)

    # Return the decoded payload.
    return response.payload.data.decode('UTF-8')


CLOUD_STORAGE_URL = "https://storage.googleapis.com/"
PROJECT_ENV = os.environ.get("PROJECT_ENV")
PROJECT_NAME = "dymatrip"
ENVS = {
    "dev": {
        "project_id": "{}-dev".format(PROJECT_NAME),
        # projet number for dev env , Go to AppEngine => DashBoard and look at Project Info
        "project_nb": 920624254373,
    },
    "prod": {
        "project_id": "{}".format(PROJECT_NAME),
        "project_nb": 920624254373,
    },
}


PROJECT_ID = ENVS[PROJECT_ENV]["project_id"]
PROJECT_NB = ENVS[PROJECT_ENV]["project_nb"]

DYMA_MONGO_DB_USER_NAME = access_secret_version(
    "DYMA_MONGO_DB_USER_NAME", PROJECT_ID
)
DYMA_MONGO_DB_SECRET_KEY = access_secret_version(
    "DYMA_MONGO_DB_SECRET_KEY", PROJECT_ID
)
DYMA_MONGO_DB_NAME = access_secret_version("DYMA_MONGO_DB_NAME", PROJECT_ID)

CONFIG = {
    "dev": {
        "mongodb": {
            "client": "mongodb+srv://{}:{}@dymacluster.atpsw.mongodb.net".format(DYMA_MONGO_DB_USER_NAME, DYMA_MONGO_DB_SECRET_KEY),
            "database": DYMA_MONGO_DB_NAME
        }
    },
    "prod": {
        "mongodb": {
            "client": "mongodb+srv://{}:{}@dymacluster.atpsw.mongodb.net".format(DYMA_MONGO_DB_USER_NAME, DYMA_MONGO_DB_SECRET_KEY),
            "database": DYMA_MONGO_DB_NAME
        }
    }
}

SETTINGS = {
    "project_id": PROJECT_ID,
    "cloud_storage_url": CLOUD_STORAGE_URL,
    "connector_uri": CONFIG[PROJECT_ENV][u"mongodb"][u"client"],
    "mongo_db_name": CONFIG[PROJECT_ENV][u"mongodb"][u"database"]
}
