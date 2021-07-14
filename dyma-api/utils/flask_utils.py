"""Blueprint utils methods."""
from datetime import datetime
import json
from collections import OrderedDict
from functools import wraps

from bson import json_util, ObjectId
from cerberus import Validator
from flask.json import JSONEncoder
from flask import jsonify, request


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


def flask_check_and_inject_payload(validation_schema=None, upper_links=[]):  # pylint: disable=dangerous-default-value
    """
        Args:
            validation_schema (dict): the validation schema
            upper_links (list): list of id field names. We mention it as an upper link when we have
            to update a collection when CUD of another.


        Returns:
            (func): the function

    """
    def decorated(func):

        @wraps(func)
        def wrapper(*args, **kwargs):

            if request.headers.get("Content-Type") not in ["application/json; charset=utf-8"]:
                return flask_constructor_error(
                    message="The payload format is unknown.",
                    custom_error_code="WRONG_PAYLOAD_FORMAT",
                    status=422
                )
            try:
                payload_dict = json.loads(
                    request.data,
                    object_pairs_hook=OrderedDict,
                    encoding="utf8"
                )
            except ValueError as err:
                return flask_constructor_error(
                    message=err.message,    # pylint: disable=no-member
                    custom_error_code="WRONG_PAYLOAD",
                    status=422
                )

            if validation_schema:
                validator = Validator(validation_schema)
                # Check if the document is valid.
                if not validator.validate(payload_dict):
                    return flask_constructor_error(
                        message="Wrong args.",
                        custom_error_code="WRONG_ARGS",
                        status=422,
                        error_payload=validator.errors
                    )
            try:
                for field in upper_links:
                    kwargs[field] = payload_dict.pop(field)
            except KeyError:
                return flask_constructor_error(
                    message="Wrong args. Missing id: " + field,
                    custom_error_code="WRONG_ARGS",
                    status=422
                )
            if len(payload_dict) > 0:
                kwargs["payload"] = payload_dict
            return func(*args, **kwargs)

        return wrapper

    return decorated
