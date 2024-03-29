import datetime

from app.models import MainDocumentData, DataTransfusionInfo, MainDocumentDataMonth, SlotReport
from api_v2.engine.oracle_db import OracleExecutor
from api_v2.jwt.utils import encode_jwt, decode_jwt
from api_v2.engine.utils.utils import settings


class TokenGeneration:
    def __init__(self):
        self.jw_token = self._token_generation
        self.oracle_db = OracleExecutor()

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

    def _main_document_transfusion(self, date_begin, date_end, model, df_records):
        pass

    def transfusion_into_mdd(self, date_begin, date_end):
        date_begin = datetime.datetime.strptime(date_begin, "%Y-%m-%d")
        date_end = datetime.datetime.strptime(date_end, "%Y-%m-%d")
        if self._validate_jw_token():
            df = self.oracle_db.get_main_report(date_begin, date_end)
            self.create_or_replace_info(date_begin, date_end, MainDocumentData._meta.label)
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

    def transfusion_into_slot(self):
        if self._validate_jw_token():
            df = self.oracle_db.get_slot_report()
            date_params = settings.date_sql.get_slot_date()
            self.create_or_replace_info(date_params.get('first_day'), date_params.get('last_day'), SlotReport._meta.label)
            self.clean_data(SlotReport)
            df_records = df.to_dict('records')
            model_instances = [
                SlotReport(
                    **record
                ) for record in df_records
            ]
            SlotReport.objects.bulk_create(model_instances)

    def transfusion_into_mrd(self):
        if self._validate_jw_token():
            date_begin = settings.date_sql.get_first_and_last_day_of_month().get("first_day")
            date_end = settings.date_sql.get_first_and_last_day_of_month().get("last_day")
            df = self.oracle_db.get_main_report(date_begin, date_end)
            self.create_or_replace_info(date_begin, date_end, MainDocumentDataMonth._meta.label)
            self.clean_data(MainDocumentDataMonth)
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
            MainDocumentDataMonth.objects.bulk_create(model_instances)
