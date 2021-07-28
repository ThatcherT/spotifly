from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns
from queueing import views

urlpatterns = [
    path('listeners/', views.ListenerList.as_view()),
    path('listeners/<int:pk>/', views.ListenerDetail.as_view()),
    path('sms/', views.SMS.as_view()),
    path('sms-failed/', views.sms_failed),
    path('spotify_oauth/<int:listener_id>/', views.spotify_oauth),
]

urlpatterns = format_suffix_patterns(urlpatterns)