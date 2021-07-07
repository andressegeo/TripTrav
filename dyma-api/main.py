import os
import configparser

from flask.app import Flask
from utils.flask_utils import (
    flask_constructor_error,
    MongoJsonEncoder
)

from cities.cities_blueprint import cities_api_blueprint

config = configparser.ConfigParser()
config.read(os.path.abspath(os.path.join(".ini")))

app = Flask(__name__)
app.json_encoder = MongoJsonEncoder

app.register_blueprint(
    cities_api_blueprint,
    url_prefix="/dyma-api/cities"
)

if __name__ == "__main__":
    app.config['DEBUG'] = True
    app.config['DYMA_DB_URI'] = config['PROD']['DYMA_DB_URI']
    app.config['DYMA_DB_NAME'] = config['PROD']['DYMA_DB_NAME']
    app.config['SECRET_KEY'] = config['PROD']['SECRET_KEY']

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
    app.run(threaded=True, port=5000, debug=True)
