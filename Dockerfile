# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.9.16-alpine3.17
LABEL maintainer = "Whittington"

EXPOSE 8000

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
COPY ./requirements.txt /tmp/requirements.txt
RUN python -m pip install -r tmp/requirements.txt

WORKDIR /server
COPY ./server /server

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN python manage.py makemigrations && python manage.py migrate && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

USER django-user

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "server.wsgi:application"]
