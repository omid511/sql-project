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
GO

-- Stored procedure to insert a leave or mission request
CREATE PROCEDURE InsertRequest (
    @employee_id INT,
    @request_subtype_id INT,
    @start_date DATE,
    @end_date DATE,
    @reason TEXT,
    @request_id INT OUTPUT
)
AS
BEGIN
    -- Rule Validation
    DECLARE @ErrorMessage VARCHAR(MAX);
    DECLARE @RuleName VARCHAR(255);
    DECLARE @RuleValue VARCHAR(255);
    DECLARE @RuleCheck VARCHAR(255);
    DECLARE RuleCursor CURSOR FOR
        SELECT rule_name, rule_value, rule_check
        FROM Rules
        WHERE request_subtype_id = @request_subtype_id OR (request_type_id = (SELECT request_type_id FROM RequestSubtypes WHERE request_subtype_id = @request_subtype_id) AND request_subtype_id IS NULL);

    OPEN RuleCursor;
    FETCH NEXT FROM RuleCursor INTO @RuleName, @RuleValue, @RuleCheck;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @RuleCheck = 'BOOLEAN'
        BEGIN
            IF @RuleName = 'Sick Leave Requires Note' AND @request_subtype_id = 11 AND (@reason IS NULL OR DATALENGTH(@reason) = 0) AND @RuleValue = 'true'
            BEGIN
                SET @ErrorMessage = 'Rule Violated: Sick leave requires a reason.';
                RAISERROR(@ErrorMessage, 16, 1);
                CLOSE RuleCursor;
                DEALLOCATE RuleCursor;
                RETURN;
            END

            IF @RuleName = 'Project Assignment Justification Required' AND @request_subtype_id = 20 AND (@reason IS NULL OR DATALENGTH(@reason) = 0) AND @RuleValue = 'true'
            BEGIN
                SET @ErrorMessage = 'Rule Violated: Project assignment requires a justification.';
                RAISERROR(@ErrorMessage, 16, 1);
                CLOSE RuleCursor;
                DEALLOCATE RuleCursor;
                RETURN;
            END

            IF @RuleName = 'Task Assignment Deadline Required' AND @request_subtype_id = 21 AND @end_date IS NULL AND @RuleValue = 'true'
            BEGIN
                SET @ErrorMessage = 'Rule Violated: Task assignment requires a deadline.';
                RAISERROR(@ErrorMessage, 16, 1);
                CLOSE RuleCursor;
                DEALLOCATE RuleCursor;
                RETURN;
            END

            IF @RuleName = 'Request Start Date Cannot Be In The Past' AND @start_date < GETDATE() AND @RuleValue = 'false'
            BEGIN
                SET @ErrorMessage = 'Rule Violated: Request start date cannot be in the past.';
                RAISERROR(@ErrorMessage, 16, 1);
                CLOSE RuleCursor;
                DEALLOCATE RuleCursor;
                RETURN;
            END

             IF @RuleName = 'Assignment Start Date Cannot Be In The Past' AND @request_subtype_id IN (20, 21) AND @start_date < GETDATE() AND @RuleValue = 'false'
            BEGIN
                SET @ErrorMessage = 'Rule Violated: Assignment start date cannot be in the past.';
                RAISERROR(@ErrorMessage, 16, 1);
                CLOSE RuleCursor;
                DEALLOCATE RuleCursor;
                RETURN;
            END
        END
        ELSE IF @RuleCheck IN ('>=', '<=', '>', '<')
        BEGIN
            IF @RuleName = 'Min Vacation Days' AND DATEDIFF(day, @start_date, @end_date) < CAST(@RuleValue AS INT) -1 AND @RuleCheck = '>='
            BEGIN
                SET @ErrorMessage = 'Rule Violated: Minimum vacation days not met.';
                RAISERROR(@ErrorMessage, 16, 1);
                CLOSE RuleCursor;
                DEALLOCATE RuleCursor;
                RETURN;
            END

            IF @RuleName = 'Max Vacation Days' AND DATEDIFF(day, @start_date, @end_date) > CAST(@RuleValue AS INT) AND @RuleCheck = '<='
            BEGIN
                SET @ErrorMessage = 'Rule Violated: Maximum vacation days exceeded.';
                RAISERROR(@ErrorMessage, 16, 1);
                CLOSE RuleCursor;
                DEALLOCATE RuleCursor;
                RETURN;
            END

             IF @RuleName = 'Project Assignment Max Duration' AND @request_subtype_id = 20 AND DATEDIFF(day, @start_date, @end_date) > CAST(@RuleValue AS INT) AND @RuleCheck = '<='
            BEGIN
                SET @ErrorMessage = 'Rule Violated: Project assignment duration exceeds the maximum allowed.';
                RAISERROR(@ErrorMessage, 16, 1);
                CLOSE RuleCursor;
                DEALLOCATE RuleCursor;
                RETURN;
            END
        END

        FETCH NEXT FROM RuleCursor INTO @RuleName, @RuleValue, @RuleCheck;
    END

    CLOSE RuleCursor;
    DEALLOCATE RuleCursor;

    -- Overlapping Request Check
    IF EXISTS (
        SELECT 1
        FROM Requests
        WHERE employee_id = @employee_id
          AND (
                (@start_date BETWEEN start_date AND end_date)
             OR (@end_date BETWEEN start_date AND end_date)
             OR (start_date BETWEEN @start_date AND @end_date)
             OR (end_date BETWEEN @start_date AND @end_date)
              )
    )
    BEGIN
        SET @ErrorMessage = 'Error: Overlapping request found.';
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN;
    END

    -- Insert Request
    INSERT INTO Requests (employee_id, request_subtype_id, start_date, end_date, reason, request_status, request_date)
    VALUES (@employee_id, @request_subtype_id, @start_date, @end_date, @reason, 'Pending', GETDATE());

    -- Get the newly generated request_id
    SET @request_id = SCOPE_IDENTITY();

    -- Initial Approval Entry
    INSERT INTO RequestApprovals (request_id, approval_level, approval_status)
    VALUES (@request_id, 1, 'Pending');
END;
GO
