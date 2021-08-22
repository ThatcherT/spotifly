from django.http import HttpResponse, JsonResponse
from django.http.response import HttpResponseRedirect
from django.views.decorators.csrf import csrf_exempt
from rest_framework.parsers import JSONParser
from queueing.models import Listener, Follower
from queueing.serializers import ListenerSerializer
from django.utils.decorators import method_decorator
from django.http import Http404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from twilio.twiml.messaging_response import MessagingResponse
import spotipy
from django.urls import reverse
from django.shortcuts import render, redirect
from spotipy.oauth2 import SpotifyOAuth
from twilio.rest import Client
from decouple import config
from rest_framework.decorators import api_view
from braces.views import CsrfExemptMixin
import os
from django.core.mail import send_mail
from quoters import Quote

def new_listener(request, lid):
    listener = Listener.objects.get(id=lid)
    if request.method == 'POST':
        # update listener object
        listener.name = request.POST.get('name')
        listener.email = request.POST.get('email')
        listener.number = request.POST.get('number')
        listener.save()


        # send an email to thatcherthornberry saying someone signed up
        subject = 'New Listener'
        html_message = '<h1>Someone signed up!</h1>'
        html_message += '<p>Email: ' + listener.email + '</p>'
        from_email = config('EMAIL_FROM_USER')
        to_email = 'thatcherthornberry@gmail.com'
        send_mail(subject, html_message, from_email, [to_email], html_message=html_message)
        
        # send an email to person thanking them, giving them info
        subject2 = 'Thank you for signing up!'
        html_message2 = '<h1>Thank you for signing up!</h1>'
        html_message2 += '<p>I have to manually add you to a database to grant you access to my app. I will email you when you have access.</p>'
        html_message2 += '<p>After that, you will receive a text with more instructions.</p>'
        html_message2 += '<p>In the meantime, enjoy this quote:</p>'
        quote = Quote.print()
        html_message2 += f'<p>{quote}</p>'
        from_email2 = config('EMAIL_FROM_USER')
        to_email = listener.email
        send_mail(subject2, html_message2, from_email2, [to_email], html_message=html_message2)

        return render(request, 'new_listener.html', {'success': True})
    if not listener.number:
        return render(request, 'new_listener.html', {'listener': listener})
    else:
        return render(request, 'new_listener.html', {'signedup': True})
def home(request):
    # if post, save email to db
    if request.method == 'POST':
        print('yoasted')
        email = request.POST.get('email')
        name = email.split('@')[0]
        # save email to db
        listener, created = Listener.objects.get_or_create(email=email, name=name)
        if created:
            print('created')
            # maybe do something here to strengthen model?
        # return success
        return HttpResponseRedirect(reverse('new-listener', args=(listener.id,)))
    return render(request, 'home.html')

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


@csrf_exempt
def get_access_token(request):
    """
    Get access token for spotify
    """
    sp_oauth = spotipy.oauth2.SpotifyOAuth(
        config('SPOTIPY_CLIENT_ID'),
        config('SPOTIPY_CLIENT_SECRET'),
        config('SPOTIPY_REDIRECT_URI'),
        scope=['user-library-read', 'user-read-playback-state', 'user-modify-playback-state', 'user-read-currently-playing', 'user-read-recently-played'],
    )
    access_token = ""
    
    token_info = sp_oauth.get_cached_token()

    if token_info:
        print("found cached token!")
        access_token = token_info['access_token']
    else:
        url = request.build_absolute_uri()
        code = sp_oauth.parse_response_code(url)
        if code:
            print("found spotify auth code in request url! trying to get valid access token...")
            token_info = sp_oauth.get_access_token(code)
            access_token = token_info['access_token']
    
    if access_token:
        print("access token available... trying to get user info...")
        sp = spotipy.Spotify(access_token)
        user = sp.current_user()
        return user
    else:
        return None


@csrf_exempt
def get_sp_url(request):
    # cache = spotipy.cache_handler.DjangoSessionCacheHandler(request)
    sp_oauth = spotipy.oauth2.SpotifyOAuth(
        config('SPOTIPY_CLIENT_ID'),
        config('SPOTIPY_CLIENT_SECRET'),
        config('SPOTIPY_REDIRECT_URI'),
        scope=['user-library-read', 'user-read-playback-state', 'user-modify-playback-state', 'user-read-currently-playing', 'user-read-recently-played'],
        # cache_handler=cache
        )
    return JsonResponse(sp_oauth.get_authorize_url(), safe=False)

