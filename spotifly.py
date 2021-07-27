from flask import Flask, request, jsonify
from twilio.twiml.messaging_response import MessagingResponse
import spotipy
from spotipy.oauth2 import SpotifyOAuth
from twilio.rest import Client
from decouple import config

ACCOUNT_SID = config('ACCOUNT_SID')
AUTH_TOKEN  = config('AUTH_TOKEN')

client = Client(ACCOUNT_SID, AUTH_TOKEN)


CLIENT_SECRET = config('CLIENT_SECRET')
CLIENT_ID = config('CLIENT_ID')

sp = spotipy.Spotify(auth_manager=SpotifyOAuth(
    client_id=CLIENT_ID,
    client_secret=CLIENT_SECRET,
    redirect_uri='http://localhost:8888/callback',
    scope=['user-library-read', 'user-read-playback-state', 'user-modify-playback-state', 'user-read-currently-playing', 'user-read-recently-played']))

app = Flask(__name__)

@app.route('/getmsg/', methods=['GET'])
def respond():
    # Retrieve the name from url parameter
    name = request.args.get("name", None)

    # For debugging
    print(f"got name {name}")

    response = {}

    # Check if user sent a name at all
    if not name:
        response["ERROR"] = "no name found, please send a name."
    # Check if the user entered a number not a name
    elif str(name).isdigit():
        response["ERROR"] = "name can't be numeric."
    # Now the user entered a valid name
    else:
        response["MESSAGE"] = f"Welcome {name} to our awesome platform!!"

    # Return the response in json format
    return jsonify(response)


@app.route("/sms-failed", methods=['GET', 'POST'])
def incoming_sms_failed():
    """
    Send failure message if twilio webhook triggers it
    """
    resp = MessagingResponse()

    resp.message("We're sorry, something went wrong on our end.")
    return str(resp)


@app.route("/sms", methods=['GET', 'POST'])
def incoming_sms():
    """Send a dynamic reply to an incoming text message"""
    # Get the message the user sent our Twilio number
    try:
        body = request.values.get('Body', None)
        from_who = request.values.get('From', None)

        # Start our TwiML response
        resp = MessagingResponse()

        # Determine the right reply for this message
        track_and_artist = body.split(' by ')
        track = track_and_artist[0]
        artist = track_and_artist[1]
        # print('track', track)
        # print('artist', artist)
        
        uri = sp.search(q='artist:' + artist + ' track:' + track, type='track', market='US')['tracks']['items'][0]['id']
        # print(uri)
        sp.add_to_queue(uri, device_id=None)

        message = client.messages.create(
            to="7372754382", 
            from_="14243735305",
            body='Okay, I added a song: {} by {}. Thanks {}'.format(track, artist, from_who))
    except:
        message = client.messages.create(
            to="7372754382", 
            from_="14243735305",
            body='Some error occured... from: {}'.format(from_who))
    
    return str(resp)

# @app.route('/queue-track/', methods=['POST'])
# def queue_track():
#     # Retrieve the track from url parameter
#     track = request.args.get("track", None)

#     # For debugging
#     print(f"got track {track}")

#     if track:
#         return jsonify({"status": "success", "message": "track queued"})
#     else:
#         return jsonify({"status": "failure", "message": "track not found"})


@app.route('/post/', methods=['POST'])
def post_something():
    name = request.form.get('name')
    print(name)
    # You can add the test cases you made in the previous function, but in our case here you are just testing the POST functionality
    if name:
        return jsonify({
            "Message": f"Welcome {name} to our awesome platform!!",
            # Add this option to distinct the POST request
            "METHOD" : "POST"
        })
    else:
        return jsonify({
            "ERROR": "no name found, please send a name."
        })

# A welcome message to test our server
@app.route('/')
def index():
    return "<h1>Welcome to Spotifly!!</h1>"

if __name__ == '__main__':
    # Threaded option to enable multiple instances for multiple user access support
    app.run(threaded=True, port=5000, debug=True)