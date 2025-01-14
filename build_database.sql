CREATE DATABASE requests;
GO

USE requests;
GO

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255)
);

CREATE TABLE Roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(255),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);
CREATE INDEX idx_roles_department_id ON Roles (department_id);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    role_id INT,
    employment_start_date DATE,
    employment_end_date DATE,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);
CREATE INDEX idx_employees_role_id ON Employees (role_id);

CREATE TABLE RequestTypes (
    request_type_id INT PRIMARY KEY,
    request_type_name VARCHAR(255)
);

CREATE TABLE RequestSubtypes (
    request_subtype_id INT PRIMARY KEY,
    request_type_id INT,
    request_subtype_name VARCHAR(255),
    request_subtype_description TEXT,
    FOREIGN KEY (request_type_id) REFERENCES RequestTypes(request_type_id)
);
CREATE INDEX idx_request_subtypes_request_type_id ON RequestSubtypes (request_type_id);

CREATE TABLE ApprovalChains (
    approval_chain_id INT PRIMARY KEY,
    request_type_id INT,
    employee_role_id INT,
    approval_level INT,
    approver_role_id INT,
    approver_department_id INT,
    FOREIGN KEY (request_type_id) REFERENCES RequestTypes(request_type_id),
    FOREIGN KEY (employee_role_id) REFERENCES Roles(role_id),
    FOREIGN KEY (approver_role_id) REFERENCES Roles(role_id),
    FOREIGN KEY (approver_department_id) REFERENCES Departments(department_id),
    CONSTRAINT UC_RequestTypeRoleLevel UNIQUE (request_type_id, employee_role_id, approval_level)
);
CREATE INDEX idx_approval_chains_request_type_id ON ApprovalChains (request_type_id);
CREATE INDEX idx_approval_chains_employee_role_id ON ApprovalChains (employee_role_id);
CREATE INDEX idx_approval_chains_approver_role_id ON ApprovalChains (approver_role_id);
CREATE INDEX idx_approval_chains_approver_department_id ON ApprovalChains (approver_department_id);

CREATE TABLE Rules (
    rule_id INT PRIMARY KEY,
    request_type_id INT,
    request_subtype_id INT,
    rule_name VARCHAR(255),
    rule_value VARCHAR(255),
    rule_check VARCHAR(255),
    FOREIGN KEY (request_type_id) REFERENCES RequestTypes(request_type_id),
    FOREIGN KEY (request_subtype_id) REFERENCES RequestSubtypes(request_subtype_id)
);
CREATE INDEX idx_rules_request_type_id ON Rules (request_type_id);
CREATE INDEX idx_rules_request_subtype_id ON Rules (request_subtype_id);

CREATE TABLE Requests (
    request_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT,
    request_subtype_id INT,
    start_date DATE,
    end_date DATE,
    reason TEXT,
    request_status VARCHAR(20) CHECK (request_status IN ('Pending', 'Approved', 'Rejected')),
    request_date DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (request_subtype_id) REFERENCES RequestSubtypes(request_subtype_id)
);
CREATE INDEX idx_requests_employee_id ON Requests (employee_id);
CREATE INDEX idx_requests_request_subtype_id ON Requests (request_subtype_id);

CREATE TABLE RequestApprovals (
    request_approval_id INT PRIMARY KEY IDENTITY(1,1),
    request_id INT,
    approval_level INT,
    approver_employee_id INT,
    approval_status VARCHAR(20) CHECK (approval_status IN ('Approved', 'Rejected', 'Pending')),
    response_date DATETIME,
    FOREIGN KEY (request_id) REFERENCES Requests(request_id),
    FOREIGN KEY (approver_employee_id) REFERENCES Employees(employee_id)
);
CREATE INDEX idx_request_approvals_request_id ON RequestApprovals (request_id);
CREATE INDEX idx_request_approvals_approver_employee_id ON RequestApprovals (approver_employee_id);
