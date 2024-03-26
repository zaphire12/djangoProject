import datetime

from app.models import MainDocumentData, DataTransfusionInfo
from api_v2.engine.oracle_db import OracleExecutor
from api_v2.jwt.utils import encode_jwt, decode_jwt
from api_v2.jwt.config import settings


class TokenGeneration:
    def __init__(self):
        self.jw_token = self._token_generation

    @property
    def _token_generation(self):
        payload = {
            'access': True,
        }
        return encode_jwt(payload)

    def _validate_jw_token(self):
        return decode_jwt(self.jw_token)


class DataTransfusion(TokenGeneration):

    def __init__(self):
        super().__init__()

    @staticmethod
    def clean_data(model):
        return model.objects.all().delete()

    @staticmethod
    def create_or_replace_info(date_begin, date_end, model_label):
        model_info = DataTransfusionInfo.objects.filter(table_name=model_label)
        update_time = datetime.datetime.now()
        if model_info:
            item = DataTransfusionInfo.objects.filter(table_name=model_label).first()
            item.date_begin = date_begin
            item.date_end = date_end
            item.update_date = update_time
            item.save(update_fields=['date_begin', 'date_end', 'update_date'])
        else:
            DataTransfusionInfo.objects.create(
                table_name=model_label,
                date_begin=date_begin,
                date_end=date_end,
                update_date=update_time
            ).save()

    def transfusion_into_mdd(self, date_begin, date_end):
        if self._validate_jw_token():
            df = OracleExecutor().get_month_report(date_begin, date_end)
            # self.create_or_replace_info(date_begin, date_end, MainDocumentData._meta.label)
            self.clean_data(MainDocumentData)
            df_records = df.to_dict('records')
            model_instances = [MainDocumentData(
                lpu_id=record['lpu'],
                lpu_dep=record['lpu_dep'],
                dep_oid=record['dep_oid'],
                doc_type=record['doc_type'],
                employer=record['employer'],
                position=record['position'],
                date_provide=record['date_dl'],
                services_success=record['services_success'],
                services_not_send=record['services_not_send'],
                services_error=record['services_error'],
                services_send=record['services_send'],
                semd_reg=record['semd_reg'],
                semd_formed=record['semd_formed'],
                semd_success_reg=record['semd_success_reg'],
                semd_success_summ=record['semd_success_summ'],
            ) for record in df_records]
            MainDocumentData.objects.bulk_create(model_instances)

    def transfusion_into_sr(self):
        if self._validate_jw_token():
            pass
