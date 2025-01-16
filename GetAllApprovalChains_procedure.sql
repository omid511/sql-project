USE requests;
GO

CREATE PROCEDURE GetAllApprovalChains
AS
BEGIN
    -- Declare a cursor to iterate through distinct approval chains
    DECLARE approval_chains_cursor CURSOR FOR
        SELECT DISTINCT request_type_id, request_subtype_id, employee_role_id
        FROM ApprovalChains;

    -- Declare variables to hold the current approval chain's details
    DECLARE @request_type_id INT, @request_subtype_id INT, @employee_role_id INT;

    -- Open the cursor
    OPEN approval_chains_cursor;

    -- Fetch the first approval chain
    FETCH NEXT FROM approval_chains_cursor INTO @request_type_id, @request_subtype_id, @employee_role_id;

    -- Loop through each approval chain
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Select the approval chain details for the current combination
        SELECT
            d.department_name,
            rs.request_subtype_name,
            r2.role_name AS requester_role_name,
            ac.approval_level,
            r.role_name AS approver_role
        FROM
            ApprovalChains ac
        INNER JOIN
            RequestSubtypes rs ON ac.request_subtype_id = rs.request_subtype_id
        INNER JOIN
            Departments d ON ac.approver_department_id = d.department_id
        INNER JOIN
            Roles r ON ac.approver_role_id = r.role_id
        INNER JOIN
            Roles r2 ON ac.employee_role_id = r2.role_id
        WHERE
            ac.request_subtype_id = @request_subtype_id
            AND ac.employee_role_id = @employee_role_id
        ORDER BY
            ac.approval_level;

        -- Fetch the next approval chain
        FETCH NEXT FROM approval_chains_cursor INTO @request_type_id, @request_subtype_id, @employee_role_id;
    END;

    -- Close the cursor
    CLOSE approval_chains_cursor;

    -- Deallocate the cursor
    DEALLOCATE approval_chains_cursor;
END;