
# Python file for the backend
import datetime
import os
import random
import sys
import cv2
import numpy as np

from flask import Flask, jsonify, logging, request, send_from_directory
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS, cross_origin
from FisherFaceFinal.model import Model
from utils import colors
# from db.Models.Attendee import Attendee
# from db.Models.Image import Image
# from db.Models.Class import Class


# this is used for all SQLAlchemy commands
db = SQLAlchemy()


############################################## Models #############################

class Class(db.Model):
    id = db.Column(db.Integer, primary_key = True, autoincrement=True)
    title = db.Column(db.String(50))
    color = db.Column(db.String(10))
    created_at = db.Column(db.DateTime, default=datetime.datetime.now(), server_default=db.func.now())

class Image(db.Model):
    id = db.Column(db.Integer, primary_key = True, autoincrement=True)
    class_id = db.Column(db.Integer, db.ForeignKey('class.id'))
    file_name = db.Column(db.String(100))
    created_at = db.Column(db.DateTime, default=datetime.datetime.now(), server_default=db.func.now())

class Attendee(db.Model):
    class_id = db.Column(db.Integer, db.ForeignKey('class.id'), primary_key=True)
    name = db.Column(db.String(50), primary_key=True)
    created_at = db.Column(db.DateTime, default=datetime.datetime.now(), server_default=db.func.now())

####################################################################################


app = Flask(__name__)
db_name = "mydb.db"

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + db_name
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
db.init_app(app)

mymodel = Model()
mymodel.train()

CORS(app)


### This is just for testing purpost
@app.route("/hello", methods=["GET"])
@cross_origin()
def say_hello():
    return "<p>Hello world</p>", 200


@app.route("/takeAttendance", methods=["POST"])
@cross_origin()
def take_attandance():
    """ takes an image, and the class and takes attendance """
    image_file = request.files["image"]

    image_data = image_file.read()

    # Convert the byte array to a numpy array
    image_array = np.frombuffer(image_data, dtype=np.uint8)

    # Decode the numpy array to an OpenCV image
    cv_image = cv2.imdecode(image_array, cv2.IMREAD_COLOR)

    # For example, save the image locally
    timestamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    save_path = f'./images/{timestamp}.jpg'
    cv2.imwrite(save_path, cv_image)


    output_dir_path = './detected_images/' + timestamp
    mymodel.detect_and_save_faces(save_path, output_dir_path, 250)

    class_id = request.args.get('class_id')

    newImage = Image(
        class_id = class_id,
        file_name = f'{timestamp}.jpg'
    )

    db.session.add(newImage)
    db.session.commit()
    attendees = []

    for filename in os.listdir(output_dir_path):
        if filename.endswith(".jpg"):
            file_path = os.path.join(output_dir_path, filename)
            attendees.append(mymodel.find_diff(file_path, ""))

    return jsonify({'image': {'file_name': newImage.file_name, 'id': newImage.id}, 'attendees': attendees}), 200


@app.route("/class", methods=["POST"])
@cross_origin()
def create_class():
    """
    : returns the list of possible classes if not given the class id 
    else returns the detailed description of the class
    """
    class_title = request.args.get('title')
    new_class = Class(
        title=class_title or "No Title",
        color = random.choice(colors)
    )
    db.session.add(new_class)
    db.session.commit()
    return new_class, 200


@app.route("/class", methods=["GET"])
@cross_origin()
def get_classes():
    """
    : returns the list of possible classes if not given the class id 
    else returns the detailed description of the class
    """

    classes = Class.query.all()
    class_list = [{'id': cls.id, 'title': cls.title, 'created_at': cls.created_at, 'color': cls.color} for cls in classes]

    return jsonify({'classes': class_list}), 200


@app.route("/class/<class_id>", methods=["GET"])
@cross_origin()
def get_class_details(class_id):
    """
    : returns the detailed description of a specific class based on class_id.
    """
    cls = Class.query.get(class_id)


    if cls:
        class_detail = { 'id': cls.id, 'title': cls.title, 'created_at': cls.created_at, 'color': cls.color}
        return jsonify(class_detail), 200
    else:
        return jsonify({'error': 'Class not found'}), 404


@app.route("/images", methods=["GET"])
@cross_origin()
def get_images():
    """
    : returns a list of images taken in a class
    """
    class_id = request.args.get('class_id')
    if class_id is None:
        return jsonify({'error': 'Class ID is required'}), 400

    Images = Image.query.filter_by(class_id=class_id).all()

    image_list = [{'id': img.id, 'file_name': img.file_name, 'created_at': img.created_at} for img in Images]
    return jsonify({'images': []})


@app.route("/image/<filename>", methods=["GET"])
@cross_origin()
def get_image(filename):
    """ returns an image taken in a class """
    return send_from_directory("images", filename), 200


@app.route("/attendees", methods=["GET"])
@cross_origin()
def get_attendees():
    """ Should return the attendees by class """
    class_id = request.args.get('class_id')
    if class_id is None:
        return jsonify({'error': 'Class ID is required'}), 400

    attendees = Attendee.query.filter_by(class_id=class_id).all()

    attendees_list = [{'name': attendee.name, 'class_id': attendee.class_id} for attendee in attendees]
    return jsonify({'attendees': attendees_list}), 200

def add_class(title):
    new_class = Class(title= title)
    db.session.add(new_class)
    db.session.commit()

def add_attendee(class_id, name):
    new_attendee = Attendee( class_id = class_id, name = name)
    db.session.add(new_attendee)
    db.session.commit()


def add_image(class_id, file_name):
    new_image = Image(
        class_id = class_id,
        file_name = file_name
    )
    db.session.add(new_image)
    db.session.commit()


with app.app_context():
    db.create_all()
    # add_class("new class test")    
    # add_attendee(0, "Nathnael Dereje")
    # add_image(0, "test_image.jpg")
    db.session.commit()

if __name__ == "__main__":
    logging.getLogger('flask_cors').level = logging.DEBUG
    app.run(host='127.0.0.1',port=5001, debug=True)
