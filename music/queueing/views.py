from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.parsers import JSONParser
from queueing.models import Listener, Follower
from queueing.serializers import ListenerSerializer

from django.http import Http404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from twilio.twiml.messaging_response import MessagingResponse
import spotipy
from spotipy.oauth2 import SpotifyOAuth
from twilio.rest import Client
from decouple import config


class ListenerList(APIView):
    """
    List all listeners, or create a new listener.
    """
    def get(self, request, format=None):
        listeners = Listener.objects.all()
        serializer = ListenerSerializer(listeners, many=True)
        return Response(serializer.data)
    
    def post(self, request, format=None):
        serializer = ListenerSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ListenerDetail(APIView):
    """
    Retrieve, update or delete a code snippet.
    """
    def get_object(self, pk):
        try:
            return Listener.objects.get(pk=pk)
        except Listener.DoesNotExist:
            raise Http404
    
    def get(self, request, pk, format=None):
        listener = self.get_object(pk)
        serializer = ListenerSerializer(listener)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        listener = self.get_object(pk)
        serializer = ListenerSerializer(listener, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        listener = self.get_object(pk)
        listener.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

def sms_failed(request):
    """
    Send failure message if twilio webhook triggers it
    """
    resp = MessagingResponse()
    resp.message("We're sorry, something went wrong on our end.")
    return Response(resp)

class SMS(APIView):
    """
    All Texts are Routed Here. Then, we'll send a message to the other relevant api functions.

    We'll get the response from those functions.

    So, what can we do?

    1. If user registers -> create account, then reply with spotify auth url.
    2. If user follows someone -> create account if needed, associate account with listener, reply with message
    3. If user queues a song -> check if listener exists, if not, reply asking them to follow someone. If they exist, add song to queue for associated account.

    """
    
    
    def post(self, request, format=None):
        # Get the account_sid from the config file
        account_sid = config('ACCOUNT_SID')
        
        # Get the auth_token from the config file
        auth_token = config('AUTH_TOKEN')
        
        # Create a Twilio client to send text messages
        client = Client(account_sid, auth_token)
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
        # Get the text message from the request
        message_body = request.data.get('Body').lower()
        # Get the sender's phone number from the request
        from_number = request.data.get('From')
        
        if message_body.startswith('register'):
            # Send a text message to the user telling them to visit the link to use spotify oath
            message = client.messages.create(
                to=from_number,
                from_="14243735305",
                body="Please visit this link to authenticate: https://accounts.spotify.com/authorize?client_id=%s&response_type=code&redirect_uri=http://localhost:8888/callback" % CLIENT_ID
            )
            return Response(status=status.HTTP_200_OK)

        elif message_body.startswith('follow'):
            # Send a text message to the user telling them to follow someone
            # get user from database
            name = message_body.split(' ')[1]
            follower = Follower.objects.create(number=from_number, name=name)
            user = Listener.objects.get(name=name)

            message = client.messages.create(
                to=from_number,
                from_="14243735305",
                body=f"You are now following {user.name}. Add a track to their queue by texting 'queue (song title')"
            )
            return Response(status=status.HTTP_200_OK)

        elif message_body.startswith('queue'):
            # Get the song that the user has queued
            track_by_artist = message_body.partition(' ')[-1]
            if 'by' in track_by_artist:
                track_by_artist = track_by_artist.split(' by ')
                track = track_by_artist[0]
                artist = track_by_artist[1]
                q = 'artist:' + artist + ' track:' + track
            else:
                q = 'track:' + track_by_artist
            
            # find track and add to queue
            
            uri = sp.search(q=q, type='track', market='US')['tracks']['items'][0]['id']
            sp.add_to_queue(uri, device_id=None)

            # tell user their song is queued
            message = client.messages.create(
                    to=from_number,
                    from_="14243735305",
                    body=f"We queued {track}."
                )
            return Response(status=status.HTTP_200_OK)
        # elif message_body == 'Help':
        #     # get spotify 


