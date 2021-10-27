use master
go

restore filelistonly from disk = 'E:\AdminVPR2.bak'

----- sintaxis
/*
restore database nombre_base from disk = 'physicalname'
with
move 'LogicalName_mdf' to 'physicalname_mdf',
move 'LogicalName_log' to 'physicalname_log',
replace, stats = 10
*/

restore database AdminVPR2
from disk = 'E:\AdminVPR2.bak'
with
move 'AdminVPR2' to 'E:\SQLdata4\AdminVPR2.mdf',
move 'AdminVPR2_log' to 'E:\SQLdata4\AdminVPR2_log.ldf',
replace, stats = 10

---
restore database AdminVPR2
from disk = 'E:\AdminVPR2.bak'
with replace, stats = 10


restore filelistonly from disk = 'E:\Cursos\BACKUPS\AdminVPR24.bak'


restore database AdminVPR2
from disk = 'E:\AdminVPR2.bak'
with replace, stats = 10

restore database AdminVPR2
from disk = 'E:\Cursos\BACKUPS\AdminVPR24.bak'
with recovery;

----LOG

restore LOG AdminVPR2
from disk = 'E:\Cursos\BACKUPS\AdminVPR2_log.bak'
with recovery





