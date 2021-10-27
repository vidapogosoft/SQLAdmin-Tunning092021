
select
conn.session_id as blockerSession,
conn2.session_id as BlockedSession,
req.wait_time as waiting_time_ms,
CAST((req.wait_time/1000.) as decimal(18,2)) as waiting_Time_secs,
CAST((req.wait_time/1000./60.) as decimal(18,2)) as waiting_Time_mins,
t.text as BlockerQuery,
t2.text as BlockedQuery
from sys.dm_exec_requests as req
inner join sys.dm_exec_connections as conn
	on req.blocking_session_id = conn.session_id
inner join sys.dm_exec_connections as conn2
	on  req.session_id = conn2.session_id
cross apply sys.dm_exec_sql_text(conn.most_recent_sql_handle) as t
cross apply sys.dm_exec_sql_text(conn2.most_recent_sql_handle) as t2

go