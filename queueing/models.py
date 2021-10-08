from django.db import models


class Listener(models.Model):
    name = models.CharField(max_length=50, unique=True)
    spotify_id = models.CharField(max_length=100, unique=True, blank=True, null=True)
    token = models.TextField(blank=True, null=True)
    refresh_token = models.TextField(blank=True, null=True)
    expires_at = models.TextField(blank=True, null=True)
    number = models.CharField(max_length=10, unique=True, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    email = models.EmailField(blank=True, null=True)
    max_offset = models.IntegerField(default=5000)

    def __str__(self):
        return self.name


class Follower(models.Model):
    number = models.CharField(max_length=10, unique=True)
    following = models.CharField(
        max_length=50, default="thatcher"
    )  # corresponds to name
    following_spotify_id = models.CharField(max_length=100, null=True, blank=True)
    promo = models.BooleanField(default=False)

    def __str__(self):
        return self.number + " following " + self.following
