USE requests;
GO

-- Insert new request subtypes for sick leave and assignment types
INSERT INTO RequestSubtypes (request_subtype_id, request_type_id, request_subtype_name, request_subtype_description) VALUES
(30, 1, 'Extended Sick Leave', 'Request for extended sick leave'),
(31, 2, 'Project Reassignment', 'Request for reassigning an employee to a different project');
INSERT INTO RequestSubtypes (request_subtype_id, request_type_id, request_subtype_name, request_subtype_description) VALUES
(32, 1, 'Vacation', 'Request for vacation');

-- Define approval chains for new request subtypes
INSERT INTO ApprovalChains (approval_chain_id, request_type_id, request_subtype_id, employee_role_id, approval_level, approver_role_id, approver_department_id) VALUES
(7, 1, 30, 201, 1, 202, 2),  -- Software Engineer -> Team Lead (Engineering) for Extended Sick Leave
(8, 1, 30, 201, 2, 101, 1),  -- Software Engineer -> HR Manager (HR) for Extended Sick Leave
(9, 1, 30, 201, 3, 301, 3),  -- Software Engineer -> Accountant (Finance) for Extended Sick Leave
(10, 1, 30, 201, 4, 401, 4), -- Software Engineer -> Marketing Manager (Marketing) for Extended Sick Leave
(11, 2, 31, 201, 1, 202, 2),  -- Software Engineer -> Team Lead (Engineering) for Project Reassignment
(12, 2, 31, 201, 2, 401, 4),  -- Software Engineer -> Marketing Manager (Marketing) for Project Reassignment
(13, 1, 32, 202, 1, 203, 2),  -- Team Lead (Engineering) -> Senior Engineer (Engineering) for Vacation
(14, 1, 32, 202, 2, 101, 1); -- Team Lead (Engineering) -> HR Manager (HR) for Vacation

-- Test the GetAllApprovalChains procedure with different filters
-- PRINT 'Test Case 1: All approval chains';
-- EXEC GetAllApprovalChains;

PRINT 'Test Case 2: Approval chains for request type 1 and subtype 30';
EXEC GetAllApprovalChains @request_type_id = 1, @request_subtype_id = 30;

PRINT 'Test Case 3: Approval chains for request type 2 and subtype 31';
EXEC GetAllApprovalChains @request_type_id = 2, @request_subtype_id = 31;

-- PRINT 'Test Case 4: Approval chains for department 2 (Engineering) and role 201 (Software Engineer)';
-- EXEC GetAllApprovalChains @department_id = 2, @role_id = 201;