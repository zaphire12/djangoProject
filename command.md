celery -A project worker --loglevel=info -n django
celery -A project beat --loglevel=info
celery -A project flower --loglevel=info --basic-auth=dev:123
