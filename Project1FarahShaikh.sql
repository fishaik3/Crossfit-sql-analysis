-- BUS440 Project 1
-- Farah Shaikh
-- 11/7/25

USE crossfit;

-- Question 7

CREATE TABLE affiliate(
    affiliatename VARCHAR(50) not null,
    affiliateid int not null primary key,
    affiliatestate VARCHAR(50)
);


INSERT INTO affiliate (affiliateid, affiliatename) 
SELECT DISTINCT affiliateid, affiliatename
FROM competitor
WHERE affiliateid IS NOT NULL;

CREATE TABLE country(
    countryoforigincode VARCHAR(50) not null primary key, 
    countryoforiginname VARCHAR(50),
    countrypopulation VARCHAR(50) not null 
);

INSERT INTO country (countryoforigincode, countryoforiginname, countrypopulation)
SELECT DISTINCT countryoforigincode, countryoforiginname, countrypopulation
FROM competitor;

ALTER TABLE COMPETITOR
ADD COLUMN middlename VARCHAR(50);

-- Question 8

-- Table titled score already has id as its primary key when imported with data converter, 
-- decided to rename it to scoreid 

ALTER TABLE score
CHANGE COLUMN id scoreid INT;

ALTER TABLE COMPETITOR
ADD CONSTRAINT pk_competitor PRIMARY KEY (competitorid);


-- Question 9

SHOW INDEX FROM COMPETITOR;
ALTER TABLE SCORE
ADD CONSTRAINT FK_score_competitor FOREIGN KEY (competitorid)
REFERENCES COMPETITOR(competitorid);
-- will not run because all of the competitors that have scores, may not be in the competitor section.

ALTER TABLE COMPETITOR
ADD CONSTRAINT FK_competitor_affiliate FOREIGN KEY (affiliateid)
REFERENCES AFFILIATE(affiliateid);

ALTER TABLE COMPETITOR
ADD CONSTRAINT FK_competitor_country FOREIGN KEY (countryoforigincode)
REFERENCES COUNTRY(countryoforigincode);

-- Question 10

SELECT * FROM SCORE;

SELECT * FROM Competitor;

SELECT * FROM AFFILIATE;

SELECT * FROM COUNTRY;

-- Question 11a.

SELECT DISTINCT
    c.competitorid,
    c.firstname,
    c.lastname,
    co.countryoforiginname AS country,
    c.overallrank
FROM competitor c
JOIN score s 
    ON c.competitorid = s.competitorid
JOIN country co 
    ON c.countryoforigincode = co.countryoforigincode
WHERE s.year = 2019 
AND c.division = 'MEN'
ORDER BY CAST(c.overallrank AS UNSIGNED) ASC;


-- Question 11b.
SELECT 
    c.competitorid,
    c.firstname,
    c.lastname,
    co.countryoforiginname AS country,
    c.status
FROM competitor AS c
INNER JOIN score AS s
    ON s.competitorid = c.competitorid
INNER JOIN country AS co
    ON co.countryoforigincode = c.countryoforigincode
WHERE s.year = 2019
  AND (c.status = 'CUT' OR c.status = 'WD')
GROUP BY c.competitorid, c.firstname, c.lastname, co.countryoforiginname, c.status
ORDER BY c.lastname ASC, c.firstname ASC;

-- Question 11c.
SELECT 
    co.countryoforiginname AS country,
    co.countrypopulation AS population,
    SUM(c.overallscore) AS total_points
FROM competitor AS c
INNER JOIN score AS s 
    ON c.competitorid = s.competitorid
INNER JOIN country AS co 
    ON c.countryoforigincode = co.countryoforigincode
WHERE s.year = 2019
GROUP BY co.countryoforiginname, co.countrypopulation
ORDER BY total_points DESC;

-- Question 11d. 
SELECT 
    c.competitorid,
    c.firstname,
    c.lastname,
    c.division,
    c.overallrank,
    c.overallscore
FROM competitor c
WHERE c.division = 'Men (35-39)'
ORDER BY c.overallrank ASC
LIMIT 10;

-- Question 11e.
SELECT DISTINCT
    c.competitorid,
    c.firstname,
    c.lastname,
    co.countryoforiginname AS country
FROM competitor AS c
JOIN country AS co
    ON c.countryoforigincode = co.countryoforigincode
WHERE co.countryoforiginname REGEXP 'land$'
ORDER BY country, c.lastname, c.firstname;

-- Question 11f. Which division had the most competitors from each country in 2019?
SELECT 
    co.countryoforiginname AS country,
    c.division,
    COUNT(DISTINCT c.competitorid) AS num_competitors
FROM competitor c
JOIN score s
    ON c.competitorid = s.competitorid
JOIN country co
    ON c.countryoforigincode = co.countryoforigincode
WHERE s.year = 2019
GROUP BY co.countryoforiginname, c.division
ORDER BY co.countryoforiginname, num_competitors DESC;

-- Question 11g. Total points earned by each competitor in 2019.
SELECT 
    c.competitorid,
    c.firstname,
    c.lastname,
    SUM(s.points) AS total_points
FROM competitor AS c
JOIN score AS s
    ON c.competitorid = s.competitorid
WHERE s.year = 2019
GROUP BY c.competitorid, c.firstname, c.lastname
ORDER BY total_points DESC;

-- Question 11h. Which competitors scored the lowest points in any event in 2019?
SELECT 
    c.competitorid,
    c.firstname,
    c.lastname,
    s.points,
    s.workoutIDforDivision
FROM competitor c
JOIN score s
    ON c.competitorid = s.competitorid
WHERE s.year = 2019
  AND s.points = (
      SELECT MIN(points)
      FROM score
      WHERE year = 2019
  )
ORDER BY s.points ASC;

-- Question 11i. Which competitors have a last name that starts with the letter ‘J’ in 2019?
SELECT 
    c.competitorid,
    c.firstname,
    c.lastname,
    co.countryoforiginname AS country,
    SUM(s.points) AS total_points
FROM competitor c
JOIN score s
    ON c.competitorid = s.competitorid
JOIN country co
    ON c.countryoforigincode = co.countryoforigincode
WHERE s.year = 2019
  AND c.lastname LIKE 'J%'
GROUP BY c.competitorid, c.firstname, c.lastname, co.countryoforiginname
ORDER BY c.lastname, c.firstname;



