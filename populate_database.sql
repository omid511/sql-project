USE requests;
GO

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
INSERT INTO Roles (role_id, role_name, department_id) VALUES
(203, 'Senior Engineer', 2);

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
INSERT INTO ApprovalChains (approval_chain_id, request_type_id, request_subtype_id, employee_role_id, approval_level, approver_role_id, approver_department_id) VALUES
(1, 1, 10, 201, 1, 202, 2),
(2, 1, 10, 201, 2, 101, 1),
(3, 1, 10, 102, 1, 101, 1),
(4, 2, 20, 201, 1, 202, 2),
(5, 2, 20, 201, 2, 401, 4),
(6, 2, 21, 501, 1, 401, 4);

-- Insert data into Rules table
INSERT INTO Rules (rule_id, request_type_id, request_subtype_id, rule_name, rule_value, rule_check) VALUES
(100, 1, 10, 'Min Vacation Days', '5', '>='),
(101, 1, 10, 'Max Vacation Days', '20', '<='),
(102, 1, 11, 'Sick Leave Requires Note', 'true', 'BOOLEAN'),
(103, 2, 20, 'Project Assignment Justification Required', 'true', 'BOOLEAN'),
(104, 2, 20, 'Project Assignment Max Duration', '365', '<='),
(105, 2, 21, 'Task Assignment Deadline Required', 'true', 'BOOLEAN'),
(106, 1, 10, 'Vacation Request Advance Notice', '14', '>='),
(107, 1, 11, 'Max Sick Leave Duration', '10', '<='),
(108, 2, 20, 'Project Assignment Cannot Start In The Past', 'false', 'BOOLEAN'),
(109, 2, 21, 'Task Assignment Cannot Start In The Past', 'false', 'BOOLEAN');

-- Insert data into Requests table
INSERT INTO Requests (employee_id, request_subtype_id, start_date, end_date, reason, request_status, request_date) VALUES
(1, 10, '2025-02-10', '2025-02-15', 'Planning a vacation', 'Pending', '2025-01-14 10:00:00'),
(3, 11, '2025-01-15', '2025-01-16', 'Feeling unwell', 'Pending', '2025-01-14 12:00:00'),
(2, 10, '2023-03-01', '2024-03-05', 'Spring break', 'Approved', '2023-01-14 13:00:00'),
(9, 21, '2025-01-20', '2025-01-22', 'Complete marketing report', 'Pending', '2025-01-14 14:00:00');