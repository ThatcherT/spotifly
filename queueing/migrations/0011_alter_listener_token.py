# Generated by Django 3.2.5 on 2021-07-29 03:09

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('queueing', '0010_alter_listener_token'),
    ]

    operations = [
        migrations.AlterField(
            model_name='listener',
            name='token',
            field=models.TextField(blank=True, null=True),
        ),
    ]
