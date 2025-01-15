use REQUESTS
go
-- Insert mock employees

INSERT INTO Employees (employee_id, first_name, last_name, role_id, employment_start_date, employment_end_date) VALUES
(14, 'Alice', 'Smith', 201, '2024-01-01', NULL),
(15, 'Bob', 'Johnson', 202, '2024-01-01', NULL),
(16, 'Charlie', 'Brown', 301, '2024-01-01', NULL);

-- Enable IDENTITY_INSERT for Requests table
-- SET IDENTITY_INSERT Requests ON;

-- Insert mock requests
INSERT INTO Requests (employee_id, request_subtype_id, start_date, end_date, reason, request_status, request_date) VALUES
(14, 10, '2024-02-01', '2024-02-05', 'Vacation', 'Approved', '2024-02-01'),
(14, 10, '2024-01-01', '2024-01-05', 'Vacation', 'Approved', '2024-01-01'),
(14, 20, '2024-03-01', '2024-03-05', 'Project Assignment', 'Approved', '2024-03-01'),
(15, 10, '2024-01-01', '2024-01-05', 'Vacation', 'Approved', '2024-01-01'),
(15, 20, '2024-02-01', '2024-02-05', 'Project Assignment', 'Approved', '2024-02-01'),
(16, 10, '2024-01-01', '2024-01-05', 'Vacation', 'Approved', '2024-01-01'),
(16, 20, '2024-02-01', '2024-02-05', 'Project Assignment', 'Approved', '2024-02-01'),
(16, 20, '2024-03-01', '2024-03-05', 'Project Assignment', 'Approved', '2024-03-01');

-- Disable IDENTITY_INSERT for Requests table
-- SET IDENTITY_INSERT Requests OFF;

-- Call the procedure to test its behavior
EXEC GetEmployeesByRequestTypes @DepartmentID = NULL, @StartDate = '2023-01-01', @EndDate = '2024-12-31';