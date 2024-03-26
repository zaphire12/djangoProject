with /*СЭМДы по дате создания*/
 SEMD_CREATE_DATE as (
select
    LPU LPU_P,
    DEPART_NAME DEP_NAME,
    DIV_OID,
    case
    --    when DOC_TYPE_NAME like 'Направление на госпитализацию, восстановительное лечение, обследование, консультацию%' then 'Направление на госпитализацию, восстановительное лечение, обследование, консультацию'
        when DOC_TYPE_NAME like 'Сведения о результатах диспансеризации или профилактического медицинского осмотра%' then 'Сведения о результатах диспансеризации или профилактического медицинского осмотра'
        when DOC_TYPE_NAME like 'Протокол инструментального исследования%' then 'Инструментальные'
        when DOC_TYPE_NAME like 'Выписной эпикриз из родильного дома%' then 'Выписной эпикриз из роддома (ИР)'
        when DOC_TYPE_NAME like 'Протокол консультации%' then 'Консультации'
        when DOC_TYPE_NAME like 'Документ, содержащий сведения медицинского свидетельства о смерти%' then 'МСС'
        when DOC_TYPE_NAME like 'Протокол телемедицинской консультации%' then 'Телемедицина'
        when DOC_TYPE_NAME like 'Направление на медико-социальную экспертизу%' then 'МСЭ'
        when DOC_TYPE_NAME like 'Документ, содержащий сведения медицинского свидетельства о перинатальной смерти%' then 'МСПС'
        when DOC_TYPE_NAME like 'Документ, содержащий сведения медицинского свидетельства о рождении в бумажной форме%' then 'МСР'
        when DOC_TYPE_NAME like 'Эпикриз по законченному случаю амбулаторный%' then 'Эпикриз по законченному случаю амбулаторный'
        when DOC_TYPE_NAME like 'Протокол лабораторного исследования%' then 'Лаборатория'
        when DOC_TYPE_NAME like 'Эпикриз в стационаре выписной%' then 'Эпикриз в стационаре выписной (ИБ)'
        when DOC_TYPE_NAME like 'Протокол прижизненного патологоанатомического исследования%' then 'Протокол прижизненного патологоанатомического исследования'
        when DOC_TYPE_NAME like 'Справка о временной нетрудоспособности студент%' then 'Справка о временной нетрудоспособности учащихся'
        when DOC_TYPE_NAME like 'Медицинская справка о состоянии здоровья ребенка, отъезжающего в организацию отдыха детей и их оздоровления%' then 'Медицинская справка о состоянии здоровья ребенка'
        when DOC_TYPE_NAME like 'Медицинское заключение об отсутствии противопоказаний к занятию определенными видами спорта%' then 'Медицинское заключение об отсутствии противопоказаний к занятию определенными видами спорта'
        when DOC_TYPE_NAME like 'Этапный эпикриз%' then 'Этапный эпикриз'
        when DOC_TYPE_NAME like 'Заключение лечебного учреждения о нуждаемости престарелого гражданина в постоянном постороннем уходе%' then 'Заключение лечебного учреждения о нуждаемости престарелого гражданина в постоянном постороннем уходе'
        when DOC_TYPE_NAME like 'Заключение о выявлении факта поствакцинального осложнения%' then 'Заключение о выявлении факта поствакцинального осложнения'
        when DOC_TYPE_NAME like 'Санаторно-курортная карта для детей%' then 'Санаторно-курортная карта для детей'
        when DOC_TYPE_NAME like 'Санаторно-курортная карта.%' then 'Санаторно-курортная карта'
        else DOC_TYPE_NAME
             || ' '
             || 'Другое'
    end DOC_TYPE_NAME,
    CREATED_BY_FIO,
    JOBTITLE_S,
    DATE_N DATE_N_SEMD,
    count(1) ALL_REMD_CREATE_DATE,
    sum(SUCCESS_REMD) SUCCESS_REMD_CREATE_DATE
from
    (
        select
            TT.LPU,
            TT.DEPART_NAME,
            TT.DOC_TYPE_NAME,
            TT.CREATED_BY_FIO,
            TT.JOBTITLE JOBTITLE_S,
            TT.REMD_RESULT,
            TT.SUCCESS_REMD,
            TT.DATE_N,
            TT.DIV_OID
        from (select row_number() over(partition by T1.PID, T1.DOC_TYPE_NAME order by T1.SUCCESS_REMD desc ) RN,
                     T1.*
      from (select es.PID,
                   T.DOC_TYPE_NAME,
                   es.LPU,
                   T.DEPART_NAME,
                   T.DIV_OID,
                   trunc(T.DOC_DATE) DATE_N,
                   emp.JOBTITLE,
                   T.CREATED_BY_FIO,
                   T.REMD_RESULT,
                   T.REMD_ERRORS,
                   case when T.REMD_RESULT = 'Отказано в регистрации' and T.REMD_ERRORS like '%уже зарегистрирован%' then 1 else T.SUCCESS_REMD	end SUCCESS_REMD
              from table ( INT_PKG_REMD_REPORTS.GET_COMMUNICAT_JOUR_REMD(PNLPU => 93956536, PDDATE_BEGIN => to_date(:DATE_BEGIN, 'dd.mm.yyyy'
                    ), PDDATE_END => to_date(:DATE_END, 'dd.mm.yyyy'), PCLPU_IDS => null, PNEMPLOYER => null, PNPATIENT => null, PSDOC_TYPE_OID
                    => null, PSDEPART_OID => null, PNRESULTS => -1, psREMD_ERRORS=>null,psEMP_SIGNS => null,pdSEND_DATE_BEG => null,pdSEND_DATE_END => null) ) T
                    join D_EHR_STATES es on es.ID = T.ES_ID
                    join D_EHRS e on e.ID = es.PID
                    join D_PERSMEDCARD pmc on pmc.ID = e.PATIENT
                    join D_V_EMPLOYERS emp on emp.ID = e.CREATED_BY
             where trunc(T.DOC_DATE) between to_date(:DATE_BEGIN, 'dd.mm.yyyy') and to_date(:DATE_END, 'dd.mm.yyyy')
               and (D_PKG_AGENT_SOCIAL_STATES.GET_ACTUAL_ON_DATE(pmc.AGENT,trunc(T.DOC_DATE),'SOC_NAME') is null or lower(D_PKG_AGENT_SOCIAL_STATES.GET_ACTUAL_ON_DATE(pmc.AGENT,trunc(T.DOC_DATE),'SOC_NAME')) != 'бомж')
               ) T1
) TT  where TT.RN = 1
    ) G
group by
    LPU,
    DEPART_NAME,
    DIV_OID,
    case
        --when DOC_TYPE_NAME like 'Направление на госпитализацию, восстановительное лечение, обследование, консультацию%' then 'Направление на госпитализацию, восстановительное лечение, обследование, консультацию'
        when DOC_TYPE_NAME like 'Сведения о результатах диспансеризации или профилактического медицинского осмотра%' then 'Сведения о результатах диспансеризации или профилактического медицинского осмотра'
        when DOC_TYPE_NAME like 'Протокол инструментального исследования%' then 'Инструментальные'
        when DOC_TYPE_NAME like 'Выписной эпикриз из родильного дома%' then 'Выписной эпикриз из роддома (ИР)'
        when DOC_TYPE_NAME like 'Протокол консультации%' then 'Консультации'
        when DOC_TYPE_NAME like 'Документ, содержащий сведения медицинского свидетельства о смерти%' then 'МСС'
        when DOC_TYPE_NAME like 'Протокол телемедицинской консультации%' then 'Телемедицина'
        when DOC_TYPE_NAME like 'Направление на медико-социальную экспертизу%' then 'МСЭ'
        when DOC_TYPE_NAME like 'Документ, содержащий сведения медицинского свидетельства о перинатальной смерти%' then 'МСПС'
        when DOC_TYPE_NAME like 'Документ, содержащий сведения медицинского свидетельства о рождении в бумажной форме%' then 'МСР'
        when DOC_TYPE_NAME like 'Эпикриз по законченному случаю амбулаторный%' then 'Эпикриз по законченному случаю амбулаторный'
        when DOC_TYPE_NAME like 'Протокол лабораторного исследования%' then 'Лаборатория'
        when DOC_TYPE_NAME like 'Эпикриз в стационаре выписной%' then 'Эпикриз в стационаре выписной (ИБ)'
        when DOC_TYPE_NAME like 'Протокол прижизненного патологоанатомического исследования%' then 'Протокол прижизненного патологоанатомического исследования'
        when DOC_TYPE_NAME like 'Справка о временной нетрудоспособности студент%' then 'Справка о временной нетрудоспособности учащихся'
        when DOC_TYPE_NAME like 'Медицинская справка о состоянии здоровья ребенка, отъезжающего в организацию отдыха детей и их оздоровления%' then 'Медицинская справка о состоянии здоровья ребенка'
        when DOC_TYPE_NAME like 'Медицинское заключение об отсутствии противопоказаний к занятию определенными видами спорта%' then 'Медицинское заключение об отсутствии противопоказаний к занятию определенными видами спорта'
        when DOC_TYPE_NAME like 'Этапный эпикриз%' then 'Этапный эпикриз'
        when DOC_TYPE_NAME like 'Заключение лечебного учреждения о нуждаемости престарелого гражданина в постоянном постороннем уходе%' then 'Заключение лечебного учреждения о нуждаемости престарелого гражданина в постоянном постороннем уходе'
        when DOC_TYPE_NAME like 'Заключение о выявлении факта поствакцинального осложнения%' then 'Заключение о выявлении факта поствакцинального осложнения'
        when DOC_TYPE_NAME like 'Санаторно-курортная карта для детей%' then 'Санаторно-курортная карта для детей'
        when DOC_TYPE_NAME like 'Санаторно-курортная карта.%' then 'Санаторно-курортная карта'
        else DOC_TYPE_NAME
             || ' '
             || 'Другое'
    end,
    CREATED_BY_FIO,
    JOBTITLE_S,
    DATE_N
)

