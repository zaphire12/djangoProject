from api_v2.engine.data_transfusion import DataTransfusion

from celery import shared_task


@shared_task
def foo():
    return 'Hello'
