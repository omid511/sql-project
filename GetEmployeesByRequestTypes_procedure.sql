use requests;
GO

CREATE PROCEDURE GetEmployeesByRequestTypes
    @DepartmentID INT = NULL,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DefaultStartDate DATE;
    DECLARE @DefaultEndDate DATE;

    -- Set default date range to last two years if start and end dates are null
    IF @StartDate IS NULL OR @EndDate IS NULL
    BEGIN
        SET @DefaultStartDate = DATEADD(YEAR, -2, GETDATE());
        SET @DefaultEndDate = GETDATE();
    END
    ELSE
    BEGIN
        SET @DefaultStartDate = @StartDate;
        SET @DefaultEndDate = @EndDate;
    END

    -- Main query to get the list of employees ordered by the count of types of approved requests
    SELECT
        e.employee_id AS EmployeeID,
        CONCAT(e.first_name, ' ', e.last_name) AS Name,
        r.department_id AS DepartmentID,
        COUNT(req.request_id) AS TotalRequests,
        COUNT(DISTINCT CASE WHEN rs.request_type_id = 1 THEN rs.request_subtype_id ELSE NULL END) AS LeaveRequestTypesCount,
        COUNT(DISTINCT CASE WHEN rs.request_type_id = 2 THEN rs.request_subtype_id ELSE NULL END) AS AssignmentRequestTypesCount,
        COUNT(DISTINCT rs.request_subtype_id) AS RequestTypesCount
    FROM
        Employees e
    LEFT JOIN
        Roles r ON e.role_id = r.role_id
    LEFT JOIN
        Requests req ON e.employee_id = req.employee_id
    LEFT JOIN
        RequestSubtypes rs ON req.request_subtype_id = rs.request_subtype_id
    WHERE
        (@DepartmentID IS NULL OR r.department_id = @DepartmentID)
        AND req.request_status = 'Approved'
        AND req.request_date BETWEEN @DefaultStartDate AND @DefaultEndDate
    GROUP BY
        e.employee_id, e.first_name, e.last_name, r.department_id
    ORDER BY
        RequestTypesCount DESC;
END;