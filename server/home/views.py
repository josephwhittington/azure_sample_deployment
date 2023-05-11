from django.http import HttpResponse


def index(request):
    return HttpResponse("<h1>Home Page or whatever</h1>")
