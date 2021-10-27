

---[sys]. [Dm_db_index_physical_stats]

USE Master;
  GO
  ALTER DATABASE demo_db SET READ_COMMITTED_SNAPSHOT ON;
  GO
  USE demo_db;
  GO


  CREATE TABLE dbo.demo_table
  (
      ID    INT       NOT NULL    IDENTITY (1, 1),
      C1    CHAR(100) NOT NULL
  );
  GO
   
  INSERT INTO dbo.demo_table (C1)
  SELECT TOP (1000)
         CAST(TEXT AS CHAR(100)) AS C1
  FROM   sys.messages
  WHERE  language_id = 1031;
  GO
    
  CREATE UNIQUE CLUSTERED INDEX cuix_demo_table_Id
  ON dbo.demo_table (Id);
  GO


  SET STATISTICS IO ON;
  GO
  SELECT MAX(Id) FROM dbo.demo_table;

  ----lectura de los datos copia

  SELECT	version_ghost_record_count, *
  FROM	sys.dm_db_index_physical_stats
  	(
  		DB_ID(),
  		OBJECT_ID(N'dbo.demo_table', N'U'),
  		1,
  		NULL,
  		N'DETAILED'
  	)
  WHERE	index_level = 0

  ----Codigo para job y verificar el ghost record

  -- Add a user definied counter for the monitoring in PERFMON
  DECLARE	@cache_size BIGINT;
  SET		@cache_size =
  		(
  			SELECT	version_ghost_record_count
  			FROM	sys.dm_db_index_physical_stats
  				(
  					DB_ID(),
  					OBJECT_ID(N'dbo.demo_table', N'U'),
  					1,
  					NULL,
  					N'DETAILED'
  				)
  			WHERE	index_level = 0
  		);
  EXEC	sp_user_counter1 @cache_size;


  -----------------------

  
-- We start our workload 
  SET NOCOUNT ON;
  GO
  BEGIN TRANSACTION;
  GO
  	-- Insert new record into dbo.demo_table
  	DECLARE	@finish_date DATETIME2(0) = DATEADD(MINUTE, 5, GETDATE());
  	WHILE @finish_date >= GETDATE()
  	BEGIN
  		-- wait 10 ms before each new process
  		INSERT INTO dbo.demo_table(C1)
  		SELECT C1
  		FROM   dbo.demo_table
  		WHERE  Id = (SELECT MIN(Id) FROM dbo.demo_table);
    
  		-- Wait 10 ms to delete the first record from the table
  		WAITFOR DELAY '00:00:00:010';
    
  		-- Now select the min record from the table
  		DELETE dbo.demo_table WHERE Id = (SELECT MIN(Id) FROM dbo.demo_table);
  	END
  ROLLBACK TRAN;
  GO


  ---lectura de estadisticas

  SET STATISTICS IO ON;
  SET NOCOUNT ON;
  GO
  PRINT 'I/O with RCSI...'
  SELECT MAX(ID) FROM dbo.demo_table;
  GO
    
  PRINT 'I/O with READ UNCOMMITTED...'
  SELECT MAX(ID) FROM dbo.demo_table WITH (NOLOCK);
  GO
  SET STATISTICS IO OFF;
  GO


  USE Master;
  GO
  ALTER DATABASE demo_db SET READ_COMMITTED_SNAPSHOT OFF;
  GO
  
  SELECT C1, *
  		FROM   dbo.demo_table with (nolock)
