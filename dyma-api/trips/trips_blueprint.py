"""Trips Blueprint Operations."""

import logging
from flask import Blueprint
from bson import ObjectId
from utils.flask_utils import (
    flask_construct_response,
    flask_constructor_error,
    flask_check_and_inject_payload
)

from trips.trips_api import (
    create_trip,
    get_trips,
    find_trips_by_id,
    update_trip_by_id
)

trips_messages = {
    "forbidden": "Access forbidden",
    "trip_not_found": "Trip not found in mongodb"
}

trips_api_blueprint = Blueprint("trips_api_blueprint", __name__)


@trips_api_blueprint.route("/<string:trip_id>", methods=["GET"])
def api_get_trip(trip_id):
    """API GET trip by id

        Arguments:
            trip_id(str): trip's id to retrieve
        Returns:
            Flask Response

    """
    logging.info(
        "[DEBUG ONLY] operation to get trip by id: %s", trip_id
    )
    try:
        result = find_trips_by_id(
            trip_id
        )
        if not result:
            return flask_constructor_error(
                message=trips_messages["trip_not_found"],
                custom_error_code="WRONG_TRIP_ID_GIVEN",
                status=404
            )
        return flask_construct_response(result)

    except Exception as err:
        logging.error(
            "error while retrieving trip resource: %s -> %s",
            err.__class__.__name__,
            str(err)
        )
        return flask_constructor_error(
            message="error while retrieving trip"
        )


@trips_api_blueprint.route("/", methods=["GET"])
def api_get_all_trips():
    """API GET all trips
        Returns:
            Flask Response

    """
    logging.info(
        "[DEBUG ONLY] operation to retrieve all trips"
    )
    try:
        result = list(get_trips())
        if not result:
            return flask_constructor_error(
                message="not yet trip registered for the moment",
                status=204
            )
        return flask_construct_response(result)

    except Exception as err:
        logging.error(
            "error while retrieving trips ressources: %s -> %s",
            err.__class__.__name__,
            str(err)
        )
        return flask_constructor_error(
            message="error while retrieving trips ressources"
        )


@trips_api_blueprint.route("/", methods=["POST"])
@flask_check_and_inject_payload()
def api_create_trip(payload):
    """API POST trip

        Arguments:
            payload(orderedDict): request data to \
                create trip from @flask_check_and_inject_payload_decorator
        Returns:
            Flask Response

    """
    # from IPython import embed
    # embed()
    logging.info(
        "[DEBUG ONLY] Operation to create trip in city: %s",
        payload.get("city")
    )
    try:
        result = create_trip(
            payload
        )
        if result.inserted_id:
            return flask_construct_response(
                {
                    "_id": str(result.inserted_id),
                    "city": payload["city"],
                    "date": payload["date"],
                    "activities": payload["activities"]
                },
                code=201
            )

    except Exception as err:
        logging.error(
            "error while creating trip resource: %s -> %s",
            err.__class__.__name__,
            str(err)
        )
        return flask_constructor_error(
            message="error while creating trip resource"
        )


@trips_api_blueprint.route("/<string:trip_id>", methods=["PUT"])
@flask_check_and_inject_payload()
def api_update_trip(trip_id, payload):
    """API PUT trip

        Arguments:
            trip_id(str): trip to update through his id
            payload(orderedDict): request data to \
                update trip from @flask_check_and_inject_payload_decorator
        Returns:
            Flask Response

    """
    logging.info(
        "[DEBUG ONLY] Operation to update trip in city: %s",
        payload.get("city")
    )
    try:
        result = update_trip_by_id(
            trip_id,
            payload
        )
        if result.modified_count == 1:
            # http status code 204,
            # query successfully processed and no info to return
            # from IPython import embed
            # embed()
            return flask_construct_response(
                {
                    "_id": trip_id,
                    "city": payload["city"],
                    "date": payload["date"],
                    "activities": payload["activities"]
                },
                code=200
            )
        return flask_constructor_error(
            message=trips_messages["trip_not_found"],
            custom_error_code="WRONG_TRIP_ID_GIVEN",
            status=404
        )

    except Exception as err:
        logging.error(
            "error while updating trip resource: %s -> %s",
            err.__class__.__name__,
            str(err)
        )
        return flask_constructor_error(
            message="error while updating trip resource"
        )
