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


def spotify_oauth(request, listener_id):
    """
    Get Access Token for Spotify user using spotipy.oauth2.SpotifyOAuth
    """
    # get listener
    listener = Listener.objects.get(pk=listener_id)
    cache = spotipy.cache_handler.DjangoSessionCacheHandler(request)
    sp_oauth = spotipy.oauth2.SpotifyOAuth(
        config('SPOTIPY_CLIENT_ID'),
        config('SPOTIPY_CLIENT_SECRET'),
        config('SPOTIPY_REDIRECT_URI'),
        scope=['user-library-read', 'user-read-playback-state', 'user-modify-playback-state', 'user-read-currently-playing', 'user-read-recently-played'],
        cache_handler=cache
    )
    access_token = ""
    token_info = sp_oauth.get_cached_token()
    if token_info:
        # we found access token in the cache
        print('found token')
        access_token = token_info['access_token']
    else:
        # get request url
        sp = spotipy.Spotify(auth_manager=sp_oauth)
        results = sp.current_user_saved_tracks()

        # get access token and cache it
        token_info = sp_oauth.get_cached_token()
        access_token = token_info['access_token']
    if access_token:
        # we have the access token, trying to get user info
        print('getting user info')
        sp = spotipy.Spotify(access_token)
        results = sp.current_user()
        listener.token = access_token
        listener.spotify_id = results['display_name']
        listener.save()
        return JsonResponse(results, safe=False)
    else:
        return "<a href='" + sp_oauth.get_authorize_url() + "'>Login to Spotify</a>"


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
        LOCAL=config('LOCAL', default=False)
        account_sid = config('ACCOUNT_SID')
        
        # Get the auth_token from the config file
        auth_token = config('AUTH_TOKEN')
        
        # Create a Twilio client to send text messages
        client = Client(account_sid, auth_token)
        ACCOUNT_SID = config('ACCOUNT_SID')
        AUTH_TOKEN  = config('AUTH_TOKEN')

        client = Client(ACCOUNT_SID, AUTH_TOKEN)


        SPOTIPY_CLIENT_SECRET = config('SPOTIPY_CLIENT_SECRET')
        SPOTIPY_CLIENT_ID = config('SPOTIPY_CLIENT_ID')

        
        # Get the text message from the request
        message_body = request.data.get('Body').lower()
        # Get the sender's phone number from the request
        from_number = str(request.data.get('From'))
        
        if message_body.startswith('register'):
            # Send a text message to the user telling them to visit the link to use spotify oath
            # create listener
            name = message_body.partition(' ')[-1]
            listener, created = Listener.objects.get_or_create(name=name, number=from_number)

            if not LOCAL:
                resp = MessagingResponse()
                resp.message("Please visit this link to authenticate: https://spotif-l-y.herokuapp.com/spotify_oauth/{}".format(listener.id))
                return Response(resp)
            return Response("Please visit this link to authenticate: http://127.0.0.1:8000/spotify_oauth/{}".format(listener.id))

        elif message_body.startswith('follow'):
            # get user from database
            following = message_body.partition(' ')[-1]
            # get user
            print(following)
            user = Listener.objects.get(name=following)
            follower, created = Follower.objects.get_or_create(number=from_number, following=following)
            

            if not LOCAL:
                message = client.messages.create(
                    to=from_number,
                    from_="14243735305",
                    body=f"You are now following {user.name}. Add a track to their queue by texting 'queue (song title')"
                )
            return Response(status=status.HTTP_200_OK)

        elif message_body.startswith('queue'):
            
            # Get the song that the user has queued
            follower, created = Follower.objects.get_or_create(number=from_number)
            if not follower.following:
                if not LOCAL:
                    resp = MessagingResponse()
                    resp.message(f"It appears you aren't following anybody... Try 'follow thatcher thornberry'")
                    return Response(resp)
                return Response(status=status.HTTP_400_BAD_REQUEST)
            else:
                listener = Listener.objects.get(name=follower.following)
                if not listener.token:
                    if not LOCAL:
                        resp = MessagingResponse()
                        resp.message(f"It appears the person you're following hasn't authenticated their account yet. Tell them to 'register'")
                sp = spotipy.Spotify(listener.token)
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
            try:
                sp.add_to_queue(uri, device_id=None)
            except:
                if not LOCAL:
                    message = client.messages.create(
                            to=from_number,
                            from_="14243735305",
                            body=f"It appears {follower.name} is not listening to music right now. Give them the AUX."
                        )

            # tell user their song is queued
            if not LOCAL:
                message = client.messages.create(
                        to=from_number,
                        from_="14243735305",
                        body=f"We queued {track}."
                    )
            return Response(status=status.HTTP_200_OK)

        else:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        # elif message_body == 'Help':
        #     # get spotify 

