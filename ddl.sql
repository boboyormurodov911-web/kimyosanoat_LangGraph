create table public.agro_fertilizer_demand -- O'gitlarga bo'lgan talablar haqidagi ma'lumotlarni faqatgina public.crop jadvalidan, yetkazilgan o'g'itlar bo'yicha esa public.sold_lot jadvalidan ma'lumot olish kerak! Viloyat va tuman bo'yicha o'g'itlar miqdori yoki qoldig'i so'ralganda public.warehouse_amount jadvalidan foydalanish kerak!
(
    id                 bigint       not null 
        primary key,
    create_by          bigint,
    datetime_created   timestamp(6) not null,
    datetime_updated   timestamp(6) not null,
    amofos_amount      double precision,
    amofos_delivery    double precision,
    boshqalar_delivery double precision,
    district_name      varchar(255),
    farmer_name        varchar(255),
    harvest_name       varchar(255),
    has_farmer_data    boolean,
    karbamid_amount    double precision,
    karbamid_delivery  double precision,
    outline_bonitet    double precision,
    region_name        varchar(255)
        constraint ekw83ksd82jvm32hsjfu2h8w
            references public.region(name_uz),
    selitra_amount     double precision,
    selitra_delivery   double precision,
    text_number        bigint,
    total_area         double precision
);

create table public.all_investment  -- Ushbu jadvalda barcha investitsiya loyihalari haqida umumiy ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    text             varchar(255) -- investitsiya loyihasi haqida ma'lumot
);

create table public.argus -- Ushbu jadvalda Argus tizimidan olingan ma'lumotlar saqlanadi (bu tizimda chetga eksport qilingan mahsulotlar haqida ma'lumotlar bor)
(
    id                   bigint       not null -- ID raqam (primary key)
        primary key,
    create_by            bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created     timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated     timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    date                 date, -- sana
    description          varchar(255), -- tavsif
    value                double precision, -- qiymat (narx $)
    short_description    varchar(255) default NULL::character varying, -- qisqa tavsif
    ru_description       varchar(255) default NULL::character varying, -- ruscha tavsif
    ru_short_description varchar(255) default NULL::character varying -- ruscha qisqa tavsif
);

create table public.contract -- Ushbu jadvalda barcha shartnomalarga oid ma'lumotlar saqlanadi
(
    id               bigint       not null -- shartnoma ID raqami (primary key)
        primary key,
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana va vaqt sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    enter_date       varchar(255),
    inn              varchar(255) -- shartnoma qilgan tashkilot inn raqami (organization jadvalidagi inn ustuni bilan bog'langan)
        constraint ggheitnsnbiekjwi2dk
            references public.organization(inn),
    lot              varchar(255), -- lot miqdori
    lot_name         varchar(255), -- lot nomi
    measure_unit     varchar(255), -- o'lchov birligi
    name             text, -- shartnoma nomi
    number           varchar(255), -- shartnoma raqami
        constraint askrudghoawekufaweioufa 
            references public.lot(contract_number),
    region           varchar(255), -- shartnoma bo'lgan viloyat nomi
    seller_name      varchar(255), -- sotuvchi tashkilot nomi
    sklad_name       text, -- shartnomadagi ombor nomi
    status           varchar(255), -- shartnoma holati
    inn_sklad        varchar(255), -- shartnomadagi omborning inn raqami
    spets            varchar(255),
    create_by        bigint, -- yaratuvchi (foydalanuvchi) id raqami
    is_deleted       boolean default false -- shartnoma o'chirilgan yoki yo'qligi (true/false)
);

create table public.contract_documents -- Ushbu jadvalda shartnoma hujjatlari haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    article          varchar(255), -- harajat nomi
    bases            varchar(255), -- shartnoma asoslari
    contr_agent      varchar(255), -- shartnoma bo'yicha kontragent
    contract_type    varchar(255), -- shartnoma turi
    description      text, -- shartnoma tavsifi
    document_amount  double precision, -- shartnoma miqdori
    document_date    timestamp(6), -- hujjat sanasi
    document_number  varchar(255), -- hujjat raqami
    expiry_date      timestamp(6), -- hujjat amal qilish muddati
    payment_percent  double precision, -- to'lov foizi
    supplier         varchar(255), -- yetkazib beruvchi
    c1id             varchar(255) -- shartnoma hujjatining 1C tizimidagi ID raqami
        constraint ukehlnfny039rdtadet7kha0usj
            unique,
    organization_id  bigint, -- tashkilot ID raqami (organization jadvalidagi id ustuni bilan bog'langan)
    article1cid      varchar(255), -- harajatning 1C tizimidagi ID raqami
    article_code     varchar(255) -- harajat kodi
);

create table public.country_code -- Ushbu jadvalda mamlakatlar kodlari haqida ma'lumotlar saqlanadi (Mamlakatlar nomlarini tanlashda short_name ustunidan foydalanish kerak!)
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    alpha2           varchar(255), -- mamlakat kodi (2 harfli)
    alpha3           varchar(255), -- mamlakat kodi (3 harfli)
    code             varchar(255), -- mamlakat kodi
    long_name        varchar(255), -- mamlakatning to'liq nomi
    short_name       varchar(255), -- mamlakatning qisqa nomi
    create_by        bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.crop -- Ushbu jadvalda fermer xo'jaliklarining ekinlari haqida ma'lumotlar saqlanadi (o'g'itlarga bo'lgan talabni hisoblash uchun shu formula asosida hisoblash kerak -> sum(bonitet koeffitsiyenti * ekin bo'yicha baza normasi * ekin maydoni))
