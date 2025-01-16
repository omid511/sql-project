USE requests;
GO

CREATE PROCEDURE GetNextApprover (
    @request_id INT
)
AS
BEGIN
    -- Get Current Approval Level
    DECLARE @CurrentApprovalLevel INT;
    SELECT @CurrentApprovalLevel = ISNULL(MAX(approval_level), 0)
    FROM RequestApprovals
    WHERE request_id = @request_id
      AND approval_status <> 'Pending';

    -- Find Next Approval Level
    DECLARE @request_subtype_id INT, @employee_id INT, @employee_role_id INT;

    SELECT @request_subtype_id = request_subtype_id, @employee_id = employee_id
    FROM Requests
    WHERE request_id = @request_id;

    SELECT @employee_role_id = role_id
    FROM Employees
    WHERE employee_id = @employee_id;

    DECLARE @NextApprovalLevel INT;
    SELECT @NextApprovalLevel = MIN(approval_level)
    FROM ApprovalChains
    WHERE request_subtype_id = @request_subtype_id
      AND employee_role_id = @employee_role_id
      AND approval_level > @CurrentApprovalLevel;

    -- Return Approvers
    IF @NextApprovalLevel IS NOT NULL
    BEGIN
        SELECT approver_role_id AS ApproverRoleId, approver_department_id AS ApproverDepartmentId
        FROM ApprovalChains
        WHERE request_subtype_id = @request_subtype_id
          AND employee_role_id = @employee_role_id
          AND approval_level = @NextApprovalLevel;
    END
    ELSE
    BEGIN
        -- Return a flag indicating that the request is fully approved
        SELECT CAST(1 AS BIT) AS IsFullyApproved;
    END
END;