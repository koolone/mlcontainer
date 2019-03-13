# This is the file that implements a flask server to do inferences. It's
# the file that you will modify to implement the scoring for your own
# algorithm.

from __future__ import print_function

import json
import os

import flask

prefix = '/opt/program/'

# A singleton for holding the model. This simply loads the model and holds
# it.
# It has a predict function that does a prediction based on the model and
# the input data.


class ScoringService(object):
    model = None

    @classmethod
    def get_model(cls):
        """Get the model object for this instance, loading it if it's not
        already loaded."""
        if cls.model is None:
            from fastText import load_model

            model_file_path = os.path.join(prefix, 'model.ftz')
            cls.model = load_model(model_file_path)
        return cls.model

    @classmethod
    def predict(cls, text, k=1):
        clf = cls.get_model()
        ret = {}
        labels, probs = cls.model.predict(text, k)
        for l, p in zip(labels, probs):
            ret[l] = p
        return ret


# The flask app for serving predictions
app = flask.Flask(__name__)


@app.route('/ping', methods=['GET'])
def ping():
    """Determine if the container is working and healthy. In this sample
    container, we declare it healthy if we can load the model
    successfully."""
    health = ScoringService.get_model() is not None

    status = 200 if health else 404
    return flask.Response(
        response='\n', status=status, mimetype='application/json'
    )


@app.route('/invocations', methods=['POST'])
def transformation():
    if flask.request.content_type == 'application/json':
        data = flask.request.get_json()
    else:
        return flask.Response(
            response='This predictor only supports JSON data',
            status=415,
            mimetype='application/json'
        )

    predictions = ScoringService.predict(
        text=data['text'],
        k=data['k']
    )

    resp_json = {
        'predictions': predictions
    }

    return flask.Response(
        response=json.dumps(resp_json),
        status=200,
        mimetype='application/json'
    )
