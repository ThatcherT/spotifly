from django.db import models

class Listener(models.Model):
    name = models.CharField(max_length=100, unique=True)
    code = models.CharField(max_length=100, unique=True, blank=True, null=True)
    number = models.CharField(max_length=100, unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
        
    def __str__(self):
        return self.name

class Follower(models.Model):
    number = models.IntegerField(unique=True)
    following = models.CharField(max_length=100, unique=True)