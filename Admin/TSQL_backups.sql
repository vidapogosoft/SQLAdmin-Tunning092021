use master
go

--Full backup
BACKUP DATABASE RocnarfV2  
TO DISK = 'E:\Cursos\BACKUPS\full\RocnarfV2.bak'
WITH FORMAT;

go

---Diferencial
BACKUP DATABASE RocnarfV2  
TO DISK = 'E:\Cursos\BACKUPS\RocnarfV2.bak'
WITH DIFFERENTIAL, FORMAT;

--Transaccional
BACKUP LOG RocnarfV2  
TO DISK = 'E:\Cursos\BACKUPS\log\RocnarfV2_log.bak'
WITH FORMAT;



-----------------------
use master 
go

BACKUP DATABASE AdminVPR2  
TO DISK = 'E:\Cursos\BACKUPS\AdminVPR23.bak'
WITH DIFFERENTIAL, FORMAT;


BACKUP LOG AdminVPR2  
TO DISK = 'E:\Cursos\BACKUPS\log\AdminVPR2_log.bak'
WITH FORMAT;


EXECUTE master.dbo.xp_create_subdir N'E:\\AdminVPR2'
GO
BACKUP DATABASE [AdminVPR2] TO  DISK = N'E:\AdminVPR2\AdminVPR2_backup_2020_07_28_201717_5990138.bak' 
WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  
NAME = N'AdminVPR2_backup_2020_07_28_201717_5990138', 
SKIP, REWIND, NOUNLOAD,  STATS = 10


