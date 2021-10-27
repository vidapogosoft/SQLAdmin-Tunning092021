---OPTION(OPTIMIZE FOR UNKNOWN)

use musicallyapp
go


--Test for blocking

Create table LockTable
(
	id int identity(1,1) not null,
	col1 int
)

insert into LockTable (col1) values(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15)

-----1. show a lock looks like

--tran 1

begin tran 

	update LockTable set col1 = 98 where  id= 7

rollback

--tran 2

begin tran

	select * from LockTable

rollback


-----2. Show types of lock

--shared locks

begin tran

select * from LockTable with (holdlock) -- keeps the lock
where id = 3

---monitor
select
lck.resource_type,
lck.request_mode,
lck.request_session_id,
lck.request_status,
OBJECT_NAME(ps.object_id) as objectName
from sys.dm_tran_locks as lck
inner join sys.dm_exec_connections as conn
on conn.session_id = lck.request_session_id
inner join sys.partitions as ps
on ps.hobt_id = lck.resource_associated_entity_id
cross apply sys.dm_exec_sql_text(conn.most_recent_sql_handle) as t
where lck.request_session_id in (
		select distinct session_id
		from sys.dm_exec_sessions
		--where login_name = 'sa'
)
and resource_type not in ('Database', 'Object', 'PAGE')


rollback

---exclusive locks

begin tran
	
	update LockTable set col1 = 100
	where id = 3


		---monitor
		select
		lck.resource_type,
		lck.request_mode,
		lck.request_session_id,
		lck.request_status,
		OBJECT_NAME(ps.object_id) as objectName
		from sys.dm_tran_locks as lck
		inner join sys.dm_exec_connections as conn
		on conn.session_id = lck.request_session_id
		inner join sys.partitions as ps
		on ps.hobt_id = lck.resource_associated_entity_id
		cross apply sys.dm_exec_sql_text(conn.most_recent_sql_handle) as t
		where lck.request_session_id in (
				select distinct session_id
				from sys.dm_exec_sessions
				--where login_name = 'sa'
		)
		and resource_type not in ('Database', 'Object', 'PAGE')


rollback



---Monitores de lock

---tran 1

begin tran
	
	update LockTable set col1 = 98
	where id = 10

rollback tran


---tran 2
---SQLQuery Stress
---with waifor delay
begin tran
	
	update LockTable set col1 = 130
	where id = 15


	---monitor
		select
		lck.resource_type,
		lck.request_mode,
		lck.request_session_id,
		lck.request_status,
		OBJECT_NAME(ps.object_id) as objectName
		from sys.dm_tran_locks as lck
		inner join sys.dm_exec_connections as conn
		on conn.session_id = lck.request_session_id
		inner join sys.partitions as ps
		on ps.hobt_id = lck.resource_associated_entity_id
		cross apply sys.dm_exec_sql_text(conn.most_recent_sql_handle) as t
		where lck.request_session_id in (
				select distinct session_id
				from sys.dm_exec_sessions
				--where login_name = 'sa'
		)
		and resource_type not in ('Database', 'Object', 'PAGE')

	waitfor delay '00:00:35'

rollback tran


		