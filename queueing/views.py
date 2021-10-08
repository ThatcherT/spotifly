from django.http import HttpResponse
from django.http.response import HttpResponseRedirect
from django.views.decorators.csrf import csrf_exempt
from queueing.models import Listener
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from twilio.twiml.messaging_response import MessagingResponse
import spotipy
from django.urls import reverse
from django.shortcuts import render
from twilio.rest import Client
from decouple import config
from rest_framework.decorators import api_view
from braces.views import CsrfExemptMixin
import os
from queueing.utils import (
    new_listener_email,
    register_message,
    follow_message,
    album_mix_message,
    shuffle_message,
    queue_message,
    idk_message,
)

# GLOBALS MUAHAHAHAH
sp_oauth = spotipy.oauth2.SpotifyOAuth(
    config("SPOTIPY_CLIENT_ID"),
    config("SPOTIPY_CLIENT_SECRET"),
    config("SPOTIPY_REDIRECT_URI"),
    scope=[
        "user-library-read",
        "user-read-playback-state",
        "user-modify-playback-state",
        "user-read-currently-playing",
        "user-read-recently-played",
    ],
)


def new_listener(request, lid):
    listener = Listener.objects.get(id=lid)
    if request.method == "POST":
        # update listener object
        listener.name = request.POST.get("name")
        listener.email = request.POST.get("email")
        listener.number = request.POST.get("number")
        listener.save()

        new_listener_email(listener.email)

        return render(request, "new_listener.html", {"success": True})
    if not listener.number:
        return render(request, "new_listener.html", {"listener": listener})
    else:
        return render(request, "new_listener.html", {"signedup": True})


def home(request):
    if request.method == "POST":  # if post, save email to db
        email = request.POST.get("email")
        name = email.split("@")[0]
        # save email to db
        listener, created = Listener.objects.get_or_create(email=email, name=name)
        if created:
            print("created")
            # maybe do something here to strengthen model?
        # return success
        return HttpResponseRedirect(reverse("new-listener", args=(listener.id,)))
    return render(request, "home.html")


def redirect(request):
    """
    Use the client authorization code flow to get a token to make requests on behalf of the user
    Store that token and associate it with the listener.
    """
    # get code from url
    url = request.build_absolute_uri()
    code = url.split("?code=")[1]
    return HttpResponseRedirect(reverse("register", args=[code]))


def register(request, code):
    """
    Use the client authorization code to get a token to make requests on behalf of the user
    """
    if request.POST:
        name = request.POST.get("name").lower()
        try:
            listener = Listener.objects.get(number=request.POST["number"])
        # if listener doesn't exist, render register page with message
        except Listener.DoesNotExist:
            return render(
                request,
                "register.html",
                {
                    "error": "We couldn't find your phone number. Please <a href=http://spotifly.thatcherthornberry.com>sign up</a>"
                },
            )
        if listener.name != name:
            listener.name = name
        token_info = sp_oauth.get_access_token(code)
        token = token_info["access_token"]
        listener.token = token
        listener.refresh_token = token_info["refresh_token"]
        listener.expires_at = token_info["expires_at"]
        os.remove(".cache")
        listener.save()
        lid = str(listener.id)
        return HttpResponseRedirect(reverse("success", args=(lid,)))
    return render(request, "register.html")


def success(request, lid):
    """
    Succesful registration page
    """
    listener = Listener.objects.get(id=lid)
    return render(request, "success.html", {"listener": listener})


@api_view(("POST",))
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
    Send a message to a certain number, this is a utility function
    """

    def post(self, request, format=None):
        """
        Send a message to a certain number
        """
        # get the number from the request
        number = request.data.get("number")
        # get the message from the request
        message = request.data.get("message")
        # get the twilio account info from the request
        ACCOUNT_SID = config("ACCOUNT_SID")
        AUTH_TOKEN = config("AUTH_TOKEN")
        # get the twilio client
        client = Client(ACCOUNT_SID, AUTH_TOKEN)
        # send the message
        client.messages.create(to=number, from_="+14243735305", body=message)
        return Response(status=status.HTTP_200_OK)


class SMS(CsrfExemptMixin, APIView):
    """
    All Texts are Routed Here. Then, we'll send messages to the other relevant api functions.

    We'll get the response from those functions.

    So, what can we do?

    1. If user registers -> create account, then reply with spotify auth url.
    2. If user follows someone -> create account if needed, associate account with listener, reply with message
    3. If user queues a song -> check if listener exists, if not, reply asking them to follow someone. If they exist, add song to queue for associated account.

    """

    authentication_classes = []

    def post(self, request, format=None):
        # Get the account_sid from the config file
        LOCAL = config("LOCAL", default=False)

        message_body = request.data.get("Body").lower()
        if message_body[-1] == " ":
            message_body = message_body[:-1]

        # Get the sender's phone number from the request
        from_number = str(request.data.get("From"))[2:]  # skip the +1

        # register flow
        if message_body.startswith("register"):
            return register_message()

        # follow flow
        elif message_body.startswith("follow"):
            return follow_message(message_body, from_number)

        # mix album
        elif message_body.startswith("mix"):
            return album_mix_message(message_body, from_number)

        # shuffle
        elif message_body.lower().startswith("shuffle"):
            return shuffle_message(from_number)

        # queue flow
        elif message_body.lower().startswith("queue"):
            return queue_message(message_body, from_number)

        else:
            return idk_message()