@csrf_exempt
def redirect(request):
    if request.method == 'POST':
        if request.POST.get('name'):
            token = request.POST['token']
            name = request.POST['name']
            listener, created = Listener.objects.get_or_create(name=name)
            listener.token = token
            listener.save()
            print('listener', name, 'has token', token)
            return render(request, 'success.html', {"name": name})
    # cache = spotipy.cache_handler.DjangoSessionCacheHandler(request)
    sp_oauth = spotipy.oauth2.SpotifyOAuth(
        config('SPOTIPY_CLIENT_ID'),
        config('SPOTIPY_CLIENT_SECRET'),
        config('SPOTIPY_REDIRECT_URI'),
        scope=['user-library-read', 'user-read-playback-state', 'user-modify-playback-state', 'user-read-currently-playing', 'user-read-recently-played'],
        # cache_path='./tokees/',
        # cache_handler=cache,
    )
    # get code from url
    url = request.build_absolute_uri()
    code = url.split('?code=')[1]
    token_info = sp_oauth.get_access_token(code)
    token = token_info['access_token']

    # load register page
    return render(request, 'register.html', {'token': token})

@csrf_exempt
def spotify_oauth(request, listener_id):
    """
    Get Access Token for Spotify user using spotipy.oauth2.SpotifyOAuth
    """
    # get listener
    listener = Listener.objects.get(pk=listener_id)
    # cache = spotipy.cache_handler.DjangoSessionCacheHandler(request)
    sp_oauth = spotipy.oauth2.SpotifyOAuth(
        config('SPOTIPY_CLIENT_ID'),
        config('SPOTIPY_CLIENT_SECRET'),
        config('SPOTIPY_REDIRECT_URI'),
        scope=['user-library-read', 'user-read-playback-state', 'user-modify-playback-state', 'user-read-currently-playing', 'user-read-recently-played'],
        # cache_path='./tokees/',
        # cache_handler=cache,
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

@api_view(('POST',))
@csrf_exempt
def sms_failed(request):
    """
    Send failure message if twilio webhook triggers it
    """
    resp = MessagingResponse()
    resp.message("We're sorry, something went wrong on our end.")
    return HttpResponse(str(resp))


class SMS(CsrfExemptMixin, APIView):
    """
    All Texts are Routed Here. Then, we'll send a message to the other relevant api functions.

    We'll get the response from those functions.

    So, what can we do?

    1. If user registers -> create account, then reply with spotify auth url.
    2. If user follows someone -> create account if needed, associate account with listener, reply with message
    3. If user queues a song -> check if listener exists, if not, reply asking them to follow someone. If they exist, add song to queue for associated account.

    """
    
    authentication_classes = []
    def post(self, request, format=None):
        # Get the account_sid from the config file
        LOCAL=config('LOCAL', default=False)

        ACCOUNT_SID = config('ACCOUNT_SID')
        AUTH_TOKEN  = config('AUTH_TOKEN')

        client = Client(ACCOUNT_SID, AUTH_TOKEN)

        
        # Get the text message from the request
        message_body = request.data.get('Body')
        # Get the sender's phone number from the request
        from_number = str(request.data.get('From'))[2:]
        print(message_body)
        print(from_number)
        if message_body.lower().startswith('register'):
            # cache = spotipy.cache_handler.DjangoSessionCacheHandler(request)
            sp_oauth = spotipy.oauth2.SpotifyOAuth(
                config('SPOTIPY_CLIENT_ID'),
                config('SPOTIPY_CLIENT_SECRET'),
                config('SPOTIPY_REDIRECT_URI'),
                scope=['user-library-read', 'user-read-playback-state', 'user-modify-playback-state', 'user-read-currently-playing', 'user-read-recently-played'],
                # cache_handler=cache
                )
            if not LOCAL:
                resp = MessagingResponse()
                resp.message(f"Please visit this link to authenticate: {sp_oauth.get_authorize_url()}")
                return HttpResponse(str(resp))
            return Response(f"Please visit this link to authenticate: {sp_oauth.get_authorize_url()}")

        elif message_body.lower().startswith('follow'):
            # get user from database
            following = message_body.partition(' ')[-1]
            # get user
            print(following)
            try:
                user = Listener.objects.get(name=following)
            except:
                # send message saying this user doesn't exist
                if not LOCAL:
                    resp = MessagingResponse()
                    resp.message("This user doesn't exist. They need to text this number 'register'.")
                    return HttpResponse(str(resp))
                return Response("This user doesn't exist. They need to text this number 'register'.")
            follower, created = Follower.objects.get_or_create(number=from_number)
            follower.following = following
            follower.save()
            

            if not LOCAL:
                resp = MessagingResponse()
                resp.message(f"You are now following {user.name}. Add a track to their queue by texting queue (song title)")
                return HttpResponse(str(resp))
            return Response(status=status.HTTP_200_OK)

        elif message_body.lower().startswith('queue'):
            # sp_oauth = spotipy.oauth2.SpotifyOAuth(
            #     config('SPOTIPY_CLIENT_ID'),
            #     config('SPOTIPY_CLIENT_SECRET'),
            #     config('SPOTIPY_REDIRECT_URI'),
            #     scope=['user-library-read', 'user-read-playback-state', 'user-modify-playback-state', 'user-read-currently-playing', 'user-read-recently-played'],
            #     # cache_handler=cache
            #     )
            SPOTIPY_CLIENT_SECRET=config('SPOTIPY_CLIENT_SECRET')
            SPOTIPY_CLIENT_ID=config('SPOTIPY_CLIENT_ID')
            # SPOTIPY_REDIRECT_URI='https://spotif-l-y.herokuapp.com/redirect'
            SPOTIPY_REDIRECT_URI=config('SPOTIPY_REDIRECT_URI')
            os.environ['SPOTIPY_CLIENT_ID'] = SPOTIPY_CLIENT_ID
            os.environ['SPOTIPY_CLIENT_SECRET'] = SPOTIPY_CLIENT_SECRET
            os.environ['SPOTIPY_REDIRECT_URI'] = SPOTIPY_REDIRECT_URI
            scope=['user-library-read', 'user-read-playback-state', 'user-modify-playback-state', 'user-read-currently-playing', 'user-read-recently-played']

            sp = spotipy.Spotify(auth_manager=SpotifyOAuth(scope=scope))
            # Get the song that the user has queued
            follower, created = Follower.objects.get_or_create(number=from_number)
            # if not follower.following:
            #     if not LOCAL:
            #         resp = MessagingResponse()
            #         resp.message(f"It appears you aren't following anybody... Try 'follow thatcher'")
            #         return HttpResponse(str(resp))
            #     return Response(status=status.HTTP_400_BAD_REQUEST)
            # else:
                # listener = Listener.objects.get(name=follower.following)
                # if not listener.token:
                #     if not LOCAL:
                #         resp = MessagingResponse()
                #         resp.message(f"It appears the person you're following hasn't authenticated their account yet. Tell them to 'register'")
                        # return HttpResponse(str(resp))
                # print(listener.token)
                # token_info = sp_oauth.get_cached_token()
                # access_token = token_info['access_token']
                # sp = spotipy.Spotify(access_token)
            track_by_artist = message_body.partition(' ')[-1]
            if 'by' in track_by_artist:
                track_by_artist = track_by_artist.split(' by ')
                track = track_by_artist[0]
                artist = track_by_artist[1]
                q = 'artist:' + artist + ' track:' + track
            else:
                track = track_by_artist
                q = 'track:' + track
            
            # find track and add to queue
            
            uri = sp.search(q=q, type='track', market='US')['tracks']['items'][0]['id']
            try:
                sp.add_to_queue(uri, device_id=None)
            except:
                if not LOCAL:
                    resp = MessagingResponse()
                    resp.message(f"It appears {follower.following} is not listening to music right now. Give them the AUX.")
                    return HttpResponse(str(resp))
            if not LOCAL:
                # tell user their song is queued
                resp = MessagingResponse()
                resp.message(f"We queued {track}.")
                return HttpResponse(str(resp))
            return Response(status=status.HTTP_200_OK)

        else:
            if not LOCAL:
                # tell user their song is queued
                resp = MessagingResponse()
                resp.message("Sorry. I didn't understand that. The commands are register, follow, and queue.")
                return HttpResponse(str(resp))
            return Response("Sorry. I didn't understand that. The commands are register, follow, and queue.")


