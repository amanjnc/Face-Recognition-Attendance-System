import datetime
from app import db

class Image(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    class_id = db.Column(db.Integer, db.ForeignKey('Class.id'))
    file_name = db.Column(db.String(100))
    created_at = db.Column(db.DateTime, default=datetime.datetime.now(), server_default=db.func.now())
