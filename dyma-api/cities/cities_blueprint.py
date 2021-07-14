"""Cities Blueprint Operations."""

import logging
from flask import Blueprint
from bson import ObjectId
from utils.flask_utils import (
    flask_construct_response,
    flask_constructor_error
)

from cities.cities_api import (
    get_cities,
    find_cities_by_id
)

cities_messages = {
    "forbidden": "Access forbidden",
    "city_not_found": "City not found in mongodb"
}

cities_api_blueprint = Blueprint("cities_api_blueprint", __name__)


@cities_api_blueprint.route("/<string:city_id>", methods=["GET"])
def api_get_city(city_id):
    """API GET city by id

        Arguments:
            city_id(str): city's id to retrieve
        Returns:
            Flask Response

    """
    logging.info(
        "[DEBUG ONLY] operation to get city by id: %s", city_id
    )
    try:
        result = find_cities_by_id(
            city_id
        )
        if not result:
            return flask_constructor_error(
                message=cities_messages["city_not_found"],
                custom_error_code="WRONG_CITY_ID_GIVEN",
                status=404
            )
        return flask_construct_response(result)

    except Exception as err:
        logging.error(
            "error while retrieving city resource: %s -> %s",
            err.__class__.__name__,
            str(err)
        )
        return flask_constructor_error(
            message="error while retrieving city"
        )


@cities_api_blueprint.route("/", methods=["GET"])
def api_get_all_cities():
    """API GET all cities
        Returns:
            Flask Response

    """
    logging.info(
        "[DEBUG ONLY] operation to retrieve all cities"
    )
    try:
        result = list(get_cities())
        if not result:
            return flask_constructor_error(
                message="not yet city registered for the moment",
                status=204
            )
        return flask_construct_response(result)

    except Exception as err:
        logging.error(
            "error while retrieving cities ressources: %s -> %s",
            err.__class__.__name__,
            str(err)
        )
        return flask_constructor_error(
            message="error while retrieving cities ressources"
        )
