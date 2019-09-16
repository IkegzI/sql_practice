DECLARE
PHONE_EXIST VARCHAR2(4 BYTE) := '';
DEBIT_EXIST VARCHAR2(4 BYTE) := '';
CMD_EXIST VARCHAR2(4 BYTE) := '';
UL_FL NUMBER(1,0) := 1;
DEBIT_TYPE NUMBER(1,0) := 0;
PARTY_EXIST NUMBER(10,0) := 0;
DEBIT VARCHAR2(20 BYTE) := '40817810000000001905';
PHONE VARCHAR2(13 BYTE) := '79143288048';
BEGIN

select count(T_CODCLIENT) into PARTY_EXIST from DDEPOSITR_DBT where T_ACCOUNT = DEBIT;
if PARTY_EXIST > 0 then
    UL_FL := 2;  
    select max(T_CODCLIENT) into PARTY_EXIST from DDEPOSITR_DBT where T_ACCOUNT = DEBIT;      
else
    select max(T_CLIENT) into PARTY_EXIST from DACCOUNT_DBT where T_ACCOUNT = DEBIT;
    UL_FL := 1;
end if;

select count(linkid) into PHONE_EXIST from USMSS_DBT where link = PHONE;
if PHONE_EXIST > 0 then
    select USMSS_DBT.linkid into PHONE_EXIST from USMSS_DBT where link = PHONE;
else
    insert into USMSS_DBT VALUES ( (select max(linkid) from  USMSS_DBT)+1, PHONE, 'H', '1', 0, 0, 0, 1);
    select USMSS_DBT.linkid into PHONE_EXIST from USMSS_DBT where link = PHONE;
end if;

select count(id) into DEBIT_EXIST from USTSNACCS_DBT where ACCOUNT = DEBIT;
if DEBIT_EXIST > 0 then
    select USTSNACCS_DBT.ID into DEBIT_EXIST from USTSNACCS_DBT where ACCOUNT = DEBIT;
else
    insert into USTSNACCS_DBT VALUES ( (select max(id) from  USTSNACCS_DBT)+1, DEBIT, chr(0), chr(0), chr(0), chr(0), 'X', 'X', chr(0), current_date, '', '' , 1, PARTY_EXIST, UL_FL);
    select USTSNACCS_DBT.ID into DEBIT_EXIST from USTSNACCS_DBT where ACCOUNT = DEBIT;
end if;

select count(id) into CMD_EXIST from USMSCMD_DBT where ID = DEBIT_EXIST and LINKID = PHONE_EXIST;
if CMD_EXIST = 0 then
    insert into USMSCMD_DBT VALUES ('I', DEBIT_EXIST, PHONE_EXIST, 1);
    insert into USMSCMD_DBT VALUES ('O', DEBIT_EXIST, PHONE_EXIST, 1);
end if;
end;