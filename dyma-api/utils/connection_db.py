"""Connection to MongoDB"""
import logging
import ssl

from flask import current_app, g
from werkzeug.local import LocalProxy

from pymongo import MongoClient


def get_mongo_db():
    """
    Configuration function to return db instance
    """
    mongo_db = getattr(g, "_database", None)
    DYMA_DB_URI = current_app.config["DYMA_DB_URI"]
    DYMA_DB_NAME = current_app.config["DYMA_DB_NAME"]
    if mongo_db is None:
        mongo_db = g._database = MongoClient(
            DYMA_DB_URI,
            ssl_cert_reqs=ssl.CERT_NONE,
            # DONE: Connection Pooling
            # Set the maximum connection pool size to 50 active connections.
            maxPoolSize=50,
            # DONE: Timeouts
            # Set the write timeout limit to 2500 milliseconds.
            wTimeoutMS=2500
        )[DYMA_DB_NAME]

    return mongo_db


# Use LocalProxy to read the global db instance with just `db`
db = LocalProxy(get_mongo_db)
