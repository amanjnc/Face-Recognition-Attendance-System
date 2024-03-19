import datetime
from app import db

class Class(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    title = db.Column(db.String(50), primary_key = True)
    created_at = db.Column(db.DateTime, default=datetime.datetime.now(), server_default=db.func.now())