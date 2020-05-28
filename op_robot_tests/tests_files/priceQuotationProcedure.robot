*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${MODE}             priceQuotation
@{USED_ROLES}       tender_owner  provider  provider1  provider2  viewer
@{USED_PROVIDERS}   provider  provider1  provider2
${RESOURCE}         tenders

${NUMBER_OF_ITEMS}  ${1}
${NUMBER_OF_LOTS}   ${1}
${NUMBER_OF_MILESTONES}  ${0}
${TENDER_MEAT}      ${False}
${LOT_MEAT}         ${False}
${ITEM_MEAT}        ${False}
${MOZ_INTEGRATION}  ${False}
${VAT_INCLUDED}     ${True}
${ROAD_INDEX}       ${False}
${GMDN_INDEX}       ${False}
${PLAN_TENDER}      ${True}
${PROFILE}          ${True}

*** Test Cases ***
Неможливість оголосити тендер з tenderPeriod:endDate < 2 робочих дні
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_wrong_date  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Set Test Variable  ${WRONG_TENDER_DATE}  ${True}
  Run Keyword And Expect Error  *  Можливість оголосити тендер


Можливість оголосити тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      find_tender  level1
  ...      critical
  Можливість знайти тендер по ідентифікатору для усіх користувачів


Відображення заголовку тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title тендера для користувача ${viewer}


Відображення опису тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      non-critical
  Звірити відображення поля description тендера для користувача ${viewer}


Відображення валюти тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_value  level2
  ...      non-critical
  Звірити відображення поля value.currency тендера для користувача ${viewer}


Відображення ПДВ в бюджеті тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_value  level2
  ...      non-critical
  Звірити відображення поля value.valueAddedTaxIncluded тендера для користувача ${viewer}



Відображення дати початку доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_deliveryDate  level2
  ...      non-critical
  Звірити відображення дати deliveryDate.startDate усіх предметів для користувача ${viewer}


Відображення дати кінця доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_deliveryDate  level2
  ...      non-critical
  Звірити відображення дати deliveryDate.endDate усіх предметів для користувача ${viewer}


Відображення кількості номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_quantity  level2
  ...      non-critical
  Звірити відображення поля quantity усіх предметів для користувача ${viewer}


Неможливість змінити дату закінчення періоду подання пропозиції на 1 день після публікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Неможливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      extend_tendering_period  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${endDate}=  add_minutes_to_date  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod.endDate}  1
  Перевірити неможливість зміни поля tenderPeriod.endDate тендера на значення ${endDate} для користувача ${tender_owner}


Відображення зміни закінчення періоду прийому пропозицій тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      extend_tendering_period  level2
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення дати tenderPeriod.endDate тендера для усіх користувачів


Можливість пройти процедуру валідації
  [Tags]   ${USERS.users['${viewer}'].broker}: Валідація тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      successfully_tender_validation  level1
  ...      critical
  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}


Можливість подати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію priceQuotation користувачем ${provider}


Можливість зменшити пропозицію на 5% першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      modify_bid_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість зменшити пропозицію до 95 відсотків користувачем ${provider}


Можливість завантажити документ в пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ в пропозицію користувачем ${provider}


Можливість змінити документацію цінової пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію цінової пропозиції користувачем ${provider}


Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію priceQuotation користувачем ${provider1}


Можливість дочекатись дати початку періоду кваліфікації
  [Tags]  ${USERS.users['${provider}'].broker}: Подання кваліфікації
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     awardPeriod_startDate
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку періоду кваліфікації  ${provider}  ${TENDER['TENDER_UAID']}


Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_add_doc_to_first_award
  ...  critical
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії   ${file_path}   ${TENDER['TENDER_UAID']}   0
  Remove File  ${file_path}


Можливість відхилити постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_reject_first_award
  ...  critical
  Run As  ${tender_owner}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  0


Можливість дискваліфікуватися постачальником
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  provider
  ...  provider1
  ...  provider2
  ...  disqualification_first_award
  ...  critical
  ${user}=  Пошук постачальника пропозиції з awards по індексу  0
  Run As  ${user}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  0


Можливість кваліфікувати постачальником другої пропозиції
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  provider
  ...  provider1
  ...  provider2
  ...  qualification_approve_second_award_by_provider
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${user}=  Пошук постачальника пропозиції з awards по індексу  1
  Run As  ${user}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  1


Відображення статусу завершення, якщо не було подано коректного профайлу
  [Tags]   ${USERS.users['${viewer}'].broker}: Завершення тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      unsuccessfully_tender_verification_wrong_profile  level1
  ...      critical
  Дочекатися припинення процесу  ${viewer}  ${TENDER['TENDER_UAID']}


Відображення статусу завершення, якщо не було подано жодних пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Завершення тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      unsuccefully_tender_without_bids  level1
  ...      critical
  Дочекатись зміни статусу unsuccessful  ${viewer}  ${TENDER['TENDER_UAID']}


Можливість редагувати вартість угоди без урахування ПДВ
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract_amount_net
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  ${amount_net}=  create_fake_amount_net  ${award.value.amount}  ${award.value.valueAddedTaxIncluded}  ${contract.value.valueAddedTaxIncluded}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_amount_net=${amount_net}
  Run As  ${tender_owner}  Редагувати угоду
  ...      ${TENDER['TENDER_UAID']}
  ...      ${contract_index}
  ...      value.amountNet
  ...      ${amount_net}


Можливість редагувати вартість угоди
  ${viewer_data}=  Get From Dictionary  ${USERS.users}  ${viewer}
  ${tender_owner_data}=  Get From Dictionary  ${USERS.users}  ${tender_owner}
  [Tags]   ${tender_owner_data.broker}: Редагування угоди
  ...      tender_owner
  ...      ${tender_owner_data.broker}
  ...      modify_contract_value
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  ${amount}=  create_fake_amount  ${award.value.amount}  ${award.value.valueAddedTaxIncluded}  ${contract.value.valueAddedTaxIncluded}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_amount=${amount}
  Run As  ${tender_owner}  Редагувати угоду
  ...      ${TENDER['TENDER_UAID']}
  ...      ${contract_index}
  ...      value.amount
  ...      ${amount}


Можливість укласти угоду для закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      contract_sign  level1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Run As  ${tender_owner}  Підтвердити підписання контракту  ${TENDER['TENDER_UAID']}  ${contract_index}


Відображення статусу підписаної угоди з постачальником закупівлі
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_sign
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Run As  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити відображення поля contracts[${contract_index}].status тендера із active для користувача ${viewer}


Відображення статусу успішного завершення тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      agreement_registration
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status тендера із complete для користувача ${viewer}


*** Keywords ***
Пошук постачальника пропозиції з awards по індексу
    [Arguments]  ${index}
    :FOR  ${user_role}  IN  @{USED_PROVIDERS}
    \  ${user_name}=  Get Variable Value  ${BROKERS['${BROKER}'].roles['${user_role}']}
    \  ${bid_id}=  Отримати дані із тендера  ${user_name}  ${TENDER['TENDER_UAID']}  awards[${index}].bid_id
    \  ${bid_id_by_user}=  Get Variable Value  ${USERS.users['${user_name}'].bidresponses.bid.data.id}
    \  Exit For Loop If  '${bid_id}' == '${bid_id_by_user}'
    [Return]  ${user_name}