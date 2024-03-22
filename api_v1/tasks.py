import time

from celery import shared_task


@shared_task
def foo():
    time.sleep(50)
    return 'Hello'