select coalesce(LPU_P,LPU)  "Медицинская организация",
       coalesce(DEPART_NAME,DEP_NAME) "Подразделение",
       coalesce(DEPART_OID, DIV_OID) "OID_подразделения",
       coalesce(DOC_TYPE, DOC_TYPE_NAME) "Тип документа",
       coalesce(EMP_FIO_NAME,CREATED_BY_FIO) "Сотрудник",
       coalesce(JOBTITLE, JOBTITLE_S) "Должность",
       coalesce(DATE_N, DATE_N_SEMD) "Дата",
       coalesce(VSEGO, 0) "Всего оказано услуг",
       coalesce(NOT_SEND_REMD, 0) "Не отправлено",
       coalesce(ERROR_REMD, 0) "Ошибки",
       coalesce(SENDED_REMD, 0) "Отправлено",
       coalesce(SUCCESS_REMD, 0) "Из них зарегистрировано",
       coalesce(REMD_QNT, 0) "Из них сформировано СЭМД",
     --  coalesce(SUCCESS_REMD_TRANS_DATE, 0) "Зарег СЭМДов по дате рег",
       coalesce(SUCCESS_REMD_CREATE_DATE, 0) "Зарег СЭМДов по дате создания",
       coalesce(ALL_REMD_CREATE_DATE, 0) "Всего СЭМДов по дате создания"
  from (

select LPU,
       EMP_FIO_NAME,
       JOBTITLE,
       DATE_N,
       DOC_TYPE,
       DEPART_NAME,
       DEPART_OID,
       count(1) VSEGO,
       sum(NOT_SEND_REMD) NOT_SEND_REMD,
       sum(ERROR_REMD) ERROR_REMD,
       sum(SENDED_REMD) SENDED_REMD,
       sum(SUCCESS_REMD) SUCCESS_REMD,
       sum(NOT_SEND_REMD) + sum(ERROR_REMD) + sum(SENDED_REMD) + sum(SUCCESS_REMD) REMD_QNT
 from (
        select ROW_NUMBER() OVER (PARTITION BY t1.ID, t1.DOC_TYPE ORDER BY t1.STATUS) RN,
               case when t1.STATUS = 'Подписан' then 1 else 0 end NOT_SEND_REMD,
               case when t1.STATUS = 'Не зарегистрирован в РЭМД' then 1 else 0 end ERROR_REMD,
               case when t1.STATUS = 'Отправлен на регистрацию в РЭМД' then 1 else 0 end SENDED_REMD,
               case when t1.STATUS = 'Зарегистрирован в РЭМД' then 1 else 0 end SUCCESS_REMD,
               t1.*
          from (
                select t.ID,
                       t.LPU,
                       t.EMPLOYER,
                       emp.EMP_FIO_NAME,
                       emp.JOBTITLE,
                       t.DATE_N,
                       t.DOC_TYPE
                       , (select fd.DEPART_NAME
                            from D_FED_NSI_LINK_SP s
                                 join D_FED_NSI_LINKS fnl on fnl.ID = s.PID
                                 join D_FN_FRMO_DIV fd on fd.ID = fnl.UNIT_ID and fnl.UNITCODE = 'FN_FRMO_DIV'
                                 join D_FED_NSI_VERS v on v.ID = fd.VERS
                                 join D_FED_NSI n on n.LAST_VERS = v.ID and n.UNITCODE = 'FN_FRMO_DIV'
                           where emp.DIVISION_ID = s.UNIT_ID
                             and s.UNITCODE = 'DIVISIONS'
                        ) DEPART_NAME
                        , (select fd.DEPART_OID
                            from D_FED_NSI_LINK_SP s
                                 join D_FED_NSI_LINKS fnl on fnl.ID = s.PID
                                 join D_FN_FRMO_DIV fd on fd.ID = fnl.UNIT_ID and fnl.UNITCODE = 'FN_FRMO_DIV'
                                 join D_FED_NSI_VERS v on v.ID = fd.VERS
                                 join D_FED_NSI n on n.LAST_VERS = v.ID and n.UNITCODE = 'FN_FRMO_DIV'
                           where emp.DIVISION_ID = s.UNIT_ID
                             and s.UNITCODE = 'DIVISIONS'
                        ) DEPART_OID
                        , case when es.SGN_HASH is not null and ( (select D_PKG_EX_SYSTEM_VALUES.GET_VAL(null, 'remd/mis', 'EMDR_ID', 'EHR_STATES', es.ID) from dual) is not null
                                                                   or (select D_PKG_EX_SYSTEM_VALUES.GET_VAL(null, 'remd/mis', 'REMD_ERRORS', 'EHR_STATES', es.ID) from dual) is not null
                                                                      and (select D_PKG_EX_SYSTEM_VALUES.GET_VAL(null, 'remd/mis', 'REMD_ERRORS', 'EHR_STATES', es.ID) from dual) like '%уже зарегистрирован%')
                                 then 'Зарегистрирован в РЭМД'
                               when es.SGN_HASH is not null and (select D_PKG_EX_SYSTEM_VALUES.GET_VAL(null, 'remd/mis', 'REMD_ERRORS', 'EHR_STATES', es.ID) from dual) is not null
                                 then 'Не зарегистрирован в РЭМД'
                               when es.SGN_HASH is not null and D_PKG_EX_SYSTEM_VALUES.GET_VAL(null, 'remd/mis', 'MESSAGE_ID', 'EHR_STATES', es.ID) is not null
                                 then 'Отправлен на регистрацию в РЭМД'
                               when es.SGN_HASH is not null and (select INT_PKG_IEMK_EXP.GET_EX_VAL('EXPDATE', 'EHR_STATES', es.ID) from dual) is null
                                 then 'Подписан'
                           end STATUS
                  from (
                        /* все закрытые карты медосмотра с типом "Диспансеризация" + "Профосмотр"  */
                        select pc.ID,
                               pc.LPU,
                               pc.EMPLOYER,
                               pc.PERSMEDCARD PATIENT,
                               null AGENT,
                               trunc(pc.DATE_E) DATE_N,
                               'Сведения о результатах диспансеризации или профилактического медицинского осмотра' DOC_TYPE
                          from D_PROF_CARD pc
                               join D_PROF_CARD_TYPES pct on pc.PROF_CARD_TYPE = pct.ID
                         where trunc(pc.DATE_E) between to_date(:DATE_BEGIN, 'dd.mm.yyyy') and to_date(:DATE_END, 'dd.mm.yyyy')
                           and pct.PCT_CODE in (2,6,4,5) /*6 Диспансеризация, 2	Профосмотр*/
                           and pc.DATE_E is not null
                           and pc.PAYMENT_KIND = 20319110	/*1	ОМС*/

                       union all
                        /* ИБ + ИР*/
                        select hh.ID,
                               hh.LPU,
                               hhd.HEALING_EMP EMPLOYER,
                               hh.PATIENT,
                               null AGENT,
                               trunc(hh.DATE_OUT) DATE_N,
                               case when hh.HH_TYPE is null then 'Эпикриз в стационаре выписной (ИБ)' else 'Выписной эпикриз из роддома (ИР)' end DOC_TYPE
                          from D_HOSP_HISTORIES hh
                               join D_HPK_PLAN_JOURNALS hpj on hpj.ID = hh.HPK_PLAN_JOURNAL
                               join D_HOSP_HISTORY_DEPS hhd on hhd.PID = hh.ID and hhd.IS_LAST = 1
                         where trunc(hh.DATE_OUT) between to_date(:DATE_BEGIN, 'dd.mm.yyyy') and to_date(:DATE_END, 'dd.mm.yyyy')
                           and (hh.HH_TYPE is null or hh.HH_TYPE = 1 /*История родов*/)
                           and hh.DISCARD_STATUS = 0
                           and hpj.PAYMENT_KIND = 20319110	/*1	ОМС*/

                         union all

                        /*МСЭ*/
                        select vis.ID,
                               vis.LPU,
                               vis.EMPLOYER,
                               pc.PERSMEDCARD PATIENT,
                               null AGENT,
                               trunc(vis.VISIT_DATE) DATE_N,
                               'МСЭ' DOC_TYPE
                          from D_VISITS vis
                               join D_DIRECTION_SERVICES ds on ds.ID = vis.PID
                               join D_PROF_CARD_DIR_SERVS pcds on pcds.DIR_SERV = ds.ID
                               join D_PROF_CARD_SERVICES pcs on pcs.ID = pcds.PID
                               join D_PROF_CARD pc on pc.ID = pcs.PID
                               join D_SERVICES serv on serv.ID = ds.SERVICE
                               join D_PROF_CARD_TYPES pct on pc.PROF_CARD_TYPE = pct.ID
                         where trunc(vis.VISIT_DATE) between to_date(:DATE_BEGIN, 'dd.mm.yyyy') and to_date(:DATE_END, 'dd.mm.yyyy')
                           and pct.PCT_CODE = 9 /*Направление на МСЭ*/
                           and serv.SE_CODE in ( '1.МСЭК' , '1.МСЭК.36н', '1.МСЭК.6')
                           and ds.PAYMENT_KIND = 20319110	/*1	ОМС*/

                         union all

                          /* все оказанные услуги с типом "Исследование" + "Посещение" (поликлинический случай + приёмны покой) */
                        select vis.ID,
                               vis.LPU,
                               vis.EMPLOYER,
                               d.PATIENT,
                               null AGENT,
                               trunc(vis.VISIT_DATE) DATE_N,
                               case serv.SE_KIND when 6218091882 /*вид услуги - Результат ПАО*/ then 'Протокол прижизненного патологоанатомического исследования'
                                 else case serv.SE_TYPE when 0 then case when dis.DC_TYPE != 1 and dis.DC_TYPE != 2 then 'Инструментальные' end
                                                        when 3 then case when dis.DC_TYPE != 1 and dis.DC_TYPE != 2 and dis.DC_TYPE != 3 and serv.SE_CODE not in ('000010','000011') then 'Консультации'
                                                                         when dis.DC_TYPE != 1 and dis.DC_TYPE != 2 and dis.DC_TYPE != 3 and serv.SE_CODE in ('000010','000011') then 'Прием фельдшера'
                                                                    end
                                                        when 10 then case when dis.DC_TYPE = 0 then 'Телемедицина' end
                                                        when 9 then case when dis.DC_TYPE != 1 and dis.DC_TYPE != 2 and serv.SE_CODE = 'SPRAVKA_SPORT' then 'Медицинское заключение об отсутствии противопоказаний к занятию определенными видами спорта'
                                                                         when serv.SE_CODE = 'ВКК09' then 'Заключение лечебного учреждения о нуждаемости престарелого гражданина в постоянном постороннем уходе'
                                                                         when serv.SE_CODE = 'PVO' then 'Заключение о выявлении факта поствакцинального осложнения'
                                                                         when serv.SE_CODE = 'СКК Д' then 'Санаторно-курортная карта для детей'
                                                                         when serv.SE_CODE = 'СКК' then 'Санаторно-курортная карта'
                                                                    end
                                                        when 4 then case when serv.SE_CODE = 'СТ 02Э 530' then 'Этапный эпикриз' end
                                      end
                               end DOC_TYPE
                          from D_VISITS vis
                               join D_DIRECTION_SERVICES ds on ds.ID = vis.PID
                               join D_SERVICES serv on serv.ID = ds.SERVICE
                               join D_DIRECTIONS d on d.ID = ds.PID
                               join D_PERSMEDCARD pmc on pmc.ID = d.PATIENT                   -- Карта пациента
                               join D_AGENTS pa on pa.ID = pmc.AGENT
                               join D_DISEASECASES dis on ds.DISEASECASE = dis.ID
                               join D_V_EMPLOYERS emp on emp.ID = vis.EMPLOYER and emp.SNILS not in ('01201559484','14773820488', '15388915712', '23457140252')
                         where trunc(vis.VISIT_DATE) between to_date(:DATE_BEGIN, 'dd.mm.yyyy') and to_date(:DATE_END, 'dd.mm.yyyy')
                           and ds.SERV_STATUS = 1
                           and ds.PAYMENT_KIND = 20319110	/*1	ОМС*/
                           and ((serv.SE_TYPE = 0 /*Исследование*/
                                or serv.SE_TYPE = 3 /*Посещение*/
                                or serv.SE_TYPE = 10 /*Телемедицина */
                                or serv.SE_TYPE = 9 /* Документ */
                                or serv.SE_KIND = 6218091882 /*вид услуги - Результат ПАО*/ )
                                and serv.SE_CODE not in ( 'ONCO_CONS',
                                                         'VIPISKA_SMP',
                                                         'VIPISKA_VMP',
                                                         'B01.034.01',
                                                         'A08.20.017.002',
                                                         '0001_n',
                                                         'B04.014.004',
                                                         'B04.014.004.001',
                                                         'A13.29.003.001',
                                                         'A13.29.006.001',
                                                         'A26.20.012.002'
                                                         )
                                  or serv.SE_TYPE = 4 /*Осмотр*/ and serv.SE_CODE = 'СТ 02Э 530' /*Этапный эпикриз по 530 приказу*/
                              )
                           and MONTHS_BETWEEN(sysdate,pa.BIRTHDATE) > 1

                         union all

                         /* все выданные свидетельства о смерти. Врач в данном случае, это выдавший сотрудник. Учет ? Учет медицинских свидетельств ? Журнал выданных свидетельств  */
                        select dc.ID,
                               dc.LPU,
                               dc.GIVEN_OUT_EMP EMPLOYER,
                               null PATIENT,
                               dc.AGENT,
                               trunc(cf.DATE_OUT) DATE_N,
                               'МСС' DOC_TYPE
                          from D_CERTIFICATE_FORMS cf -- Бланки медицинских свидетельств
                               join D_CF_DEATH_CONTENTS dc on dc.PID = cf.ID
                         where trunc(cf.DATE_OUT) >= to_date(:DATE_BEGIN,'dd.mm.yyyy') and trunc(cf.DATE_OUT) <= to_date(:DATE_END,'dd.mm.yyyy')
                           and dc.DIR_EMPLOYMENT is not null
                           and dc.DIR_EDUCATION is not null
                           and dc.DIR_MARITAL_S is not null
                           and dc.DIR_PLACE is not null
                           and dc.DIR_REASON_SET is not null
                           and cf.C_STATE = 4 /*выдан*/

                         union all

                         /* все выданные свидетельства перинатальной смерти. Врач в данном случае, это выдавший сотрудник. Учет ? Учет медицинских свидетельств ? Журнал выданных свидетельств */
                        select dc.ID,
                               dc.LPU,
                               dc.GIVEN_OUT_EMP EMPLOYER,
                               null PATIENT,
                               dc.AGENT,
                               trunc(cf.DATE_OUT) DATE_N,
                               'МСПС' DOC_TYPE
                          from D_CERTIFICATE_FORMS cf -- Бланки медицинских свидетельств
                               join D_CF_PERDEATH_CONTENTS dc on dc.PID = cf.ID -- Бланки медицинских свидетельств: Содержание свидетельств перинатальной смерти
                         where trunc(cf.DATE_OUT) >= to_date(:DATE_BEGIN,'dd.mm.yyyy') and trunc(cf.DATE_OUT) <= to_date(:DATE_END,'dd.mm.yyyy')
                           and dc.DIR_EMPLOYMENT is not null
                           and dc.DIR_EDUCATION is not null
                           and dc.DIR_MARITAL_S is not null
                           and dc.DIR_PLACE is not null
                           and dc.DIR_REASON_SET is not null
                           and cf.C_STATE = 4 /*выдан*/

                         union all

                         /* все выданные свидетельства о рождении. Врач в данном случае, это выдавший сотрудник. */
                        select bc.ID,
                               bc.LPU,
                               bc.GIVEN_OUT_EMP EMPLOYER,
                               null PATIENT,
                               bc.M_AGENT_ID AGENT,
                               trunc(cf.DATE_OUT) DATE_N,
                               'МСР' DOC_TYPE
                          from D_CERTIFICATE_FORMS cf
                               join D_V_CF_BIRTH_CONTENTS bc on bc.PID = cf.ID
                         where trunc(cf.DATE_OUT) >= to_date(:DATE_BEGIN,'dd.mm.yyyy') and trunc(cf.DATE_OUT) <= to_date(:DATE_END,'dd.mm.yyyy')
                           and cf.C_STATE = 4 /*выдан*/

                         union all

                         /*Все оказанные услуги с типом "Посещение" на которых закрыли ТАП*/
                        select vis.ID,
                               vis.LPU,
                               vis.EMPLOYER,
                               d.PATIENT,
                               null AGENT,
                               trunc(vis.VISIT_DATE) DATE_N,
                               'Эпикриз по законченному случаю амбулаторный' DOC_TYPE
                          from D_DIRECTION_SERVICES ds
                               join D_SERVICES serv on serv.ID = ds.SERVICE
                               join D_DIRECTIONS d on d.ID = ds.PID
				               join D_VISITS vis ON vis.PID = ds.ID
                               join D_DISEASECASES dis on ds.DISEASECASE = dis.ID and dis.DC_TYPE = 0	/*Поликлиника*/
                               join D_AMB_TALON_VISITS atv on atv.VISIT = vis.ID and atv.IS_LAST = 3 /*3 - последний визит среди посещений, и "последний среди всех визитов"*/
                               join D_AMB_TALONS at on at.ID = atv.PID and at.IS_CLOSE = 1 and at.IS_AUTO = 1 and at.EDIT_EMPLOYER is null
                             -- join D_V_EMPLOYERS emp on emp.ID = vis.EMPLOYER
                         where trunc(vis.VISIT_DATE) between to_date(:DATE_BEGIN, 'dd.mm.yyyy') and to_date(:DATE_END, 'dd.mm.yyyy')
                           and ds.PAYMENT_KIND = 20319110  /*1	ОМС*/
                           and ds.SERV_STATUS = 1
                           and serv.SE_TYPE = 3 /*Посещение*/
										and serv.SE_CODE not in ( 'ONCO_CONS',
                                                     'VIPISKA_SMP',
                                                     'VIPISKA_VMP',
                                                     'B01.034.01',
                                                     'A08.20.017.002',
                                                     '0001_n',
                                                     'B04.014.004',
                                                     'B04.014.004.001',
                                                     'A13.29.003.001',
                                                     'A13.29.006.001',
                                                     'A26.20.012.002'
                                                   )

                         union all

                        select t10.ID,
                               t10.LPU,
                               t10.VALIDATION_EMP_ID EMPLOYER,
                               t10.PATIENT,
                               null AGENT,
                               t10.DATE_N,
                               'Лаборатория' DOC_TYPE
                          from (
                                 select ls.ID, trunc(ls.COLLECT_DATE) DATE_N, lsd.LPU , ldl.VALIDATION_EMP_ID, d.PATIENT, ldl.VALIDATION_DATE
                                   from D_V_LABMED_DIRECTION_LINE ldl
                                        join D_DIRECTION_SERVICES ds on ds.ID = ldl.DIR_SERV_ID
                                        join D_SERVICES serv on serv.ID = ds.SERVICE
                                        join D_DIRECTIONS d on d.ID = ds.PID
                                        left join D_OUTER_DIRECTIONS od on od.REPRESENT_DIRECTION = d.ID
                                        join D_LBM_SAMPLE_DIRLINE lsd on lsd.DIRLINE = ldl.ID and lsd.IS_REJECTED = 0 and lsd.IS_ALIKVOTE = 0
                                        join D_LABMED_SAMPLES ls on ls.ID = lsd.PID
                                        join D_LABMED_RSRCH_JOURSP lrj on lrj.DIR_LINE = ldl.ID
                                        join D_LABMED_RSRCH_JOUR rj on rj.ID = lrj.PID
                                        join D_LABMED_PATJOUR pj on pj.ID = rj.PATJOUR
                                        join D_DIRECTION_SERVICES dv on dv.ID = pj.DIRECTION_SERVICE
                                        join D_PERSMEDCARD pmc on pmc.ID = d.PATIENT -- Карта пациента
                                        join D_AGENTS pa on pa.ID = pmc.AGENT
                                  where ldl.STATUS_ID = 5
                                    and ldl.RTYPE in (0,1) -- (Тип исследования = 0 - стандартное  1 - микробиологическое, 2 - гистологическое, 4 - цитологическое)
                                    and dv.PAYMENT_KIND = 20319110	/*1	ОМС*/
                                    and MONTHS_BETWEEN(sysdate,pa.BIRTHDATE) > 1
                                    and trunc(ls.COLLECT_DATE) between trunc(to_date(:DATE_BEGIN,'dd.mm.yyyy')) and trunc(to_date(:DATE_END,'dd.mm.yyyy')) /*Дата взятия образца*/
                                    and od.ID is null
                                    and serv.SE_CODE not in (
										'A26.21.047',
										'A26.20.017',
										'A26.25.004',
										'A26.01.023',
										'A26.01.022',
										'A26.07.006',
										'A26.21.014',
										'A26.21.047.',
										'A26.20.017.',
										'A26.25.004.',
										'A26.01.023.',
										'A26.01.022.',
										'A26.07.006.',
										'A26.21.014.')
                                  -- and ls.COLLECT_DATE between to_date(:DATE_BEGIN||'00:01', 'dd.mm.yyyy hh24:mi') and to_date(:DATE_END||'23:59', 'dd.mm.yyyy hh24:mi')
                                  --  and lrj.IS_ACTUAL = 1
                                 group by ls.ID, trunc(ls.COLLECT_DATE), lsd.LPU , ldl.VALIDATION_EMP_ID, d.PATIENT, ldl.VALIDATION_DATE
                             ) t10

                       ) t
                         join D_V_EMPLOYERS emp on emp.ID = t.EMPLOYER /*	and emp.SNILS not in ('','')*/
                         left join D_PERSMEDCARD pmc on pmc.ID = t.PATIENT --and t.PATIENT is not null
                         join D_AGENTS ag on ag.ID = coalesce(pmc.AGENT, t.AGENT)
                         left join D_EHRS e on e.UNIT_ID = t.ID
                                           --and e.UNIT = 'VISITS'
                                           and e.DOC_TYPE in (141   /* Сведения о результатах диспансеризации или профилактического медицинского осмотра*/
                                                              , 122 /*Сведения о результатах диспансеризации или профилактического медицинского осмотра. Редакция 2*/
                                                              ,194 /*Медицинское заключение по результатам предварительного (периодического) медицинского осмотра (обследования). Редакция 2*/
                                                              , 4   /*8 - Эпикриз в стационаре выписной*/
                                                              , 36  /*17 - Выписной эпикриз из родильного дома*/
                                                              , 24  /*Направление на медико-социальную экспертизу*/
                                                              , 34  /*Направление на медико-социальную экспертизу (Редакция 6)*/
                                                              , 71  /*Медицинское заключение об отсутствии противопоказаний к занятию определенными видами спорта*/
                                                              , 74  /*Протокол прижизненного патологоанатомического исследования (Редакция 2)*/
                                                              , 37   /* Протокол прижизненного патологоанатомического исследования*/
                                                              , 119 /*Протокол консультации (CDA) Редакция 4*/
                                                              , 7	/*5 - Протокол консультации*/
                                                              , 10 	/*2 - Протокол инструментального исследования*/
                                                              , 110 /*Протокол инструментального исследования (редакция 3)*/
                                                              , 38	/*Протокол телемедицинской консультации*/
                                                              , 111 /*Протокол консультации в рамках диспансерного наблюдения (CDA) Редакция 4*/
                                                              , 353	/*13-1 - Документ, подтверждающий содержание медицинского свидетельства о смерти в форме электронного документа*/
                                                              , 13  /*13 - Медицинское свидетельство о смерти*/
                                                              , 354 /*19-1 - Документ, подтверждающий содержание медицинского свидетельства о перинатальной смерти в форме электронного документа*/
                                                              , 14  /*19 - Медицинское свидетельство о перинатальной смерти*/
                                                              , 363 /*Медицинское свидетельство о рождении в бумажной форме*/
                                                              , 12	/*Медицинское свидетельство о рождении*/
                                                              , 75  /*Протокол лабораторного исследования (4 редакция)*/
                                                              , 6	/*3 - Протокол лабораторного исследования*/
                                                              , 3	/*12 - Эпикриз по законченному случаю амбулаторный*/
                                                              , 92 /*Эпикриз по законченному случаю амбулаторный (CDA) Редакция 4*/
                                                              , 194 /*Медицинское заключение по результатам предварительного (периодического) медицинского осмотра (обследования). Редакция 2*/
                                                              , 133 /*Этапный эпикриз (CDA) Редакция 1*/
                                                              , 178	/*Санаторно-курортная карта. Редакция 2*/
                                                              , 179	/*Санаторно-курортная карта для детей. Редакция 2*/
                                                              , 142	/*Заключение о выявлении факта поствакцинального осложнения. Редакция 1*/
                                                              , 143	/*Заключение лечебного учреждения о нуждаемости престарелого гражданина в постоянном постороннем уходе. Редакция 1*/
                                                             )
                                           and e.EX_SYSTEM = 3907302620	/*remd/mis	Сервис регистрации документов в РЭМД*/
                         left join D_EHR_STATES es on es.PID = e.ID
                                                  and es.SGN_HASH is not null
                                                  and ((select D_PKG_EX_SYSTEM_VALUES.GET_VAL(null, 'remd/mis', 'EMDR_ID', 'EHR_STATES', es.ID) from dual) is not null
                                                        or (select D_PKG_EX_SYSTEM_VALUES.GET_VAL(null, 'remd/mis', 'REMD_ERRORS', 'EHR_STATES', es.ID) from dual) is not null
                                                        or D_PKG_EX_SYSTEM_VALUES.GET_VAL(null, 'remd/mis', 'MESSAGE_ID', 'EHR_STATES', es.ID) is not null
                                                        or (select INT_PKG_IEMK_EXP.GET_EX_VAL('EXPDATE', 'EHR_STATES', es.ID) from dual) is null)
                        where (D_PKG_AGENT_SOCIAL_STATES.GET_ACTUAL_ON_DATE(ag.ID,trunc(t.DATE_N),'SOC_NAME') is null
                               or lower(D_PKG_AGENT_SOCIAL_STATES.GET_ACTUAL_ON_DATE(ag.ID,trunc(t.DATE_N),'SOC_NAME')) != 'бомж')
                         /* and ag.SNILS is not null
                          and exists (select p.CITIZENSHIP_A2
                                        from D_V_AGENT_PERSDOCS p
                                       where p.PID = ag.ID
                                         and (p.PERIOD_END is null or trunc(p.PERIOD_END) >= trunc(sysdate))
                                         and p.CITIZENSHIP_A2 = 'RU')	*/

                ) t1
                )
 where RN = 1
 group by LPU,
          EMP_FIO_NAME,
          JOBTITLE,
          DATE_N,
          DOC_TYPE,
          DEPART_NAME,
          DEPART_OID
) full join SEMD_CREATE_DATE on LPU_P = LPU
                            and EMP_FIO_NAME = CREATED_BY_FIO
                            and DEPART_NAME = DEP_NAME
                            and DATE_N = DATE_N_SEMD
                            and DOC_TYPE = DOC_TYPE_NAME
