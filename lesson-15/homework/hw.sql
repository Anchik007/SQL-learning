Level 1: Basic Subqueries
1. Find Employees with Minimum Salary


SELECT *
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);
2. Find Products Above Average Price


SELECT *
FROM products
WHERE price > (SELECT AVG(price) FROM products);
Level 2: Nested Subqueries with Conditions
3. Find Employees in Sales Department


SELECT *
FROM employees
WHERE department_id = (
    SELECT id FROM departments WHERE department_name = 'Sales'
);
4. Find Customers with No Orders


SELECT *
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);
Level 3: Aggregation and Grouping in Subqueries
5. Find Products with Max Price in Each Category


SELECT *
FROM products p
WHERE price = (
    SELECT MAX(price)
    FROM products
    WHERE category_id = p.category_id
);
6. Find Employees in Department with Highest Average Salary


SELECT *
FROM employees
WHERE department_id = (
    SELECT TOP 1 department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
);
Level 4: Correlated Subqueries
7. Find Employees Earning Above Department Average


SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);
8. Find Students with Highest Grade per Course


SELECT *
FROM grades g
WHERE grade = (
    SELECT MAX(grade)
    FROM grades
    WHERE course_id = g.course_id
);
To get student names as well:


SELECT s.name, g.course_id, g.grade
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE grade = (
    SELECT MAX(grade)
    FROM grades
    WHERE course_id = g.course_id
);
Level 5: Subqueries with Ranking and Complex Conditions
9. Find Third-Highest Price per Category


SELECT *
FROM products p
WHERE 2 = (
    SELECT COUNT(DISTINCT price)
    FROM products
    WHERE category_id = p.category_id AND price > p.price
);
10. Find Employees whose Salary Between Company Average and Department Max Salary


SELECT *
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees)
  AND salary < (
      SELECT MAX(salary)
      FROM employees
      WHERE department_id = e.department_id
  );
