-- SQLite 3

CREATE TABLE Agents(AgentID UNIQUE, Name);
CREATE TABLE Payment(PaymentID UNIQUE, AgentExt, ParentPayment, PType, Dte, Val);

insert into Agents(AgentID, Name) values(1, 'Конь Агент 1');
insert into Agents(AgentID, Name) values(2, 'Агент 2');
insert into Agents(AgentID, Name) values(3, 'Конный транспорт 3');
insert into Agents(AgentID, Name) values(4, 'Агент 4');
insert into Agents(AgentID, Name) values(5, 'Констрстрайк 5');

insert into Payment(PaymentID, AgentExt, ParentPayment, PType, Dte, Val) values(1, 1, null, 10, '2016-04-18 00:00:00', 100);
insert into Payment(PaymentID, AgentExt, ParentPayment, PType, Dte, Val) values(2, 1, 1, 10, '2016-04-20 00:00:00', 500);
insert into Payment(PaymentID, AgentExt, ParentPayment, PType, Dte, Val) values(3, 1, 1, 10, '2016-05-01 00:00:00', 751);
insert into Payment(PaymentID, AgentExt, ParentPayment, PType, Dte, Val) values(4, 1, 2, 10, '2016-05-15 00:00:00', 651);
insert into Payment(PaymentID, AgentExt, ParentPayment, PType, Dte, Val) values(5, 1, 3, 166, '2016-05-16 00:00:00', 82);
insert into Payment(PaymentID, AgentExt, ParentPayment, PType, Dte, Val) values(6, 1, 3, 10, '2016-05-17 00:00:00', 2854);

insert into Payment(PaymentID, AgentExt, ParentPayment, PType, Dte, Val) values(7, 2, null, 166, '2016-05-19 00:00:00', 366);
insert into Payment(PaymentID, AgentExt, ParentPayment, PType, Dte, Val) values(8, 3, 7, 166, '2016-05-20 00:00:00', 255);
insert into Payment(PaymentID, AgentExt, ParentPayment, PType, Dte, Val) values(9, 4, 8, 10, '2016-05-27 00:00:00', 71);
insert into Payment(PaymentID, AgentExt, ParentPayment, PType, Dte, Val) values(10, 2, 9, 10, '2016-06-10 00:00:00', 636);
insert into Payment(PaymentID, AgentExt, ParentPayment, PType, Dte, Val) values(11, 5, 9, 10, '2016-06-11 00:00:00', 2678);
insert into Payment(PaymentID, AgentExt, ParentPayment, PType, Dte, Val) values(12, 4, 9, 10, '2016-06-12 00:00:00', 436);

/*
Вывести имена агентов, совершавших платежи с 01.05.2016 по 20.05.2016, и сумму
последнего платежа агента.
*/

WITH payments 
     AS (SELECT agentext, 
                Max(paymentid) AS id 
         FROM   payment 
         WHERE  dte BETWEEN '2016-05-01 00:00:00' AND '2016-05-20 00:00:00' 
         GROUP  BY agentext) 
SELECT DISTINCT a.NAME, 
                c.val 
FROM   agents a 
       LEFT JOIN payments b 
              ON a.agentid = b.agentext 
       LEFT JOIN payment c 
              ON c.paymentid = b.id 
WHERE  a.agentid = c.agentext 
       AND c.paymentid = b.id; 

/*
Вывести платежи непосредственно не связанные с исходным платежом с типом 166
*/

WITH recursive payments AS 
( 
       SELECT paymentid, 
              agentext, 
              parentpayment, 
              ptype, 
              dte, 
              val 
       FROM   payment 
       WHERE  parentpayment IS NULL 
       AND    ptype <> 166 
       UNION ALL 
       SELECT     a.paymentid, 
                  a.agentext, 
                  a.parentpayment, 
                  a.ptype, 
                  a.dte, 
                  a.val 
       FROM       payment a 
       INNER JOIN payments b 
       ON         a.parentpayment = b.paymentid 
       WHERE      a.ptype <> 166 ) 
SELECT * 
FROM   payments;

/*
Найти платежи агентов, наименование которых начинается на «кон» (независимо от
регистра символов) и вывести их в порядке возрастания даты платежа. Нужно вывести
наименование агента, дату платежа, сумму платежа, сумму предыдущего (по дате)
платежа этого агента.
*/

WITH kon_agents AS 
( 
       -- важное замечание: т.к. я делаю это в рамках SQlite, данная субд не умеет правильно применять lower к юникоду, только к анси.
       -- задачу можно решить через использование юзерской ф-ии, либо просто использовать другую БД 
       -- по этому здесь оставляю лайк с «Кон» (с большой буквы), в других субд следует написать where lower(Name) like 'кон%'
       SELECT agentid, 
              NAME 
       FROM   agents 
       WHERE  NAME LIKE 'Кон%' ) 
SELECT     b.NAME, 
           a.dte, 
           a.val, 
           ( 
                  SELECT c.val 
                  FROM   payment c 
                  WHERE  a.agentext = c.agentext 
                  AND    c.paymentid < a.paymentid limit 1) 
FROM       payment a 
INNER JOIN kon_agents b 
ON         a.agentext = b.agentid 
ORDER BY   a.dte;
