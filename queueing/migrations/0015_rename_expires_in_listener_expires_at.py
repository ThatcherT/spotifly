# Generated by Django 3.2.5 on 2021-08-25 19:27

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('queueing', '0014_auto_20210825_1921'),
    ]

    operations = [
        migrations.RenameField(
            model_name='listener',
            old_name='expires_in',
            new_name='expires_at',
        ),
    ]
