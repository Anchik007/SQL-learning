1. DROP TABLE IF EXISTS InputTbl
1. CREATE TABLE InputTbl ( col1 VARCHAR(10), col2 VARCHAR(10) ); INSERT INTO InputTbl (col1, col2) VALUES ('a', 'b'), ('a', 'b'), ('b',																																																															
'a'), ('c', 'd'), ('c', 'd'), ('m', 'n'), ('n', 'm');

Puzzle 1: Finding Distinct Values
SELECT DISTINCT
  LEAST(col1, col2) AS col1,
  GREATEST(col1, col2) AS col2
FROM InputTbl;
Puzzle 2: Removing Rows with All Zeroes
SELECT *
FROM TestMultipleZero
WHERE NOT (A = 0 AND B = 0 AND C = 0 AND D = 0);
Puzzle 3: Find those with odd ids

IF OBJECT_ID('dbo.section1', 'U') IS NOT NULL
    DROP TABLE dbo.section1;

CREATE TABLE dbo.section1 (
    id INT,
    name VARCHAR(20)
);

INSERT INTO dbo.section1 (id, name) 
VALUES 
    (1, 'Been'),
    (2, 'Roma'),
    (3, 'Steven'),
    (4, 'Paulo'),
    (5, 'Genryh'),
    (6, 'Bruno'),
    (7, 'Fred'),
    (8, 'Andro');

SELECT * FROM dbo.section1;
Puzzle 4: Person with the smallest id (use the table in puzzle 3)
SELECT TOP 1 *
FROM section1
ORDER BY id ASC;
Puzzle 5: Person with the highest id (use the table in puzzle 3)
SELECT TOP 1 *
FROM section1
ORDER BY id DESC;
Puzzle 6: People whose name starts with b (use the table in puzzle 3)
SELECT *
FROM section1
WHERE name LIKE 'B%';
Puzzle 7: Write a query to return only the rows where the code contains the literal underscore _ (not as a wildcard).
SELECT *
FROM section1
WHERE name LIKE '%[_]%';

