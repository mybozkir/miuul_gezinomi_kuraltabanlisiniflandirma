-- GÖREV 1
-- Soru 1: Tabloyu oluşturunuz, ilk 10 satırını gözlemleyiniz.
CREATE SCHEMA miuul;

CREATE TABLE miuul.gezinomi(
	saleid INT,
	saledate TIMESTAMP,
	checkindate TIMESTAMP,
	price FLOAT,
	conceptname TEXT,
	salecityname TEXT,
	cinday TEXT,
	salecheckindaydiff INT,
	seasons TEXT);
	
SELECT
	*
FROM
	miuul.gezinomi
LIMIT 10;
	
--  Soru 2: Kaç tekil şehir vardır? Frekansları nedir?
SELECT
	COUNT(DISTINCT salecityname)
FROM
	miuul.gezinomi;
	
SELECT
	salecityname,
	COUNT(*) AS frequency
FROM
	miuul.gezinomi
GROUP BY
	salecityname;
	
-- Soru 3: Kaç tekil konsept vardır?
SELECT
	COUNT(DISTINCT conceptname)
FROM
	miuul.gezinomi;
	
-- Soru 4: Hangi konseptten kaçar tane satış gerçekleşmiş?		
SELECT
	conceptname AS concepts,
	COUNT(*) AS number_of_sales
FROM
	miuul.gezinomi
GROUP BY
	conceptname
ORDER BY 
	number_of_sales DESC;

-- Soru 5: Şehir türlerine göre ne kadar kazanılmış?
SELECT
	salecityname AS cities,
	SUM(price) AS earnings_per_city
FROM
	miuul.gezinomi
GROUP BY
	salecityname
ORDER BY 
	earnings_per_city DESC;
	
-- Soru 6: Konsept türlerine göre ne kadar kazanılmış?
SELECT
	conceptname AS concept,
	SUM(price) AS earnings_per_concept
FROM
	miuul.gezinomi
GROUP BY
	conceptname
ORDER BY 
	earnings_per_concept DESC;
	
-- Soru 7: Şehirlere göre "price" ortalamaları nedir?	
SELECT
	salecityname AS cities,
	AVG(price) AS avg_earnings_per_city
FROM
	miuul.gezinomi
GROUP BY
	salecityname
ORDER BY 
	avg_earnings_per_city DESC;
	
-- Soru 8: Konseptlere göre "price" ortalamaları nedir?	
SELECT
	conceptname AS concepts,
	AVG(price) AS avg_earnings_per_concept
FROM
	miuul.gezinomi
GROUP BY
	conceptname
ORDER BY 
	avg_earnings_per_concept DESC;	
	
-- Soru 9: Şehir-Konsept kırılımında "price" ortalamaları nedir?
SELECT
	salecityname AS cities,
	conceptname AS concepts,
	AVG(price) AS avg_earnings_per_concept
FROM
	miuul.gezinomi
GROUP BY
	salecityname,
	conceptname
ORDER BY 
	avg_earnings_per_concept DESC;	
	
-------------------------------------------------------------------------------------	
-- GÖREV 2
-- SaleCheckinDayDiff değişkenini kategorik bir değişkene çeviriniz. miuul.sales adında yeni bir tablo oluşturunuz.

SELECT *
FROM miuul.gezinomi;

CREATE TABLE miuul.sales AS
SELECT
	*,
	CASE
		WHEN salecheckindaydiff BETWEEN 0 AND 7 THEN 'Last Minuters'
		WHEN salecheckindaydiff BETWEEN 7 AND 30 THEN 'Potential Planners'
		WHEN salecheckindaydiff BETWEEN 30 AND 90 THEN 'Planners'
		WHEN salecheckindaydiff > 90 THEN 'Early Bookers'
	END AS eb_score
FROM
	miuul.gezinomi;
	
SELECT
	*
FROM
	miuul.sales;
	
-- GÖREV 3
/*
Şehir-Konsept-EB_Score
Şehir-Konsept-Sezon
Şehir-Konsept-CInday

kırılımlarında ortalama ödenen ücret ve yapılan işlem sayısı cinsinden inceleyiniz.

*/	
	
SELECT
	*
FROM
	miuul.sales
LIMIT 10;

-- Şehir-Konsept-EB_Score
SELECT
	salecityname AS cities,
	conceptname AS concepts,
	eb_score AS eb,
	AVG(price) AS avg_price,
	COUNT(*) AS total_transaction
FROM
	miuul.sales
GROUP BY
	salecityname,
	conceptname,
	eb_score
ORDER BY
	salecityname;
	
-- Şehir-Konsept-Sezon
SELECT
	salecityname AS cities,
	conceptname AS concepts,
	seasons,
	AVG(price) AS avg_price,
	COUNT(*) AS total_transaction
FROM
	miuul.sales
GROUP BY
	salecityname,
	conceptname,
	seasons
ORDER BY
	salecityname;	
	
-- Şehir-Konsept-CInday
SELECT
	salecityname AS cities,
	conceptname AS concepts,
	cinday,
	AVG(price) AS avg_price,
	COUNT(*) AS total_transaction
FROM
	miuul.sales
GROUP BY
	salecityname,
	conceptname,
	cinday
ORDER BY
	salecityname;
	
-- GÖREV 4
-- Şehir-Konsept-Sezon kırılımın çıktısını PRICE'a göre sıralayınız. Elde ettiğiniz çıktıyı miuul.sales_ccs olarak kaydediniz.

CREATE TABLE miuul.sales_css AS
SELECT
	salecityname AS cities,
	conceptname AS concepts,
	seasons,
	AVG(price) AS avg_price,
	COUNT(*) AS total_transaction
FROM
	miuul.sales
GROUP BY
	salecityname,
	conceptname,
	seasons
ORDER BY
	avg_price DESC;

-- GÖREV 5
-- Yeni seviye tabanlı satışları (persona) tanımlayınız. level_base_sales adında yeni tablo olarak kaydediniz.

CREATE TABLE miuul.level_base_sales AS
SELECT
	*,
	UPPER(cities || '_' || concepts || '_' || seasons) AS sales_level_based 
FROM
	miuul.sales_css;
	
-- GÖREV 6
-- Personaları segmentlere ayırınız.
	
CREATE TABLE miuul.segment AS
SELECT 
	*,
	CASE
		WHEN avg_price BETWEEN 25 AND 50 THEN 'Segment 1'
		WHEN avg_price BETWEEN 50 AND 75 THEN 'Segment 2'
		WHEN avg_price > 75 THEN 'Segment 3'
	END AS segment
FROM 
	miuul.level_base_sales
ORDER BY
	avg_price;	

SELECT
	segment,
	AVG(avg_price) AS mean,
	MAX(avg_price) AS _max,
	SUM(avg_price) AS _sum
FROM
	miuul.segment
GROUP BY
	segment;

/* GÖREV 7

1. Antalya'da her şey dahil ve yüksek sezonda tatil yapmak isteyen bir kişinin ortalama ne kadar gelir kazandırması beklenir?
2. Girne'de yarım pansiyon bir otelde düşük sezonda giden bir tatilci hangi segmentte yer alacaktır?
*/

SELECT * FROM miuul.segment


SELECT
	*
FROM
	miuul.segment
WHERE
	LOWER(sales_level_based) = 'antalya_herşey dahil_high';
	
SELECT
	*
FROM
	miuul.segment
WHERE
	sales_level_based LIKE 'GIRNE_YAR%LOW';
	
	
	
	