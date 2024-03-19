
# End Points
1. Create a class
This creates a new class, Just like before the teacher starts his class.

! the ip 127.0.0.1 here is going to be different later.

> url
```
POST | http://127.0.0.1:5000/class?title="Gaussian Lecture"
```

This would return you the class after created with all it's properties like id and do.

2. Get class details
> url
```
GET | http://127.0.0.1:5000/class/<class_id>
```

This would return json of the class details.

3. Get all classes
> url
```
GET | http://127.0.0.1:5000/class
```

This would retun the list of classes


4. Get images
You should provide the class id for this.
> url
```
GET | http://127.0.0.1:5000/images?class_id=0
```
> sample output
```
{"images":[{"created_at":"Sat, 03 Feb 2024 18:52:06 GMT","file_name":"test_image.jpg","id":1}]}
```

This would retun the list of images taken for that class.

5. Get image

! The great news about this is that we're using a file sharing directly from the directory so you can
even put this as a src in an html img and it works.
See the output using your browser.

> url
```
http://127.0.0.1:5000/image/<image_name>
```
> Use this to see
```
http://127.0.0.1:5000/image/test_image.jpg
```

^^^^^ This actually works, try it.

6. get atendees
Gives you a list of attendees, you should provide it with class_id as an argument
> url
```
http://127.0.0.1:5000/attendees?class_id=1
```
> sample Output
```
{"attendees":[{"class_id":0,"name":"Nathnael Dereje"}]}
```

>>> I am actually thinking of removing the class_id above because it's going to be the sam for all attendees. Plus it's meaning less because you actually provide the class_id to get the list of attendees.


7. Take Attendance
```
http://127.0.0.1:5000/take_attendance?class_id=0
```

> response
```
{
    "attendees": [
        {
            "class_id": 0,
            "name": "Nathnael Dereje"
        }
    ],
    "image": [
        {
            "created_at": "Sat, 03 Feb 2024 18:52:06 GMT",
            "file_name": "test_image.jpg",
            "id": 1
        }
    ]
}
```