"""Cities Blueprint Operations."""

import logging
from flask import Blueprint, request, jsonify

from bson import ObjectId

from google.cloud import storage

from utils.flask_utils import (
    flask_construct_response,
    flask_constructor_error,
    flask_check_and_inject_payload
)

from cities.cities_api import (
    get_cities,
    find_cities_by_id,
    update_activities_on_city_by_id,
    check_if_activity_already_exist
)
from utils.secret_manager_utils import SETTINGS


cities_messages = {
    "forbidden": "Access forbidden",
    "city_not_found": "City not found in mongodb"
}

cities_api_blueprint = Blueprint("cities_api_blueprint", __name__)


def _upload_media(bucket_folder, stream, filename, content_type):
    """
    Upload media from mobile in Storage
    """
    client_storage = storage.Client()
    bucket = client_storage.get_bucket(
        "{}.appspot.com".format(SETTINGS["project_id"])
    )
    blob = bucket.blob("{}/{}".format(bucket_folder, filename))
    blob.upload_from_file(stream, content_type=content_type)
    return "{}{}/{}/{}".format(SETTINGS["cloud_storage_url"], bucket.name, bucket_folder, filename)


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


@cities_api_blueprint.route("/activity/image", methods=["POST"])
def post_activity_image():
    """API POST activity-image

        Args:
            payload: request image data to post

        Returns:
            Flask Response

    """
    logging.info("[DEBUG ONLY] Operation to post new activity-image")
    # request.files => return => ImmutableMultiDict([('activity_image', <FileStorage: 'image_picker_B9016E36-E0F2-4ACB-9541-1A06DA7C8054-60977-00000C075827958C.jpg' ('multipart/form-data')>)])
    media = request.files.getlist('activity_image')
    stream = media[0].stream
    filename = media[0].filename
    content_type = media[0].content_type

    if not content_type.startswith(("image/", "video/", "multipart/")):
        logging.info("not allowed content type: %s", content_type)
        return flask_constructor_error(
            message="bad request",
            status=400
        )
    bucket_folder = "activity-form-images"
    url = _upload_media(bucket_folder, stream, filename, content_type)
    return flask_construct_response({"response": {"url": url}}, code=201)


@cities_api_blueprint.route("/<string:city_id>", methods=["PUT"])
@flask_check_and_inject_payload()
def api_update_activities_on_city(city_id, payload):
    """API PUT city

        Arguments:
            city_id(str): city to update through his id
            payload(orderedDict): request data to \
                update city from @flask_check_and_inject_payload_decorator
        Returns:
            Flask Response

    """
    payload["_id"] = ObjectId()
    logging.info(
        "[DEBUG ONLY] Operation to update activities on city: %s",
        payload.get("city_id")
    )

    try:
        result = update_activities_on_city_by_id(
            city_id,
            payload
        )
        if result.modified_count == 1:
            # http status code 204,
            # query successfully processed and no info to return
            resp = find_cities_by_id(
                city_id
            )
            return flask_construct_response(
                resp,
                code=200
            )
        return flask_constructor_error(
            message=cities_messages["city_not_found"],
            custom_error_code="WRONG_CITY_ID_GIVEN",
            status=404
        )

    except Exception as err:
        logging.error(
            "error while updating city resource: %s -> %s",
            err.__class__.__name__,
            str(err)
        )
        return flask_constructor_error(
            message="error while updating city resource"
        )


@cities_api_blueprint.route("/<string:city_id>/activities/verify/<string:activity_name>")
def verify_activity_is_unique(city_id, activity_name):
    try:
        result = check_if_activity_already_exist(city_id, activity_name)
        if result >= 1:
            return jsonify("l'activité existe deja")
        else:
            return jsonify("OK")
    except Exception as err:
        logging.error(
            "error while checking activity name: %s -> %s",
            err.__class__.__name__,
            str(err)
        )
        return flask_constructor_error(
            message="error while checking activity name"
        )
