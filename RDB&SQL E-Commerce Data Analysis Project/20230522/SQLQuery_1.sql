-- Session from 22.05.2023

drop procedure print_hello_world

create procedure print_hello_world as 
	begin
		select 'hello world 2'
	end;

exec print_hello_world


drop proc print_hello_world

create proc print_hello_world as 
	begin
		select 'hello world 2'
	end;

execute print_hello_world


alter proc print_hello_world as 
	begin
		print 'hello world 3'
	end;

exec print_hello_world

print_hello_world

create table new_updates (
	update_column  varchar(20),
	update_time    datetime
			);


insert into new_updates (update_column, update_time)
values ('new update', getdate())