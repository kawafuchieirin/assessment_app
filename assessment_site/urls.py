from django.contrib import admin
from django.urls import path, include
from django.shortcuts import redirect
from estimator.views import estimate_view

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', lambda request: redirect('estimate/')),  # ← 追加：トップを /estimate に飛ばす
    path('estimate/', estimate_view, name='estimate'),
]
