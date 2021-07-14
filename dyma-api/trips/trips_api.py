"""TripsAPI methods operate with the MongoDB collection"""

from datetime import datetime
from bson import ObjectId

from utils.connection_db import db


def get_trips():
    """retrieve all trips documents in mongo atlas db"""

    return db.trips.find()


def find_trips_by_id(trip_id):
    """Get trip document in mongo atlas db"""
    return db.trips.find_one(
        {
            "_id": ObjectId(trip_id)
        }
    )


def create_trip(document):
    """Create trip document in mongo database"""
    document["date"] = datetime.strptime(
        document["date"], "%Y-%m-%dT%H:%M:%S.%f")
    return db.trips.insert_one(document)


def update_trip_by_id(trip_id, document):
    """Update trip document in mongo database"""
    document["date"] = datetime.strptime(
        document["date"], "%Y-%m-%dT%H:%M:%S.%f")
    return db.trips.update_one(
        {"_id": ObjectId(trip_id)},
        {"$set": document}
    )
