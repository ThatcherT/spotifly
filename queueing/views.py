from django.http import HttpResponse, JsonResponse
from django.http.response import HttpResponseRedirect
from django.views.decorators.csrf import csrf_exempt
from rest_framework.parsers import JSONParser
from spotipy.exceptions import SpotifyException
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
from music.settings import BASE_DIR

#GLOBALS MUAHAHAHAH
sp_oauth = spotipy.oauth2.SpotifyOAuth(
        config('SPOTIPY_CLIENT_ID'),
        config('SPOTIPY_CLIENT_SECRET'),
        config('SPOTIPY_REDIRECT_URI'),
        scope=['user-library-read', 'user-read-playback-state', 'user-modify-playback-state', 'user-read-currently-playing', 'user-read-recently-played'],
        )

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


def redirect(request):
    """
    Use the client authorization code flow to get a token to make requests on behalf of the user
    Store that token and associate it with the listener.
    """
    # get code from url
    url = request.build_absolute_uri()
    code = url.split('?code=')[1]
    return HttpResponseRedirect(reverse('register', args=[code]))


def register(request, code):
    """
    Use the client authorization code to get a token to make requests on behalf of the user
    """
    if request.POST:
        print(request.POST)
        name = request.POST.get('name').lower()
        try:
            listener = Listener.objects.get(number=request.POST['number'])
        # if listener doesn't exist, render register page with message
        except Listener.DoesNotExist:
            return render(request, 'register.html', {'error': "We couldn't find your phone number. Please <a href=http://spotifly.thatcherthornberry.com>sign up</a>"})
        if listener.name != name:
            listener.name = name
        token_info = sp_oauth.get_access_token(code)
        token = token_info['access_token']
        listener.token = token
        listener.refresh_token = token_info['refresh_token']
        listener.expires_at= token_info['expires_at']
        os.remove(".cache")
        listener.save()
        lid = str(listener.id)
        return HttpResponseRedirect(reverse('success', args=(lid,)))
    return render(request, 'register.html')


def success(request, lid):
    listener = Listener.objects.get(id=lid)
    return render(request, 'success.html', {'listener': listener})


def get_song(request, lid):
    listener = Listener.objects.get(id=lid)
    if listener.token:
        sp = spotipy.Spotify(auth=listener.token)
        try:
            results = sp.current_user_playing_track()
        except SpotifyException as e:
            if 'The access token expired' in e.msg:
                print('token exp')
                # get new token from refresh token
                token_info = sp_oauth.refresh_access_token(listener.refresh_token)
                # update listener with new token info
                listener.token = token_info['access_token']
                listener.refresh_token = token_info['refresh_token']
                listener.expires_at= token_info['expires_at']
                listener.save()

                # update sp with new token
                sp = spotipy.Spotify(auth=listener.token)
                results = sp.current_user_playing_track()

        if results:
            track = results['item']
            return render(request, 'song.html', {'track': track})
        else:
            return render(request, 'song.html', {'track': None})
    else:
        return render(request, 'song.html', {'track': None})


def auth(request):
    url = sp_oauth.get_authorize_url()
    return HttpResponse(url)


@csrf_exempt
def get_sp_url():
    return sp_oauth.get_authorize_url()


@api_view(('POST',))
@csrf_exempt
def sms_failed(request):
    """
    Send failure message if twilio webhook triggers it
    """
    resp = MessagingResponse()
    resp.message("We're sorry, something went wrong on our end.")
    return HttpResponse(str(resp))

