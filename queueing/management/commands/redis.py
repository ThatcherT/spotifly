from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
import django_redis
import json
import spotipy
from queueing.models import Listener


class Command(BaseCommand):
    help = "Test Redis"

    def handle(self, *args, **options):
        cache = django_redis.get_redis_connection("default")
        obj = {
            "name": "Thatcher Thornberry",
            "age": 21,
            "song_uris": ["spotify:track:1", "spotify:track:2"],
        }
        obj_str = json.dumps(obj)
        cache.set("Thatcher.Thornberry", obj_str)
        print(cache.get("Thatcher.Thornberry"))

        # convert str to dict
        obj2 = json.loads(cache.get("Thatcher.Thornberry"))
        print(obj2["song_uris"])
        # listener = Listener.objects.get(name="thatcher.thornberry")
        # sp = sp = listener.sp_client.sp()
        # playback = sp.current_playback()

        # uri = playback["item"]["uri"]
        # print(uri)
