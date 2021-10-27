
-------Niveles de aislamiento (isolation levels)
use musicallyapp
go

---Read uncommitted
--Tran 1
set transaction isolation level read uncommitted

declare @sessionId int

select @sessionId = @@SPID

select 
	case transaction_isolation_level
	when 0 then 'Unspecified'
	when 1 then 'ReadUncommited'
	when 2 then 'ReadCommited'
	when 3 then 'Repeatable'
	when 4 then 'Serializable'
	when 5 then 'Snapshot'
	end TRANSACTION_ISOLATION_LEVEL
from sys.dm_exec_sessions
where session_id = @sessionId

begin tran

	select * from LockTable

rollback

set transaction isolation level read committed

---Show inconsistent data and no locked

begin tran

	update LockTable set col1 = 300 where id = 10;

rollback 

---Read committed
--Tran 2
set transaction isolation level read committed

declare @sessionId int

select @sessionId = @@SPID

select 
	case transaction_isolation_level
	when 0 then 'Unspecified'
	when 1 then 'ReadUncommited'
	when 2 then 'ReadCommited'
	when 3 then 'Repeatable'
	when 4 then 'Serializable'
	when 5 then 'Snapshot'
	end TRANSACTION_ISOLATION_LEVEL
from sys.dm_exec_sessions
where session_id = @sessionId


-----Repeatable read (Notice hold lock difference)
---Tran 3
set transaction isolation level repeatable read

begin tran

	select * from LockTable where id = 10
	

	declare @sessionId int

	select @sessionId = @@SPID

	select 
		case transaction_isolation_level
		when 0 then 'Unspecified'
		when 1 then 'ReadUncommited'
		when 2 then 'ReadCommited'
		when 3 then 'Repeatable'
		when 4 then 'Serializable'
		when 5 then 'Snapshot'
		end TRANSACTION_ISOLATION_LEVEL
	from sys.dm_exec_sessions
	where session_id = @sessionId


rollback