class send(APIView):
    """
    Send a message to a certain number
    """

    def post(self, request, format=None):
        """
        Send a message to a certain number
        """
        # get the number from the request
        number = request.data.get('number')
        # get the message from the request
        message = request.data.get('message')
        # get the twilio account info from the request
        ACCOUNT_SID = config('ACCOUNT_SID')
        AUTH_TOKEN  = config('AUTH_TOKEN')
        # get the twilio client
        client = Client(ACCOUNT_SID, AUTH_TOKEN)
        # send the message
        client.messages.create(
            to=number,
            from_="+14243735305",
            body=message
        )
        return Response(status=status.HTTP_200_OK)


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
        # remove space from end of message

        if message_body[-1] == ' ':
            message_body = message_body[:-1]

        # Get the sender's phone number from the request
        from_number = str(request.data.get('From'))[2:]

        print("MESSAGE: ", message_body)
        print("FROM: ", from_number)

        # register flow
        if message_body.lower().startswith('register'):
            register_msg = f"Please visit this link to authenticate: {sp_oauth.get_authorize_url()}"
            print('Sending message: ', register_msg)
            if not LOCAL:
                resp = MessagingResponse()
                resp.message(register_msg)
                return HttpResponse(str(resp))
            return Response(register_msg)

        # follow flow
        elif message_body.lower().startswith('follow'):
            # get user from database
            following = message_body.partition(' ')[-1]
            # get user
            print("Trying to follow: ", following)
            try:
                user = Listener.objects.get(name=following)
                print('Found user: ', user.name)
            except:
                err_msg = f"`{following}` doesn't exist. They need to visit http://spotifly.thatcherthornberry.com"
                print("Error: ", err_msg)

                # send message saying this user doesn't exist
                if not LOCAL:
                    resp = MessagingResponse()
                    resp.message(err_msg)
                    return HttpResponse(str(resp))
                return Response(err_msg)
            # found user, creating/getting follower object
            
            follower, created = Follower.objects.get_or_create(number=from_number)
            if created:
                print("Created follower: ", follower.number)
            else:
                print("Found follower: ", follower.number)
            follower.following = following
            follower.save()
            
            follower_msg = f"You are now following {follower.following}. Add a track to their queue by texting 'queue let it happen by tame impala' or 'queue lose yourself to dance'. You get the idea."
            print("Sending reply: ", follower_msg)
            if not LOCAL:              
                resp = MessagingResponse()
                resp.message(follower_msg)
                return HttpResponse(str(resp))
            return Response(status=status.HTTP_200_OK)

        # queue flow
        elif message_body.lower().startswith('queue'):            
            # get follower object from phone nummber
            follower, created = Follower.objects.get_or_create(number=from_number)
            if not follower.following:
                not_following_msg = f"It appears you aren't following anybody... Try 'follow thatcher'. Or, ask the person what their username is."
                print("Sending reply: ", not_following_msg)
                if not LOCAL:
                    resp = MessagingResponse()
                    resp.message(not_following_msg)
                    return HttpResponse(str(resp))
                return Response(status=status.HTTP_400_BAD_REQUEST)
            else:
                print("Found follower: ", follower.number)
                print("Looking for listener...")
                listener = Listener.objects.get(name=follower.following)
                print("Found listener: ", listener.name)
                
                if not listener.token:
                    missing_token_msg = f"It appears the person you're following hasn't authenticated their account yet. Tell them to visit http://spotifly.thatcherthornberry.com or, if they've done that, tell them to text register to 424-373-5305."
                    print("Sending reply: ", missing_token_msg)
                    if not LOCAL:
                        resp = MessagingResponse()
                        resp.message(missing_token_msg)
                        return HttpResponse(str(resp))
                    return Response(status=status.HTTP_400_BAD_REQUEST)
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
            sp = spotipy.Spotify(auth=listener.token)
            try:
                uri_lst = sp.search(q=q, type='track', market='US')['tracks']['items']
                if len(uri_lst) == 0:
                    print("No results found for: ", q)
                    uri_lst = sp.search(q=track_by_artist, type='track', market='US')['tracks']['items']
                    if len(uri_lst) == 0:
                        print("No results found for: ", track_by_artist)
                        uri_lst = sp.search(q=track, type='track', market='US')['tracks']['items']
                        if len(uri_lst) == 0:
                            no_results_msg = f"No results found for `{track_by_artist}`. Try again."
                            print("Sending reply: ", no_results_msg)
                            if not LOCAL:
                                resp = MessagingResponse()
                                resp.message(no_results_msg)
                                return HttpResponse(str(resp))
                            return Response(status=status.HTTP_400_BAD_REQUEST)
                uri = uri_lst[0]['id']
                
                # add to queue
                sp.add_to_queue(uri, device_id=None)
            except SpotifyException as e:
                if 'The access token expired' in e.msg:
                    print(e.msg)

                    # get new token from refresh token
                    token_info = sp_oauth.refresh_access_token(listener.refresh_token)

                    # update listener with new token info
                    listener.token = token_info['access_token']
                    listener.refresh_token = token_info['refresh_token']
                    listener.expires_at= token_info['expires_at']
                    listener.save()

                    # update sp with new token
                    sp = spotipy.Spotify(auth=listener.token)
                    
                    # try again
                    try:
                        uri_lst = sp.search(q=q, type='track', market='US')['tracks']['items']
                        if len(uri_lst) == 0:
                            print("No results found for: ", q)
                            uri_lst = sp.search(q=track_by_artist, type='track', market='US')['tracks']['items']
                            if len(uri_lst) == 0:
                                print("No results found for: ", track_by_artist)
                                uri_lst = sp.search(q=track, type='track', market='US')['tracks']['items']
                                if len(uri_lst) == 0:
                                    no_results_msg = f"No results found for `{track_by_artist}`. Try again."
                                    print("Sending reply: ", no_results_msg)
                                    if not LOCAL:
                                        resp = MessagingResponse()
                                        resp.message(no_results_msg)
                                        return HttpResponse(str(resp))
                                    return Response(status=status.HTTP_400_BAD_REQUEST)
                        uri = uri_lst[0]['id']
                        
                        # add to queue
                        sp.add_to_queue(uri, device_id=None)
                    except:
                        # some other error must of occured
                        unknown_error_msg = f"An unknown error occured. Please try again."
                        print("Sending reply: ", unknown_error_msg)
                        if not LOCAL:
                            resp = MessagingResponse()
                            resp.message(unknown_error_msg)
                            return HttpResponse(str(resp))
                        return Response(status=status.HTTP_400_BAD_REQUEST)
                
                elif 'No active device' in e.msg:
                    if not LOCAL:
                        resp = MessagingResponse()
                        resp.message(f"It appears {follower.following} is not listening to music right now. Give them the AUX.")
                        return HttpResponse(str(resp))
                else:
                    # some other error must of occured
                    unknown_error_msg = f"An unknown error occured! Please try again."
                    print("Sending reply: ", unknown_error_msg)
                    if not LOCAL:
                        resp = MessagingResponse()
                        resp.message(unknown_error_msg)
                        return HttpResponse(str(resp))
                    return Response(status=status.HTTP_400_BAD_REQUEST)
            
            # check if var is a list
            if isinstance(track_by_artist, list):
                queue_msg = f"Added `{track_by_artist[0]}` by `{track_by_artist[1]}` to the queue."
            else:
                queue_msg = f"Added `{track_by_artist}` to {follower.following}'s queue."
            print("Sending reply: ", queue_msg)
            if not LOCAL:
                # tell user their song is queued
                resp = MessagingResponse()
                resp.message(queue_msg)
                return HttpResponse(str(resp))
            return Response(status=status.HTTP_200_OK)

        else:
            if not LOCAL:
                # tell user their song is queued
                resp = MessagingResponse()
                resp.message("Sorry. I didn't understand that. The commands are register, follow, and queue.")
                return HttpResponse(str(resp))
            return Response("Sorry. I didn't understand that. The commands are register, follow, and queue.")


