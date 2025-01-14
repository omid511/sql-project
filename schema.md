## Final Schema

### Tables

#### Departments

*   `department_id` (INT, PRIMARY KEY)
*   `department_name` (VARCHAR) - e.g., "Sales", "Marketing", "Engineering", "HR"

#### Roles

*   `role_id` (INT, PRIMARY KEY)
*   `role_name` (VARCHAR) - e.g., "Employee", "Team Lead", "Manager", "Director", "HR Specialist", "HR Manager"
*   `department_id` (INT, FOREIGN KEY to Departments, INDEXED)

#### Employees

*   `employee_id` (INT, PRIMARY KEY)
*   `first_name` (VARCHAR)
*   `last_name` (VARCHAR)
*   `role_id` (INT, FOREIGN KEY to Roles, INDEXED)
*   `employment_start_date` (DATE)
*   `employment_end_date` (DATE) - Can be NULL

#### RequestTypes

*   `request_type_id` (INT, PRIMARY KEY)
*   `request_type_name` (VARCHAR) - "Leave", "Mission"

#### RequestSubtypes

*   `request_subtype_id` (INT, PRIMARY KEY)
*   `request_type_id` (INT, FOREIGN KEY to RequestTypes, INDEXED)
*   `request_subtype_name` (VARCHAR) - For `request_type_id` = 1 (Leave): "Vacation", "Sick Leave", "Maternity Leave", "Paternity Leave", "Bereavement Leave". For `request_type_id` = 2 (Mission): "Business Trip", "Training", "Conference", "Project Assignment"
*   `request_subtype_description` (TEXT)

#### ApprovalChains

*   `approval_chain_id` (INT, PRIMARY KEY)
*   `request_type_id` (INT, FOREIGN KEY to RequestTypes, INDEXED)
*   `employee_role_id` (INT, FOREIGN KEY to Roles, INDEXED)
*   `approval_level` (INT)
*   `approver_role_id` (INT, FOREIGN KEY to Roles, INDEXED)
*   `approver_department_id` (INT, FOREIGN KEY to Departments, INDEXED)
*   UNIQUE KEY (`request_type_id`, `employee_role_id`, `approval_level`)

#### Rules

*   `rule_id` (INT, PRIMARY KEY)
*   `request_type_id` (INT, FOREIGN KEY to RequestTypes, INDEXED)
*   `request_subtype_id` (INT, FOREIGN KEY to RequestSubtypes, INDEXED)
*   `rule_name` (VARCHAR) - e.g., "Max Days", "Min Service Years", "Required Documentation", "Must Not Overlap"
*   `rule_value` (VARCHAR)
*   `rule_check` (VARCHAR) - This will store an expression or a short code that our stored procedures can use to evaluate the rule. e.g. "DATEDIFF(day, @start_date, @end_date) <= @rule_value", "YEAR(GETDATE()) - YEAR(@employment_start_date) >= @rule_value", "@requestingEmployeeHasDocument = 1"

#### Requests

*   `request_id` (INT, PRIMARY KEY)
*   `employee_id` (INT, FOREIGN KEY to Employees, INDEXED)
*   `request_subtype_id` (INT, FOREIGN KEY to RequestSubtypes, INDEXED)
*   `start_date` (DATE)
*   `end_date` (DATE)
*   `reason` (TEXT)
*   `request_status` (ENUM('Pending', 'Approved', 'Rejected'))
*   `request_date` (DATETIME)

#### RequestApprovals

*   `request_approval_id` (INT, PRIMARY KEY)
*   `request_id` (INT, FOREIGN KEY to Requests, INDEXED)
*   `approval_level` (INT)
*   `approver_employee_id` (INT, FOREIGN KEY to Employees, INDEXED)
*   `approval_status` (ENUM('Approved', 'Rejected', 'Pending'))
*   `response_date` (DATETIME)