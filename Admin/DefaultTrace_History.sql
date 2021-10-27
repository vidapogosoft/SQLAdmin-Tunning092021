
---drop table dbo.DefaultTrace_History

DECLARE @path NVARCHAR(260);
SELECT @path = REVERSE(SUBSTRING(REVERSE([path]), 
 CHARINDEX('\', REVERSE([path])), 260)) + N'log.trc'
  FROM sys.traces WHERE is_default = 1;
SELECT  
 TextData = CONVERT(NVARCHAR(MAX), TextData),
 DatabaseID,
 HostName,
 ApplicationName,
 LoginName,
 SPID,
 StartTime,
 EndTime,
 Duration,
 ObjectID,
 ObjectType,
 IndexID,
 EventClass,
 [FileName],
 RowCounts,
 IsSystem,
 SqlHandle = CONVERT(VARBINARY(MAX), SqlHandle)
INTO dbo.DefaultTrace_History
FROM sys.fn_trace_gettable(@path, DEFAULT);
CREATE CLUSTERED INDEX IX_StartTime ON dbo.DefaultTrace_History(StartTime);


DECLARE @maxDT DATETIME;
SELECT @maxDT = MAX(StartTime)
  FROM dbo.DefaultTrace_History;
INSERT dbo.DefaultTrace_History
SELECT  
 TextData = CONVERT(NVARCHAR(MAX), TextData),
 DatabaseID,
 HostName,
 ApplicationName,
 LoginName,
 SPID,
 StartTime,
 EndTime,
 Duration,
 ObjectID,
 ObjectType,
 IndexID,
 EventClass,
 [FileName],
 RowCounts,
 IsSystem,
 SqlHandle = CONVERT(VARBINARY(MAX), SqlHandle)
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE StartTime > @maxDT;


select * from dbo.DefaultTrace_History
