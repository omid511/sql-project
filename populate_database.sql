-- Insert data into Departments table
INSERT INTO Departments (department_id, department_name) VALUES
(1, 'Human Resources'),
(2, 'Engineering'),
(3, 'Finance');

-- Insert data into Roles table
INSERT INTO Roles (role_id, role_name, department_id) VALUES
(101, 'HR Manager', 1),
(102, 'Recruiter', 1),
(201, 'Software Engineer', 2),
(202, 'Team Lead', 2),
(301, 'Accountant', 3);

-- Insert data into Employees table
INSERT INTO Employees (employee_id, first_name, last_name, role_id, employment_start_date, employment_end_date) VALUES
(1, 'John', 'Doe', 201, '2023-08-15', NULL),
(2, 'Jane', 'Smith', 102, '2022-09-01', NULL),
(3, 'Alice', 'Johnson', 301, '2024-01-05', NULL),
(4, 'Bob', 'Williams', 202, '2021-05-20', NULL),
(5, 'Charlie', 'Brown', 101, '2020-11-10', NULL);

-- Insert data into RequestTypes table
INSERT INTO RequestTypes (request_type_id, request_type_name) VALUES
(1, 'Leave Request'),
(2, 'Expense Claim');

-- Insert data into RequestSubtypes table
INSERT INTO RequestSubtypes (request_subtype_id, request_type_id, request_subtype_name, request_subtype_description) VALUES
(10, 1, 'Vacation', 'Request for paid time off'),
(11, 1, 'Sick Leave', 'Request for time off due to illness'),
(20, 2, 'Travel Expenses', 'Claim for expenses related to business travel'),
(21, 2, 'Office Supplies', 'Claim for office supplies purchased');

-- Insert data into ApprovalChains table
INSERT INTO ApprovalChains (approval_chain_id, request_type_id, employee_role_id, approval_level, approver_role_id, approver_department_id) VALUES
(1, 1, 201, 1, 202, 2),  -- Software Engineer -> Team Lead (Engineering)
(2, 1, 102, 1, 101, 1),  -- Recruiter -> HR Manager (HR)
(3, 2, 201, 1, 202, 2),  -- Software Engineer -> Team Lead (Engineering)
(4, 2, 201, 2, 301, 3);  -- Software Engineer -> Accountant (Finance) for higher level approval

-- Insert data into Rules table
INSERT INTO Rules (rule_id, request_type_id, request_subtype_id, rule_name, rule_value, rule_check) VALUES
(100, 1, 10, 'Min Vacation Days', '5', '>='),
(101, 2, 20, 'Max Travel Expense', '1000', '<=');

-- Insert data into Requests table
INSERT INTO Requests (request_id, employee_id, request_subtype_id, start_date, end_date, reason, request_status, request_date) VALUES
(1, 1, 10, '2025-02-10', '2025-02-15', 'Planning a vacation', 'Pending', '2025-01-14 10:00:00'),
(2, 2, 20, '2025-01-20', '2025-01-21', 'Travel to conference', 'Approved', '2025-01-13 14:30:00');

-- Insert data into RequestApprovals table
INSERT INTO RequestApprovals (request_approval_id, request_id, approval_level, approver_employee_id, approval_status, response_date) VALUES
(1, 2, 1, 4, 'Approved', '2025-01-13 16:00:00');