--1. Процедура видалення клієнту (клієнт при видаленні в замовленні стає null)
create or replace procedure AddKlient(surname varchar, name varchar, fathername varchar, phonenumber varchar, stati varchar, age int)
as auto_id int := 0;
begin
    select Max(klient)+1 into auto_id from Klient;

    insert into Klient values (auto_id, surname, name, fathername, phonenumber, stati,age);
end;

execute AddKlient('surname', 'name',  'fathername', '0660261829', 'М',20);

select * from Klient;

--2. Фукнція яка виводить  ціну найбільшої операції
create or replace function MaxPrice
return int is
    resultat int := 0;
begin
    select Max(suma) into resultat
    from Operations;
    
    return resultat;
end;

select MaxPrice
from dual;

-----Тригер резервне збереження операцій

drop table Operations_Backup;
create table Operations_Backup as select * from Operations where 0 = 1;
alter table Operations_Backup drop column operations;

create or replace trigger Operations_Delete 
    after delete
    on Operations 
    for each row
begin
    insert into Operations_Backup(
                                suma,
                                ddate,
                                operator,
                                klient,
                                exchange_office,
                                type_operations,
                                current_course,
                                currency)
                        values (
                                :old.suma,
                                :old.ddate,
                                :old.operator,
                                :old.klient,
                                :old.exchange_office,
                                :old.type_operations,
                                :old.current_course,
                                :old.currency);
end;

insert into Operations(operations, suma, ddate, operator, klient) values (99, 10, SYSDATE, 2, 1);

select * from Operations;

delete from Operations where operations = 99;

select * from Operations_Backup;
