from datetime import datetime
import os
import pandas as pd
from api_v2.engine.utils.utils import settings
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import QueuePool


class OracleExecutor:
    def __init__(self):
        self.db_url = 'oracle+cx_oracle://nni1:assassins@mis-cluster-scan.infomed39.ru:1521/?service_name=kalinacluster'
        self.engine = create_engine(
            self.db_url,
            poolclass=QueuePool,
            max_overflow=10,
            pool_size=10,
            pool_reset_on_return=None,
            # isolation_level="AUTOCOMMIT",
            # echo_pool="debug"
        )
        self.Session = sessionmaker(bind=self.engine)

    def check_connection(self):
        try:
            self.engine.connect()
            return True
        except Exception as e:
            raise Exception(f"Ошибка подключения к Oracle: {e}")

    def get_month_report(self, date_begin, date_end):
        with self.Session() as session:
            if self.check_connection():
                date_begin = datetime.strptime(date_begin, '%Y-%m-%d').strftime('%d.%m.%Y')
                date_end = datetime.strptime(date_end, '%Y-%m-%d').strftime('%d.%m.%Y')
                session.execute(settings.set_nls_date_format)
                df = pd.read_sql(
                    settings.month_report,
                    session.connection(),
                    params={
                        'DATE_BEGIN': date_begin,
                        'DATE_END': date_end,
                    },
                )
                df.columns = settings.month_report_col
                df.to_excel('test.xlsx')
                return df

    # def get_slot_report(self):
    #     with self.Session() as session:
    #         session.execute(settings.set_nls_date_format)
    #         date_params = settings.date_sql.get_slot_date()
    #         params = {
    #             'db': date_params.get('first_day'),
    #             'de': date_params.get('last_day'),
    #         }
    #         df = pd.read_sql(
    #             settings.slot_report,
    #             session.connection(),
    #             params=params
    #         )
    #         col = [
    #             "lpu",
    #             "dep",
    #             "cab",
    #             "spec",
    #             "emp",
    #             "date",
    #             "vsego_slotov",
    #             "vsego_konkyr",
    #             "vsego_internet",
    #             "vsego_call_center",
    #             "kol_vo",
    #             'kol_vo_14',
    #             "kol_vo_zap_otkaz"
    #         ]
    #         df.columns = col
    #         PostgresqlExecutor().df_to_sql_slot_report(df)
    #         return params
    #
    # def get_year_report(self):
    #     with self.Session() as session:
    #         if self.check_connection():
    #             # date = settings.date_sql.get_first_and_last_day_of_month()
    #             session.execute(settings.set_nls_date_format)
    #             df = pd.read_sql(
    #                 settings.month_report,
    #                 session.connection(),
    #                 params={
    #                     'DATE_BEGIN': '01.01.2024',
    #                     'DATE_END': '17.03.2024',
    #                 }
    #             )
    #             df.columns = settings.month_report_col
    #             PostgresqlExecutor().df_to_sql_year_report(df=df)
    #             return 1
    #         else:
    #             return 0
