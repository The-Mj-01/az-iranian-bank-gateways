from django.urls import path
from . import views

app_name = 'test_app'

urlpatterns = [
    path('', views.home_view, name='home'),
    path('payment/', views.go_to_gateway_view, name='go-to-payment'),
    path('callback/', views.callback_gateway_view, name='callback-gateway'),
]


