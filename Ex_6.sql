-- Câu 1:
DELIMITER //
CREATE PROCEDURE Proce_Ques1 (IN in_dep_name VARCHAR (255))
BEGIN
SELECT A.AccountID, A.FullName, D.DepartmentName FROM `account` A
JOIN department D ON D.DepartmentID = A.DepartmentID
WHERE D.DepartmentName = in_dep_name;
END//
DELIMITER ;
CALL Proce_Ques1('');

-- Câu 2:
DELIMITER //
CREATE PROCEDURE Proce_Ques2 (IN in_group_name VARCHAR(200))
BEGIN
SELECT G.GroupName, count(GA.AccountID) FROM `group account` GA
JOIN `group` G ON GA.GroupID = G.GroupID
WHERE G.GroupName = in_group_name;
END//
DELIMITER ;
CALL Proce_Ques2('');

-- Câu 3:
DELIMITER //
CREATE PROCEDURE Proce_Ques3 (IN in_type_question VARCHAR(200))
BEGIN
SELECT TA.TypeName, count(TA.TypeID) FROM `type question` TQ
LEFT JOIN `question` Q ON TQ.TypeID = Q.TypeID
WHERE MONTH(Q.CreatorDate) = MONTH(now()) AND YEAR(Q.CreatorDate) = YEAR(NOW())
GROUP BY Q.TypeID;
END//
DELIMITER ;
CALL Proce_Ques3('');

-- Câu 4:
-- store:
DROP PROCEDURE IF EXISTS Proce_Ques4;
DELIMITER //
CREATE PROCEDURE Proce_Ques4(OUT out_ID TINYINT)
BEGIN
WITH CTE_CountTypeID AS (
SELECT count(Q.TypeID) AS SL FROM question Q
GROUP BY Q.TypeID
)
SELECT Q.TypeID INTO out_ID FROM question Q
GROUP BY Q.TypeID
HAVING COUNT(Q.TypeID) = (SELECT max(SL) FROM CTE_CountTypeID);
END//
DELIMITER ;
SET @ID =0;
CALL Proce_Ques4(@ID);
SELECT @ID;

-- Câu 5:
DROP PROCEDURE IF EXISTS Proce_Ques5;
DELIMITER //
CREATE PROCEDURE Proce_Ques5()
BEGIN
WITH CTE_MaxTypeID AS(
SELECT count(Q.TypeID) AS SL FROM question Q
GROUP BY Q.TypeID
)
SELECT TQ.TypeName, count(Q.TypeID) AS SL FROM question Q
JOIN `type question` TQ ON TQ.TypeID = Q.TypeID
GROUP BY Q.TypeID
HAVING count(Q.TypeID) = (SELECT MAX(SL) FROM CTE_MaxTypeID);
END//
DELIMITER ;
Call Proce_Ques5();
SET @ID =0;
Call Proce_Ques5(@ID);
SELECT * FROM `type question` WHERE TypeID = @ID;

-- Câu 6:
DELIMITER //
CREATE PROCEDURE Proce_Ques6(IN in_searchText VARCHAR(255))
BEGIN
SELECT 
    A.Username, G.Groupname
FROM
    account A
LEFT JOIN`group account` GA ON A.AccountID = GA.AccountID
RIGHT JOIN `group` G ON G.GroupID = GA.GroupID
WHERE A.Username LIKE CONCAT('%',in_searchText,'%') 
	OR G.GroupName LIKE CONCAT('%',in_searchText,'%');
END//
DELIMITER ;
CALL Proce_Ques6('');

-- Câu 7:
DELIMITER //
CREATE PROCEDURE Proce_Ques7(IN in_fullname VARCHAR(200), IN in_email VARCHAR(200))
BEGIN
	DECLARE v_Username VARCHAR(200) DEFAULT SUBSTRING_INDEX(in_email, '@', 1);
	DECLARE v_DepartmentID INT DEFAULT 0;
	DECLARE v_PositionID INT  DEFAULT 0;
	SELECT 
		DepartmentID
	INTO v_DepartmentID FROM Department
	WHERE
		DepartmentName = 'Phòng Chờ';
	SELECT 
		PositionID
	INTO v_PositionID FROM Position
	WHERE
		PositionName = 'Deverloper';
	INSERT INTO `account` (`Email`, `Username`, `FullName`,
	`DepartmentID`, `PositionID`)
	VALUES (in_Email, v_Username, v_Fullname,
	v_DepartmentID, v_PositionID);
	END//
	DELIMITER ;
	CALL Proce_Ques7('sfenning0@boston.com','Stephana Fenning');

	-- Câu 8:
	DELIMITER //
	CREATE PROCEDURE Proce_Ques8(IN in_TypeName ENUM('Essay', 'Multiple Choice'))
	BEGIN
		SELECT 
		   Q.Content, Count(Q.Content) as Độ_dài_của_Content
		FROM
			Question Q
		WHERE LENGTH(Q.Content) = (SELECT MAX(LENGTH(Q.Content)) 
									FROM Question Q 
									JOIN `Type Question` TQ 
									ON Q.TypeID = TQ.TypeID 
									WHERE TQ.TypeName = in_TypeName);
END//
DELIMITER ;

CALL Proce_Ques8 ('Essay');

CALL Proce_Ques8 ('Multiple Choice');

-- Câu 9:
DELIMITER //
CREATE PROCEDURE Proce_Ques9(IN in_ExamID INT)
BEGIN
	DELETE FROM
		exam
	WHERE ExamID = in_ExamID;

	DELETE FROM
		exam question
	WHERE ExamID = in_ExamID;
END//
DELIMITER ;

CALL Proce_Ques9(1);

-- Câu 10:
DELIMITER //
CREATE PROCEDURE Proce_Ques10()
BEGIN
	DECLARE Delete_from_ExamQuestion INT;
	DECLARE Delete_from_Exam INT;
	DELETE FROM
		exam question
	WHERE ExamID IN (SELECT ExamId FROM exam WHERE year(now()) - year(CreateDate) = 3);

	DELETE FROM
		exam
	WHERE year(now()) - year(CreateDate) = 3;
	SELECT Delete_from_ExamQuestion, Delete_from_Exam;
END//
DELIMITER ;

CALL Proce_Ques10();
