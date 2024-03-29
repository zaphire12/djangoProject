With
spec as (
    select t.ID, t.TITLE,
           case when t.TITLE like '%педиатр%' and t.TITLE not like '%участк%' then 'Врач педиатр'
                when t.TITLE like 'Врач стоматолог%дет%' then 'Врач стоматолог детский'
                when t.TITLE = 'Врач психиатр  подростковый' or t.TITLE = 'Врач-психиатр детский' then 'Врач-психиатр детский (подростковый)'
                else t.TITLE
           end TITLNEW,
           case when t.TITLE = 'Врач педиатр' or t.TITLE = 'Врач педиатр (0-3)' or t.TITLE = 'Врач терапевт' or t.TITLE = 'Фельдшер' then 1 else 0 end DOP_SP
      from (
            select * from d_specialities s where lower(title) like 'врач%оториноларинголог%' and lower(title) not like 'врач%сурдолог%'
                                             and lower(title) not like '%дет%' union all
            select * from d_specialities s where lower(title) like 'врач%офтальмолог'  union all
            select * from d_specialities s where lower(title) like 'врач%акушер%гинеколог'  union all
            select * from d_specialities s where lower(title) like 'врач%хирург' and lower(title) not like '%нейро%'
                                             and lower(title) not like '%торак%' and lower(title) not like '%сердечн%'
                                             and lower(title) not like '%детск%' and lower(title) not like '%стомат%' union all
            select * from d_specialities s where lower(title) like 'врач%общей%практики%' and lower(title) not like '%стомат%'
                                             and lower(title) not like '%действ%' union all
            select * from d_specialities s where lower(title) like '%фельдшер' or lower(title) like '%Фельдшер' union all
            select * from d_specialities s where lower(title) like 'врач%педиатр'  union all
            select * from d_specialities s where lower(title) like 'врач%педиатр%(0-3)'  union all
            select * from d_specialities s where lower(title) like 'врач%педиатр%участковый%'  union all
            select * from d_specialities s where lower(title) like 'врач%терапевт' and lower(title) not like 'врач%психо%'
                                             and lower(title) not like '%мануальн%' and lower(title) not like '%рефлекс%'
                                             and lower(title) not like '%физио%' and lower(title) not like '%стомат%' union all
            select * from d_specialities s where lower(title) like 'врач%терапевт%участковый%'  union all
            select * from d_specialities s where lower(title) like 'врач%детский%хирург%'  union all
            select * from d_specialities s where lower(title) like 'врач%стоматолог%терапевт'  union all
            select * from d_specialities s where lower(title) like 'врач%стоматолог' and lower(title) not like '%хирург%' union all
            select * from d_specialities s where lower(title) like 'врач%стоматолог%дет%'  union all
            --select * from d_specialities s where lower(title) like '%стомат%общ%пр%'  union all
            select * from d_specialities s where lower(title) like 'врач%фтизиатр'  union all
            select * from d_specialities s where lower(title) like 'врач%психиатр%детский%'  union all
            select * from d_specialities s where lower(title) like 'врач%психиатр%подростковый%'  union all
            select * from d_specialities s where lower(title) like 'врач%психиатр%нарколог%' and lower(title) not like '%дет%'
           ) t
     where t.DATE_END is null
     /*select s.ID, s.TITLE TITLNEW, 0 DOP_SP
       from d_specialities s
      where lower(title) like 'врач%дермато%'
        and s.DATE_END is null
     */
),
mo_ti as (
    select 'Багратионовская центральная районная больница'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ "Центр специализированных видов медицинской помощи Калининградской области"'  MO,'Выезд' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ "Центр специализированных видов медицинской помощи Калининградской области"'  MO,'Дежурный Врач' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ "Центр специализированных видов медицинской помощи Калининградской области"'  MO,'Запись для других ЛПУ' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ "Центр специализированных видов медицинской помощи Калининградской области"'  MO,'Запись для других ЛПУ - ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ "Центр специализированных видов медицинской помощи Калининградской области"'  MO,'Платный приём' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ "Центр специализированных видов медицинской помощи Калининградской области"'  MO,'Профосмотры' TIME_NAME,	0	is_prim from dual union all
    select 'Балтийская центральная районная больница'  MO,'Call-центр осмотр' TIME_NAME,	1	is_prim from dual union all
    select 'Балтийская центральная районная больница'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'Балтийская центральная районная больница'  MO,'День здорового ребёнка интернет' TIME_NAME,	0	is_prim from dual union all
    select 'Балтийская центральная районная больница'  MO,'Для терапевтов' TIME_NAME,	0	is_prim from dual union all
    select 'Балтийская центральная районная больница'  MO,'Д-наблюдение' TIME_NAME,	0	is_prim from dual union all
    select 'Балтийская центральная районная больница'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Балтийская центральная районная больница'  MO,'Пациенты стационара' TIME_NAME,	0	is_prim from dual union all
    select 'Балтийская центральная районная больница'  MO,'Приёма нет' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ «Правдинская центральная районная больница»'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ «Правдинская центральная районная больница»'  MO,'COVID-19 Запись ЕПГУ' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ «Правдинская центральная районная больница»'  MO,'COVID-19 Лист ожидания' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ «Правдинская центральная районная больница»'  MO,'COVID-19 ПОС и сайт' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ «Правдинская центральная районная больница»'  MO,'COVID-19 Регистратура и CallCenter' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ «Правдинская центральная районная больница»'  MO,'Дежурный Врач' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ «Правдинская центральная районная больница»'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ «Правдинская центральная районная больница»'  MO,'Повторный прием' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'COVID-19 Запись ЕПГУ' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'COVID-19 Регистратура и CallCenter' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'Дисп. пациенты (интернет)' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'Диспансеризация' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'Для операции ' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'Для терапевтов' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'Для травматологов' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'Неотложка' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'Острая боль' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'Пациенты стационара' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'Пациенты стационара ЦГКБ' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'Платный приём' TIME_NAME,	0	is_prim from dual union all
    select 'ГБУЗ Калининградской области "ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА"'  MO,'Приёма нет' TIME_NAME,	0	is_prim from dual union all
    select 'Гвардейская центральная районная больница'  MO,'Call center стоматологический резерв' TIME_NAME,	1	is_prim from dual union all
    select 'Гвардейская центральная районная больница'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'Гвардейская центральная районная больница'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 2'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 2'  MO,'Резерв' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 3'  MO,'Время врача' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 3'  MO,'Острая боль' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 3'  MO,'Приёма нет' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'COVID-19 Запись ЕПГУ' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'COVID-19 Регистратура и CallCenter' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Выезд' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Дисп. пациенты (интернет)' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Запись для других ЛПУ' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Запись через интернет' TIME_NAME,	1	is_prim from dual union all
    select 'Городская больница № 4'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Пациенты стационара' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Платный приём' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Повторный осмотр' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Приёма нет' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Резерв' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Совещание' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Табло(Экран)' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Только в регистратуре' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Неотложка' TIME_NAME,	0	is_prim from dual union all
    select 'Городская больница № 4'  MO,'Диспансеризация' TIME_NAME,	0	is_prim from dual union all
    select 'Городская детская стоматологическая поликлиника'  MO,'Повторный диспансеризация' TIME_NAME,	0	is_prim from dual union all
    select 'Городская детская стоматологическая поликлиника'  MO,'Call centr стоматологический узкий специалист' TIME_NAME,	1	is_prim from dual union all
    select 'Городская детская стоматологическая поликлиника'  MO,'Льгота только регистратура узкий специалист' TIME_NAME,	0	is_prim from dual union all
    select 'Городская детская стоматологическая поликлиника'  MO,'льгота только регистратура' TIME_NAME,	0	is_prim from dual union all
    select 'Городская детская стоматологическая поликлиника'  MO,'Школа' TIME_NAME,	0	is_prim from dual union all
    select 'Городская детская стоматологическая поликлиника'  MO,'Школа- первичный прием' TIME_NAME,	0	is_prim from dual union all
    select 'Городская детская стоматологическая поликлиника'  MO,'Школа - повторный прием' TIME_NAME,	0	is_prim from dual union all
    select 'Городская детская стоматологическая поликлиника'  MO,'Неотложка' TIME_NAME,	0	is_prim from dual union all
    select 'Городская детская стоматологическая поликлиника'  MO,'повторный - врачебный' TIME_NAME,	1	is_prim from dual union all
    select 'Городская поликлиника № 3'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'Городская поликлиника № 3'  MO,'Выезд' TIME_NAME,	0	is_prim from dual union all
    select 'Городская поликлиника № 3'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Городская поликлиника № 3'  MO,'Профосмотры' TIME_NAME,	0	is_prim from dual union all
    select 'Городская стоматологическая поликлиника'  MO,'Выезд' TIME_NAME,	0	is_prim from dual union all
    select 'Городская стоматологическая поликлиника'  MO,'Для операции ' TIME_NAME,	0	is_prim from dual union all
    select 'Городская стоматологическая поликлиника'  MO,'Льгота' TIME_NAME,	0	is_prim from dual union all
    select 'Городская стоматологическая поликлиника'  MO,'ОНКОСКРИНИНГ' TIME_NAME,	0	is_prim from dual union all
    select 'Городская стоматологическая поликлиника'  MO,'Острая боль' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное Бюджетное Учреждение Здравоохранения «Наркологический диспансер Калининградской области»'  MO,'Запись для других ЛПУ' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения «Противотуберкулезный диспансер Калининградской области»'  MO,'Дежурный Врач' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения «Противотуберкулезный диспансер Калининградской области»'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения «Психиатрическая больница Калининградской области № 2»'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'Ежедневно в регистратуре' TIME_NAME,	1	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'Ежедневно в регистратуре ГДП4' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'Здоровые дети' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'Месячники' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'Острая боль' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'Профосмотры' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'Профосмотры ГДП6' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'Резерв' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'Рентген ГДП ДПО2' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'Сертификат 1 год' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'Табло(Экран)' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области "Городская детская поликлиника"'  MO,'Эхокардиография (УЗИ Сердца)' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'COVID-19 Запись ЕПГУ' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'COVID-19 Лист ожидания' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'COVID-19 ПОС и сайт' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'COVID-19 Регистратура и CallCenter' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'Выезд' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'Дети поликлиника' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'Для операции ' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'Запись для других ЛПУ' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'Неотложка' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'Паллиативная помощь' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'Пациенты стационара' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'Платный приём' TIME_NAME,	0	is_prim from dual union all
    select 'Государственное бюджетное учреждение здравоохранения Калининградской области «Гусевская центральная районная больница»'  MO,'Резерв' TIME_NAME,	0	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'Call center ' TIME_NAME,	1	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'Call-центр осмотр' TIME_NAME,	1	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'COVID-19 Запись ЕПГУ' TIME_NAME,	0	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'COVID-19 Лист ожидания' TIME_NAME,	0	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'COVID-19 ПОС и сайт' TIME_NAME,	0	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'COVID-19 Регистратура и CallCenter' TIME_NAME,	0	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'Беременная' TIME_NAME,	0	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'Диспансеризация' TIME_NAME,	0	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'Для операции ' TIME_NAME,	0	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'Д-наблюдение' TIME_NAME,	0	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'Ежедневно в регистратуре' TIME_NAME,	1	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'Интернет' TIME_NAME,	1	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Гурьевская центральная районная больница'  MO,'Острая боль' TIME_NAME,	0	is_prim from dual union all
    select 'Ладушкинская городская больница'  MO,'COVID-19 Лист ожидания' TIME_NAME,	0	is_prim from dual union all
    select 'Мамоновская городская больница'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'Мамоновская городская больница'  MO,'Выезд' TIME_NAME,	0	is_prim from dual union all
    select 'Неманская центральная районная больница'  MO,'COVID-19 Запись ЕПГУ' TIME_NAME,	0	is_prim from dual union all
    select 'Неманская центральная районная больница'  MO,'COVID-19 Лист ожидания' TIME_NAME,	0	is_prim from dual union all
    select 'Неманская центральная районная больница'  MO,'COVID-19 ПОС и сайт' TIME_NAME,	0	is_prim from dual union all
    select 'Неманская центральная районная больница'  MO,'COVID-19 Регистратура и CallCenter' TIME_NAME,	0	is_prim from dual union all
    select 'Нестеровская центральная районная больница'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'Нестеровская центральная районная больница'  MO,'Диспансеризация' TIME_NAME,	0	is_prim from dual union all
    select 'Нестеровская центральная районная больница'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'ОБЛАСТНАЯ СТОМАТОЛОГИЧЕСКАЯ ПОЛИКЛИНИКА'  MO,'Резерв' TIME_NAME,	0	is_prim from dual union all
    select 'Озерская центральная районная больница'  MO,'COVID-19 Запись ЕПГУ' TIME_NAME,	0	is_prim from dual union all
    select 'Озерская центральная районная больница'  MO,'COVID-19 Лист ожидания' TIME_NAME,	0	is_prim from dual union all
    select 'Озерская центральная районная больница'  MO,'COVID-19 ПОС и сайт' TIME_NAME,	0	is_prim from dual union all
    select 'Озерская центральная районная больница'  MO,'COVID-19 Регистратура и CallCenter' TIME_NAME,	0	is_prim from dual union all
    select 'Полесская центральная районная больница'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'Полесская центральная районная больница'  MO,'Вакцинация от COVID-19' TIME_NAME,	0	is_prim from dual union all
    select 'Полесская центральная районная больница'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Полесская центральная районная больница'  MO,'Экстренная помощь' TIME_NAME,	0	is_prim from dual union all
    select 'Психиатрическая больница Калининградской области № 1'  MO,'Пациенты стационара' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'1 участок' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'1 участок - беременная' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'10 участок' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'10 участок - беременная' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'11 участок' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'11 участок - беременная' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'12 участок' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'12 участок - беременная ' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'2 участок' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'2 участок - беременная' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'3 участок' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'3 участок - беременная' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'4 участок' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'4 участок - беременная' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'5 участок' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'6 участок' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'6 участок - беременная' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'7 участок' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'8 участок' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'8 участок - беременная' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'9 участок' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'9 участок - беременная' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'Беременная' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 3'  MO,'Дежурный Врач' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 4'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 4'  MO,'Беременная' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 4'  MO,'Ежедневно в регистратуре' TIME_NAME,	1	is_prim from dual union all
    select 'Родильный дом Калининградской области № 4'  MO,'Запись через интернет' TIME_NAME,	1	is_prim from dual union all
    select 'Родильный дом Калининградской области № 4'  MO,'Неотложка' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 4'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Родильный дом Калининградской области № 4'  MO,'Дежурный Врач' TIME_NAME,	0	is_prim from dual union all
    select 'Светловская центральная городская больница'  MO,'COVID-19 Запись ЕПГУ' TIME_NAME,	0	is_prim from dual union all
    select 'Светловская центральная городская больница'  MO,'COVID-19 Лист ожидания' TIME_NAME,	0	is_prim from dual union all
    select 'Светловская центральная городская больница'  MO,'COVID-19 ПОС и сайт' TIME_NAME,	0	is_prim from dual union all
    select 'Светловская центральная городская больница'  MO,'COVID-19 Регистратура и CallCenter' TIME_NAME,	0	is_prim from dual union all
    select 'Светловская центральная городская больница'  MO,'Запись через интернет' TIME_NAME,	1	is_prim from dual union all
    select 'Светловская центральная городская больница'  MO,'Приёма нет' TIME_NAME,	0	is_prim from dual union all
    select 'Славская центральная районная больница'  MO,'COVID-19 Лист ожидания' TIME_NAME,	0	is_prim from dual union all
    select 'Славская центральная районная больница'  MO,'COVID-19 ПОС и сайт' TIME_NAME,	0	is_prim from dual union all
    select 'Славская центральная районная больница'  MO,'COVID-19 Регистратура и CallCenter' TIME_NAME,	0	is_prim from dual union all
    select 'Славская центральная районная больница'  MO,'Вакцинация от COVID-19' TIME_NAME,	0	is_prim from dual union all
    select 'Славская центральная районная больница'  MO,'Время врача' TIME_NAME,	0	is_prim from dual union all
    select 'Славская центральная районная больница'  MO,'Пациенты стационара' TIME_NAME,	0	is_prim from dual union all
    select 'Советская стоматологическая поликлиника'  MO,'Ежедневно в регистратуре' TIME_NAME,	1	is_prim from dual union all
    select 'Советская центральная городская больница'  MO,'Запись для других ЛПУ' TIME_NAME,	0	is_prim from dual union all
    select 'Советская центральная городская больница'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Советский противотуберкулезный диспансер'  MO,'Ежедневно в регистратуре' TIME_NAME,	1	is_prim from dual union all
    select 'Советский противотуберкулезный диспансер'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Черняховская инфекционная больница'  MO,'ОМС' TIME_NAME,	0	is_prim from dual union all
    select 'Черняховская стоматологическая поликлиника'  MO,'Ежедневно в регистратуре' TIME_NAME,	1	is_prim from dual union all
    select 'Черняховская стоматологическая поликлиника'  MO,'Приёма нет' TIME_NAME,	0	is_prim from dual union all
    select 'Черняховская центральная районная больница'  MO,'CITO' TIME_NAME,	0	is_prim from dual union all
    select 'Черняховская центральная районная больница'  MO,'COVID Рентген' TIME_NAME,	0	is_prim from dual union all
    select 'Черняховская центральная районная больница'  MO,'COVID-19 Лист ожидания' TIME_NAME,	0	is_prim from dual union all
    select 'Черняховская центральная районная больница'  MO,'COVID-19 ПОС и сайт' TIME_NAME,	0	is_prim from dual union all
    select 'Черняховская центральная районная больница'  MO,'COVID-19 Регистратура и CallCenter' TIME_NAME,	0	is_prim from dual union all
    select 'Черняховская центральная районная больница'  MO,'Беременная' TIME_NAME,	0	is_prim from dual union all
    select 'Черняховская центральная районная больница'  MO,'Ежедневно в регистратуре' TIME_NAME,	1	is_prim from dual
),
mo_ti2 as (
    select l.id MO_ID, mo_ti.MO, mo_ti.TIME_NAME, mo_ti.IS_PRIM,
           (select id from D_V_SCHEDULE_TIME_TYPES stt where stt.TIME_NAME = mo_ti.TIME_NAME) TIME_NAME_ID
      from mo_ti
           left join d_lpu l on l.fullname = mo_ti.mo
     where is_prim = 0
)
,
cte_dates ( CD ) as (
    select to_date(:db, 'dd.mm.yyyy') CD
      from dual

    union all

    select cast((CD + 1) as date) CD
      from cte_dates
     where trunc(CD) + 1 <= to_date(:de, 'dd.mm.yyyy')
),
d as (
    select CD,
           to_number(to_char(cd, 'D')) DN,
           to_char(cd, 'DY') DD,
           extract(day from cd) MD
      from cte_dates
),
cab as (
    select c.ID,
           c.CL_NAME,
           c.LPU
      from D_V_CABLAB c
     where c.LPU not in (
            5858772243,
            77927348,
            77953001,
            2508261592,
            2723846906,
            75602245,
            105882243,
            3328588139,
            77952203,
            77961127,
            3327597789,
            106731821,
            4569282399,
            101515057,
            77944538,
            77964806,
            5344486744,
            77971160,
            4466266324,
            77970329,
            3663367237,
            4071029271)
       and nvl(c.BEGIN_DATE, sysdate) <= sysdate
       and (c.END_DATE is null or c.END_DATE > sysdate)
),
sch as (
    select gct.LPU,
           EMP_FULL_NAME,
           gct.CABLAB_ID,
		   --gct.ID,
           gct.SLOT_ID,
           gct.SCHED_ID,
           gct.DAY_NUMBER,
           round((gct.TIME_BEGIN - trunc(gct.TIME_BEGIN)) * 24 * 60) TIME_BEGIN_N,
           round((gct.TIME_END - trunc(gct.TIME_END)) * 24 * 60) TIME_END_N,
           to_char(gct.TIME_BEGIN, 'hh24') HOURS_BEGIN,
           to_char(gct.TIME_BEGIN, 'mi') MINS_BEGIN,
           to_char(gct.TIME_END, 'hh24') HOURS_END,
           to_char(gct.TIME_END, 'mi') MINS_END,
           gct.TIME_BEGIN_S,
           gct.TIME_END_S,
           gct.TIME_TYPE,
           stt.TIME_NAME,
           (select d_stragg(v.REG_TYPE_MNEMO)
              from D_V_SCHTIME_TYPE_REGS v
             where v.TIME_TYPE_ID = stt.ID
               and v.LPU = gct.LPU) TIME_CONTENT,
           gct.TIME_CODE TIME_TYPE_CODE,
           gct.RCOUNT,
           gct.RCOUNTMAX,
           gct.TIME_OR_COUNT,
           case --Тип построения: 0 - обычный, 1 - динамический, 2 - живая очередь
                when gct.CLSCH_TYPE = 2
                then nvl((
                    select re.RTIME
                      from D_V_CLSCHS_RTIMES re
                     where re.PID = gct.SCHED_ID
                       and re.TYME_TYPE_ID = gct.TIME_TYPE
                  group by re.RTIME), gct.RTIME_PRIM)|| ''
                when gct.CLSCH_TYPE = 1
                then (
                    select re.RTIME
                      from D_V_CLSCHS_RTIMES re
                     where re.PID = gct.SCHED_ID
                       and re.TYME_TYPE_ID = gct.TIME_TYPE
                       and rownum = 1
                  group by re.RTIME)|| ''
                else gct.RTIME_PRIM || ''
           end RTIME_PRIM,
           gct.INFOBOARD_NAME,
           gct.DBEGIN,
           gct.DEND,
           e.FIO,
           (select t2.ALLOW_RECORD
              from D_V_SCH_RESOURCES_SERV t2
             where e.ID = t2.EMPLOYER_ID
               and t2.CABLAB_ID = cab.ID
               and t2.LPU = cab.LPU
               and rownum = 1
           ) ALLOW_RECORD,
           sch.SCH_TYPE, -- Тип графика:0-обычный,1-чет/нечет,2-чет/нечет по дням недели,3-скользящий,4-по дням месяца
           cab.CL_NAME,
           gct.EMPLOYER_ID,
           --gct.CABLAB_ID,
           e.SPECIALITY,
           d.DIV_NAME,
           spec.TITLNEW,
           spec.DOP_SP
      from D_V_GENREG_CLSCHS_TIMES2 gct
           join D_CLSCHS c on gct.SCHED_ID = c.ID
           join D_SCHEDULE sch on sch.ID = c.SCHEDULE
           left join D_V_EMPLOYERS e on e.ID = gct.EMPLOYER_ID
           left join D_V_DIVISIONS d on d.ID = e.DIVISION_ID
           join D_V_SCHEDULE_TIME_TYPES stt on gct.TIME_TYPE = stt.ID
           join cab on cab.ID = gct.CABLAB_ID
           join spec on spec.ID = e.SPECIALITY_ID
     where (gct.DEND is null or gct.DEND >= to_date(:db, 'dd.mm.yyyy'))
       and gct.DBEGIN <= to_date(:de, 'dd.mm.yyyy')
       and (c.DEND is null or c.DEND >= to_date(:db, 'dd.mm.yyyy'))
       and c.DBEGIN <= to_date(:de, 'dd.mm.yyyy')
       and e.NIS_WORK = 1
       and NIS_DISMISSED = 0
),
sch2 as (
    select sch.*,
           round(round((to_date(TIME_END_S, 'hh24:mi') - to_date(TIME_BEGIN_S, 'hh24:mi')) * 24 * 60 / RTIME_PRIM * 100, 1) / 100) SLOT_QNT
      from sch
),
sch3 as (
    --обычное расписание SCH_TYPE = 0
    select l.FULLNAME,
           sch2.CL_NAME,
           sch2.TIME_NAME,
           sch2.DAY_NUMBER,
           sum(sch2.SLOT_QNT) SLOT_QNT,
           sum(case when (sch2.TIME_NAME = 'Запись через интернет' or sch2.TIME_NAME like '%Интернет%'
                       or sch2.TIME_NAME like 'Call%cent%r%' or sch2.TIME_NAME like '%интернет%'
                       or sch2.TIME_NAME like 'Call%цент%р%'
                         )
                    then sch2.SLOT_QNT
                    else 0
           end) SLOT_KONKUR_QNT,
           sum(case when (sch2.TIME_NAME = 'Запись через интернет'
                       or sch2.TIME_NAME like '%Интернет%'
                       or sch2.TIME_NAME like '%интернет%')
                    then sch2.SLOT_QNT
                    else 0
           end) SLOT_INTERNET_QNT,
           sum(case when (sch2.TIME_NAME like 'Call%cent%r%'
                       or sch2.TIME_NAME like 'Call%цент%р%')
                    then sch2.SLOT_QNT
                    else 0
           end) SLOT_CALL_QNT,
           TIME_CONTENT,
           SCH_TYPE,
           EMP_FULL_NAME,
           d.CD,
           sch2.EMPLOYER_ID,
           sch2.CABLAB_ID,
           sch2.LPU,
           sch2.SPECIALITY,
           ALLOW_RECORD,
           sch2.DEND,
           sch2.DBEGIN,
           RTIME_PRIM,
           DIV_NAME,
           TITLNEW,
           DOP_SP
      from sch2
           join D_V_LPU l on l.ID = sch2.LPU
           join D_V_CABLAB c on c.ID = sch2.CABLAB_ID
           join d on d.DN = sch2.DAY_NUMBER
     where (sch2.DEND is null or sch2.DEND >= d.CD)
       and sch2.SCH_TYPE = 0
       and d.CD between to_date(:db, 'dd.mm.yyyy') and to_date(:de, 'dd.mm.yyyy')
       and not exists(select null
                        from D_V_CLSCHS_BLOCKS b
                       where b.LPU = sch2.LPU
                         and b.PID = sch2.SCHED_ID
                         and d.CD between BL_DATE_BEGIN and BL_DATE_END)
  group by l.FULLNAME,
           sch2.CL_NAME,
           sch2.DAY_NUMBER,
           sch2.TIME_NAME,
           TIME_CONTENT,
           SCH_TYPE,
           EMP_FULL_NAME,
           d.CD,
           sch2.EMPLOYER_ID,
           sch2.CABLAB_ID,
           sch2.LPU,
           sch2.SPECIALITY,
           ALLOW_RECORD,
           sch2.DEND,
           sch2.DBEGIN,
           RTIME_PRIM,
           DIV_NAME,
           TITLNEW,
           DOP_SP

    union all

    --чет/нечет по дням недели SCH_TYPE = 2 нечетные дни
    select l.FULLNAME,
           sch2.CL_NAME,
           sch2.TIME_NAME,
           case when sch2.DAY_NUMBER > 7
                then sch2.DAY_NUMBER - 7
                else sch2.DAY_NUMBER
           end DAY_NUMBER,
           sum(sch2.SLOT_QNT) SLOT_QNT,
           sum(case when (sch2.TIME_NAME = 'Запись через интернет' or sch2.TIME_NAME like '%Интернет%'
                       or sch2.TIME_NAME like 'Call%cent%r%' or sch2.TIME_NAME like '%интернет%'
                       or sch2.TIME_NAME like 'Call%центр%'
                         )
                    then sch2.SLOT_QNT
                    else 0
           end) SLOT_KONKUR_QNT,
           sum(case when (sch2.TIME_NAME = 'Запись через интернет'
                       or sch2.TIME_NAME like '%Интернет%'
                       or sch2.TIME_NAME like '%интернет%')
                    then sch2.SLOT_QNT
                    else 0
           end) SLOT_INTERNET_QNT,
           sum(case when (sch2.TIME_NAME like 'Call%cent%r%'
                       or sch2.TIME_NAME like 'Call%цент%р%')
                    then sch2.SLOT_QNT
                    else 0
           end) SLOT_CALL_QNT,
           TIME_CONTENT,
           SCH_TYPE,
           EMP_FULL_NAME,
           d.CD,
           sch2.EMPLOYER_ID,
           sch2.CABLAB_ID,
           sch2.LPU,
           sch2.SPECIALITY,
           ALLOW_RECORD,
           sch2.DEND,
           sch2.DBEGIN,
           RTIME_PRIM,
           DIV_NAME,
           TITLNEW,
           DOP_SP
      from sch2
           join D_V_LPU l on l.ID = sch2.LPU
           join D_V_CABLAB c on c.ID = sch2.CABLAB_ID
           join d on d.DN = sch2.DAY_NUMBER and mod(d.MD, 2) = 1
     where (sch2.DEND is null or sch2.DEND >= d.CD)
       and sch2.SCH_TYPE = 2
       and d.CD between to_date(:db, 'dd.mm.yyyy') and to_date(:de, 'dd.mm.yyyy')
       and not exists(select null
                        from D_V_CLSCHS_BLOCKS b
                       where b.LPU = sch2.LPU
                         and b.PID = sch2.SCHED_ID
                         and d.CD between BL_DATE_BEGIN and BL_DATE_END)
 group by l.FULLNAME,
          sch2.CL_NAME,
          sch2.DAY_NUMBER,
          sch2.TIME_NAME,
          TIME_CONTENT,
          SCH_TYPE,
          EMP_FULL_NAME,
          d.CD,
          sch2.EMPLOYER_ID,
          sch2.CABLAB_ID,
          sch2.LPU,
          sch2.SPECIALITY,
          ALLOW_RECORD,
          sch2.DEND,
          sch2.DBEGIN,
          RTIME_PRIM,
          DIV_NAME,
          TITLNEW,
          DOP_SP

    union all

    -- чет/нечет по дням недели SCH_TYPE = 2 четные дни
    select l.FULLNAME,
           sch2.CL_NAME,
           sch2.TIME_NAME,
           case when sch2.DAY_NUMBER > 7
                then sch2.DAY_NUMBER - 7
                else sch2.DAY_NUMBER
           end DAY_NUMBER,
           sum(sch2.SLOT_QNT) SLOT_QNT,
           sum(case when (sch2.TIME_NAME = 'Запись через интернет' or sch2.TIME_NAME like '%Интернет%'
                       or sch2.TIME_NAME like 'Call%cent%r%' or sch2.TIME_NAME like '%интернет%'
                       or sch2.TIME_NAME like 'Call%центр%'
                         )
                    then sch2.SLOT_QNT
                    else 0
           end) SLOT_KONKUR_QNT,
           sum(case when (sch2.TIME_NAME = 'Запись через интернет'
                       or sch2.TIME_NAME like '%Интернет%'
                       or sch2.TIME_NAME like '%интернет%')
                    then sch2.SLOT_QNT
                    else 0
           end) SLOT_INTERNET_QNT,
           sum(case when (sch2.TIME_NAME like 'Call%cent%r%'
                       or sch2.TIME_NAME like 'Call%цент%р%')
                    then sch2.SLOT_QNT
                    else 0
           end) SLOT_CALL_QNT,
           TIME_CONTENT,
           SCH_TYPE,
           EMP_FULL_NAME,
           d.CD,
           sch2.EMPLOYER_ID,
           sch2.CABLAB_ID,
           sch2.LPU,
           sch2.SPECIALITY,
           ALLOW_RECORD,
           sch2.DEND,
           sch2.DBEGIN,
           RTIME_PRIM,
           DIV_NAME,
           TITLNEW,
           DOP_SP
      from sch2
           join D_V_LPU l on l.ID = sch2.LPU
           join D_V_CABLAB c on c.ID = sch2.CABLAB_ID
           join d on d.DN = sch2.DAY_NUMBER and mod(d.MD, 2) = 0
     where (sch2.DEND is null or sch2.DEND >= d.CD)
       and sch2.SCH_TYPE = 2
       and d.CD between to_date(:db, 'dd.mm.yyyy') and to_date(:de, 'dd.mm.yyyy')
       and not exists(select null
                        from D_V_CLSCHS_BLOCKS b
                       where b.LPU = sch2.LPU
                         and b.PID = sch2.SCHED_ID
                         and d.CD between BL_DATE_BEGIN and BL_DATE_END)
  group by l.FULLNAME,
           sch2.CL_NAME,
           sch2.DAY_NUMBER,
           sch2.TIME_NAME,
           TIME_CONTENT,
           SCH_TYPE,
           EMP_FULL_NAME,
           d.CD,
           sch2.EMPLOYER_ID,
           sch2.CABLAB_ID,
           sch2.LPU,
           sch2.SPECIALITY,
           ALLOW_RECORD,
           sch2.DEND,
           sch2.DBEGIN,
           RTIME_PRIM,
           DIV_NAME,
           TITLNEW,
           DOP_SP

    union all

    -- 1-чет/нечет
    select l.FULLNAME,
           sch2.CL_NAME,
           sch2.TIME_NAME,
           d.DN DAY_NUMBER,
           sum(sch2.SLOT_QNT) SLOT_QNT,
           sum(case when (sch2.TIME_NAME = 'Запись через интернет' or sch2.TIME_NAME like '%Интернет%'
                       or sch2.TIME_NAME like 'Call%cent%r%' or sch2.TIME_NAME like '%интернет%'
                       or sch2.TIME_NAME like 'Call%центр%'
                         )
                    then sch2.SLOT_QNT
                    else 0
           end) SLOT_KONKUR_QNT,
           sum(case when (sch2.TIME_NAME = 'Запись через интернет'
                       or sch2.TIME_NAME like '%Интернет%'
                       or sch2.TIME_NAME like '%интернет%')
                    then sch2.SLOT_QNT
                    else 0
           end) SLOT_INTERNET_QNT,
           sum(case when (sch2.TIME_NAME like 'Call%cent%r%'
                       or sch2.TIME_NAME like 'Call%цент%р%')
                    then sch2.SLOT_QNT
                    else 0
           end) SLOT_CALL_QNT,
           TIME_CONTENT,
           SCH_TYPE,
           EMP_FULL_NAME,
           d.CD,
           sch2.EMPLOYER_ID,
           sch2.CABLAB_ID,
           sch2.LPU,
           sch2.SPECIALITY,
           ALLOW_RECORD,
           sch2.DEND,
           sch2.DBEGIN,
           RTIME_PRIM,
           DIV_NAME,
           TITLNEW,
           DOP_SP
      from sch2
           join D_V_LPU l on l.ID = sch2.LPU
           join D_V_CABLAB c on c.ID = sch2.CABLAB_ID
           join d on case mod(d.MD, 2)
                          when 0
                          then 2
                          else 1
                     end = sch2.DAY_NUMBER
    where (sch2.DEND is null or sch2.DEND >= d.CD)
      and sch2.SCH_TYPE = 1
      and d.cd between to_date(:db, 'dd.mm.yyyy') and to_date(:de, 'dd.mm.yyyy')
      and not exists(select null
                       from D_V_CLSCHS_BLOCKS b
                      where b.LPU = sch2.LPU
                        and b.PID = sch2.SCHED_ID
                        and d.cd between BL_DATE_BEGIN and BL_DATE_END)
 group by l.FULLNAME,
          sch2.CL_NAME,
          d.DN,
          sch2.TIME_NAME,
          TIME_CONTENT,
          SCH_TYPE,
          EMP_FULL_NAME,
          d.CD,
          sch2.EMPLOYER_ID,
          sch2.CABLAB_ID,
          sch2.LPU,
          sch2.SPECIALITY,
          ALLOW_RECORD,
          sch2.DEND,
          sch2.DBEGIN,
          RTIME_PRIM,
          DIV_NAME,
          TITLNEW,
          DOP_SP
),
sch4 as (
    select sch3.FULLNAME ЛПУ,
           sch3.CL_NAME КАБИНЕТ,
           sch3.EMP_FULL_NAME ВРАЧ,
           sch3.EMPLOYER_ID,
           sch3.CABLAB_ID,
           sch3.CD ДАТА,
           sch3.LPU,
           sch3.SPECIALITY,
           sch3.DIV_NAME,
           sch3.ALLOW_RECORD,
           sum(sch3.SLOT_QNT) ВСЕГО,
           sum(case when sch3.DOP_SP = 0 then sch3.SLOT_QNT else 0 end) ВСЕГО_14,
           sum(sch3.SLOT_KONKUR_QNT) ВСЕГО_КОНКУР,
           sum(case when sch3.DOP_SP = 0 then sch3.SLOT_KONKUR_QNT else 0 end) ВСЕГО_КОНКУР_14,
           sum(sch3.SLOT_INTERNET_QNT) ВСЕГО_ИНТЕРНЕТ,
           sum(sch3.SLOT_CALL_QNT) ВСЕГО_CALL_ЦЕНТР,
           (select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.SERV_STATUS <> 2
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
           ) КОЛ_ЗАПИСЕЙ,
           case when sch3.DOP_SP = 0
                then (
            select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.SERV_STATUS <> 2
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
                     )
                else 0
           end КОЛ_ЗАПИСЕЙ_14,
           (select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
                   join D_VISITS v on v.PID = ds.ID
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
           ) КОЛ_ЗАПИСЕЙ_ОКАЗ,
           case when sch3.DOP_SP = 0
                then (
            select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
                   join D_VISITS v on v.PID = ds.ID
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
                     )
                else 0
           end КОЛ_ЗАПИСЕЙ_ОКАЗ_14,
           (select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.EX_SYSTEM = 7498836718 -- er_portal/ER_v3
               and ds.SERV_STATUS <> 2
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
           ) КОЛ_ЗАПИСЕЙ_ИЗ_ЕПГУ,
           case when sch3.DOP_SP = 0
                then (
            select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.EX_SYSTEM = 7498836718 -- er_portal/ER_v3
               and ds.SERV_STATUS <> 2
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
                     )
                else 0
           end КОЛ_ЗАПИСЕЙ_ИЗ_ЕПГУ_14,
           (select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.EX_SYSTEM = 75734918 -- er_bars/ER
               and not exists (select null
                                 from D_EX_SYSTEM_VALUES t
                                where t.UNIT_ID = ds.ID
                                  and t.UNIT = 'DIRECTION_SERVICES'
                                  and t.VAL_CODE = 'INFOMATE')
               and ds.SERV_STATUS <> 2
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
           ) КОЛ_ЗАПИСЕЙ_ИЗ_ЕР,
           case when sch3.DOP_SP = 0
                then (
            select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.EX_SYSTEM = 75734918 -- er_bars/ER
               and not exists (select null
                                 from D_EX_SYSTEM_VALUES t
                                where t.UNIT_ID = ds.ID
                                  and t.UNIT = 'DIRECTION_SERVICES'
                                  and t.VAL_CODE = 'INFOMATE')
               and ds.SERV_STATUS <> 2
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
                     )
                else 0
           end КОЛ_ЗАПИСЕЙ_ИЗ_ЕР_14,
           (select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
                   join D_DIRECTIONS dd on dd.ID = ds.PID
                   join D_EMPLOYERS e on e.ID = dd.REG_EMPLOYER
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.SERV_STATUS <> 2
               and ds.EX_SYSTEM = 8161151807 -- CallCenter, Для выгрузки на ЕПГУ
               and e.SPECIALITY = 7741584502 -- Оператор Call-Center
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
           ) КОЛ_ЗАПИСЕЙ_ИЗ_ЕД_КОЛЛ,
           case when sch3.DOP_SP = 0
                then (
            select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
                   join D_DIRECTIONS dd on dd.ID = ds.PID
                   join D_EMPLOYERS e on e.ID = dd.REG_EMPLOYER
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.SERV_STATUS <> 2
               and ds.EX_SYSTEM = 8161151807 -- CallCenter, Для выгрузки на ЕПГУ
               and e.SPECIALITY = 7741584502 -- Оператор Call-Center
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
                     )
                else 0
           end КОЛ_ЗАПИСЕЙ_ИЗ_ЕД_КОЛЛ_14,
           (select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_DIRECTIONS dd on dd.ID = ds.PID
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.SERV_STATUS <> 2
               and dd.REG_TYPE in (0,1) -- Обычная, По телефону
               and (ds.TIME_TYPE_NAME like 'Call%cent%r%' or ds.TIME_TYPE_NAME like 'Call%центр%')
               and ds.EX_SYSTEM is null
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
           ) КОЛ_ЗАПИСЕЙ_ИЗ_КОЛЛ,
           case when sch3.DOP_SP = 0
                then (
            select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_DIRECTIONS dd on dd.ID = ds.PID
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.SERV_STATUS <> 2
               and dd.REG_TYPE in (0,1) -- Обычная, По телефону
               and (ds.TIME_TYPE_NAME like 'Call%cent%r%' or ds.TIME_TYPE_NAME like 'Call%центр%')
               and ds.EX_SYSTEM is null
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
                     )
                else 0
           end КОЛ_ЗАПИСЕЙ_ИЗ_КОЛЛ_14,
           (select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
                   join D_EX_SYSTEM_VALUES t on t.UNIT_ID = ds.ID and t.UNIT = 'DIRECTION_SERVICES'
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and t.VAL_CODE = 'INFOMATE'
               and ds.SERV_STATUS <> 2
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
           ) КОЛ_ЗАПИСЕЙ_ИНФОМАТ,
           case when sch3.DOP_SP = 0
                then (
            select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
                   join D_EX_SYSTEM_VALUES t on t.UNIT_ID = ds.ID and t.UNIT = 'DIRECTION_SERVICES'
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and t.VAL_CODE = 'INFOMATE'
               and ds.SERV_STATUS <> 2
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
                     )
                else 0
           end КОЛ_ЗАПИСЕЙ_ИНФОМАТ_14,
           (select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_DIRECTIONS dd on dd.ID = ds.PID
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.SERV_STATUS <> 2
               and dd.REG_TYPE in (0,1,3,4) -- Обычная, Удалённо, Интернет, По телефону
               and ds.EX_SYSTEM is null
               and ds.TIME_TYPE_NAME not like 'Call%cent%r%'
               and ds.TIME_TYPE_NAME not like 'Call%центр%'
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
           ) КОЛ_ЗАПИСЕЙ_РЕГИСТР,
           case when sch3.DOP_SP = 0
                then (
            select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_DIRECTIONS dd on dd.ID = ds.PID
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.SERV_STATUS <> 2
               and dd.REG_TYPE in (0,1,3,4) -- Обычная, Удалённо, Интернет, По телефону
               and ds.EX_SYSTEM is null
               and ds.TIME_TYPE_NAME not like 'Call%cent%r%'
               and ds.TIME_TYPE_NAME not like 'Call%центр%'
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
                     )
                else 0
           end КОЛ_ЗАПИСЕЙ_РЕГИСТР_14,
           (select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.SERV_STATUS = 2
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
           ) КОЛ_ЗАПИСЕЙ_ОТМЕН,
           case when sch3.DOP_SP = 0
                then (
            select count(1)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and ds.EMPLOYER_TO = sch3.EMPLOYER_ID
               and ds.CABLAB_TO_ID = sch3.CABLAB_ID
               and ds.LPU = sch3.LPU
               and ds.SERV_STATUS = 2
               and ds.TIME_TYPE_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
                     )
                else 0
           end КОЛ_ЗАПИСЕЙ_ОТМЕН_14,
           (select count(unique wlr.AGENT)
              from D_V_WL_RECORDS wlr
                   join D_SCH_RESOURCES r on r.ID = wlr.SCH_RESOURCE
             where wlr.IS_EXTERNAL = 0 --не внешняя очередь
               and trunc(wlr.REG_DATE) = to_date(CD,'dd.mm.yy')
               and r.EMPLOYER = sch3.EMPLOYER_ID
               and r.CABLAB = sch3.CABLAB_ID
               and r.LPU = sch3.LPU
           ) КОЛ_ЛИЦ_ДОБАВ_ЛО,
           (select count(unique wlr.AGENT)
              from D_V_DIRECTION_SERVICES ds
                   join D_SERVICES s on ds.SERVICE_ID = s.ID
                                        and s.SE_TYPE in (3,4)
                   join D_V_WL_RECORDS wlr on wlr.DIRECTION_SERVICE_ID = ds.ID and wlr.IS_EXTERNAL = 0 --не внешняя очередь
                   join D_SCH_RESOURCES r on r.ID = wlr.SCH_RESOURCE
             where trunc(ds.REC_DATE) = to_date(CD,'dd.mm.yy')
               and r.EMPLOYER = sch3.EMPLOYER_ID
               and r.CABLAB = sch3.CABLAB_ID
               and r.LPU = sch3.LPU
               and ds.SERV_STATUS <> 2
           ) КОЛ_ЛИЦ_ЗАПИС_ЛО_ЗА_ПЕР,
           sch3.TITLNEW,
           sch3.DOP_SP
      from sch3
     where sch3.TIME_CONTENT is not null
       and sch3.TIME_NAME not in (select mo_ti2.TIME_NAME from mo_ti2 where mo_ti2.MO_ID = sch3.LPU)
       and (to_date(sch3.CD,'dd.mm.yy') between sch3.DBEGIN and sch3.DEND or sch3.DBEGIN <= to_date(sch3.CD) and sch3.DEND is null)
       --and sch3.LPU <> 77950440 /*Центр общественного здоровья*/
	   --and sch3.LPU = 77957796 --75791579-- 93956536 -- select * from D_V_LPU where FULLNAME like '%Гурье%'
  group by sch3.FULLNAME,
           sch3.CL_NAME,
           sch3.EMP_FULL_NAME,
           sch3.EMPLOYER_ID,
           sch3.CABLAB_ID,
           sch3.CD,
           sch3.LPU,
           sch3.SPECIALITY,
           sch3.ALLOW_RECORD,
           sch3.DIV_NAME,
           sch3.TITLNEW,
           sch3.DOP_SP
)
select --*
      ЛПУ, DIV_NAME ПОДРАЗДЕЛЕНИЕ, КАБИНЕТ, TITLNEW СПЕЦИАЛЬНОСТЬ, ВРАЧ, ДАТА, ВСЕГО ВСЕГО_СЛОТОВ, ВСЕГО_КОНКУР, ВСЕГО_ИНТЕРНЕТ, ВСЕГО_CALL_ЦЕНТР, КОЛ_ЗАПИСЕЙ, КОЛ_ЗАПИСЕЙ_14, КОЛ_ЗАПИСЕЙ_ОКАЗ
 from sch4
--where TITLNEW = 'Врач-стоматолог общей практики'
