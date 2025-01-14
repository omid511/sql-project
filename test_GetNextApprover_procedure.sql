USE requests;
GO

-- Test script for GetNextApprover procedure

-- Test case 1: Fully approved request
DECLARE @RequestID INT = 74;
PRINT 'Test Case 1 Output:';
EXEC GetNextApprover @RequestID;

-- Test case 2: Request with next level approval needed
-- Insert a new request
INSERT INTO Requests (employee_id, request_subtype_id, start_date, end_date, reason, request_status, request_date)
VALUES (1, 10, '2025-02-15', '2025-02-20', 'Vacation for testing', 'Pending', GETDATE());
DECLARE @NewRequestID INT = SCOPE_IDENTITY();

-- Insert the first level approval
INSERT INTO RequestApprovals (request_id, approval_level, approver_employee_id, approval_status, response_date)
VALUES (@NewRequestID, 1, 4, 'Approved', GETDATE());

-- Execute the GetNextApprover procedure for the new request
PRINT 'Test Case 2 Output:';
EXEC GetNextApprover @NewRequestID;
GO