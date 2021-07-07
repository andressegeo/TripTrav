"""CitiesAPI methods operate with the MongoDB collection"""

from datetime import datetime
from bson import ObjectId

from utils.connection_db import db


def get_cities():
    """retrieve all cities documents in mongo atlas db"""

    return db.cities.find()


def find_cities_by_id(city_id):
    """Get city document in mongo atlas db"""
    return db.cities.find_one(
        {
            "_id": ObjectId(city_id)
        }
    )
