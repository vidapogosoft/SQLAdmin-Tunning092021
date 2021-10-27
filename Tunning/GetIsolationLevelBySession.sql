
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