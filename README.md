# Spotifly
Giving Spotify Wings.
## How it works
Users can text a certain phone number to create an account, follow their friends, and queue songs. By texting, their message is sent from the Twilio API to our Django API, then to the spotify API to do the actual queueing.
## Components
### Web Framework
Python Web Framework with Django
REST API with Django REST Framework
### Web Server
Gunicorn Web server running at https://spotif-l-y.herokuapp.com/
### Database
Postgresql Relational Database
### SMS
Twilio API
### Music/Queueing
Spotify API interfaced with helpful package: spotipy
