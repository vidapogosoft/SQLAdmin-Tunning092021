-- =================================================================================
-- Author: VPR CURSO GRUPO SIPECOM
-- Procedure Name: dbo.usp_FindErrorsInDefTrace
-- Description: This procedure reports all error details collected by the SQL Server default trace file
-- ==================================================================================

USE master
GO

CREATE PROCEDURE dbo.usp_FindErrorsInDefTrace
AS
BEGIN
   SET NOCOUNT ON
   DECLARE @traceFileName NVARCHAR (500)

   SELECT @traceFileName = CONVERT (NVARCHAR (500), value)
   FROM sys.fn_trace_getinfo (DEFAULT)
   WHERE traceid = 1
      AND property = 2

   SELECT 
      t.TextData,
      t.DatabaseName,
      t.NTUserName,
      t.NTDomainName,
      t.HostName,
      t.ClientProcessID,
      t.ApplicationName,
      t.LoginName,
      t.SPID,
      t.StartTime,
      t.ServerName,
      t.Error,
      t.SessionLoginName
   FROM ::fn_trace_gettable(@traceFileName, DEFAULT) t
   WHERE t.ERROR IS NOT NULL

   SET NOCOUNT OFF
END
GO