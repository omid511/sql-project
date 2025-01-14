USE requests;
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
        WHERE request_subtype_id = @request_subtype_id;

    OPEN RuleCursor;
    FETCH NEXT FROM RuleCursor INTO @RuleName, @RuleValue, @RuleCheck;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @RuleName = 'Min Vacation Days' AND DATEDIFF(day, @start_date, @end_date) < CAST(@RuleValue AS INT) -1
        BEGIN
            SET @ErrorMessage = 'Rule Violated: Minimum vacation days not met.';
            RAISERROR(@ErrorMessage, 16, 1);
            CLOSE RuleCursor;
            DEALLOCATE RuleCursor;
            RETURN;
        END

        IF @RuleName = 'Max Vacation Days' AND DATEDIFF(day, @start_date, @end_date) > CAST(@RuleValue AS INT)
        BEGIN
            SET @ErrorMessage = 'Rule Violated: Maximum vacation days exceeded.';
            RAISERROR(@ErrorMessage, 16, 1);
            CLOSE RuleCursor;
            DEALLOCATE RuleCursor;
            RETURN;
        END

        IF @RuleName = 'Sick Leave Requires Note' AND @request_subtype_id = 11 AND (@reason IS NULL OR DATALENGTH(@reason) = 0)
        BEGIN
            SET @ErrorMessage = 'Rule Violated: Sick leave requires a reason.';
            RAISERROR(@ErrorMessage, 16, 1);
            CLOSE RuleCursor;
            DEALLOCATE RuleCursor;
            RETURN;
        END

        IF @RuleName = 'Project Assignment Justification Required' AND @request_subtype_id = 20 AND (@reason IS NULL OR DATALENGTH(@reason) = 0)
        BEGIN
            SET @ErrorMessage = 'Rule Violated: Project assignment requires a justification.';
            RAISERROR(@ErrorMessage, 16, 1);
            CLOSE RuleCursor;
            DEALLOCATE RuleCursor;
            RETURN;
        END

        -- Add more rule checks as needed
        IF @RuleName = 'Project Assignment Max Duration' AND @request_subtype_id = 20 AND DATEDIFF(day, @start_date, @end_date) > CAST(@RuleValue AS INT)
        BEGIN
            SET @ErrorMessage = 'Rule Violated: Project assignment duration exceeds the maximum allowed.';
            RAISERROR(@ErrorMessage, 16, 1);
            CLOSE RuleCursor;
            DEALLOCATE RuleCursor;
            RETURN;
        END

        IF @RuleName = 'Task Assignment Deadline Required' AND @request_subtype_id = 21 AND @end_date IS NULL
        BEGIN
            SET @ErrorMessage = 'Rule Violated: Task assignment requires a deadline.';
            RAISERROR(@ErrorMessage, 16, 1);
            CLOSE RuleCursor;
            DEALLOCATE RuleCursor;
            RETURN;
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