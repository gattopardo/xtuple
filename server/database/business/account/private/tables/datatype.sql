-- populate data

insert into private.datatype (datatype_name, datatype_descrip, datatype_source) 
select 'Account', '_account','CRMA' where not exists (select * from private.datatype where datatype_name = 'Account');
