from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns
from queueing import views

urlpatterns = [
    path("", views.home, name="home"),
    path("new-listener/<lid>/", views.new_listener, name="new-listener"),
    path("sms/", views.SMS.as_view()),
    path("sms-failed/", views.sms_failed),
    path("redirect/", views.redirect),
    path("register/<code>/", views.register, name="register"),
    path("success/<lid>/", views.success, name="success"),
    path("send/", views.send.as_view()),
]

urlpatterns = format_suffix_patterns(urlpatterns)
