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

go