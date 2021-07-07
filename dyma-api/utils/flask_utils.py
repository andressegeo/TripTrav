"""Blueprint utils methods."""
from datetime import datetime

from bson import json_util, ObjectId
from flask.json import JSONEncoder
from flask import jsonify


def flask_constructor_error(message, status=500, custom_error_code=None, error_payload=None):
    """Construct Json Error returned message."""
    payload = {
        "message": message
    }
    if error_payload:
        payload["payload"] = error_payload

    if custom_error_code:
        payload["error_code"] = custom_error_code

    return jsonify(payload), status


def flask_construct_response(item, code=200):
    """Construct Json response returned."""
    return jsonify(item), code


class MongoJsonEncoder(JSONEncoder):
    """Overload the default Flask JSON encoder"""

    def default(self, obj):
        """Help to overcome `fields not JSON serializable` from mongo
            Args:
                response(list/dict): mongo response

            Returns:
                response(dict): MongoJsonEncoder response
        """
        if isinstance(obj, datetime):
            return obj.strftime("%Y-%m-%d %H:%M:%S")
        if isinstance(obj, ObjectId):
            return str(obj)
        return json_util.default(obj, json_util.CANONICAL_JSON_OPTIONS)
