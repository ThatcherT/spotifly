# Generated by Django 3.2.5 on 2021-07-28 18:24

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('queueing', '0009_remove_listener_number'),
    ]

    operations = [
        migrations.AlterField(
            model_name='listener',
            name='token',
            field=models.TextField(blank=True, null=True, unique=True),
        ),
    ]