(
    id                             bigint       not null -- id raqam (primary key)
        primary key,
    datetime_created               timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated               timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    area                           varchar(255), -- ekin maydoni (javobni 1000 ga bo'lib chiqarish kerak -> (SUM(CAST(area AS DOUBLE PRECISION)) / 1000.0, 2))
    crop_id                        bigint, -- ekin id raqami
    cropagro_link                  varchar(255), -- https://crop2.agro.uz tizimidagi havola
    farmer_cad_number              varchar(255), -- fermer xo'jaligi kadastr raqami
    farmer_tax_number              bigint, -- fermer xo'jaligi soliq raqami
    harvest_code                   bigint, -- hosil kodi
    harvest_generation_code        integer, -- hosil avlodi kodi
    harvest_generation_name        varchar(255), -- hosil avlodi nomi
    harvest_name                   varchar(255), -- hosil nomi. ekin bo'yicha baza normasi -> (case when lower(c.harvest_name) like '%paxta%' or lower(c.harvest_name) like '%cotton%' or lower(c.harvest_name) like '%хлопок%' then 230 when lower(c.harvest_name) like '%bug''doy%' or lower(c.harvest_name) like '%bugdoy%' or lower(c.harvest_name) like '%wheat%' or lower(c.harvest_name) like '%пшеница%' then 240 when lower(c.harvest_name) like '%kartoshka%' or lower(c.harvest_name) like '%potato%' or lower(c.harvest_name) like '%картошка%' then 180 else 230 end), fosforli o'g'itlarga bo'lgan talabni hisoblash uchun -> (case when lower(c.harvest_name) like '%paxta%' or lower(c.harvest_name) like '%cotton%' or lower(c.harvest_name) like '%хлопок%' then 289 when lower(c.harvest_name) like '%bug''doy%' or lower(c.harvest_name) like '%bugdoy%' or lower(c.harvest_name) like '%wheat%' or lower(c.harvest_name) like '%пшеница%' then 200 when lower(c.harvest_name) like '%kartoshka%' or lower(c.harvest_name) like '%potato%' or lower(c.harvest_name) like '%картошка%' then 250 else 289 end), kaliyli o'g'itlarga bo'lgan talabni hisoblash uchun esa -> (case when lower(c.harvest_name) like '%paxta%' or lower(c.harvest_name) like '%cotton%' or lower(c.harvest_name) like '%хлопок%' then 150 when lower(c.harvest_name) like '%bug''doy%' or lower(c.harvest_name) like '%bugdoy%' or lower(c.harvest_name) like '%wheat%' or lower(c.harvest_name) like '%пшеница%' then 300 when lower(c.harvest_name) like '%kartoshka%' or lower(c.harvest_name) like '%potato%' or lower(c.harvest_name) like '%картошка%' then 300 else 150 end). foydalanuvchi o'g'it nomini bermasdan shunchaki o'g'tilarni so'raganda, hamma o'g'itlarni chiqarish kerak -> (azotli o'g'it + kaliyli o'g'it + fosforli o'g'it)
    harvest_sort_code              integer, -- hosil navi kodi
    harvest_sort_name              varchar(255), -- hosil navi nomi
    harvest_type_code              varchar(255), -- hosil turi kodi
    harvest_type_name              varchar(255), -- hosil turi nomi
    harvest_year                   integer, -- hosil yig'ib olingan yili
    outline_bonitet                integer, -- yerning bonitet balli. bonitet koeffitsiyentini hisoblash -> sum((case when c.outline_bonitet >= 80 then 0.8 when c.outline_bonitet between 60 and 79 then 1.0 when c.outline_bonitet between 40 and 59 then 1.15 when c.outline_bonitet < 40 then 1.25 else 1.0 end)
    outline_bonitet_contour_number integer, -- kontur bonitet raqami
    place_category_code            varchar(255), -- yerdan foydalanish toifasining kodi
    place_category_name            varchar(255), -- yerdan foydalanish toifasining nomi
    place_code                     integer, -- foydalaniladigan yer kodi
    place_name                     varchar(255), -- foydalaniladigan yer nomi
    region_code                    integer -- viloyatning tizimdagi kodi (region jadvalining faktura_region_code ustuni bilan bog'langan)
        constraint iopekjwqnbuwnkqj2k4n23q
            references public.region(faktura_region_code),
    region_name                    varchar(255), -- viloyat nomi (region jadvalining name_uz ustuni bilan bog'liq)
    watering                       integer, -- yerning suvlilik darajasi(%)
    district_code                  integer -- tumanning tizimdagi kodi (district jadvalining soato ustuni bilan bog'langan)
        constraint cndiwickw983nn29vn21ljk
            references public.district(soato),
    district_name                  varchar(255), -- tuman nomi
    farmer_name                    varchar(255), -- fermer xo'jaligi nomi
    create_by                      bigint -- yaratuvchi (foydalanuvchi) id raqami
);

create table public.debtor_creditor1c -- Ushbu jadvalda 1C tizimidan olingan debitor va kreditorlar haqida ma'lumotlar saqlanadi (ushbu jadvaldan tashkilotlar va zavodlarga oid savol so'ralganda albatta organization ustuniga join qilish kerak (JOIN organization o ON debtor_creditor1c.organization_id = o.id))
(
    id                     bigint       not null -- ID raqam (primary key)
        primary key,
    date_created           date         not null, -- qarzdorlik yaratilgan sana (debitor va kreditor qarzdorliklarini chiqarishda faqat shu ustundan foydalanish kerak!; bugungi kun ma'lumotlari so'ralganda faqat bugungi kun sanasini olish kerak, bugungi kungacha bo'lgan hammasini emas!)
    datetime_created       timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated       timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    amount                 double precision, -- qarzdorlik summasi (so'm)
    contract               varchar(255), -- shartnoma
    contract_id            uuid, -- shartnoma ID raqami
    currency_amount        double precision, -- valuta miqdori
    currency_code          varchar(255), -- valuta kodi
    inn                    varchar(255), -- ikkinchi taraf tashkilot INN raqami (qarzdorliklarni ko'rish uchun faqat organization_id ustunidan foydalanish kerak)
    last_operation_date    date, -- oxirgi operatsiya sanasi (muddati o'tgan debitor yoki kreditorlik qarzdorligini chiqarish uchun ham shu ustundan foydalaniladi(2 xil turdagi muddati o'tgan qarzdorlik mavjud: 90 kunlik va 60 kunlik); 90 kunlikni xisoblash uchun: last_operation_date < (now()::date - INTERVAL '90 days'); 60 kunlikni xisoblash uchun: last_operation_date < (now()::date - INTERVAL '60 days'))
    name                   varchar(255), -- nomi (nomlar bilgan bog'liq savol kelganda, faqat savol ichidagi nomni ILIKE metodi bilan qidirish kerak oldin berib ketilgan misollar orqali emas!)
    organization_id        bigint, -- tegishli tashkilot yoki zavod ID raqami (organizaiton jadavlining id ustuni bilan bog'langan (tashkilot yoki zavodning debitor yoki kreditor qarzdorliklari so'ralganda nomi bo'yicha organization jadvalining id ustuni bo'yicha JOIN qilib tekshirish kerak; masalan: SELECT SUM(amount) FROM public.debtor_creditor1c dc JOIN organization o ON dc.organization_id = o.id WHERE o.name ILIKE '%Navoiyazot AND dc.type = 'debitor'))
    type                   varchar(255), -- turi (debitor yoki kreditor (bu ustun juda muhim, debitorlik qarzdorliklari so'ralganda 'debitor' qiymati, kreditorlik qarzdorligi so'ralganda 'kreditor' qiymati bilan tekshirish kerak))
    create_by              bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    documents_created_date date -- hujjatlar yaratilgan sana
);

create table public.department_types -- Ushbu jadvalda bo'lim turlari haqida ma'lumotlar saqlanadi
(
    id              bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    created_at      timestamp(6), -- yaratilgan sana va vaqt
    description     varchar(255), -- ta'rif
    organization_id bigint, -- tashkilot ID raqami
    type_name       varchar(255) not null -- bo'lim turi nomi
);

create table public.drivers_info -- Ushbu jadvalda haydovchilar haqida ma'lumotlar saqlanadi
(
    id               bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    created_at       timestamp(6), -- yaratilgan sana va vaqt
    driver_name      varchar(255), -- haydovchi ismi
    phone_number     varchar(255), -- haydovchi telefon raqami
    pinfl            varchar(255) not null -- PINFL
    transport_model  varchar(255), -- transport modeli
    transport_number varchar(255) not null -- transport raqami
        constraint uk9d8061s1io52egsleur8yqmne
            unique,
    updated_at       timestamp(6), -- yangilangan sana va vaqt
    district_id      bigint, -- haydovchi yashaydigan tuman ID raqami
    region_id        bigint -- haydovchi yashaydigan viloyat ID raqami
);

create table public.electric_meters -- Ushbu jadvalda elektr hisoblagichlari haqida ma'lumotlar saqlanadi
(
    id          bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    account_id  varchar(255) not null, -- hisob raqam
    created_at  timestamp(6), -- ma'lumot yozilgan sana
    freeze_date date, -- hisoblagichdan ma'lumot olingan sana
    full_name   varchar(255), -- hisoblagich egasining to'liq ismi
    meter_no    varchar(255) -- hisoblagich raqami (public.organization_meters jadvalining meter_no ustuni bilan bog'langan)
        constraint soqckeibns8ski2301kdkdk
            references public.organization_meters(meter_no),
    p0300       double precision, -- p0300-sonli ko'rsatkich
    p0310       double precision, -- p0310-sonli ko'rsatkich
    p0320       double precision, -- p0320-sonli ko'rsatkich
    p0330       double precision, -- p0330-sonli ko'rsatkich
    p0340       double precision, -- p0340-sonli ko'rsatkich
    p0400       double precision, -- p0400-sonli ko'rsatkich
    p0410       double precision, -- p0410-sonli ko'rsatkich
    p0420       double precision, -- p0420-sonli ko'rsatkich
    p0430       double precision, -- p0430-sonli ko'rsatkich
    p0440       double precision, -- p0440-sonli ko'rsatkich
    p0500       double precision, -- p0500-sonli ko'rsatkich
    p0510       double precision, -- p0510-sonli ko'rsatkich
    p0520       double precision, -- p0520-sonli ko'rsatkich
    p0530       double precision, -- p0530-sonli ko'rsatkich
    p0540       double precision, -- p0540-sonli ko'rsatkich
    p0600       double precision, -- p0600-sonli ko'rsatkich
    p0610       double precision, -- p0610-sonli ko'rsatkich
    p0620       double precision, -- p0620-sonli ko'rsatkich
    p0630       double precision, -- p0630-sonli ko'rsatkich
    p0640       double precision, -- p0640-sonli ko'rsatkich
    rate        integer, -- tarif stavkasi / hisoblagichning ko'paytirish koeffitsienti
    soato       varchar(255) not null -- SOATO kodi
    updated_at  timestamp(6), -- ma'lumot yangilangan sanasi
    constraint uk_meter_no_freeze_date
        unique (meter_no, freeze_date),
    constraint unique_meter_date
        unique (meter_no, freeze_date)
);

create table public.employee_type -- Ushbu jadvalda ishchi turlari haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    name             varchar(255) -- ishchi turi nomi
);

create table public.enakladnoy_shipment_status -- Ushbu jadvalda jo'natma tashish holatlari haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    code             integer, -- jo'natma kodi
    status           text -- jo'natma holati (ustun qiymatllari ruscha, tarjima qilish kerak)
);

create table public.enaklodnoy_shipment -- Ushbu jadvalda enakladnoy tizimidagi jo'natmalar haqida ma'lumotlar saqlanadi
(
    id                   bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created     timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated     timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    create_date          timestamp(6), -- jo'natma yaratilgan sana va vaqt
    delivery_date        timestamp(6), -- jo'natma yetkazib berilgan sana va vaqt
    gu29id               bigint, -- gu29 tizimidagi ID raqami
    is_load              boolean, -- jo'natma yuklangan yoki yo'qligi (true/false)
    loaded_date          timestamp(6), -- jo'natma yuklangan sana va vaqt
    otpravka_number      varchar(255), -- jo'natma raqami
    receive_station_code varchar(255), -- qabul qiluvchi stansiya kodi
    receive_station_name varchar(255), -- qabul qiluvchi stansiya nomi
    receiver_code        integer, -- qabul qiluvchi kodi
    receiver_name        varchar(255), -- qabul qiluvchi nomi
    send_station_code    varchar(255), -- jo'natuvchi stansiya kodi
    send_station_name    varchar(255), -- jo'natuvchi stansiya nomi
    sender_code          integer, -- jo'natuvchi kodi
    sender_name          varchar(255), -- jo'natuvchi nomi
    status_code          integer -- jo'natma holati kodi (enakladnoy_shipment_status jadvalidagi code ustuni bilan bog'langan)
        constraint kw8ckn84nahhh32kd99w
            references public.enakladnoy_shipment_status(code),
    tin                  varchar(255), -- jo'natma TIN raqami
    total_price          double precision, -- jo'natma umumiy narxi
    wagons_count         integer, -- jo'natma vagonlari soni
    weight               double precision, -- jo'natma og'irligi
    create_by            bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.enaklodnoy_wagon -- Ushbu jadvalda enaklodnoy tizimidagi vagonlar haqida ma'lumotlar saqlanadi
(
    id                  bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created    timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated    timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    description         varchar(255), -- vagon tavsifi
    gu12id              bigint, -- gu12 tizimidagi ID raqami
    nomenclature_code   integer, -- nomenklatura kodi
    nomenclature_name   varchar(255), -- nomenklatura nomi
    plan_date           timestamp(6), -- rejalashtirilgan sana
    receive_stations    varchar(255), -- qabul qilish stansiyalari
    send_station_code   varchar(255), -- jo'natuvchi stansiya kodi
    send_station_name   varchar(255), -- jo'natuvchi stansiya nomi
    status_code         integer, -- holat kodi
    tin                 varchar(255), -- vagon TIN raqami
    type                integer, -- vagon turi
    unladen_wagon_count integer, -- bo'sh vagonlar soni
    unladen_weight      double precision, -- bo'sh vagon og'irligi
    wagon_count         integer, -- vagonlar soni
    weight              double precision, -- vagon og'irligi
    create_by           bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.faktura_uz_document -- Ushbu jadvalda faktura.uz platformasidagi hujjatlar haqidagi ma'lumotlar saqlanadi
(
    id                             bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created               timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated               timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    contract                       text, -- shartnoma haqidagi ma'lumot
    contractor_branch_code         varchar(255), -- hujjat berilgan tashkilot filiali
     kodi
    contractor_branch_name         varchar(255), -- hujjat berilgan tashkilot filiali nomi
    contractor_inn                 varchar(255), -- hujjat berilgan tashkilot inn raqami
    contractor_member_branch_code  varchar(255), -- hujjat yaratuvchi tashkilot a'zosi filiali kodi
    contractor_member_branch_name  varchar(255), -- hujjat yaratuvchi tashkilot a'zosi filiali nomi
    contractor_member_inn          varchar(255), -- hujjat yaratuvchi tashkilot a'zosi inn raqami
    contractor_member_name         varchar(255), -- hujjat yaratuvchi tashkilot a'zosi nomi
    contractor_name                varchar(255), -- hujjat berilgan tashkilot nomi
    created_date_time              bigint, -- hujjat yaratilgan sana
    file_name                      varchar(255), -- hujjat fayli nomi
    is_agreement_approved          boolean, -- kelishuv tasdiqlanganligi (true/false)
    is_inbox                       boolean, -- hujjat platformaga kelib tushganligi (true/false)
    is_new                         boolean, -- hujjat yangiligi
    organization_id                bigint, -- tashkilot ID raqami
    organization_inn               varchar(255), -- tashkilot inn raqami
    owner_member_branch_code       varchar(255), -- hujjatga egalik qiluvchi tashkilot a'zosi filiali kodi
    owner_member_branch_name       varchar(255), -- hujjatga egalik qiluvchi tashkilot a'zosi filiali nomi
    owner_member_inn               varchar(255), -- hujjatga egalik qiluvchi tashkilot a'zosi inn raqami
    owner_member_name              varchar(255), -- hujjatga egalik qiluvchi tashkilot a'zosi nomi
    registry_file_name             varchar(255), -- ro'yxatdan o'tkazilgan hujjat fayli nomi
    registry_id                    varchar(255), -- ro'yxatga olish ID raqami
    registry_unique_id             varchar(255), -- takrorlanmas ro'yxatga olish ID raqami
    roaming_uid                    varchar(255), -- 
    status                         integer -- hujjat holati (faktura_uz_documnet_status jadvalidagi status_id ustuniga bog'langan)
        constraint dngueuxnq7uc872ng8s
            references public.faktura_uz_documnet_status(status_id),
    title                          varchar(255), -- hujjat sarlavhasi
    total_price                    varchar(255), -- hujjat umumiy narxi
    type                           integer, -- hujjat turi
    unique_id                      varchar(255), -- hujjatning takrorlanmas ID raqami
    updated_date_time              bigint, -- hujjat yangilangan sana va vaqt
    created_date_time_as_date_time timestamp(6), -- hujjat yaratilgan sana va vaqt
    updated_date_time_as_date_time timestamp(6), 
    create_by                      bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    soliq_status                   varchar(255) -- hujjatning soliq.uz platformasidagi holati
);

create table public.faktura_uz_document_content -- Ushbu jadvalda faktura.uz platformasidagi hujjatlarning mazmuni haqida ma'lumotlar saqlanadi
(
    id                               bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created                 timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated                 timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    accountant                       varchar(255), -- buxgalter
    contract_date                    varchar(255), -- shartnoma sanasi
    contract_number                  text, -- shartnoma raqami
    contractor_account               varchar(255), -- pudratchi hisob raqami
    contractor_accountant            varchar(255), -- pudratchi buxgalteri
    contractor_address               text, -- pudratchi manzili
    contractor_bank                  varchar(255), -- pudratchi banki
    contractor_branch_code           varchar(255), -- pudratchi filiali kodi
    contractor_branch_name           varchar(255), -- pudratchi filiali nomi
    contractor_director              varchar(255), -- pudratchi tashkilot direktori
    contractor_email                 varchar(255), -- pudratchi elektron pochta manzili
    contractor_inn                   varchar(255), -- pudratchi inn raqami
    contractor_mfo                   varchar(255), -- pudratchi mfo raqami
    contractor_name                  varchar(255), -- pudratchi nomi
    contractor_nds_code              varchar(255), -- pudratchi nds(Qo'shimcha Qiymat Solig'i) kodi
    contractor_oked                  varchar(255), -- pudratchi oked(Iqtisodiy faoliyat turlari klassifikatori) kodi
    contractor_okonx                 varchar(255), -- pudratchi okonx(Xalq xo‘jaligi tarmoqlari klassifikatori) kodi
    contractor_phone                 varchar(255), -- pudratchi telefon raqami
    contractor_unit_id               varchar(255), -- pudratchi bo'lim ID raqami
    date_of_issue                    varchar(255), -- chiqarilgan sana
    deliverer                        varchar(255), -- yetkazib beruvchi
    deliverer_inn                    varchar(255), -- yetkazib beruvchi inn raqami
    deliverer_passport_serial_char   varchar(255), -- yetkazib beruvchi pasport seriya raqami
    deliverer_passport_serial_number varchar(255), -- yetkazib beruvchi pasport raqami
    deliverer_roaming_id             varchar(255), -- yetkazib beruvchi roaming ID
    director                         varchar(255), -- tashkilot direktori
    document_date                    varchar(255), -- hujjat sanasi
    document_number                  varchar(255), -- hujjat raqami
    document_valid_date              varchar(255), -- hujjat amal qilish muddati
    document_values_for              varchar(255), -- hujjat qiymatlari
    external_id                      varchar(255), -- tashqi ID raqami
    file                             varchar(255), -- hujjat fayli
    is_new_identity                  boolean, -- yangi identifikator (true/false)
    issued_by                        varchar(255), -- hujjat berilgan joy
    owner_account                    varchar(255), -- egalik qiluvchi hisob raqami
    owner_address                    varchar(255), -- egalik qiluvchi manzil
    owner_bank                       varchar(255), -- egalik qiluvchi banki
    owner_branch_code                varchar(255), -- egalik qiluvchi filial kodi
    owner_branch_name                varchar(255), -- egalik qiluvchi filial nomi
    owner_email                      varchar(255), -- egalik qiluvchi elektron pochta
    owner_inn                        varchar(255), -- egalik qiluvchi inn raqami
    owner_mfo                        varchar(255), -- egalik qiluvchi mfo raqami
    owner_name                       varchar(255), -- egalik qiluvchi nomi
    owner_nds_code                   varchar(255), -- egalik qiluvchi nds(Qo'shimcha Qiymat Solig'i) kodi
    owner_oked                       varchar(255), -- egalik qiluvchi oked(Iqtisodiy faoliyat turlari klassifikatori) kodi
    owner_okonx                      varchar(255), -- egalik qiluvchi okonx(Xalq xo‘jaligi tarmoqlari klassifikatori) kodi
    owner_phone                      varchar(255), -- egalik qiluvchi telefon raqami
    owner_unit_id                    varchar(255), -- egalik qiluvchi bo'lim ID raqami
    position                         varchar(255), -- lavozim
    releaser                         varchar(255), -- chiqaruvchi
    roaming_id                       varchar(255), -- roaming ID
    services_roaming_id              varchar(255), -- xizmatlar roaming ID
    oaming_uid                       varchar(255), -- oaming UID
    unique_id                        varchar(255), -- noyob ID
    roaming_uid                      varchar(255), -- roaming UID
    create_by                        bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.faktura_uz_document_content_product -- Ushbu jadvalda faktura.uz platformasidagi mahsulotlar hujjatlari haqida ma'lumotlar saqlanadi
(
    id                           bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created             timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated             timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    date                         date, -- sana
    organization_id              bigint, -- tashkilot ID raqami
    organization_inn             varchar(255), -- tashkilot INN raqami
    organization_name            varchar(255), -- tashkilot nomi
    price                        double precision, -- mahsulot narxi
    product_mxik_code            varchar(255), -- mahsulot MXIK kodi
    product_mxik_name            text, -- mahsulot MXIK nomi
    quantity                     double precision, -- mahsulot miqdori
    unique_id                    varchar(255), -- noyob ID
    contractor_inn               varchar(255), -- pudratchi INN raqami
    contractor_name              varchar(255), -- pudratchi nomi
    owner_inn                    varchar(255), -- egalik qiluvchi INN raqami
    owner_name                   varchar(255), -- egalik qiluvchi nomi
    delivery_cost                double precision, -- yetkazib berish narxi
    delivery_tax_rate_with_taxes double precision, -- yetkazib berish bo'yicha soliq stavkasi (soliqlar bilan)
    vat_amount                   double precision, -- QQS miqdori
    vat_rate                     integer, -- QQS stavkasi
    invoice_contract_date        date, -- shartnoma cheki sanasi
    invoice_contract_number      varchar(255), -- shartnoma chek raqami
    invoice_date                 date, -- chek sanasi
    invoice_number               varchar(255), -- invoice raqami
    measurement                  varchar(255), -- o'lchov birligi
    create_by                    bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.faktura_uz_documnet_status -- Ushbu jadvalda faktura.uz platformasidagi hujjatlarning holatlari haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    code             varchar(255), -- hujjat kodi
    description      varchar(255), -- hujjat tavsifi
    status_id        integer -- hujjat holati ID raqami (faktura_uz_document jadvalidagi status ustuni bilan bog'langan)
        constraint ckw8n48vcn238hjbui2hj8j
            references public.faktura_uz_document(status),
    create_by        bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.faktura_uz_params -- Ushbu jadvalda faktura.uz platformasiga kirish va ma'lumot olish uchun kerak bo'lgan ma'lumotlar saqlanadi
(
    id                bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created  timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated  timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    inn               varchar(255), -- tashkilot INN raqami
    login             varchar(255), -- foydalanuvchi login
    organization_id   bigint, -- tashkilot ID raqami
    organization_name varchar(255), -- tashkilot nomi
    password          varchar(255), -- foydalanuvchi paroli
    create_by         bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.funding_sources -- Ushbu jadvalda moliyalashtirish manbalari haqida ma'lumotlar saqlanadi
(
    id                    bigint       not null -- ID raqam (primary key)
        primary key,
    create_by             bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created      timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated      timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    source_current_year   double precision, -- joriy yil manbasi
    source_growth_percent double precision, -- manba o'sish foizi
    source_name           varchar(255), -- manba nomi
    source_next_year      double precision, -- kelgusi yil manbasi
    all_investment_id     bigint -- investitsiya ID raqami (all_investment jadvalidagi id ustuni bilan bog'langan)
        constraint fkk3xtniwf4w0jasrrx5sxwxk4g
            references public.all_investment
);

create table public.gov_goods -- Ushbu jadvalda davlatga tegishli tovarlar eksporti va importi haqida ma'lumotlar saqlanadi
(
    id                bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created  timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated  timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    additional_unit   varchar(255), -- qo'shimcha birlik
    code_tiftn        varchar(255) -- mahsulot TIFTN kodi (product_tiftin_code jadvalidagi code ustuni bilan bog'langan)
        constraint ekdgbeusjwgsbq3jhnjh2e
            references public.product_tiftn_code(code),
    date              varchar(255), -- sana
    ekim_country      varchar(255) -- eksport yoki import amalga oshirilgan mamlakat kodi, country_code jadvalidagi code ustuni bilan bog'langan (davlatlar haqida ma'lumotlar so'ralganda country_code jadvaliga JOIN qilib alpha2 ustunini olib davlatninig 2 harfli mamlakat kodi bilan tekshirish kerak -> SELECT SUM(value) FROM public.gov_goods JOIN country_code c on c.code = ekim_country WHERE  c.alpha2 = 'KZ')
        constraint qorlsijnbuen2323884k3sks
            references public.country_code(code),
    mode              varchar(255), -- rejim (ИМ40 - import, ЭК10 - eksport)
    name_goods        text, -- tovar nomi
    net_mass          double precision, -- sof og'irlik
    organization1name varchar(255), -- chet el tashkiloti
    organization2name varchar(255), -- mahalliy tashkilot
    organization_tin  varchar(255) -- tashkilot TIN raqami, organization jadvalidagi inn ustuni bilan bog'langan (tizim tashkilotlariga oid EKSPORT yoki IMPORT haqida so'ralganda organization jadvalidagi inn ustuniga JOIN qilib tekshirish kerak: SELECT SUM(gg.value) FROM public.gov_goods gg JOIN public.organization o ON gg.organization_tin = o.inn WHERE mode = 'ИМ40' yoki SELECT SUM(gg.value) FROM public.gov_goods gg JOIN public.organization o ON gg.organization_tin = o.inn WHERE mode = 'ЭК10')
        constraint soldmwidk4bnidq
            references public.organization(inn),
    purpose           varchar(255), -- maqsad
    unit              varchar(255), -- birlik
    value             double precision, -- qiymat, 1000 ga ko'paytirib dollarda hisoblash kerak ($)
    create_by         bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    date_converted    date -- konvertatsiya qilingan sana
);

create table public.hudud_gaz_gas_meter_info -- Ushbu jadvalda Hudud Gaz kompaniyasining gaz hisoblagichlari haqida ma'lumotlar saqlanadi
(
    id                     bigint       not null -- ID raqam (primary key)
        primary key,
    create_by              bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created       timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated       timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    created_date           date, -- hisoblagich yaratilgan sana
    gas_consume            integer, -- gaz iste'moli
    meter_statuses_name    varchar(255), -- hisoblagich holatlari
    meter_types_name       varchar(255), -- hisoblagich turlari
    org_customer_code      varchar(255), -- mijoz kodi (hudud_gaz_org_customer jadvalidagi org_customer_code ustuni bilan bog'langan)
    org_gas_sensors        varchar(255), -- gaz sensori turi
    org_gas_sensors_id     varchar(255), -- gaz sensori ID raqami
    org_gas_sensors_name   varchar(255), -- gaz sensori nomi
    org_gas_sensors_status varchar(255), -- gaz sensori holati
    reading_date           date, -- o'qish sanasi
    reading_value          varchar(255) -- o'qish qiymati
);

create table public.hudud_gaz_gas_meter_readings -- Ushbu jadvalda Hudud Gaz kompaniyasining gaz hisoblagichlari o'qishlari haqida ma'lumotlar saqlanadi
(
    id                     bigint       not null -- ID raqam (primary key)
        primary key,
    create_by              bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created       timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated       timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    created_date           varchar(255), -- hisoblagich yaratilgan sana
    gas_consume            double precision, -- gaz iste'moli
    meter_statuses_name    varchar(255), -- hisoblagich holatlari
    meter_types_name       varchar(255), -- hisoblagich turlari
    org_customer_code      varchar(255) -- mijoz kodi
        constraint ckw8n48vcn2niwnsa8bnntu
            references public.hudud_gaz_org_customer(org_customer_code),
    org_gas_sensors        varchar(255), -- gaz sensori turi
    org_gas_sensors_id     bigint, -- gaz sensori ID raqami
    org_gas_sensors_name   varchar(255), -- gaz sensori nomi
    org_gas_sensors_status varchar(255), -- gaz sensori holati
    reading_date           date, -- o'qish sanasi
    reading_value          integer -- o'qish qiymati
);

create table public.hudud_gaz_org_customer -- Ushbu jadvalda Hudud Gaz kompaniyasining mijozlari haqida ma'lumotlar saqlanadi
(
    id                bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created  timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated  timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    branch_id         integer, -- filial ID raqami
    branch_name       varchar(255), -- filial nomi
    contract_date     varchar(255), -- shartnoma sanasi
    contract_number   varchar(255), -- shartnoma raqami
    contract_status   varchar(255), -- shartnoma holati
    inn               varchar(255) -- tashkilot inn raqami (organization jadvalining inn ustuni bilan bog'langan)
        constraint siqksicnwi398n219djjs
            references public.organization(inn),
    org_activitiyes   varchar(255), -- tashkilot faoliyatlari
    org_category      varchar(255), -- tashkilot kategoriyasi
    org_customer      varchar(255), -- tashkilot mijozlari
    org_customer_code varchar(255) -- tashkilot mijozlik kodi (mip2hududgaz_payments jadvalidagi org_customer_code ustuni bilan bog'langan)
        constraint ukq1e7r4m7y3f6j0p6t1gkq5n
            references public.mip2hududgaz_payments(org_customer_code),
    pinfl             varchar(255), -- pinfl kod
    create_by         bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.implementation_projects -- Ushbu jadvalda amalga oshirilayotgan loyihalar haqida ma'lumotlar saqlanadi
(
    id                            bigint       not null -- ID raqam (primary key)
        primary key,
    create_by                     bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created              timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated              timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    implementation_current_year   double precision, -- joriy yil amalga oshirilishi
    implementation_growth_percent double precision, -- o'sish foizi
    implementation_next_year      double precision, -- kelgusi yil amalga oshirilishi
    indicator                     varchar(255), -- ko'rsatkich
    all_investment_id             bigint -- investitsiya ID raqami (all_investment jadvalidagi id ustuni bilan bog'langan)
        constraint fk1kwsxo6v2qob9pm2b1mpjhchf
            references public.all_investment
);

create table public.investment_project_finance_info  -- Ushbu jadvalda investitsiya loyihalarining moliyaviy ma'lumotlari haqida ma'lumotlar saqlanadi
(
    doc_id           bigint not null -- investitsiya loyihasi ID raqami (investment_projects jadvalidagi doc_id ustuni bilan bog'langan)
        primary key,
    bank_funds       double precision, -- bank mablag'lari
    bank_remaind     double precision, -- bank qoldig'i
    bankf_invest     double precision, -- bank investitsiyasi
    bankf_remaind    double precision, -- bank investitsiya qoldig'i
    created_at       date, -- yaratilgan sana
    datetime_created timestamp(6), -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6), -- ma'lumot yangilangan sana va vaqt
    dev_funds        double precision, -- rivojlantirish mablag'lari
    dev_remaind      double precision, -- rivojlantirish qoldig'i
    foreign_invest   double precision, -- xorijiy investitsiya
    foreign_remaind  double precision, -- xorijiy qoldiq
    gov_credit       double precision, -- davlat krediti
    gov_remaind      double precision, -- davlat qoldig'i
    own_cost         double precision, -- o'z mablag'lari
    own_remaind      double precision, -- o'z qoldig'i
    project_name     varchar(255), -- loyiha nomi
    id               bigint generated by default as identity -- ID raqam (primary key)
);

create table public.investment_project_funding_source -- Ushbu jadvalda investitsiya loyihalarining moliyalashtirish manbalari haqida ma'lumotlar saqlanadi
(
    id               bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    bank_funds       double precision, -- bank mablag'lari
    bank_reality     double precision, -- bank haqiqatda
    bankf_invest     double precision, -- bank investitsiyasi
    bankf_reality    double precision, -- bank investitsiyasi haqiqatda
    created_at       date, -- yaratilgan sana
    datetime_created timestamp(6), -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6), -- ma'lumot yangilangan sana va vaqt
    dev_funds        double precision, -- rivojlantirish mablag'lari
    dev_reality      double precision, -- rivojlantirish haqiqatda
    doc_id           bigint -- investitsiya loyihasi ID raqami (investment_projects jadvalidagi doc_id ustuni bilan bog'langan)
        constraint djwsnaqhdhedheu348238fnsksk
            references public.investment_projects(doc_id),
    forecast_month   varchar(255), -- prognoz oyi
    foreign_invest   double precision, -- xorijiy investitsiya
    foreign_reality  double precision, -- xorijiy haqiqatda
    gov_credit       double precision, -- davlat krediti
    gov_reality      double precision, -- davlat haqiqatda
    mastery_month    varchar(255), -- ustunlik oyi
    own_cost         double precision, -- o'z mablag'lari
    own_reality      double precision, -- o'z haqiqatda
    project_name     varchar(255) -- loyiha nomi
);

create table public.investment_project_schedule_event -- Ushbu jadvalda investitsiya loyihalarining tadbirlar jadvali haqida ma'lumotlar saqlanadi
(
    id               bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    april_cp         double precision, -- aprel oyi
    august_cp        double precision, -- avgust oyi
    contractor_name  varchar(255), -- pudratchi nomi
    created_at       date, -- yaratilgan sana
    datetime_created timestamp(6), -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6), -- ma'lumot yangilangan sana va vaqt
    december_cp      double precision, -- dekabr oyi
    doc_id           bigint -- investitsiya loyihasi ID raqami (investment_projects jadvalidagi doc_id ustuni bilan bog'langan)
        constraint skw8dnqlv0ooen58
            references public.investment_projects(doc_id),
    duration         integer, -- davomiylik
    event_begin      date, -- tadbir boshlanish sanasi
    event_category   varchar(255), -- tadbir kategoriyasi
    event_cost       double precision, -- tadbir xarajatlari
    event_end        date, -- tadbir tugash sanasi
    event_name       varchar(255), -- tadbir nomi
    february_cp      double precision, -- fevral oyi
    january_cp       double precision, -- yanvar oyi
    july_cp          double precision, -- iyul oyi
    june_cp          double precision, -- iyun oyi
    march_cp         double precision, -- mart oyi
    may_cp           double precision, -- may oyi
    november_cp      double precision, -- noyabr oyi
    october_cp       double precision, -- oktabr oyi
    project_name     varchar(255), -- loyiha nomi
    september_cp     double precision -- sentabr oyi
);

create table public.investment_project_statuses -- Ushbu jadvalda investitsiya loyihalarining holatlari haqida ma'lumotlar saqlanadi
(
    doc_id           bigint not null -- investitsiya loyihasi ID raqami (investment_projects jadvalidagi doc_id ustuni bilan bog'langan)
        constraint dkwun398fd92hnnvbskj
            references public.investment_projects(doc_id),
    created_at       date, -- yaratilgan sana
    datetime_created timestamp(6), -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6), -- ma'lumot yangilangan sana va vaqt
    deadline         date, -- muddat
    executed_job     varchar(255), -- bajarilgan ish
    project_name     varchar(255), -- loyiha nomi
    status           varchar(2000), -- holat
    updated_date     date, -- yangilangan sana
    id               bigint generated by default as identity -- ID raqam (primary key)
);

create table public.investment_projects -- Ushbu jadvalda investitsiya loyihalari haqida ma'lumotlar saqlanadi(so'ralgan ma'lumot bu jadvaldan chiqmasa public.investment_project jadvalidan qidirish kerak)
(
    doc_id           bigint not null -- investitsiya loyihasi ID raqami (investment_projects jadvalidagi doc_id ustuni bilan bog'langan)
        primary key,
    begin_date       date, -- boshlanish sanasi
    begin_end        date, -- tugash sanasi
    budg_revenue     double precision, -- byudjet daromadi
    datetime_created timestamp(6), -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6), -- ma'lumot yangilangan sana va vaqt
    district_id      varchar(255), -- tuman ID raqami
    district_name    varchar(255), -- tuman nomi
    export           double precision, -- eksport
    import           double precision, -- import
    l_partner        varchar(255), -- mahalliy hamkor
    local_level      varchar(255), -- mahalliy daraja
    lp_stir          varchar(255), -- mahalliy hamkor STIR raqami
    p_cost           double precision, -- loyiha qiymati
    p_country        varchar(255), -- loyiha mamlakati
    p_currency       varchar(255), -- loyiha valyutasi
    p_initiator      varchar(255), -- loyiha tashabbuskori
    p_investor       varchar(255), -- loyiha investor
    p_name           varchar(255), -- loyiha nomi
    p_scope          varchar(255), -- loyiha doirasi
    product_type     varchar(255), -- mahsulot turi
    project_power    varchar(255), -- loyiha quvvati
    project_type     varchar(255), -- loyiha turi
    region_id        varchar(255), -- mintaqa ID raqami
    region_name      varchar(255), -- viloyat nomi
    start_act        varchar(255), -- boshlanish harakati
    start_date       date, -- boshlanish sanasi
    unit             varchar(255), -- o'lchov birligi
    workplace        integer, -- ish joyi
    id               bigint generated by default as identity -- ID raqam (primary key)
);

create table public.legal_entity_debt -- Ushbu jadvalda tashkilotlarning soliqdan qarzdorliklari haqida ma'lumotlar saqlanadi (qarzdorlik so'ralganda penya ustunini qo'shmasdan faqat nedoimka ustunini olish kerak)
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created timestamp(6) not null, -- yaratilgan sana va vaqt
    datetime_updated timestamp(6) not null, -- yangilangan sana va vaqt
    date             varchar(255), -- sana
    nedoimka         double precision, -- asosiy qarzdorlik
    ns10code         integer, -- qarzdor tashkilot viloyati kodi (region jadvalining faktura_region_id ustuni bilan bog'langan)
    ns10name         varchar(255), -- qarzdor tashkilot viloyat nomi
    ns11code         integer, -- qarzdor tashkilot tuman kodi (region jadvalining faktura_region_id ustuni bilan bog'langan)
    ns11name         varchar(255), -- qarzdor tashkilot tuman nomi
    object_code      varchar(255), -- ob'ekt kodi
    object_name      varchar(255), -- ob'ekt nomi
    penya            double precision, -- jarima
    pereplata        double precision, -- oldindan to'lov
    tin              varchar(255) -- qarzdor tashkilot TIN raqami (agar organization jadvaliga JOIN qilinsa: type = 'STATE' bo'lganlarini tekshirish kerak)
        constraint xiwniinnskwialw209n
            references public.organization(inn),
    create_by        bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.lot -- ushbu jadvalda lotlar haqida ma'lumotlar saqlanadi
(
    id                    bigint       not null -- lot id raqami
        primary key,
    datetime_created      timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated      timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    base_price            varchar(255), -- lotlarning 1 tonnasi uchun belgilangan narx (sotuvga chiqarilgan lotlarning narxi so'ralganda base_price va set_volume_tons ustunlarini ko'paytirish kerak(SELECT SUM(CAST(base_price AS double precision) * CAST(set_volume_tons AS double precision))))
    brand                 varchar(255), -- lot brendi nomi
    contract_number       varchar(255) -- lot shartnoma raqami
        constraint slltidkwlsij2kdjfedklsdj
            references public.contract(number),
    date                  timestamp(6), -- lotning sotuvga chiqarilgan sanasi
    lot                   integer, -- lot miqdori
    measure_unit          varchar(255), -- o'lchov birligi
    product_group_name    varchar(255), -- mahsulot guruhi nomi (внутренний: ichki sotuv uchun, экспортный: eksport uchun)
    product_name          varchar(255), -- mahsulot nomi
    product_type_name     varchar(255), -- mahsulot turi nomi (Rus tilida)
    seller_name           varchar(255), -- sotuvchi tashkilot nomi (yillik yoki oylik, sotuvga chiqarilgan lotlar soni yoki narxi haqida so'ralganda seller_name ustunidan ushbu qiymatlarni tanlab chiqarish kerak: -> SELECT COUNT(*) FROM public.lot l WHERE EXISTS (SELECT 1 FROM (VALUES ('АО Fargonaazot'),('Maxam-Chirchiq'),('АО Ammofos-Maxam'),('АО Navoiyazot'),('"QONGIROT SODA ZAVODI" MCHJ QK'),('AO "DEHQONOBOD KALIY ZAVODI"')) AS names(name) WHERE l.seller_name ILIKE CONCAT('%', names.name, '%'));)
    seller_region         varchar(255), -- sotuvchi tashkilot viloyati
    session               integer, -- sessiya raqami (1: kunduzgi, 2: kechki)
    set_volume_tons       varchar(255), -- tashkilot tomonidan sotish uchun chiqarilgan lot hajmi, (tonna)
    sold_volume_tons      varchar(255), -- shu paytgacha sotilgan lotlarning hajmi (tonna)
    sold_volume_uzs       varchar(255), -- Sotilgan lotlarning qiymati (so'm) 
    create_by             bigint, -- yaratuvchi
    product_main_category varchar(255) -- mahsulot asosiy kategoriyasi
);





create table public.measurement_unit -- Ushbu jadvalda o'lchov birliklari haqida ma'lumotlar saqlanadi
(
    id                     bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created       timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated       timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    code                   varchar(255), -- o'lchov birligi kodi
    measurement_name_long  varchar(255), -- o'lchov birligi uzun nomi
    measurement_name_short varchar(255), -- o'lchov birligi qisqa nomi
    create_by              bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.mip2hududgaz_payments -- Ushbu jadvalda Hududgaz tizimidagi to'lovlar haqidagi ma'lumotlar saqlanadi
(
    id                bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created  timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated  timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    amount            bigint, -- to'lov miqdori
    created_date      varchar(255), -- yaratilgan sana
    operator          varchar(255), -- operator
    org_bank          varchar(255), -- tashkilot banki
    org_customer_code varchar(255) -- tashkilot mijozlik kodi
        constraint qksjwoeijrwj2kj3kjd
            references public.hudud_gaz_org_customer(org_customer_code),
    org_inn           varchar(255) -- tashkilot inn raqami
        constraint eidkewjwo23kj43kj3a
            references public.organization(inn),
    org_mfo           varchar(255), -- tashkilot mfo raqami
    org_name          text, -- tashkilot nomi
    org_rs            varchar(255), -- tashkilot hisob raqami
    purpose           text, -- o'tkazma maqsadi
    status_name       varchar(255), -- holat nomi
    tid               varchar(255), -- tranzaksiya ID raqami
    transaction_time  varchar(255), -- tranzaksiya vaqti
    create_by         bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.organization_1c_balance -- Ushbu jadvalda tashkilotlarning 1C balanslari haqida ma'lumotlar saqlanadi
(
    id                     bigint       not null -- ID raqam (primary key)
        primary key,
    create_by              bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created       timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated       timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    account_number         varchar(255), -- hisob raqam
    amount                 double precision, -- balans miqdori
    created_date           date, -- yaratilgan sana
    organization_id        bigint, -- tashkilot ID raqami
    end_of_report_amount   double precision, -- hisobot oxiridagi balans
    next_of_report_amount  double precision, -- keyingi hisobotdagi balans
    start_of_report_amount double precision -- hisobot boshlanishidagi balans
);

create table public.organization_bank_account_transactions -- Ushbu jadvalda tashkilotlarning bank aylanmalari, soliq to'lovlari, birja tushumlari va pul o'tkazmalari haqidagi ma'lumotlar saqlanadi (birja tushumlarini chiqarishda sndr_account va rcvr_account ustunlarini birgalikda OR qilib tekshirish kerak -> AND (rcvr_account ILIKE '%00600257%' OR sndr_account ILIKE '%00600257%'))
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    amount           bigint, -- pul o'tkazma miqdori (tiyinda hisoblagan; so'mda chiqarish uchun 100 ga bo'lish kerak)
    currency_code    varchar(255), -- valyuta kodi
    date             varchar(255), -- sana
    date_execute     varchar(255), -- o'tkazma bajarilgan sana
    doc_id           varchar(255), -- hujjat ID raqami
    lead_id          bigint, -- yetakchi ID raqami
    purpose          text, -- o'tkazma maqsadi (soliq to'lovlari haqida ma'lumot olish uchun shu ustun ichida 'TAX_ID' qiymati bo'lishini tekshirish kerak -> purpose ILIKE '%$TAX_ID$%')
    rcvr_account     varchar(255), -- qabul qiluvchi hisob raqami (soliq to'lovlari faqat ushbu qiymat bilan olinishi kerak -> 23402000300100001010. birja tushumlari bo'yicha shunaqa raqamli hisob raqami bilan tekshirish kerak -> 00600257 (rcvr_account ilike '%00600257%'))
    rcvr_bank        varchar(255), -- qabul qiluvchi bank
    rcvr_inn         varchar(255), -- qabul qiluvchi INN raqami
    rcvr_mfo         varchar(255), -- qabul qiluvchi MFO raqami
    rcvr_name        text, -- qabul qiluvchi nomi
    rcvr_pinfl       varchar(255), -- qabul qiluvchi PINFL raqami
    sndr_account     varchar(255), -- jo'natuvchi hisob raqami (birja tushumlari bo'yicha shunaqa raqamli hisob raqami bilan tekshirish kerak -> 00600257 (sndr_account ilike '%00600257%'))
    sndr_bank        varchar(255), -- jo'natuvchi bank
    sndr_inn         varchar(255), -- jo'natuvchi INN raqami
    sndr_mfo         varchar(255), -- jo'natuvchi MFO raqami
    sndr_name        text, -- jo'natuvchi nomi
    sndr_pinfl       varchar(255), -- jo'natuvchi PINFL raqami
    state_id         integer, -- holat ID raqami
    transaction_type varchar(255), -- aylanma turi (debit: tashkilotning chiqim aylanmalari, credit: tashkilotning kirim aylanmalari). birja tushumlari so'ralganda barcha aylanma turini tanlash kerak!
    account_number   varchar(255), -- hisob raqami (kirim yoki chiqim haqidagi ma'lumotlar so'ralganda kartoteka ma'lumotlari yani account_number usutnidagi 9632 raqami bilan boshlangan qiymatlar olinmaydi(account_number NOT ILIKE '9632%'))
    organization_id  bigint, -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan; tegishli tashkilot so'ralganda nomi bilan emas organization_id ustuni bilan tekshirish kerak; 1: Navoiyazot, 2: Maxam-Chirchiq, 3: Ammofos-Maxam, 4: Dehqonobod kaliy zavodi, 5: Qizilqum fosforit kompleksi, 6: Qo‘ng‘irot soda zavodi)
    date_as_date     date, -- sana (date tipida)
    create_by        bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.organization_bank_accounts -- Ushbu jadvalda tashkilotlarning bank hisob raqamlari haqida ma'lumotlar saqlanadi
(
    id                            bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created              timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated              timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    account_name                  varchar(255), -- hisob raqami nomi
    account_number                varchar(255), -- hisob raqami
    included_in_saldo_calculation boolean, -- hisoblashda qoldiq hisobga olinganmi
    organization_id               bigint -- tashkilot ID raqami
        constraint cisikeuucun83n384nff
            references public.organization(id),
    create_by                     bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.organization_meters -- Ushbu jadvalda tashkilotlarning o'lchagichlari haqida ma'lumotlar saqlanadi
(
    id                         bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    meter_no                   varchar(255) not null, -- o'lchagich raqami
    organization_id            bigint       not null, -- tashkilot ID raqami
    datetime_created           timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated           timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    meter_brand                varchar(255), -- o'lchagich brendi
    meter_location             varchar(255), -- o'lchagich joylashuvi
    meter_service_organization varchar(255), -- o'lchagich xizmat ko'rsatuvchi tashkilot
    organization_name          varchar(255), -- tashkilot nomi
    which_organization         varchar(255), -- qaysi tashkilot
    constraint ukkmju2q2ppcm0ig0olnfspql14
        unique (organization_id, meter_no)
);

create table public.position -- Ushbu jadvalda lavozimlar haqida ma'lumotlar saqlanadi
(
    id   bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    name varchar(255), -- lavozim nomi
    c1id varchar(255) -- lavozimning 1C dasturidagi identifikatori
        constraint uklnr6x4m1y0lwtj8c85arhqukw
            unique
);

create table public.product -- Ushbu jadvalda mahsulotlar haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, ushbu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    mxik_code        varchar(255) -- mahsulot MXIK kodi (product_code jadvalidagi mxik_code ustuni bilan bog'langan)
        constraint bnsiwkeisksiwk3kk
            references public.product_code(mxik_code),
    mxik_name        varchar(255), -- mahsulot MXIK nomi (rus tilida)
    type             varchar(255), -- maxsulot turi
    measure_code     varchar(255), -- o'lchov kodi
    measure_unit     varchar(255), -- o'lchov birligi birligi 
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    name_uz          varchar(255) -- mahsulotning o'zbekcha nomi
);

create table public.product_code -- Ushbu jadvalda mahsulot kodlari haqida ma'lumotlar saqlanadi
(
    mxik_code                       text -- mahsulot MXIK kodi (product jadvalining mxik_code ustuni bilan bog'langan)
        constraint djennbhhsjjjj2k
            references public.product(mxik_code),
    group_name                      text, -- mahsulot guruhi nomi
    class_name                      text, -- mahsulot sinfi nomi
    position_name                   text, -- mahsulot pozitsiyasi nomi
    sub_name                        text, -- mahsulot subpozitsiyasi nomi
    brand_name                      text, -- mahsulot brendi nomi
    attribute_name                  text, -- mahsulot atributi nomi
    mxik_name                       text, -- mahsulot MXIK nomi
    barcode                         text, -- mahsulot barkodi
    attached_measurement_group      text, -- mahsulotga biriktirilgan o'lchov guruhi
    attached_unit_of_measurement    text, -- mahsulotga biriktirilgan o'lchov birligi
    attached_pack                   text, -- mahsulotga biriktirilgan qadoq
    recommended_measurement_group   text, -- tavsiya etilgan o'lchov guruhi
    recommended_unit_of_measurement text, -- tavsiya etilgan o'lchov birligi
    privilege_id                    text, -- mahsulotga berilgan imtiyoz identifikatori
    x                               text, -- keraksiz ustun
    y                               text  -- keraksiz ustun
);

create table public.product_mxik -- Ushbu jadvalda MXIK kodlari haqida ma'lumotlar saqlanadi
(
    id   text -- mahsulot MXIK kodi (product jadvalidagi mxik_code ustuni bilan bog'langan)
        constraint kcimnhnbgiuruyuyyr38fj
            references public.product(mxik_code),
    name text -- mahsulot MXIK nomi
);

create table public.product_tiftn_code -- Ushbu jadvalda mahsulotning TIFTN kodlari haqida ma'lumotlar saqlanadi
(
    id               bigint                     not null -- ID raqam (primary key)
        primary key,
    datetime_created timestamp(6) default now() not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6) default now() not null, -- ma'lumot yangilangan sana va vaqt
    code             varchar(255) -- kod (gov_goods jadvalidagi code_tiftn ustuni bilan bog'langan)
        constraint mduekdiwekwqj3ijji3k
            references public.gov_goods(code_tiftn),
    name             varchar(255), -- nom
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    status           text         default 'BOSHQALAR'::text -- kod holati
);

create table public.projects -- Ushbu jadvalda loyihalar haqida ma'lumotlar saqlanadi
(
    id                bigint       not null -- ID raqam (primary key)
        primary key,
    create_by         bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created  timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated  timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    current_year      double precision, -- joriy yil
    growth_percent    double precision, -- o'sish foizi
    next_year         double precision, -- keyingi yil
    projects_count    double precision, -- loyihalar soni
    all_investment_id bigint -- investitsiya ID raqami (all_investment jadvalidagi id ustuni bilan bog'langan)
        constraint fkpkhmxlwi6w8r8835fdhq980l
            references public.all_investment
);

create table public.region -- Ushbu jadvalda viloyatlar haqida ma'lumotlar saqlanadi
(
    id                  bigint       not null -- id raqam (primary key)
        primary key, 
    datetime_created    timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated    timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    name                varchar(255), -- Viloyat nomi(Krill)
    faktura_region_code bigint, -- Viloyatning Ma'muriy-hududiy tuzilmalarni belgilash tizimi (soato) kodi
    faktura_region_id   bigint, -- Viloyat identifikatori kodi
    name_uz             varchar(255), -- Viloyat nomi(O'zbekcha)
    faktura_region_name varchar(255), -- Viloyat nomi(Rus tilida)
    create_by           bigint -- ma'lumotni yaratgan foydalanuvchi identifikatori
);

create table public.district -- Ushbu jadvalda tumanlar haqida ma'lumotlar saqlanadi
(
    id                    bigint       not null -- id raqam (primary key)
        primary key, 
    datetime_created      timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated      timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    name                  varchar(255), -- Tuman nomi(Krill)
    region_id             bigint -- Tegishli viloyat identifikatori 
        constraint fkpjyu66maoe0h5uqfhle85e5vo
            references public.region, 
    faktura_district_code bigint, -- Tumanning identifikator kodi
    name_uz               varchar(255), -- Tuman nomi(O'zbekcha)
    faktura_district_name varchar(255), -- Tuman nomi(Rus tilida)
    create_by             bigint, -- ma'lumotni yaratgan foydalanuvchi identifikatori
    soato                 bigint -- Tumanning Ma'muriy-hududiy tuzilmalarni belgilash tizimi (soato) kodi
);

create table public.organization  -- Ushbu jadvalda tashkilotlar haqida ma'lumotlar saqlanadi, davlat tashkilotlari(korxona, zavod) va xususiy tashkilotlar(vakolatli omborlari bor). (Tashkilotlardagi shtatlar soni haqida ma'lumot olish uchun har doim inn ustuni bilan tekshirish kerak)
(
    id                       bigint       not null -- id raqam (primary key)
        primary key, 
    datetime_created         timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated         timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    inn                      varchar(255)
        constraint winbeisxili1k43d
            references public.contract(inn), -- tashkilotning inn raqami
            
    name                     varchar(255), -- tashkilot nomi
    name_in_lots             varchar(255), -- tashkilotning lotlardagi nomi
    type                     varchar(255) -- tashkilot turi (STATE: davlat yoki tizim tashkiloti, korxona yoki zavod; PRIVATE: xususiy tashkilot, omborlarga egalik qiladi)
        constraint organization_type_check
            check ((type)::text = ANY
                   (ARRAY [('STATE'::character varying)::text, ('PRIVATE'::character varying)::text])), 
    warehouse1c_id           varchar(255), -- omborning 1C dasturi identifikatori
    district_id              bigint -- tuman identifikatori (district jadvalining id ustuni bilan bog'langan)
        constraint fk6k9fv7s99m04x22vueveflp81
            references public.district, 
    contracts                jsonb, -- tashkilot shartnomalari
    create_by                bigint, -- ma'lumotni yaratgan foydalanuvchi identifikatori
    gas_customer_code        varchar(255), -- tashkilotning gaz iste'molchisi kodi
    sub_type                 varchar(255), -- tashkilotning sub turi
    ifutcode                 varchar(255), -- iqtisodiy faoliyat indentifikatsion kodi
    micro_macro_organization varchar(255), -- mikro yoki makro tashkilot
    activity_type            varchar(255), -- faoliyat turi
    foundation_date          date, -- tashkilot tashkil etilgan sana
    industry_type            varchar(255), -- sanoat turi
    main_product_type        varchar(255), -- asosiy mahsulot turi
    organization_director    varchar(255), -- tashkilot direktori
    phone_number             varchar(255), -- tashkilot telefon raqami
    org_address              varchar(255) -- tashkilot manzili
);

create table public.organization_komunal_values -- Ushbu jadvalda tashkilotlarning energiya resurslari sarfi bo'yicha ma'lumotlar saqlanadi
(
    id                bigint         not null -- ID raqam (primary key)
        primary key,
    create_by         bigint, -- yaratuvchi (foydalanuvchi) id raqami
    datetime_created  timestamp(6)   not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated  timestamp(6)   not null, -- ma'lumot yangilangan sana va vaqt
    amount            numeric(38, 2) not null, -- energiya miqdori
    date              date           not null, -- enrgiya sarfi qayd etilgan vaqt
    date_types        varchar(255)   not null -- energiya sarflangan davr turi (YEARLY: yillik, MONTHLY: oylik, DAILY: kunlik)
        constraint organization_komunal_values_date_types_check
            check ((date_types)::text = ANY
                   (ARRAY [('YEARLY'::character varying)::text, ('MONTHLY'::character varying)::text, ('DAILY'::character varying)::text])),
    measurement_types varchar(255)   not null -- o'lchov birligi turlari (m3: metr kub, kwt: kilovatt)
        constraint organization_komunal_values_measurement_types_check
            check ((measurement_types)::text = ANY
                   (ARRAY [('m3'::character varying)::text, ('kwt'::character varying)::text])),
    organization_id   bigint         not null, -- tashkilot id raqami (1: Navoiyazot, 2: Maxam-Chirchiq, 3: Ammofos-Maxam, 4: Dehqonobod kaliy zavodi, 32: YAKKATUT KIMYO)
    type              varchar(255)   not null -- sarflangan energiya turi (GAS: gaz, SVET: elektr, SUV: suv)
        constraint organization_komunal_values_type_check
            check ((type)::text = ANY
                   (ARRAY [('GAS'::character varying)::text, ('SVET'::character varying)::text, ('SUV'::character varying)::text]))
);

create table public.application -- Ushbu jadvalda arizalar haqida ma'lumotlar saqlanadi
(
    id                 bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created   timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated   timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    amount             double precision, -- ariza miqdori
    app_date           date, -- ariza sanasi
    c_type             varchar(255), -- ariza turi (debitor, kreditor)
    contract_number    varchar(255), -- shartnoma raqami
    court_name         varchar(255), -- sud nomi
    currency_code      varchar(255), -- valyuta kodi
    description        varchar(255), -- ariza tavsifi
    inn                varchar(255), -- INN
    kontragent         varchar(255), -- kontragent (shartnoma bo'yicha ishtirokchi tashkilot yoki shaxs)
    debt_credit_1c_id  bigint -- qarzdorlik yoki kreditorlik 1C identifikatori
        constraint fkdeki5ioff7h6u9lqqqds69l1s
            references public.debtor_creditor1c,
    organization_id    bigint -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fkr7dxqnwu3rgug7du538brkedh
            references public.organization,
    application_number varchar(255), -- ariza raqami
    document_path      varchar(255), -- hujjatning platformadagi URL yo'li
    create_by          bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.application_divorce -- Ushbu jadvalda ajrim arizalari haqida ma'lumotlar saqlanadi
(
    id                                bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created                  timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated                  timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    amount                            double precision, -- ariza miqdori
    divorce_date                      date, -- sana bo'yicha ma'lumotlar datetime_created ustunidan olinadi, chunki divorce_date ustuni bo'sh
    status                            varchar(255) -- ajrim holati (SATISFIED: qoniqarli, PARTIALLY_SATISFIED: qisman qoniqarli, REJECTED: bekor qilingan)
        constraint application_divorce_status_check
            check ((status)::text = ANY
                   (ARRAY [('SATISFIED'::character varying)::text, ('PARTIALLY_SATISFIED'::character varying)::text, ('REJECTED'::character varying)::text])),
    application_id                    bigint -- ariza ID raqami (application jadvalining id ustuni bilan bog'langan)
        constraint fk1lwt6bod0v3f21gbb9x7vmjey
            references public.application,
    create_by                         bigint -- yaratuvchi (foydalanuvchi) ID raqami
    application_divorce_document_path varchar(255), -- ajrim arizasi hujjatining platformadagi URL yo'li
    application_payment_document_path varchar(255), -- ariza to'lovi hujjatining platformadagi URL yo'li
    application_payment_number        varchar(255) -- ariza to'lovi raqami
);

create table public.application_document_products -- Ushbu jadvalda ariza hujjatlariga tegishli mahsulotlar haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    mxik_code        varchar(255), -- mahsulot MXIK kodi
    name             varchar(255) not null, -- mahsulot nomi
    organization_id  bigint       not null -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fkk6hgtohqp1lgk6rt6j6j6f6wa
            references public.organization
);

create table public.application_documents -- Ushbu jadvalda ariza hujjatlari haqida ma'lumotlar saqlanadi
(
    id                    bigint       not null -- ID raqam (primary key)
        primary key,
    create_by             bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created      timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated      timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    approver              varchar(255), -- tasdiqlovchi
    currency              varchar(255), -- valyuta
    date                  timestamp(6), -- sana
    document_number       varchar(255), -- hujjat raqami
    initiator             varchar(255), -- tashabbuskor
    number                varchar(255), -- raqam
    recipient             varchar(255), -- qabul qiluvchi
    responsible           varchar(255), -- javobgar
    status_code           integer, -- status kodi
    step                  varchar(255) not null, -- qism
    type                  varchar(255) not null -- hujjat turi (EXPORT: eksport, IMPORT: import)
        constraint application_documents_type_check
            check ((type)::text = ANY
                   (ARRAY [('EXPORT'::character varying)::text, ('IMPORT'::character varying)::text])),
    organization_id       bigint       not null -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fk6hfhen1nbh17cjdwxyxj798um
            references public.organization,
    parent_application_id bigint -- yuqori ariza ID raqami
        constraint fk4fohbqfyilgodfa9cyah5lnw7
            references public.application_documents,
    document_status       varchar(255) -- hujjat holati (NEW: yangi, APPROVED_BY_ORGANIZATION: tashkilot tomonidan tasdiqlangan, REJECTED_BY_ORGANIZATION: tashkilot tomonidan rad etilgan, APPROVED_BY_KIMYOSANOAT: Kimyosanоat tomonidan tasdiqlangan, FULLY_APPROVED: to'liq tasdiqlangan)
        constraint application_documents_document_status_check
            check ((document_status)::text = ANY
                   (ARRAY [('NEW'::character varying)::text, ('APPROVED_BY_ORGANIZATION'::character varying)::text, ('REJECTED_BY_ORGANIZATION'::character varying)::text, ('APPROVED_BY_KIMYOSANOAT'::character varying)::text, ('FULLY_APPROVED'::character varying)::text])),
    basis_file_urls       jsonb, -- asos fayllarining URL manzillari (JSON formatida)
    unit_id               bigint -- o'lchov birligi ID raqami (measurement_unit jadvalining id ustuni bilan bog'langan)
        constraint fkddqrc1r4npf32a914uigh84hs
            references public.measurement_unit,
    amount                double precision, -- miqdor
    contractor_agreement  varchar(255), -- pudrat shartnomasi
    product_id            bigint -- ariza hujjatiga tegishli mahsulot ID raqami (application_document_products jadvalining id ustuni bilan bog'langan)
        constraint fk_product
            references public.application_document_products,
    basis                 varchar(255) -- asos
);

create table public.article -- Ushbu jadvalda tashkilotlarning qilingan umumiy harajatlari haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    name             varchar(255), -- nomi
    parent_id        bigint -- yuqori harajat ID raqami
        constraint fkh9e499pibnsp4n37w25ebl8ne
            references public.article,
    c1id             varchar(255) -- qilingan harajatning 1C dasturidagi ID raqami
        constraint c1id
            unique,
    organization_id  bigint -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fkcgg5kkexxy1usb9vrbkeh7ybd
            references public.organization
);

create table public.contract_document_articles -- Ushbu jadvalda shartnoma hujjatlariga tegishli harajatlar haqida ma'lumotlar saqlanadi
(
    contract_document_id bigint not null -- shartnoma hujjati ID raqami (contract_documents jadvalining id ustuni bilan bog'langan)
        constraint fkfsx3ewhbdt3wgi1u0oh6gtau0
            references public.contract_documents,
    article_id           bigint not null -- harajat ID raqami (article jadvalining id ustuni bilan bog'langan)
        constraint fkrg557x8qnmqaqos4h5u8vvvmy
            references public.article
);

create table public.department -- Ushbu jadvalda tashkilotlar bo'limlari haqidagi ma'lumotlar saqlanadi
(
    id                 bigint generated by default as identity -- bo'lim ID raqami (primary key)
        primary key,
    name               varchar(255), -- bo'lim nomi
    parent_id          bigint -- bo'limninig o'zidan oldingi qaysi bo'limga tegishliligi ID raqami 
        constraint fkmgsnnmudxrwqidn4f64q8rp4o
            references public.department,
    organization_id    bigint -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fkgt2jmae86v2aik1nklhdc2dnx
            references public.organization,
    department_type_id bigint -- bo'lim turi ID raqami (department_types jadvalining id ustuni bilan bog'langan)
        constraint fkjxv00xar9yakwaff0of7tci4y
            references public.department_types,
    c1id               varchar(255) -- bo'limning 1C dasturidagi id raqami
        constraint uksk6pr7ngt5r55va8kkom6l4q8
            unique,
    created_at         timestamp(6), -- ma'lumot yaratilgan sana va vaqt, ushbu ustunni umumiy sana va vaqt sifatida ishlatish kerak
    updated_at         timestamp(6) -- ma'lumot yangilangan sana va vaqt
);

create table public.investment_project -- Ushbu jadvalda investitsiya loyihalari haqida ma'lumotlar saqlanadi
(
    id                           bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created             timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated             timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    name                         text,
    organization_id              bigint -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fkckwyadcrchw7yosli2dmtc0a7
            references public.organization,
    amount                       double precision, -- umumiy miqdor
    complete_percent             double precision, -- bajarilgan foiz
    end_date                     date, -- tugash sanasi
    start_date                   date, -- boshlanish sanasi
    paid_amount                  double precision, -- to'langan miqdor
    district                     varchar(255), -- tuman
    partner                      varchar(255), -- hamkor
    partner_country              varchar(255), -- hamkor mamlakati
    partner_name                 varchar(255), -- hamkor nomi
    project_value                varchar(255), -- loyiha qiymati
    projection_amount            double precision, -- prognoz miqdori
    region                       varchar(255), -- viloyat
    staff                        integer, -- investitsion loyiha bo'yicha ishchilar soni
    tech_staff                   integer, -- investitsion loyiha bo'yicha texnik ishchilar
    create_by                    bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    expected_stock               double precision, -- kutilgan aksiya
    project_product              varchar(255), -- loyiha mahsuloti
    project_value_foreign_invest double precision, -- loyiha qiymati (xorijiy investitsiya)
    progress                     double precision, -- loyiha jarayoni
    region_code                  integer -- viloyat kodi
);

create table public.investment_step -- Ushbu jadvalda investitsiya bosqichlari haqida ma'lumotlar saqlanadi
(
    id                    bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created      timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated      timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    name                  text, -- investitsiya bosqichi nomi
    investment_project_id bigint -- investitsiya loyihasi identifikatori (investment_project jadvalining id ustuni bilan bog'langan)
        constraint fkna72j8c3cyb5yyg3hbddh9ve5
            references public.investment_project,
    status                varchar(255) -- investitsiya bosqichi holati (PENDING: kutilmoqda, COMPLETED: yakunlandi, LATER: keyinroq)
        constraint investment_step_status_check
            check ((status)::text = ANY
                   (ARRAY [('PENDING'::character varying)::text, ('COMPLETED'::character varying)::text, ('LATER'::character varying)::text])),
    create_by             bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.investment -- Ushbu ustunda barcha investitsiyalar haqida ma'lumotlar saqlanadi.
(
    id                 bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created   timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated   timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    april              double precision, -- Aprel oyi uchun investitsiya miqdori
    august             double precision, -- Avgust oyi uchun investitsiya miqdori
    december           double precision, -- Dekabr oyi uchun investitsiya miqdori
    duration_days      bigint, -- Investitsiya davomiyligi (kunlarda)
    end_date           date, -- Investitsiya tugash sanasi
    february           double precision, -- Fevral oyi uchun investitsiya miqdori
    january            double precision, -- Yanvar oyi uchun investitsiya miqdori
    july               double precision, -- Iyul oyi uchun investitsiya miqdori
    june               double precision, -- Iyun oyi uchun investitsiya miqdori
    march              double precision, -- Mart oyi uchun investitsiya miqdori
    may                double precision, -- May oyi uchun investitsiya miqdori
    name               text, -- Investitsiya nomi
    november           double precision, -- Noyabr oyi uchun investitsiya miqdori
    october            double precision, -- Oktyabr oyi uchun investitsiya miqdori
    provider           text, -- Investitsiya provayderi nomi
    project_name       text, -- Investitsiya loyihasi nomi
    september          double precision, -- Sentyabr oyi uchun investitsiya miqdori
    start_date         date, -- Investitsiya boshlanish sanasi
    year               integer, -- Investitsiya yili
    district_id        bigint -- Tuman identifikatori (district jadvalining id ustuni bilan bog'langan)
        constraint fktoe4egfohav40wss20xv1n9th
            references public.district,
    investment_step_id bigint       not null -- Investitsiya bosqichi identifikatori (investment_step jadvalining id ustuni bilan bog'langan)
        constraint fkjbjlv29py6j26l6iwr2qe81q7
            references public.investment_step,
    amount             double precision, -- Umumiy investitsiya miqdori
    status             varchar(255) -- Investitsiya holati (PENDING: kutilmoqda, COMPLETED: yakunlandi, LATER: keyinroq)
        constraint investment_status_check
            check ((status)::text = ANY
                   (ARRAY [('PENDING'::character varying)::text, ('COMPLETED'::character varying)::text, ('LATER'::character varying)::text])),
    create_by          bigint -- ma'lumotni yaratgan foydalanuvchi identifikatori
);

create table public.investment_comment -- Ushbu jadvalda investitsiya izohlariga oid ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    comment_date     date, -- izoh sanasi
    text             varchar(255), -- izoh matni
    url              text, -- izohga oid URL
    investment_id    bigint -- investitsiya identifikatori (investment jadvalining id ustuni bilan bog'langan)
        constraint fkjjm0o2krvc6hy2l60um5vag4k
            references public.investment,
    create_by        bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.legal_company_account -- Ushbu jadvalda tashkilotlarning soliqlari bo'yicha hisob raqamlari haqida ma'lumotlar saqlanadi (soliq to'lovlari bo'yicha ma'lumot organization_bank_account_transactions jadvalidan olinadi. soliq qarzdorliklari bo'yicha ma'lumot legal_entity_debt jadvalidan olinadi.)
(
    id                bigint       not null -- ID raqam (primary key)
        primary key,
    create_by         bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created  timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated  timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    aktdeb_tax        double precision, -- aktivlar bo'yicha qarz solig'i
    back_tax          double precision, -- orqaga soliq
    calculated_tax    double precision, -- hisoblangan soliq
    debt_tax          double precision, -- qarz solig'i
    decrease_tax      double precision, -- kamaytirilgan soliq
    district_code     integer, -- tuman kodi
    organization_name varchar(255), -- tashkilot nomi
    over_payment      double precision, -- ortiqcha to'lov
    pay_tax           double precision, -- to'lanadigan soliq
    penya             double precision, -- jarima
    prepayment_tax    double precision, -- oldindan to'langan soliq
    region_code       integer, -- viloyat kodi
    report_period     varchar(255), -- hisobot davri
    tax_code          integer, -- soliq kodi
    tax_name          varchar(255), -- soliq nomi
    tin               varchar(255), -- tashkilot TIN raqami
    year              integer, -- soliqlar amalga oshirilgan yil
    organization_id   bigint       not null -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fkcqgvxwqy5hkbpb548wgvrxpva
            references public.organization
);

create table public.limit_report -- Ushbu jadvalda tashkilotlarning belgilangan limitlari bo'yicha hisobotlari saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    description      varchar(255), -- hisobot ta'rifi
    expense          double precision, -- xarajat
    limit_amount     double precision, -- belgilangan limit
    quantity         double precision, -- miqdor
    organization_id  bigint -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fkk3pxe2700hutf4djvll9fec99
            references public.organization,
    c1id             varchar(255) -- 1C dasturidagi identifikator
        constraint unique_c1id
            unique
);

create table public.organization_bank_account_saldos -- Ushbu jadvalda tashkilot va zavodlarning bank hisoblari bo'yicha qoldiqlari saqlanadi. Hisob raqam bo'yicha qoldiqlarni faqat ushbu jadvaldan olish kerak
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    account_name     varchar(255), -- hisob nomi
    account_number   varchar(255), -- hisob raqami, kartoteka ma'lumotlarini olmaslik kerak, majburiy! (har doim qat'iy ravishda umumiy hisob raqam qoldiqlari haqidagi ma'lumotlar so'ralganda kartoteka ma'lumotlari yani account_number usutnidagi 9632 raqami bilan boshlangan qiymatlar olinmaydi(account_number NOT ILIKE '9632%') lekin kartoteka ma'lumotlarining o'zi so'ralganda esa tanlash kerak: account_number ILIKE '9632%')
    date             date, -- sana
    organization_id  bigint -- tashkilot ID raqami (eng asosiy tashkilotlar id raqamlari -> 1: Navoiyazot, 2: Maxam-Chirchiq, 3: Ammofos-Maxam, 4: Dehqonobod kaliy zavodi, 5: Qizilqum fosforit kompleksi, 6: Qo‘ng‘irot soda zavodi)
        constraint fk_organization_bank_account_saldos_organization
            references public.organization
            on update cascade on delete cascade,
    saldo_out        bigint, -- qoldiq miqdori, har doim miqdorning yig'indisni chiqarish kerak (tiyinda hisoblagan; so'mda chiqarish uchun 100 ga bo'lish kerak)
    create_by        bigint -- yaratuvchi (foydalanuvchi) ID raqami
);



create table public.organization_partner -- Ushbu jadvalda tashkilotlarning hamkorlari haqida ma'lumotlar saqlanadi
(
    organization_id         bigint not null -- tashkilot ID raqami
        constraint fk78e0wcxxqixmw952kivlv7kn
            references public.organization,
    partner_organization_id bigint not null -- hamkor tashkilot ID raqami
        constraint fkcdrku3gtl522wjlcvbd2doknn
            references public.organization
);

create table public.personal -- Ushbu jadvalda hodimlarning shaxsiy ma'lumotlari saqlanadi. TASHKILOTLAR BO'YICHA HODIMLARGA OID BARCHA MALUMOTLAR personal_check JADVALIDAN OLINADI
(
    id                      bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    academic_degree         varchar(255), -- ilmiy darajasi
    academic_title          varchar(255), -- ilmiy unvoni
    awards                  varchar(255), -- mukofotlari
    birth_date              varchar(255), -- tug'ilgan sanasi
    country                 varchar(255), -- tug'ilgan mamlakati
    deputy_status           varchar(255), -- deputatlik holati
    disability              varchar(255), -- nogironlik darajasi
    document                varchar(255), -- hujjati
    education               varchar(255), -- o'qish joyi
    employee_number         varchar(255), -- ishchi raqami
    expiry_date             varchar(255), -- mehnat shartnomasi muddati
    first_name              varchar(255), -- ismi
    foreign_languages       varchar(255), -- biladigan chet tillari
    gender                  varchar(255), -- jinsi
    home_phone              varchar(255), -- uy telefon raqami
    img                     varchar(255), -- rasmi
    inps                    varchar(255), -- INPS raqami
    internal_phone          varchar(255), -- ichki telefon raqami
    issue_date              varchar(255), -- ishga olingan sanasi
    issued_by               varchar(255), -- ishga olgan mas'ul shaxs
    job_grade               varchar(255), -- lavozim darajasi
    last_name               varchar(255), -- familiyasi
    middle_name             varchar(255), -- otasining ismi
    military_rank           varchar(255), -- harbiy unvoni
    military_service_status varchar(255), -- harbiy xizmat holati
    mobile_phone            varchar(255), -- mobil telefon raqami
    nationality             varchar(255), -- millati
    organization_name       varchar(255), -- tashkilot nomi
    organization_stir       varchar(255), -- tashkilot STIR(inn) raqami
    passport_series_number  varchar(255), -- pasport seriya raqami
    permanent_address       varchar(255), -- doimiy manzili
    pinfl                   varchar(255), -- PINFL raqami
    place_of_birth          varchar(255), -- tug'ilgan joyi
    political_affiliation   varchar(255), -- partiyaviyligi (yes/no)
    position                varchar(255), -- lavozimi
    position_count          integer, -- shu paytgacha ishlagan lavozimlari soni
    registration_date       varchar(255), -- ro'yxatga olingan sanasi
    specialization          varchar(255), -- mutaxassisligi
    stir                    varchar(255), -- STIR(inn) raqami
    work_phone              varchar(255), -- ish telefon raqami
    district_id             bigint  -- tuman ID raqami (district jadvalining id ustuni bilan bog'langan)
        constraint fkcfqdvlv14qw2n5ui1q6gqki8j
            references public.district,
    region_id               bigint  -- viloyat ID raqami (region jadvalining id ustuni bilan bog'langan)
        constraint fk52wxtckqgut7nx2o839p1swj2
            references public.region,
    education_level         varchar(255), -- ta'lim darajasi
    end_date                date, -- passport muddati tugaydigan sana
    start_date              date, -- passport berilgan sana
    created_at              timestamp(6), -- yaratilgan sanasi
    updated_at              timestamp(6), -- yangilangan sanasi
    military_ticket_number  varchar(255), -- harbiy chiptas raqami
    position_id             bigint  -- lavozim ID raqami (position jadvalining id ustuni bilan bog'langan)
        constraint dkwin48384n9fju28j
            references public.position(id),
    department_id           bigint  -- bo'lim ID raqami (department jadvalining id ustuni bilan bog'langan)
        constraint fk33i80qi0r82hlhoaern2972c8
            references public.department,
    status                  varchar(255) -- ish holati ("Bo`shatilgan", "Ish faoliyatida", "Noma'lum")
);

create table public.department_personal -- Bo'limlar va hodimlarni bog'laydigan Many-to-Many Table
(
    department_id bigint not null -- bo'lim ID raqami (department jadvalining id ustuni bilan bog'langan)
        constraint fk11monipx5pv8dvij2rgsytrme
            references public.department,
    personal_id   bigint not null -- hodim ID raqami (personal jadvalining id ustuni bilan bog'langan)
        constraint fk3b09446451yk5drt2bydyi7cu
            references public.personal
);

create table public.document -- Ushbu jadvalda hodimlarni ishga olish va ishdan bo'shatish hujjatlari haqida ma'lumotlar saqlanadi
(
    id                 bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    sub_type           varchar(255), -- hujjat sub-turi
    text               varchar(255), -- hujjat matni
    type               varchar(255), -- hujjat turi
    personal_id        bigint -- hodim ID raqami (personal jadvalining id ustuni bilan bog'langan)
        constraint fkhju30vj93nx3gywhgb74b3ms4
            references public.personal,
    signed_personal_id bigint -- imzolagan hodim ID raqami (personal jadvalining id ustuni bilan bog'langan)
        constraint fkp03nxqpif2cvfb06yxasr8i43
            references public.personal,
    created_at         timestamp, -- ma'lumot yaratilgan sana va vaqt
    date               date, -- hujjat sanasi
    updated_at         timestamp, -- ma'lumot yangilangan sana va vaqt
    url                varchar(255), -- hujjatning platformadagi URL yo'li
    doc_number         varchar(255), -- hujjat raqami
    is_generated       boolean -- hujjat tizim tomonidan yaratilganligi (true/false)
);

create table public.income_outcome -- Ushbu jadvalda tashkilotlarga kirish va chiqish harakatlari haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    date             date, -- harakat sanasi
    timestamp        timestamp(6), -- harakat sanansi va vaqti
    type             varchar(255) -- harakat turi (IN: kirish, OUT: chiqish)
        constraint income_outcome_type_check
            check ((type)::text = ANY (ARRAY [('IN'::character varying)::text, ('OUT'::character varying)::text])),
    personal_id      bigint -- hodim ID raqami (personal jadvalining id ustuni bilan bog'langan)
        constraint fkuni4n48g4i3rgse2eqhlepy3
            references public.personal,
    turniket_name    varchar(255) -- turniket nomi
);

create table public.personal_awards -- Ushbu jadvalda hodimlarning mukofotlari saqlanadi
(
    personal_id bigint not null -- hodim ID raqami (personal jadvalining id ustuni bilan bog'langan)
        constraint fkicyssppgjmvqdu92m7g03a115
            references public.personal,
    awards      varchar(255) -- mukofot haqida ma'lumot
);

create table public.personal_document -- Ushbu jadvalda hodimlarning hujjatlari saqlanadi
(
    id          bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    file_url    varchar(255), -- hujjatning platformadagi URL yo'li
    name        varchar(255), -- hujjat nomi
    personal_id bigint -- hodim ID raqami (personal jadvalining id ustuni bilan bog'langan)
        constraint fkgsepyitkskvlxp4vfxi1jav0b
            references public.personal
);

create table public.personal_foreign_languages -- Ushbu jadvalda hodimlarning biladigan chet tillari saqlanadi
(
    personal_id       bigint not null -- hodim ID raqami (personal jadvalining id ustuni bilan bog'langan)
        constraint fkspnue0kva8uusqrb1tltqmg9b
            references public.personal,
    foreign_languages varchar(255) -- chet tili nomi
);

create table personal_relative_releation -- Ushbu jadvalda hodimlarning qarindoshlari haqida ma'lumotlar saqlanadi. Many-to-Many jadval. Qarindoshlar haqida ma'lumotlarni chiqarish uchun relatives jadvaliga JOIN qilib is_deleted ustunidan false bo'lganlarini olib tekshirish kerak
(
    id             bigserial -- id raqam
        primary key,
    relative_id    bigint, -- qarindosh ID raqami (relatives jadvalining id ustuni bilan bog'langan)
    relative_pinfl varchar(32), -- qarindoshning PINFL raqami
    personal_pinfl varchar(32) not null, -- hodimning PINFL raqami
    personal_id    varchar(64), -- hodim ID raqami (personal jadvalining id ustuni bilan bog'langan)
    created_at     timestamp(6) default now(), -- ma'lumot yaratilgan sana
    updated_at     timestamp(6) default now()  -- ma'lumot yangilangan sana
);

create table public.personal_salary -- Ushbu jadvalda hodimlarning oylik ma'lumotlari saqlanadi
(
    id                bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    datetime_created  timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated  timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    month_of_salary   integer, -- oylik ish haqi
    phone_number      varchar(255), -- hodimning telefon raqami
    pinfl             varchar(255) not null, -- hodimning PINFL raqami
    salary_given_date date, -- oylik ish haqi berilgan sana
    text              text, -- oylik ish haqi haqida izoh
    year_of_salary    integer, -- oylik ish haqi yili
    personal_id       bigint -- hodim ID raqami (personal jadvalining id ustuni bilan bog'langan)
        constraint fkltvwggr3g72pb7ea04m7gpkd8
            references public.personal
);

create table public.personal_check -- Asosiy hodimlar jadvali, bu jadvalda barcha hodimlarning asosiy ma'lumotlari saqlanadi. Tashkilotlardagi hodimlar soni, shtatlar sonini chiqarishda ushbu jadvaldan foydalanish kerak. Shtatlar uchun alohida, hodimlar uchun alohida tegishli query tuzish kerak. Ushbu jadvalda ishdan bo'shatilgan hodimlar ham saqlanadi, shuning uchun tashkilotlardagi faol hodimlarni chiqarishda status ustuniga e'tibor berish kerak (status = 'WORKING' bo'lganlarni olish kerak). Tashkilotlardagi shtatlar sonini chiqarishda esa ishdan bo'shatilgan hodimlarni ajratib olish kerak (status != 'FIRED' bo'lganlarni olish kerak)
(
    id                      bigint generated by default as identity -- Hodim ID raqami (primary key)
        primary key,
    birth_date              varchar(255), -- hodimning tug'ilgan sanasi
    department_id           varchar(255), -- hodimning bo'limi ID raqami. Tashkilotlar bo'yicha bo'limlar sonini chiqarish ushbu ustunni ishlatish kerak. Har bir tashkilot uchun personal_check jadvalidagi department_id ustunidagi takrorlanmagan va bo‘sh bo‘lmagan qiymatlarni sanab chiqish kerak (NULL va bo'sh qiymatlarni hisobga olmang)
    department_name         varchar(255), -- hodimning bo'limi nomi
    end_date                date, -- hodimning passport muddati tugaydigan sana
    first_name              varchar(255), -- hodimning ismi
    gender                  varchar(255), -- hodimning jinsi
    last_name               varchar(255), -- hodimning familiyasi
    middle_name             varchar(255), -- hodimning otasining ismi
    nationality             varchar(255), -- hodimning millati
    one_cid                 varchar(255), -- hodimning 1C dasturidagi ID raqami
    organization_id         bigint, -- hodimning tashkilot ID raqami. Tashkilotlarga oid hodimlar haqidagi barcha ma'lumotlarni ushbu ustundan foydalanib chiqarish kerak. organization jadvalining id ustuni bilan bog'langan (1: Navoiyazot, 2: Maxam-Chirchiq, 3: Ammofos-Maxam, 4: Dehqonobod kaliy zavodi, 5: Qizilqum fosforit kompleksi)
    parent_department_id    varchar(255), -- hodimning yuqori bo'lim ID raqami
    parent_department_name  varchar(255), -- hodimning yuqori bo'lim nomi
    passport_series_number  varchar(255), -- hodimning passport seriya raqami
    pinfl                   varchar(255) -- hodimning passport pinfl raqami
        constraint ukgryk70kb92nfw0r8g3mgtbg4q
            unique,
    start_date              date, -- hodimga passport berilgan sana
    academic_degree         varchar(255), -- hodimning ilmiy darajasi
    awards                  varchar(255), -- hodimning mukofotlari
    country                 varchar(255), -- hodimning mamlakati
    datetime_created        timestamp(6), -- hodim ma'lumotlari yaratilgan sana
    datetime_updated        timestamp(6), -- hodim ma'lumotlari yangilangan sana
    deputy_status           varchar(255), -- hodimning deputatlik holati
    district                varchar(255), -- hodim yashaydigan tuman
    employee_number         varchar(255), -- hodimning ishchi raqami
    foreign_languages       varchar(255), -- hodimning biladigan chet tillari
    home_phone              varchar(255), -- hodimning uy telefoni
    military_service_status varchar(255), -- hodimning harbiy xizmat holati
    military_ticket_number  varchar(255), -- hodimning harbiy biljet raqami
    phone_number            varchar(255), -- hodimning telefon raqami
    place_of_birth          varchar(255), -- hodimning tug'ilgan joyi
    position                varchar(255), -- hodimning lavozimi. Tashkilotlardagi shtatlar sonini chiqarish uchun ushbu position null bo'lmaganlarini ajratib chiqarish kerak. Ushbu ustunda bo'sh satrlardan iborat bo'lgan qiymatlar ham bor, har doim shtatlarni tanlashda bo'sh satrlarni bo'sh qiymat deb hisoblash kerak va har doim shunday filter bilan tekshirish kerak -> ( btrim(pc.position) <> '' )
    region                  varchar(255), -- hodim yashaydigan viloyat
    status                  varchar(255) -- hodimning ish holati. "FIRED" - ishdan bo'shatilgan, "WORKING" - ish faoliyatida, "DEKRET" - dekretda (Tashkilotlardagi shtatlar sonini chiqarish uchun ushbu ishdan bo'shatilgan hodimlarni ajratib chiqarish kerak)
);

create table public.relatives -- Ushbu jadvalda hodimlar qarindoshlarining shaxsiy ma'lumotlari saqlanadi. Qarindoshlar haqida ma'lumotlarni chiqarish uchun personal_relative_releation jadvaliga JOIN qilib is_deleted ustunidan false bo'lganlarini olib tekshirish kerak. qarindoshlar sonini chiqarishda faqat DISTINCT sonini emas hammasini olish kerak (ya'ni bir xil qarindoshlar soni ham hisobga olinadi)
(
    id              bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    birth_date      date, -- tug'ilgan sana
    document        varchar(255), -- hujjat turi
    expiration_date date, -- hujjat amal qilish muddati
    first_name      varchar(255), -- ism
    gender          varchar(255), -- jins
    issue_date      date, -- hujjat berilgan sana
    issued_by       varchar(255), -- hujjat kim tomonidan berilganligi
    jshshir         varchar(255), -- hujjat jshshir raqami. qarindoshlar soni chiqarish uchun relatives ustuniga JOIN qilinganda, ushbu ustun ustida bog'lash kerak (personal_relative_releation jadvalidagi relative_pinfl ustuni bilan)
    kinship         varchar(255) -- qarindoshlik darajasi (OTA - hodimning otasi, ONA - hodimning onasi, OZI - hodimning o'zi, ER - hodimning eri, XOTIN - hodimning xotini, FARZAND - hodimning farzandi, AYOL - hodimning ayoli, QAYNOTA - hodimning qaynotasi, QAYNONA - hodimnning qaynonasi, QAYN_AKA_UKA - hodimning qaynakasi yoki qaynukasi, AKA_UKA - hodimning akasi yoki ukasi, QAYN_OPA_SINGIL - hodimning qaynopasi yoki qaynsinglisi, OPA_SINGIL - hodimning opasi yoki singlisi)
        constraint relatives_kinship_check
            check ((kinship)::text = ANY
                   (ARRAY [('OTA'::character varying)::text, ('ONA'::character varying)::text, ('OZI'::character varying)::text, ('ER'::character varying)::text, ('XOTIN'::character varying)::text, ('FARZAND'::character varying)::text, ('AYOL'::character varying)::text, ('QAYNOTA'::character varying)::text, ('QAYNONA'::character varying)::text, ('QAYN_AKA_UKA'::character varying)::text, ('AKA_UKA'::character varying)::text, ('QAYN_OPA_SINGIL'::character varying)::text, ('OPA_SINGIL'::character varying)::text])),
    last_name       varchar(255), -- familiyasi
    middle_name     varchar(255), -- otasining ismi
    passport_number varchar(255), -- pasport raqami
    district_id     bigint -- yashash tumani (district jadvalining id ustuni bilan bog'langan)
        constraint fkq77vecmdvt9m03653hvyhqhl0
            references public.district,
    personal_id     bigint -- qarindosh bo'lgan hodimning ID raqami (personal jadvalining id ustuni bilan bog'langan)
        constraint fkoal3mub1hr66orx8bc1hv6q3l
            references public.personal,
    region_id       bigint -- yashash viloyati (region jadvalining id ustuni bilan bog'langan)
        constraint fk4h0dy43xby5d26kswm5po78dq
            references public.region,
    is_deleted      boolean default false -- ma'lumot o'chirilgan yoki yo'qligi
);

create table public.roles -- Ushbu jadvalda foydalanuvchi rollari haqida ma'lumotlar saqlanadi
(
    id   integer not null -- ID raqam (primary key)
        primary key,
    name varchar(50) -- rol nomi
);

create table public.shtat -- Ushbu jadvalda tashkilotlarning shtat birliklari haqida ma'lumotlar saqlanadi (Tashkilotlardagi shtatlar sonini chiqarishda personal_check jadvalidagi status ustuni "FIRED" bo'lmaganlarni ajratib olish kerak)
(
    id                     bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    datetime_created       timestamp(6), -- ma'lumot yaratilgan sana va vaqt, ushbu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated       timestamp(6), -- ma'lumot yangilangan sana va vaqt
    department_id          varchar(255), -- bo'lim ID raqami
    department_name        varchar(255), -- bo'lim nomi
    parent_department_id   varchar(255), -- yuqori bo'lim ID raqami
    parent_department_name varchar(255), -- yuqori bo'lim nomi
    position_id            varchar(255) -- lavozim ID raqami (position jadvalining id ustuni bilan bog'langan)
        constraint kwicm289fh294n290faa
            references public.position(id),
    position_name          varchar(255), -- lavozim nomi
    shtat_count            integer, -- shtat birliklari soni
    organization_id        bigint -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
);

create table public.sold_lot -- ushbu jadvalda sotilgan lotlar haqida ma'lumotlar saqlanadi (sotilgan yoki to'langan yoki yetkazilgan lotlar haqida ma'lumot olish uchun bargain_status va transaction_sum ustunidan foydalan, majburiy!). Yetkazilgan Azotli, Fosforli, Kaliyli o'g'itlarga oid savollar so'ralganda ushbu jadvalning mxik_code ustuni bilan filter qilish kerak!
(
    id                         bigint       not null -- id raqami
        primary key,
    datetime_created           timestamp(6) not null, -- BU USTUNDAN MA'LUMOT OLINMASIN! (sana uchun transaction_date yoki transaction_date_as_date ustunidan ma'lumot olinadi)
    datetime_updated           timestamp(6) not null, -- BU USTUNDAN MA'LUMOT OLINMASIN! (sana uchun transaction_date yoki transaction_date_as_date ustunidan ma'lumot olinadi)
    account                    varchar(255), -- hisob raqami
    bank_name                  varchar(255), -- bank nomi
    bargain_status             varchar(255), -- savdo holati (yillik yoki oylik sotilgan lotlar hajmi yoki narxi so'ralganda -> ('Разблокирован','Оплата','Исполнено'), to'langan lotlar hajmi yoki narxi so'ralganda -> ('Оплата','Исполнено'), yetkazib berilgan lotlar hajmi yoki narxi so'ralganda -> ('Исполнено') qiymatlarini tanlash kerak)
    buyer_address              varchar(255), -- xaridor manzili
    buyer_inn                  varchar(255), -- xaridor INN raqami
    buyer_name                 varchar(255), -- xaridor nomi
    contract_name              varchar(255), -- shartnoma nomi
    contract_number            varchar(255), -- shartnoma raqami
    contract_type              integer, -- shartnoma turi
    currency                   varchar(255), -- valyuta
    delivery_date              date, -- yetkazib berish sanasi (yillik yoki oylik to'langan yoki yetkazilgan lotlar haqida so'ralganda transaction_date ustunidan foydalanish kerak, delivery_date ustunidan emas)
    delivery_date_deadline     integer, -- yetkazib berish muddati
    lot_id                     bigint -- lot id raqami
        constraint vndiwkzxuidnwj2vi48j
            references public.lot(id),
    measure_unit               varchar(255), -- o'lchov birligi (тонна - tonnada, килограмм - kilogrammda)
    mfo                        varchar(255), -- bank mfo kodi
    pay_date                   date, -- to'lov sanasi (sanalarni transaction_date va transaction_date_as_date bo'yicha olinshi kerak, pay_date ishlatilmaydi)
    payment_date_deadline      integer, -- to'lov muddati
    price_per_contract         double precision, -- har bir shartnoma bo'yicha narx (umumiy summa yoki umumiy narx emas!; umumiy narx uchun transaction_sum ustunidan foydalanish kerak)
    product_group              varchar(255), -- mahsulot guruhi
    product_name               varchar(255), -- mahsulot nomi (ustun qiymatlari rus tilida shuning uchun shunaqa filter qilish kerak: Ammiakli selitra -> product_name ILIKE '%Аммиачная селитра%', Karbamid -> product_name ILIKE '%Карбамид%', Ammofos -> product_name ILIKE '%Аммофос%'; qolgan barcha mahsulotlar 'boshqalar' kategoriyasiga kiradi)
    quantity                   integer, -- sotib olingan lot hajmi (o'lchov birligi measure_unit ga bog'liq)
    quantity_in_lot            integer, -- umumiy lot hajmi
    seller_address             varchar(255), -- sotuvchi zavod manzili
    seller_inn                 varchar(255), -- sotuvchi zavod INN raqami, organization jadvalining inn ustuni bilan bog'langan (yillik yoki oylik sotilgan yoki to'langan yoki yetkazilgan lotlarning soni yoki narxi so'ralganda ushbu qiymatlarni tanlash kerak, majburiy -> (309341717, 200941518, 200599579, 200002933, 200949269, 206887857, '200202240', '204651678'), o'g'itlar so'ralganda esa umumiy jadvaldagi barcha ma'lumotlarni olish kerak!)
    seller_name                varchar(255), -- sotuvchi zavod nomi 
    session                    integer, -- sessiya raqami (0: aniqlanmagan, 1: soat 13:00 gacha, 2: soat 13:00 dan keyin)
    start_price                double precision, -- boshlang'ich narx
    transaction_date           timestamp(6), -- tranzaksiya sanasi va vaqti (yillik yoki oylik yetkazilgan yoki to'langan lotlar soni yoki narxi so'ralganda ushbu ustundan foydalanish kerak; korxonalar bo'yicha sotilgan lotlar narxi so'ralganda ham ushbu ustundan olish kerak)
    transaction_number         varchar(255), -- tranzaksiya raqami
    transaction_sum            double precision, -- sotilgan lotlar umumiy narxi (yillik yoki oylik sotilgan lotlarning narxi so'ralganda joriy ustundan foydalanish kerak)
    warehouse                  varchar(255), -- ombor
    product_group_name         varchar(255), -- mahsulot guruhi nomi
    transaction_date_as_date   date, -- tranzaksiya sanasi (ma'lumot turi 'date' ko'rinishida; asosiy sanalar bo'yicha ustun)
    real_quantity              double precision, -- bu quantity summa chiqarishda ishlatiladi (formulasi: quantity_in_lot / quantity.)
    mxik_code                  varchar(255) -- mahsulot MXIK kodi, product jadvalining mxik_code ustuni bilan bog'langan; O'gitlar haqida so'rov kelganda ushbu ustundan, mahsulot haqida so'rov kelganda product_name ustunidan ma'umot olish kerak; O'g'itlarga oid so'rov kelganda ushbu qiymatlar bilan boshlaganlarni tanlash kerak -> (Azotli o'g'itlar = 03102 (mxik_code ILIKE '03102%'). Fosforli o'g'itlar = 03103 (mxik_code ILIKE '03103%') Kaliyli o'g'itlar = 03104 (mxik_code ILIKE '03104%'))
        constraint ckw8n48vcn238hjbui2hj8j
            references public.product(mxik_code),
    real_quantity_for_amount   double precision, -- Savdoga chiqarilgan lotlar yoki Sotilgan lotlar yoki To'langan lotlar yoki Yetkazilgan lotlar hajmi ya'ni necha tonnaligi so'ralganda ushbu jadvalni tanlash kerak. bu real_quantity ni chiqarishda ishlatiladi (if measure_unit = тонна then real_quantity_for_amount = quantity_in_lot, if measure_unit = килограмм then real_quantity_for_amount = quantity_in_lot / 1000) 
    converted_measure_unit     varchar(255), -- konvertatsiya qilingan o'lchov birligi (misol uchun kilogramm tonnaga konvertatsiya qilinadi)
    product_main_category      varchar(255), -- mahsulotning asosiy kategoriyasi
    create_by                  bigint, -- ma'lumotni yaratgan foydalanuvchi identifikatori
    mxik_name                  varchar(255), -- mahsulot MXIK nomi
    buyer_phone                varchar(255), -- xaridor telefon raqami
    seller_phone               varchar(255) -- sotuvchi telefon raqami
);

create table public.staff_and_technics -- Ushbu jadvalda xodimlar va texnikalar o'rtasidagi munosabatlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    project_id       bigint -- investment_project jadvalidagi id ustuni bilan bog'langan
        constraint fkdidyyy3sc2had2v350kw375gx
            references public.investment_project,
    date             date -- haqiqiy sana
);

create table public.employee -- Ushbu jadvalda barcha ishchilar haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    count            integer, -- ishchilar soni
    date             date, -- sana sifatida datetime_created ustuni ishlatiladi, chunki bu ustun bo'sh
    type             varchar(255), -- ishchi turi
    staff_technic_id bigint -- staff_and_technics jadvalidagi id ustuni bilan bog'langan
        constraint fkj5th7wl8uux7i1fj667ch46u
            references public.staff_and_technics,
    type_id          bigint -- ishchi turi identifikatori (employee_type jadvalidagi id ustuni bilan bog'langan)
        constraint fkk3i11yuktiern5hr2lc2ssedq
            references public.employee_type
);

create table public.staff_position -- Ishchilar lavozimi haqidagi jadval. Hodimlar haqidagi ma'lumotlar personal_check jadvalidan olinadi!
(
    id                bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    organization_stir varchar(255), -- tashkilot STIR(inn) raqami (200599579, 206887857, 200941518, 200002933, 203621367, 309341717) 
    personal_count    integer, -- ishchilar soni
    position_name     varchar(255), -- lavozim nomi
    department_id     bigint -- bo'lim ID raqami
        constraint fk2rccfqg11kksq37ku44aforg5
            references public.department,
    personal_limit    integer, -- shtat bo'yicha limit
    position_id       bigint -- lavozim ID raqami
);

create table public.staff_position_personal -- Ushbu jadvalda ishchilarning lavozimlari haqida ma'lumotlar saqlanadi
(
    staff_position_id bigint not null -- staff_position jadvalidagi id ustuni bilan bog'langan
        constraint fkenwbelkxri3j1jo9cxwwhr4ex
            references public.staff_position,
    personal_id       bigint not null -- personal jadvalidagi id ustuni bilan bog'langan
        constraint fk4g6cca23bg6rac107ys84xohl
            references public.personal,
    primary key (staff_position_id, personal_id)
);

create table public.technic_type -- Ushbu jadvalda texnika turlari haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    name             varchar(255) -- texnika nomi
);

create table public.technic -- Ushbu jadvalda barcha texnikalar haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    count            integer, -- soni
    date             date, -- sana sifatida datetime_created ustuni ishlatiladi, chunki bu ustun bo'sh
    type             varchar(255), -- texnika turi
    staff_technic_id bigint -- staff_and_technics jadvalidagi id ustuni bilan bog'langan
        constraint fk533a8656ys7vo6ae0nyhm1hdc
            references public.staff_and_technics,
    type_id          bigint -- texnika turi identifikatori (technic_type jadvalidagi id ustuni bilan bog'langan)
        constraint fk1p17alcuk8x54t91yoap9ca3f
            references public.technic_type
);

create table public.technical_tasks -- Ushbu jadvalda texnik vazifalar haqida ma'lumotlar saqlanadi
(
    id                      bigint       not null -- ID raqam (primary key)
        primary key,
    create_by               bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created        timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated        timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    document_sign           text, -- hujjat imzosi
    file_url                varchar(255), -- hujjatning platformadagi URL yo'li
    name                    varchar(255), -- texnik vazifa nomi
    status                  varchar(255) -- texnik vazifa holati (APPROVED: tasdiqlangan, REJECTED: rad etilgan)
        constraint technical_tasks_status_check
            check ((status)::text = ANY
                   (ARRAY [('APPROVED'::character varying)::text, ('REJECTED'::character varying)::text])),
    application_document_id bigint       not null -- application_documents jadvalidagi id ustuni bilan bog'langan
        constraint fkr2ih7gt2tb4we25nk55hn50gr
            references public.application_documents
);

create table public.trade_offers -- Ushbu jadvalda savdo takliflari haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    contract_id      varchar(255), -- shartnoma identifikatori
    contract_lot     bigint, -- shartnoma loti
    currency         varchar(255), -- valyuta
    deal_lot_count   integer, -- bitim loti soni
    exchange_rate    double precision, -- valyuta kursi
    offer_direction  varchar(255), -- taklif yo'nalishi (Продажа: sotish, Покупка: sotib olish)
    offer_lot_count  integer, -- taklif loti soni
    offer_price      double precision, -- taklif narxi
    offer_status     varchar(255), -- taklif holati
    product_unit     varchar(255), -- mahsulot birligi
    region_code      varchar(255) -- viloyat kodi (region jadvalidagi faktura_region_code ustuni bilan bog'langan)
        constraint dkwickj3bn6jd4kjdkj
            references public.region(faktura_region_code),
    rn               bigint, -- rn
    seller_tin       varchar(255) -- sotuvchi STIR(inn) raqami (organization jadvalidagi inn ustuni bilan bog'langan)
        constraint mxikweunu4n39nd73nnss
            references public.organization(inn),
    session          varchar(255), -- sessiya
    short_name       varchar(255), -- qisqa nomi
    total_count      bigint, -- jami soni
    trade_date       date, -- savdo sanasi
    deal_number      varchar(255) -- bitim raqami
);

create table public.transgaz_organization -- Ushbu jadvalda gaz bo'yicha transgaz bilan oldi sotdi qiladigan tashkilotlar haqida ma'lumotlar saqlanadi
(
    id                bigint       not null
        primary key,
    create_by         bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created  timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated  timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    organization_name varchar(255), -- tashkilot nomi
    point_code        varchar(255) -- tashkilot hisoblagich kodi
        constraint dkwickj3kjd4kjdkj
            references public.transgaz_point(point_code)
);

create table public.transgaz_point -- Ushbu jadvalda gaz bo'yicha transgaz hisoblagichlari haqida ma'lumotlar saqlanadi
(
    id                   bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created     timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated     timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    device_model         varchar(255), -- qurilma modeli
    device_serial_number varchar(255), -- qurilma seriya raqami
    grs_name             varchar(255), -- GRS nomi
    modem                varchar(255), -- modem
    org_type             varchar(255), -- tashkilot turi
    point_code           varchar(255) -- hisoblagich kodi
        constraint dkwickj3kjd4kjde3dd
            references public.transgaz_organization(point_code),
    point_id             varchar(255) -- hisoblagich ID raqami (transgaz_point_readings jadvalidagi point_id ustuni bilan bog'langan)
        constraint dkwickj3kjdbmriik23kjd
            references public.transgaz_point_readings(point_id),
    point_type           varchar(255), -- hisoblagich turi
    purpose              varchar, -- maqsad
    create_by            bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.transgaz_point_readings -- Ushbu jadvalda gaz bo'yicha transgaz hisoblagichlari ko'rsatkichlari haqida ma'lumotlar saqlanadi
(
    id                    bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created      timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated      timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    co2                   double precision, -- CO2 ko'rsatkichi
    n2                    double precision, -- N2 ko'rsatkichi
    accounting_time       integer, -- hisoblash vaqti
    density               double precision, -- zichlik
    differential_pressure double precision, -- farq bosimi
    point_id              varchar(255) -- hisoblagich ID raqami (transgaz_point jadvalidagi point_id ustuni bilan bog'langan)
        constraint qkwickj3kjdbmriik23kjd
            references public.transgaz_point(point_id),
    pressure              double precision, -- bosim
    temperature           double precision, -- harorat
    timestamp             timestamp(6), -- ko'rsatkichlar sanasi va vaqti
    volume                double precision, -- hajm
    create_by             bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.ttn -- Ushbu jadvalda ttn ya'ni jo'natma xati haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqami (primary key)
        primary key,
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, ushbu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    message          varchar(255), -- jo'natma xatidagi xabar
    name             varchar(255), -- jo'natma xati(ttn) nomi
    result_code      integer      not null,
    unique_id        varchar(255), -- fakturauz platformasidagi id raqami (faktura_uz_document jadvalidagi unique_id ustuni bilan bog'liq)
    transfer_id      bigint, -- transfer id raqami
    status           varchar(255), -- jo'natma xati(ttn) holati
    description      text, -- jo'natma xati(ttn) holati haqidagi izoh
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    is_sent          boolean -- jo'natma jo'nailgan yoki yo'qligi (true/false)
);

create table public.user_warehouse -- Ushbu jadvalda foydalanuvchi va omborlar o'rtasidagi munosabatlar saqlanadi
(
    username      varchar, -- foydalanuvchi nomi (users jadvalidagi username ustuni bilan bog'langan)
    warehouse1cid varchar -- ombor 1C identifikatori
);

create table public.user_warehouse1cid -- Ushbu jadvalda foydalanuvchi va 1C omborlari o'rtasidagi munosabatlar saqlanadi (Many to Many Table)
(
    id            integer, -- ID raqami (primary key)
    username      text, -- foydalanuvchi nomi (users jadvalidagi username ustuni bilan bog'langan)
    warehouse1cid text -- 1C ombori identifikatori
);

create table public.users
(
    id               bigint       not null -- foydalanuvchi id raqami
        primary key,
    datetime_created timestamp(6) not null, -- foydalanuvchi yaratilgan vaqt
    datetime_updated timestamp(6) not null, -- foydalanuvchi ma'lumotlari yangilangan vaqt
    deleted          boolean default false, -- foydalanuvchi o'chirilgan yoki yo'qligini bildiradi (true/false)
    full_name        varchar(255), -- foydalanuvchining to'liq ismi
    is_enabled       boolean default true, -- foydalanuvchi faolligini bildiradi (true/false)
    password         varchar(255), -- foydalanuvchining paroli
    picture          varchar(255), -- foydalanuvchining rasmi
    username         varchar(255) not null -- foydalanuvchining foydalanuvchi nomi
        constraint ukr43af9ap4edm43mmtq01oddj6
            unique,
    organization_id  bigint -- foydalanuvchi tashkiloti
        constraint fk9q8fdenwsqjwrjfivd5ovv5k3
            references public.organization,
    warehouse_id     bigint, -- foydalanuvchi ombori
    passport_number  varchar(255), -- foydalanuvchining pasport raqami
    pinfl            varchar(255), -- foydalanuvchining PINFL raqami
    create_by        bigint -- foydalanuvchini kim yaratgan
);

create table public.application_signers -- Ushbu jadvalda ariza imzolovchilari haqida ma'lumotlar saqlanadi
(
    id                      bigint       not null -- ID raqam (primary key)
        primary key,
    create_by               bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created        timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustnni umumiy sana sifatida ishlatish kerak
    datetime_updated        timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    key                     text         not null -- imzo kaliti
    signed_document         text         not null, -- imzolangan hujjat
    application_document_id bigint       not null -- ariza hujjati ID raqami
        constraint fk5moxmnfn65hujd2slliorvcmy
            references public.application_documents,
    organization_id         bigint       not null -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fkt38jhph23lqdm955q4vdfrhy1
            references public.organization,
    user_id                 bigint       not null -- foydalanuvchi ID raqami (users jadvalining id ustuni bilan bog'langan)
        constraint fkeipiwetsxhxa7659m6mg5rfgl
            references public.users,
    status                  varchar(255) -- ariza holati (APPROVED: tasdiqlangan, REJECTED: rad etilgan)
        constraint application_signers_status_check
            check ((status)::text = ANY
                   (ARRAY [('APPROVED'::character varying)::text, ('REJECTED'::character varying)::text]))
);

create table public.eimzo -- Ushbu jadvalda E-IMZO (elektron imzo) haqida ma'lumotlar saqlanadi
(
    id                         bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created           timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated           timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    data                       varchar(255), -- E-IMZO ma'lumotlari
    director_name              varchar(255), -- direktor ismi
    director_pinfl             varchar(255), -- direktor PINFL raqami
    error_code                 integer, -- xatolik kodi
    error_message              varchar(255), -- xatolik xabari
    is_individual_entrepreneur boolean, -- yakka tartibdagi tadbirkor (true/false)
    is_legal                   boolean, -- yuridik shaxs
    name                       varchar(255), -- nomi
    pinfl                      varchar(255), -- PINFL
    serial_number              varchar(255), -- seriya raqami
    success                    boolean      not null, -- muvaffaqiyatli yoki yo'qligi (true/false)
    timestamp                  varchar(255), -- vaqt
    tin                        varchar(255), -- TIN raqami
    tin_pinfl                  varchar(255), -- TIN yoki PINFL raqami
    user_id                    bigint -- foydalanuvchi ID raqami (users jadvalining id ustuni bilan bog'langan)
        constraint fk83wkr1kkoxsran7o8jt0gq9m9
            references public.users,
    secret_key                 varchar(255), -- maxfiy kalit
    create_by                  bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.user_1c_organization -- Ushbu jadvalda foydalanuvchi va 1C tashkilotlari o'rtasidagi munosabatlar saqlanadi (Many to Many Table)
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    organization_id  bigint -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fkgwpwqufxef9lh3vqb0irysxec
            references public.organization,
    user_id          bigint -- foydalanuvchi ID raqami (users jadvalining id ustuni bilan bog'langan)
        constraint fklgrfbw5k5jb54j46w2nsl5it9
            references public.users,
    create_by        bigint -- yaratuvchi (foydalanuvchi) ID raqami
);

create table public.user_action_log -- Ushbu jadvalda foydalanuvchi harakatlari haqida ma'lumotlar saqlanadi
(
    id            bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    action_info   varchar(255), -- foydalanuvchi harakati haqida ma'lumot
    requested_url varchar(255), -- so'rov yuborilgan URL manzili
    time          timestamp(6) not null, -- harakat vaqti
    user_id       bigint -- foydalanuvchi ID raqami (users jadvalining id ustuni bilan bog'langan)
        constraint fk4u2mqi2ifkc6i5gdp71q6l4me
            references public.users
);

create table public.user_roles -- Ushbu jadvalda foydalanuvchi rollari haqida ma'lumotlar saqlanadi (Many-to-Many Table)
(
    user_id bigint  not null -- foydalanuvchi ID raqami (users jadvalining id ustuni bilan bog'langan)
        constraint fkhfh9dx7w3ubf1co1vdev94g3f
            references public.users,
    role_id integer not null -- rol ID raqami (roles jadvalining id ustuni bilan bog'langan)
        constraint fkh8ciramu9cc9q3qcqiv4ue8a6
            references public.roles,
    primary key (user_id, role_id) -- Ikkita ustun bo'yicha birinchi kalit
);

create table public.wagon_numbers -- Ushbu jadvalda vagon raqamlari haqida ma'lumotlar saqlanadi
(
    shipment_id        bigint not null -- jo'natma ID raqami (enaklodnoy_shipment jadvalining id ustuni bilan bog'langan)
        constraint fksxhwos7w9asq9a1gbhk0n587k
            references public.enaklodnoy_shipment,
    wagon_number       varchar(255), -- vagon raqami
    product_etsng_code varchar(255), -- mahsulot ETSNG kodi
    product_etsng_name varchar(255), -- mahsulot ETSNG nomi
    product_gng_code   varchar(255), -- mahsulot GNG kodi
    product_gng_name   varchar(255), -- mahsulot GNG nomi
    weight_netto       double precision -- to'liq og'irlik (netto)
    id                 bigint generated by default as identity -- ID raqami
);

create table public.warehouse -- Ushbu jadvalda omborlar haqida ma'lumotlar saqlanadi
(
    id                 bigint       not null -- id raqami (primary key)
        primary key,
    datetime_created   timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated   timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    name               varchar(255), -- ombor nomi
    warehouse1cid      varchar(255), -- omborning 1C dasturi identifikatori
    address            varchar(255), -- ombor manzili
    created_by_id      bigint -- ma'lumotni yaratgan foydalanuvchi identifikatori (users jadvalining id ustuni bilan bog'langan)
        constraint fk5afsyijpp50x66p7nkt2wil8h
            references public.users,
    district_id        bigint -- ombor joylashgan tuman identifikatori (district jadvalining id ustuni bilan bog'langan)
        constraint fkn9j18l8syelgwi3ikkrcx5ptx
            references public.district,
    organization_id    bigint -- ombor tashkiloti identifikatori (organization jadvalining id ustuni bilan bog'langan) (Vakolatli omborda organization korxona yoki zavod bo'lmaydi)
        constraint fk363w26pip2e3j8p65pao5xkvc
            references public.organization,
    warehouse_type     varchar(255) -- ombor turi (CLIENT: Ombordan fermerga mahsulot chiqim qilinganda (sotilganda) yetib borish ombori hisoblanadi, STORAGE: Oddiy ombor, turli o'g'it mahsulotlari saqlanadi, PRODUCTION: Korxonalarning (zavodlarning) ichki ishlab chiqarish omborlari)
        constraint warehouse_warehouse_type_check
            check ((warehouse_type)::text = ANY
                   (ARRAY [('CLIENT'::character varying)::text, ('STORAGE'::character varying)::text, ('PRODUCTION'::character varying)::text])),
    create_by          bigint, -- ma'lumotni yaratgan foydalanuvchi identifikatori
    latitude           double precision, -- omborning kenglik koordinatasi (geografik joylashuv)
    longitude          double precision, -- omborning uzunlik koordinatasi (geografik joylashuv)
    is_deleted         boolean default false, -- ombor o'chirilgan yoki yo'qligini bildiradi (true/false)
    working_factory_id bigint -- ombor bilan ishlayotgan zavod yoki tashkilot identifikatori (organization jadvalining id ustuni bilan bog'langan)
        constraint fk7ygdx2w2dnku4tr4egrxyah67
            references public.organization,
    previous_name      varchar(255) -- omborning oldingi nomi (agar nomi o'zgargan bo'lsa, bu ustunda saqlanadi)
);

create table public.camera -- Ushbu jadvalda kameralar haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    camera_id        varchar(255) not null -- kamera ID raqami
        constraint uk83iofr88gx11wu0q67kk7xe05
            unique,
    host             varchar(255), -- kamera joylashgan server manzili
    password         varchar(255), -- kamera paroli
    path             varchar(255), -- kamera manzili
    port             varchar(255), -- kamera porti
    title            varchar(255), -- kameraga egalik qiluvchi tashkilot nomi
    url              varchar(255) not null, -- kamera URL manzili
    username         varchar(255), -- kamera foydalanuvchisi nomi
    investment_id    bigint -- investitsiya loyihasi ID raqami (investment_project jadvalining id ustuni bilan bog'langan)
        constraint fk19gjr563x0tnyv2uhyg5qy26g
            references public.investment_project,
    warehouse_id     bigint -- ombor ID raqami (warehouse jadvalining id ustuni bilan bog'langan)
        constraint fkqbcjwxx1abbodbbqoe9vo00
            references public.warehouse
);

create table public.attachment -- Ushbu jadvalda kameralar olgan rasmlarni URL yo'llari haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    file_url         varchar(255), -- fayl URL manzili
    warehouse_id     bigint -- ombor ID raqami (warehouse jadvalining id ustuni bilan bog'langan)
        constraint fkfdbf7odfc9mipsonkv7ug4d9p
            references public.warehouse,
    camera_id        bigint -- kamera ID raqami (camera jadvalining id ustuni bilan bog'langan)
        constraint fk2evmblk2twvu7s6nym7dpjxk2
            references public.camera
);

create table public.queue_code -- Ushbu jadvalda foydalanuvchilarga yuborilgan tasdiqlash kodlari haqida ma'lumotlar saqlanadi
(
    id               bigint generated by default as identity -- ID raqam (primary key)
        primary key,
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    code             integer, -- tasdiqlash kodi
    is_expired       boolean -- amal qilish muddati o'tganligi (true/false)
    pair             boolean, -- juftlik (true/false)
    warehouse_id     bigint -- ombor ID raqami (warehouse jadvalining id ustuni bilan bog'langan)
        constraint fkotk2wlhoglopkv2evvtmuehys
            references public.warehouse
);

create table public.warehouse_amount -- Ushbu jadvalda omborlardagi mahsulotlar miqdori haqida ma'lumotlar saqlanadi. Tashkilot omborlaridagi mahsulotlar miqdori va qoldiqlarini kuzatib borish uchun shu jadvaldan foydalanish kerak. Vakolatli omborlar qoldiqlarini chiqarishda ham shu jadvaldan foydalanish kerak. Viloyati yoki tuman bo'yicha qaysidur og'it qoldig'i(miqdori) so'ralganda shu jadvaldan foydalanish kerak.
(
    id               bigint default nextval('warehouse_amount_id_seq'::regclass) not null -- ID raqam 
        primary key,
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    date             date, -- sana va vaqt uchun datetime_created ustuni ishlatiladi, chunki date ustuni bo'sh
    quantity         double precision, -- ombordagi mahsulot miqdori. bu qiymat kilogrammda o'lchangan, tonnada chiqarish kerak, ya'ni chiqqan javobni 1000ga bo'lish kerak. (quantity/1000)
    organization_id  bigint -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fknnfecrjwcwhl2f2omnbji2dan
            references organization,
    product_id       bigint -- mahsulot ID raqami (product jadvalining id ustuni bilan bog'langan)
        constraint fk7fl5xps3o5ve3b9w7u3p8a6yb
            references product,
    warehouse_id     bigint -- ombor ID raqami (warehouse jadvalining id ustuni bilan bog'langan)
        constraint fk4r1r8cvovrgoil2w5f8lgcxif
            references warehouse,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    constraint unique_warehouse_amount
        unique (organization_id, warehouse_id, product_id)
);

create table public.warehouse_bijra_contract -- Ushbu jadvalda omborlar va bijra o'rtasidagi shartnomalar haqida ma'lumotlar saqlanadi (Many to Many Table)
(
    warehouse_id    bigint       not null -- ombor ID raqami (warehouse jadvalining id ustuni bilan bog'langan)
        constraint fkdfqqvfv57ygq473fp9xltjd2b
            references public.warehouse,
    contract_number varchar(255) not null, -- shartnoma raqami
    primary key (warehouse_id, contract_number)
);

create table public.warehouse_stock_income_output -- Ushbu jadvalda omborlardagi mahsulotlarning birjadagi kirim-chiqim ma'lumotlari saqlanadi. Umumiy ma'lumotlar olish uchun transfer jadvalidan foydalanish kerak.
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    account          varchar(255), -- hisob raqami
    closing_stock    double precision, -- ombordagi yopilish zaxirasi
    datetime_deleted timestamp(6), -- ma'lumot o'chirilgan sana va vaqt
    deleted          boolean, -- o'chirilganligi (true/false)
    inn              varchar(255), -- INN raqami
    mxik_code        varchar(255), -- MXIK kodi
    opening_stock    integer, -- ombordagi ochilish zaxirasi
    organization_id  varchar(255), -- tashkilot ID raqami
    period           timestamp(6), -- kirim-chiqim davri
    product_id       varchar(255), -- mahsulot ID raqami
    product_name     varchar(255), -- mahsulot nomi
    warehouse_id     varchar(255), -- ombor ID raqami
    warehouse_name   varchar(255), -- ombor nomi
    unit             varchar(255), -- o'lchov birligi
    create_by        bigint -- yaratuvchi foydalanuvchi ID raqami
);

create table public.stock_income_output_detail -- Ushbu jadvalda omborlardagi mahsulotlarning kirim-chiqim tafsilotlari haqida 1C dasturidan keladigan ma'lumotlar saqlanadi. Umumiy ma'lumotlar olish uchun transfer jadvalidan foydalanish kerak.
(
    id                               bigint       not null -- ID raqam (primary key)
        primary key,
    datetime_created                 timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated                 timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    account                          varchar(255), -- hisob raqami
    account_credit                   varchar(255), -- kredit hisob raqami
    account_debit                    varchar(255), -- debit hisob raqami
    datetime_deleted                 timestamp(6), -- ma'lumot o'chirilgan sana va vaqt
    deleted                          boolean, -- o'chirilganligi (true/false)
    stock                            double precision, -- ombordagi zaxira miqdori
    sub1                             varchar(255), -- birinchi qo'shimcha ma'lumot
    sub2                             varchar(255), -- ikkinchi qo'shimcha ma'lumot
    type                             varchar(255) -- kirim-chiqim turi (INCOME: kirim, OUTCOME: chiqim)
        constraint stock_income_output_detail_type_check
            check ((type)::text = ANY
                   (ARRAY [('INCOME'::character varying)::text, ('OUTCOME'::character varying)::text])),
    warehouse_stock_income_output_id bigint -- warehouse_stock_income_output jadvalidagi ID raqami bilan bog'lanadi
        constraint fkgb6kpv8i2sd6kaopipe7po75g
            references public.warehouse_stock_income_output,
    operation_type                   varchar(255), -- operatsiya turi
    operation_type_code              varchar(255), -- operatsiya turi kodi
    sub1id                           varchar(255), -- birinchi qo'shimcha ma'lumot ID raqami
    sub2id                           varchar(255), -- ikkinchi qo'shimcha ma'lumot ID raqami
    create_by                        bigint, -- yaratuvchi foydalanuvchi ID raqami
    wagon_number                     varchar(255) -- vagon raqami
);

create table public.transfer -- Ushbu jadvalda tashkilot yoki omborlar o‘rtasida mahsulotlarni tashish va yetkazib berish hamda kirim-chiqimga oid barcha ma’lumotlar saqlanadi (kirim-chiqim database da transfer deb yuritiladi)
(
    id                               bigint       not null -- ID raqami (primary key)
        primary key,
    datetime_created                 timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated                 timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    approved_date                    timestamp(6), -- tasdiqlangan sana
    status                           varchar(255) -- kirim-chiqimning ichki holati(ACTIVE: faol, DELETE: o'chirilgan, NO_VALID: yaroqsiz, TEMP: vaqtinchalik, DIS_ACTIVE: faol emas, CANCELLED: bekor qilingan)
        constraint transfer_status_check
            check ((status)::text = ANY
                   (ARRAY [('ACTIVE'::character varying)::text, ('DELETE'::character varying)::text, ('NO_VALID'::character varying)::text, ('TEMP'::character varying)::text, ('DIS_ACTIVE'::character varying)::text, ('CANCELLED'::character varying)::text])),
    total_quantity                   double precision, -- mahsulot umumiy miqdor
    transfer_status                  varchar(255) -- transfer holati(NEW: yangi, ON_THE_ROAD: yo'lda, DELIVERED: yetkazilgan)
        constraint transfer_transfer_status_check
            check ((transfer_status)::text = ANY
                   (ARRAY [('NEW'::character varying)::text, ('ON_THE_ROAD'::character varying)::text, ('DELIVERED'::character varying)::text])),
    approved_user_id                 bigint -- tasdiqlagan foydalanuvchi ID raqami (users jadvalining id ustuni bilan bog'langan)
        constraint fkg6q395bm7k85hacl4w5704qp1
            references public.users,
    from_warehouse_id                bigint -- jo'natilayotgan ombor ID raqami (warehouse jadvalining id ustuni bilan bog'langan)
        constraint fkaxhwbulyi26p3e6wu6xvnm4e9
            references public.warehouse,
    to_warehouse_id                  bigint -- qabul qilinayotgan ombor ID raqami (warehouse jadvalining id ustuni bilan bog'langan)
        constraint fkfeutcfmjqkxv8tald4rf4eo1
            references public.warehouse,
    warehouse_stock_income_output_id bigint -- warehouse_stock_income_output jadvalidagi ID raqami bilan bog'lanadi
        constraint fkd2lc61j0riqku19w47b3eqlnw
            references public.warehouse_stock_income_output,
    organization_id                  bigint -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fko8jnpvkf53ksuavl9fba61bjc
            references public.organization,
    period                           date, -- kirim-chiqim davri
    product_id                       varchar(255), -- mahsulot ID raqami (product jadvalining id ustuni bilan bog'langan)
    product_name                     varchar(255), -- mahsulot nomi
    lot_id                           bigint, -- lot ID raqami (lot jadvalining id ustuni bilan bog'langan)
    doverennost_number               varchar(255), -- ishonchnoma raqami
    doverennost_id                   bigint -- ishonchnoma ID raqami (faktura_uz_document jadvalining id ustuni bilan bog'langan)
        constraint fkct8g2t15qs72d1w2rexc0w93w
            references public.faktura_uz_document,
    signature                        text, -- eimzo platformasidagi kalit
    product_name_in_lot              varchar(255), -- lotdagi mahsulot nomi
    driver_pinfl                     varchar(255), -- haydovchining PINFL raqami
    transport_number                 varchar(255), -- transport raqami
    transport_model                  varchar(255), -- transport modeli
    deliverer_pinfl                  varchar(255), -- yetkazib beruvchi PINFL raqami
    description                      text, -- kirim-chiqim tavsifi
    mxik_code                        varchar(255), -- MXIK kodi
    product_mxik_id                  bigint -- mahsulot MXIK ID raqami (product jadvalining id ustuni bilan bog'langan)
        constraint fkt64cfngn8jtqxne5hshhru07u
            references public.product,
    farmer_district_id               bigint -- fermer xo'jaligi joylashgan tuman ID raqami (district jadvalining id ustuni bilan bog'langan)
        constraint fkkhsdxqvd269eur9x8fpndpq70
            references public.district,
    warehouse_district_id            bigint -- ombor joylashgan tuman ID raqami (district jadvalining id ustuni bilan bog'langan)
        constraint fki8y1qoe9vhn119jqv7qotbrfe
            references public.district,
    transport_owner_pinfl            varchar(255), -- transport egasining PINFL raqami
    driver_name                      varchar(255), -- haydovchining ismi
    factory_id                       bigint -- zavod ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fkgbkpv7tu50wdmxn0ayd0ou1f1
            references public.organization,
    create_by                        bigint, -- yaratuvchi foydalanuvchi
    e_nakladnoy_number               varchar(255), -- e-nakladnoy platformasidagi raqami
    wagon_number                     varchar(255), -- vagon raqami
    cancelled_by_user_id             bigint -- qaysi foydalanuvchi tomonidan bekor qilingan
        constraint fknv70egobii1dt1jct8x4xl6rv
            references public.users
);

create table public.warehouse_transfer_migration -- Ushbu jadvalda omborlar o'rtasidagi ko'chirishlar haqida ma'lumotlar saqlanadi
(
    id               bigint       not null -- ID raqam (primary key)
        primary key,
    create_by        bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created timestamp(6) not null, -- ma'lumot yaratilgan sana va vaqt, bu ustunni umumiy sana sifatida ishlatish kerak
    datetime_updated timestamp(6) not null, -- ma'lumot yangilangan sana va vaqt
    factory_id       bigint -- zavod ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fkggj10ntfmw74l9y75prdka0pt
            references public.organization,
    organization_id  bigint -- tashkilot ID raqami (organization jadvalining id ustuni bilan bog'langan)
        constraint fk6tyhr6xypv87x4ym5imp7ebb7
            references public.organization,
    user_id          bigint -- foydalanuvchi ID raqami (users jadvalining id ustuni bilan bog'langan)
        constraint fk1iwsghbulgc662k26nq185963
            references public.users,
    warehouse_id     bigint -- ombor ID raqami (warehouse jadvalining id ustuni bilan bog'langan)
        constraint fk3c0svp67x781wxolaxpigfrpb
            references public.warehouse
);

create table public.report_document -- Ushbu jadvalda hisobot hujjatlari haqida ma'lumotlar saqlanadi
(
    id                   bigint                     not null -- ID raqam (primary key)
        primary key,
    create_by            bigint, -- yaratuvchi (foydalanuvchi) ID raqami
    datetime_created     timestamp(6) default now() not null, -- ma'lumot yaratilgan sana va vaqt
    datetime_updated     timestamp(6)               not null, -- ma'lumot yangilangan sana va vaqt
    account              varchar(255), -- hisob raqami
    amount               double precision, -- summa
    approver             varchar(255), -- tasdiqlovchi
    basis                varchar(255), -- asos
    contract_amount      numeric(38, 2), -- shartnoma summasi
    contractor           varchar(255), -- pudratchi
    contractor_agreement varchar(255), -- pudratchi bilan kelishuv
    created_at           timestamp(6), -- ma'lumot yaratilgan sana va vaqt
    currency             varchar(255), -- valyuta
    date                 timestamp(6), -- hujjat sanasi
    document_number      varchar(255), -- hujjat raqami
    expense_direction    varchar(255), -- xarajat yo'nalishi
    initiator            varchar(255), -- tashabbuskor
    inn                  varchar(255), -- INN raqami
    number               varchar(255), -- hujjat raqami
    operation_type       varchar(255), -- operatsiya turi
    payment_purpose      varchar(255), -- to'lov maqsadi
    priority             varchar(255), -- ustuvorlik
    recipient            varchar(255), -- qabul qiluvchi
    responsible          varchar(255), -- mas'ul
    status               varchar(255), -- holat
    status_code          integer, -- holat kodi
    c1id                 varchar(255) -- 1C dasturidagi ID raqami
        constraint uk81i9rtwpfsapj77agu0t3blsn
            unique,
    article1cid          varchar(255) -- 1C dasturidagi harajat ID raqami
);