from django.core.management.base import BaseCommand
from django.contrib.auth.models import User

class Command(BaseCommand):
    help = 'Create su'

    def handle(self, *args, **options):
        if not User.objects.filter(is_superuser=True).first():
            print('creating user object')
            
            user = User.objects.create(
                username = 'admin',
                email = 'admin@spotifly.com',
                is_superuser = True,
            )
            user.set_password('pass')
            print(user.username, user.email, 'pass')
            user.save()
        else:
            print('user already exists')