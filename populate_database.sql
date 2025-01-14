-- Insert data into Departments table
INSERT INTO Departments (department_id, department_name) VALUES
(1, 'Human Resources'),
(2, 'Engineering'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Sales');

-- Insert data into Roles table
INSERT INTO Roles (role_id, role_name, department_id) VALUES
(101, 'HR Manager', 1),
(102, 'Recruiter', 1),
(201, 'Software Engineer', 2),
(202, 'Team Lead', 2),
(301, 'Accountant', 3),
(401, 'Marketing Manager', 4),
(501, 'Sales Representative', 5);

-- Insert data into Employees table
INSERT INTO Employees (employee_id, first_name, last_name, role_id, employment_start_date, employment_end_date) VALUES
(1, 'John', 'Doe', 201, '2023-08-15', NULL),
(2, 'Jane', 'Smith', 201, '2022-09-01', NULL),
(3, 'Alice', 'Johnson', 301, '2024-01-05', NULL),
(4, 'Bob', 'Williams', 202, '2021-05-20', NULL),
(5, 'Charlie', 'Brown', 101, '2020-11-10', NULL),
(6, 'Diana', 'Miller', 201, '2023-10-01', NULL),
(7, 'Ethan', 'Davis', 301, '2024-03-15', NULL),
(8, 'Fiona', 'Wilson', 401, '2022-07-01', NULL),
(9, 'George', 'Moore', 501, '2023-09-15', NULL),
(10, 'Hannah', 'Taylor', 102, '2024-02-01', NULL),
(11, 'Ian', 'Cook', 202, '2023-11-01', NULL),
(12, 'Julia', 'Hall', 401, '2024-01-15', NULL),
(13, 'Kevin', 'Scott', 501, '2023-08-01', NULL);

-- Insert data into RequestTypes table
INSERT INTO RequestTypes (request_type_id, request_type_name) VALUES
(1, 'Leave Request'),
(2, 'Assignment');

-- Insert data into RequestSubtypes table
INSERT INTO RequestSubtypes (request_subtype_id, request_type_id, request_subtype_name, request_subtype_description) VALUES
(10, 1, 'Vacation', 'Request for paid time off'),
(11, 1, 'Sick Leave', 'Request for time off due to illness'),
(20, 2, 'Project Assignment', 'Request for assigning an employee to a project'),
(21, 2, 'Task Assignment', 'Request for assigning a task to an employee');

-- Insert data into ApprovalChains table
INSERT INTO ApprovalChains (approval_chain_id, request_type_id, employee_role_id, approval_level, approver_role_id, approver_department_id) VALUES
(1, 1, 201, 1, 202, 2),  -- Software Engineer -> Team Lead (Engineering) for Leave
(2, 1, 201, 2, 101, 1),  -- Software Engineer -> HR Manager (HR) for Leave
(3, 1, 102, 1, 101, 1),  -- Recruiter -> HR Manager (HR) for Leave
(4, 2, 201, 1, 202, 2),  -- Software Engineer -> Team Lead (Engineering) for Assignment
(5, 2, 201, 2, 401, 4),  -- Software Engineer -> Marketing Manager (Marketing) for Assignment
(6, 2, 501, 1, 401, 4);  -- Sales Representative -> Marketing Manager (Marketing) for Assignment

-- Insert data into Rules table
INSERT INTO Rules (rule_id, request_type_id, request_subtype_id, rule_name, rule_value, rule_check) VALUES
(100, 1, 10, 'Min Vacation Days', '5', '>='),
(101, 1, 10, 'Max Vacation Days', '20', '<='),
(102, 1, 11, 'Sick Leave Requires Note', 'true', 'BOOLEAN'),
(103, 2, 20, 'Project Assignment Justification Required', 'true', 'BOOLEAN'),
(104, 2, 20, 'Project Assignment Max Duration', '365', '<='),
(105, 2, 21, 'Task Assignment Deadline Required', 'true', 'BOOLEAN');

-- Insert data into Requests table
INSERT INTO Requests (request_id, employee_id, request_subtype_id, start_date, end_date, reason, request_status, request_date) VALUES
(1, 1, 10, '2025-02-10', '2025-02-15', 'Planning a vacation', 'Pending', '2025-01-14 10:00:00'),
(2, 6, 20, '2025-03-01', '2025-03-15', 'Assignment to project Alpha', 'Pending', '2025-01-14 11:00:00'),
(3, 3, 11, '2025-01-15', '2025-01-16', 'Feeling unwell', 'Pending', '2025-01-14 12:00:00'),
(4, 2, 10, '2025-03-01', '2025-03-05', 'Spring break', 'Pending', '2025-01-14 13:00:00'),
(5, 9, 21, '2025-01-20', '2025-01-22', 'Complete marketing report', 'Pending', '2025-01-14 14:00:00');

-- Insert data into RequestApprovals table
INSERT INTO RequestApprovals (request_approval_id, request_id, approval_level, approver_employee_id, approval_status, response_date) VALUES
(1, 1, 1, 4, 'Pending', NULL),
(2, 2, 1, 4, 'Pending', NULL),
(3, 3, 1, 5, 'Pending', NULL),
(4, 4, 1, 11, 'Pending', NULL),
(5, 5, 1, 12, 'Pending', NULL);