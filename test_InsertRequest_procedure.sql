use requests;
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