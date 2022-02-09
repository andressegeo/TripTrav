import os
import configparser
import sys

from flask.app import Flask
from utils.flask_utils import (
    flask_constructor_error,
    MongoJsonEncoder
)

from cities.cities_blueprint import cities_api_blueprint
from trips.trips_blueprint import trips_api_blueprint

config = configparser.ConfigParser()
config.read(os.path.abspath(os.path.join(".ini")))

app = Flask(__name__)
app.json_encoder = MongoJsonEncoder

app.register_blueprint(
    cities_api_blueprint,
    url_prefix="/dyma-api/cities"
)

app.register_blueprint(
    trips_api_blueprint,
    url_prefix="/dyma-api/trips"
)

try:
    import googleclouddebugger
    googleclouddebugger.enable(
        breakpoint_enable_canary=True
    )
except:
    for e in sys.exc_info():
        print(e)

    @app.errorhandler(403)
    def user_forbidden(err):
        """View function that return an error handler(user forbidden).

            Returns:
                Flask Response

        """
        return flask_constructor_error("Access forbidden", 403, err.__class__.__name__)

    @app.errorhandler(404)
    def page_not_found(err):
        """View function that return an error handler(page not found).

            Returns:
                Flask Response
        """
        return flask_constructor_error("Url Not Found", 404, err.__class__.__name__)

    @app.errorhandler(405)
    def method_not_allowed(err):
        """View function that return an error handler(method not allowed).

            Returns:
                Flask Response
        """
        return flask_constructor_error("Method not allowed", 405, err.__class__.__name__)

if __name__ == "__main__":
    print("hello")
    app.config['DEBUG'] = True
    app.run(
        threaded=True,
        port=int(
            os.environ.get("PORT", 8080)
        ),
        debug=True,
        host="0.0.0.0"
    )
