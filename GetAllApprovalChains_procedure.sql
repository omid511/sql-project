USE requests;
GO

DROP PROCEDURE IF EXISTS GetAllApprovalChains;
GO

CREATE PROCEDURE GetAllApprovalChains
    @request_type_id INT = NULL,
    @request_subtype_id INT = NULL
AS
BEGIN
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
        (@request_type_id IS NULL OR ac.request_type_id = @request_type_id) AND
        (@request_subtype_id IS NULL OR ac.request_subtype_id = @request_subtype_id)
    ORDER BY
        ac.approval_level;
END;