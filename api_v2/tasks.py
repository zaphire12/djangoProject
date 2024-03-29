import time

from api_v2.engine.data_transfusion import DataTransfusion

from celery import shared_task


@shared_task
def transfusion_into_mdd():
    DataTransfusion().transfusion_into_mdd('2024-01-01', '2024-03-28')
    return 'Hello'


@shared_task()
def foo():
    time.sleep(20)
    return 'Hello world'
