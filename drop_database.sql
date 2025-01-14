-- Drop tables in reverse order of creation to handle dependencies
DROP TABLE IF EXISTS RequestApprovals;
DROP TABLE IF EXISTS Requests;
DROP TABLE IF EXISTS Rules;
DROP TABLE IF EXISTS ApprovalChains;
DROP TABLE IF EXISTS RequestSubtypes;
DROP TABLE IF EXISTS RequestTypes;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Roles;
DROP TABLE IF EXISTS Departments;
