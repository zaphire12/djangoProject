from sqlalchemy import text
from typing import List, Dict
import calendar
from datetime import datetime, timedelta
from sqlalchemy.sql.elements import TextClause
from typing import ClassVar
import os


class ReaderSQL:
    def __init__(self):
        self.mount_report = os.path.join(os.path.dirname(__file__), 'month_report.sql')
        # self.main_report = 'main_report.sql'
        self.slot_report = os.path.join(os.path.dirname(__file__), 'slot_report.sql')

    @property
    def read_month_report_sql(self):
        with open(self.mount_report, 'r') as sql_file:
            return text(sql_file.read())

    @property
    def read_slot_report_sql(self):
        with open(self.slot_report, 'r') as sql_file:
            return text(sql_file.read())


class DateSQL:
    @staticmethod
    def get_formatted_datetime():
        current_datetime = datetime.now()
        formatted_datetime = current_datetime.strftime('%d.%m.%Y %H:%M')
        return formatted_datetime

    @staticmethod
    def get_today():
        current_datetime = datetime.now()
        formatted_datetime = current_datetime.strftime('%d.%m.%Y')
        return formatted_datetime

    @staticmethod
    def get_first_and_last_day_of_month():
        today = datetime.now()
        today = today.replace(day=1) - timedelta(days=1)
        first_day = today.replace(day=1)
        _, last_day_in_month = calendar.monthrange(today.year, today.month)
        last_day = today.replace(day=last_day_in_month)
        result_dict = {
            "first_day": first_day.strftime("%d.%m.%Y"),
            "last_day": last_day.strftime("%d.%m.%Y")
        }
        return result_dict

    @staticmethod
    def get_slot_date():
        today = datetime.now()
        delta = timedelta(days=14)
        first_day = today - delta
        last_day = today + delta
        result_dict = {
            "first_day": first_day.strftime("%d.%m.%Y"),
            "last_day": last_day.strftime("%d.%m.%Y")
        }
        return result_dict

    @staticmethod
    def get_year_date():
        current_date = datetime.now()
        last_year = current_date.year - 1
        first_day_last_year = datetime(last_year, 1, 1)
        result_dict = {
            "first_day": first_day_last_year.strftime("%d.%m.%Y"),
            "last_day": current_date.strftime("%d.%m.%Y")
        }
        return result_dict


class SettingsSQL:
    reader_sql: ReaderSQL = ReaderSQL()
    month_report: ClassVar[TextClause] = reader_sql.read_month_report_sql
    slot_report: ClassVar[TextClause] = reader_sql.read_slot_report_sql
    date_sql: DateSQL = DateSQL()
    # first_and_last_day_of_month: ClassVar = DateSQL.get_first_and_last_day_of_month
    # year_date: ClassVar = DateSQL.get_year_date
    # slot_date: ClassVar = DateSQL.get_slot_date
    formatted_datetime: ClassVar = DateSQL().get_formatted_datetime
    month_report_col: List[str] = [
        'lpu',
        'lpu_dep',
        'dep_oid',
        'doc_type',
        'employer',
        'position',
        'date_dl',
        'services_success',
        'services_not_send',
        'services_error',
        'services_send',
        'semd_reg',
        'semd_formed',
        'semd_success_reg',
        'semd_success_summ'
    ]
    set_nls_date_format: TextClause = text("""alter session set nls_date_format = 'DD.MM.YYYY'""")


settings = SettingsSQL()
