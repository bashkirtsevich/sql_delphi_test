-- SQLite 3

CREATE TABLE Department(ID UNIQUE, Name);
CREATE TABLE Employee(ID UNIQUE, Department_ID, Chief_ID, Name, SALARY);

insert into Department(ID, Name) values(1, 'Departament 1');
insert into Department(ID, Name) values(2, 'Departament 2');
insert into Department(ID, Name) values(3, 'Departament 3');

insert into Employee(ID, Department_ID, Chief_ID, Name, SALARY) values(1, 1, null, 'Родительский шеф (д1)', 100000);
insert into Employee(ID, Department_ID, Chief_ID, Name, SALARY) values(2, 1, 1, 'Дочерний шеф (д1)', 90000);
insert into Employee(ID, Department_ID, Chief_ID, Name, SALARY) values(3, 1, 2, 'Работник 1 (д1)', 170000);
insert into Employee(ID, Department_ID, Chief_ID, Name, SALARY) values(4, 1, 2, 'Работник 2 (д1)', 95000);
insert into Employee(ID, Department_ID, Chief_ID, Name, SALARY) values(5, 1, 2, 'Работник 3 (д1)', 40000);

insert into Employee(ID, Department_ID, Chief_ID, Name, SALARY) values(6, 2, null, 'Родительский шеф (д2)', 200000);
insert into Employee(ID, Department_ID, Chief_ID, Name, SALARY) values(7, 2, 6, 'Дочерний шеф (д2)', 240000);
insert into Employee(ID, Department_ID, Chief_ID, Name, SALARY) values(8, 2, 7, 'Работник 1 (д2)', 40000);
insert into Employee(ID, Department_ID, Chief_ID, Name, SALARY) values(9, 2, 7, 'Работник 2 (д2)', 50000);
insert into Employee(ID, Department_ID, Chief_ID, Name, SALARY) values(10, 2, 7, 'Работник 3 (д2)', 60000);

insert into Employee(ID, Department_ID, Chief_ID, Name, SALARY) values(11, 3, null, 'Родительский шеф (д3)', 60000);
insert into Employee(ID, Department_ID, Chief_ID, Name, SALARY) values(12, 3, 11, 'Работник 1 (д3)', 20000);

/*
Вывести список сотрудников, получающих заработную плату большую, чем у
непосредственного руководителя
*/

SELECT a.* 
FROM   employee a 
       INNER JOIN employee b 
               ON a.chief_id = b.id 
WHERE  a.chief_id IS NOT NULL 
       AND a.salary > b.salary; 

/*
Вывести список сотрудников, получающих максимальную заработную плату в своем
отделе, отсортированный по убыванию размера заработной платы.
*/

SELECT * 
FROM   employee a 
       INNER JOIN (SELECT department_id, 
                          Max(salary) AS Employee_SALARY 
                   FROM   employee 
                   GROUP  BY department_id) b 
               ON a.department_id = b.department_id 
                  AND a.salary = b.employee_salary; 

/*
Вывести список ID отделов, количество сотрудников в которых меньше 3-х человек
*/

SELECT ID AS Department_ID
FROM   (SELECT a.id, 
               a.NAME, 
               Count(b.id) AS Employee_count 
        FROM   department a 
               LEFT JOIN employee b 
                      ON a.id = b.department_id 
        GROUP  BY a.id, 
                  a.NAME) 
WHERE  employee_count < 3; 

/*
Вывести список ID руководителей, заработная плата которых больше суммарной
заработной платы их подчиненных.
*/

WITH recursive employees AS 
( 
       SELECT id, 
              department_id, 
              chief_id, 
              NAME, 
              1 AS is_chief, 
              salary 
       FROM   employee 
       WHERE  chief_id IS NULL 
       UNION ALL 
       SELECT     a.id, 
                  a.department_id, 
                  a.chief_id, 
                  a.NAME, 
                  EXISTS 
                  ( 
                         SELECT 1 
                         FROM   employee c 
                         WHERE  c.chief_id = a.id) AS is_chief, 
                  a.salary 
       FROM       employee a 
       INNER JOIN employees b 
       ON         a.chief_id = b.id ), 
non_chiefs AS 
( 
         SELECT   department_id, 
                  chief_id, 
                  sum(salary) AS salary 
         FROM     employees 
         WHERE    is_chief = 0 
         GROUP BY department_id, 
                  chief_id ), 
chiefs AS 
( 
       SELECT id, 
              NAME, 
              salary 
       FROM   employees 
       WHERE  is_chief = 1 ) 
SELECT     * 
FROM       chiefs a 
INNER JOIN non_chiefs b 
ON         a.id = b.chief_id 
WHERE      a.salary > b.salary;

/*
Найти список наименований отделов с максимальной суммарной зарплатой сотрудников
*/

SELECT a.NAME 
FROM   department a 
       INNER JOIN (SELECT department_id, 
                          Max(employee_salary_sum) AS Employee_SALARY 
                   FROM   (SELECT department_id, 
                                  Sum(salary) AS Employee_SALARY_sum 
                           FROM   employee 
                           GROUP  BY department_id)) b 
               ON a.id = b.department_id; 
