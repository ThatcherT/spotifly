# Generated by Django 3.2.5 on 2021-08-22 21:17

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('queueing', '0012_auto_20210822_1953'),
    ]

    operations = [
        migrations.AddField(
            model_name='listener',
            name='number',
            field=models.CharField(blank=True, max_length=10, null=True, unique=True),
        ),
    ]
