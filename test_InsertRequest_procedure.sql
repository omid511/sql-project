USE requests;
GO

-- Test case 1: Valid request
DECLARE @RequestID INT;
EXEC InsertRequest
    @employee_id = 1,
    @request_subtype_id = 10, -- Vacation
    @start_date = '2025-02-20',
    @end_date = '2025-02-25',
    @reason = 'Annual vacation',
    @request_id = @RequestID OUTPUT;

SELECT @RequestID AS NewRequestID;
GO

-- Test case 2: Invalid request - Minimum vacation days not met
BEGIN TRY
    DECLARE @RequestID2 INT;
    EXEC InsertRequest
        @employee_id = 1,
        @request_subtype_id = 10, -- Vacation
        @start_date = '2025-02-20',
        @end_date = '2025-02-20',
        @reason = 'Short vacation',
        @request_id = @RequestID2 OUTPUT;
    SELECT 'Test Failed: Minimum vacation days not enforced' AS ResultX;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

-- Test case 3: Invalid request - Maximum vacation days exceeded
BEGIN TRY
    DECLARE @RequestID3 INT;
    EXEC InsertRequest
        @employee_id = 1,
        @request_subtype_id = 10, -- Vacation
        @start_date = '2025-02-20',
        @end_date = '2025-03-25',
        @reason = 'Long vacation',
        @request_id = @RequestID3 OUTPUT;
    SELECT 'Test Failed: Maximum vacation days not enforced' AS Result;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

-- Test case 4: Valid request - Sick leave with reason
DECLARE @RequestID4 INT;
EXEC InsertRequest
    @employee_id = 3,
    @request_subtype_id = 11, -- Sick Leave
    @start_date = '2025-02-15',
    @end_date = '2025-02-16',
    @reason = 'Feeling unwell',
    @request_id = @RequestID4 OUTPUT;

SELECT @RequestID4 AS NewRequestID;
GO

-- Test case 5: Invalid request - Sick leave without reason
BEGIN TRY
    DECLARE @RequestID5 INT;
    EXEC InsertRequest
        @employee_id = 3,
        @request_subtype_id = 11, -- Sick Leave
        @start_date = '2025-02-17',
        @end_date = '2025-02-18',
        @reason = NULL,
        @request_id = @RequestID5 OUTPUT;
    SELECT 'Test Failed: Sick leave reason not enforced' AS Result;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

-- Test case 6: Valid request - Project assignment with justification
DECLARE @RequestID6 INT;
EXEC InsertRequest
    @employee_id = 6,
    @request_subtype_id = 20, -- Project Assignment
    @start_date = '2025-03-10',
    @end_date = '2025-03-15',
    @reason = 'Working on new module',
    @request_id = @RequestID6 OUTPUT;

SELECT @RequestID6 AS NewRequestID;
GO

-- Test case 7: Invalid request - Project assignment without justification
BEGIN TRY
    DECLARE @RequestID7 INT;
    EXEC InsertRequest
        @employee_id = 6,
        @request_subtype_id = 20, -- Project Assignment
        @start_date = '2025-03-11',
        @end_date = '2025-03-12',
        @reason = NULL,
        @request_id = @RequestID7 OUTPUT;
    SELECT 'Test Failed: Project assignment justification not enforced' AS Result;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

-- Test case 8: Invalid request - Project assignment max duration exceeded
BEGIN TRY
    DECLARE @RequestID8 INT;
    EXEC InsertRequest
        @employee_id = 6,
        @request_subtype_id = 20, -- Project Assignment
        @start_date = '2025-03-10',
        @end_date = '2027-03-10',
        @reason = 'Long project',
        @request_id = @RequestID8 OUTPUT;
    SELECT 'Test Failed: Project assignment max duration not enforced' AS Result;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

-- Test case 9: Valid request - Task assignment with deadline
DECLARE @RequestID9 INT;
EXEC InsertRequest
    @employee_id = 9,
    @request_subtype_id = 21, -- Task Assignment
    @start_date = '2025-01-25',
    @end_date = '2025-01-26',
    @reason = 'Complete report',
    @request_id = @RequestID9 OUTPUT;

SELECT @RequestID9 AS NewRequestID;
GO

-- Test case 10: Invalid request - Task assignment without deadline
BEGIN TRY
    DECLARE @RequestID10 INT;
    EXEC InsertRequest
        @employee_id = 9,
        @request_subtype_id = 21, -- Task Assignment
        @start_date = '2025-01-27',
        @end_date = NULL,
        @reason = 'Another task',
        @request_id = @RequestID10 OUTPUT;
    SELECT 'Test Failed: Task assignment deadline not enforced' AS Result;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

-- Test case 11: Invalid request - Request start date in the past (Leave)
BEGIN TRY
    DECLARE @RequestID11 INT;
    EXEC InsertRequest
        @employee_id = 1,
        @request_subtype_id = 10, -- Vacation
        @start_date = '2024-01-01',
        @end_date = '2024-01-05',
        @reason = 'Past vacation',
        @request_id = @RequestID11 OUTPUT;
    SELECT 'Test Failed: Past start date for leave not enforced' AS Result;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

-- Test case 12: Invalid request - Assignment start date in the past (Assignment)
BEGIN TRY
    DECLARE @RequestID12 INT;
    EXEC InsertRequest
        @employee_id = 6,
        @request_subtype_id = 20, -- Project Assignment
        @start_date = '2024-01-01',
        @end_date = '2024-01-05',
        @reason = 'Past assignment',
        @request_id = @RequestID12 OUTPUT;
    SELECT 'Test Failed: Past start date for assignment not enforced' AS Result;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

-- Test case 13: Invalid request - Vacation request advance notice not met
BEGIN TRY
    DECLARE @RequestID13 INT;
    DECLARE @StartDate13 DATE = DATEADD(day, 2, GETDATE());
    DECLARE @EndDate13 DATE = DATEADD(day, 5, GETDATE());
    EXEC InsertRequest
        @employee_id = 1,
        @request_subtype_id = 10, -- Vacation
        @start_date = @StartDate13,
        @end_date = @EndDate13,
        @reason = 'Last minute vacation',
        @request_id = @RequestID13 OUTPUT;
    SELECT 'Test Failed: Vacation advance notice not enforced' AS Result;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

-- Test case 14: Invalid request - Sick leave max duration exceeded
BEGIN TRY
    DECLARE @RequestID14 INT;
    DECLARE @StartDate14 DATE = '2025-02-15';
    DECLARE @EndDate14 DATE = DATEADD(day, 15, @StartDate14);
    EXEC InsertRequest
        @employee_id = 3,
        @request_subtype_id = 11, -- Sick Leave
        @start_date = @StartDate14,
        @end_date = @EndDate14,
        @reason = 'Long illness',
        @request_id = @RequestID14 OUTPUT;
    SELECT 'Test Failed: Max sick leave duration not enforced' AS Result;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

-- Test case 15: Invalid request - Start date after end date
BEGIN TRY
    DECLARE @RequestID15 INT;
    EXEC InsertRequest
        @employee_id = 1,
        @request_subtype_id = 10, -- Vacation
        @start_date = '2025-02-25',
        @end_date = '2025-02-20',
        @reason = 'Invalid dates',
        @request_id = @RequestID15 OUTPUT;
    SELECT 'Test Failed: Start date after end date not enforced' AS Result;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO