#Question 3
SELECT 
    customer.cus_gender,
    COUNT(DISTINCT customer.cus_id) 'total number of customer'
FROM
    customer,
    `order`
WHERE
    1 = 1
        AND `order`.cus_id = customer.CUS_ID
        AND `order`.ord_amount >= 3000
GROUP BY customer.cus_gender
;
#----------------------------------------------------
#Question 4
SELECT 
    `order`.*, product.pro_name 'product name'
FROM
    `order`,
    supplier_pricing,
    product
WHERE
    1 = 1
        AND `order`.cus_id = 2
        AND `order`.PRICING_ID = supplier_pricing.PRICING_ID
        AND supplier_pricing.PRO_ID = product.pro_id;


#----------------------------------------------------
#Question 5
SELECT 
    supplier.*
FROM
    supplier_pricing,
    supplier
WHERE
    1 = 1
        AND supplier.supp_id = supplier_pricing.supp_id
GROUP BY supplier.supp_name
HAVING COUNT(supplier_pricing.pro_id) > 1
ORDER BY SUPP_ID;

#----------------------------------------------------------
#Question 6
SELECT 
    category.cat_id,
    category.cat_name,
    MIN(supplier_pricing.supp_price) 'price of product'
FROM
    product,
    supplier_pricing,
    category
WHERE
    1 = 1
        AND supplier_pricing.pro_id = product.pro_id
        AND category.cat_id = product.cat_id
GROUP BY product.cat_id;

#-------------------------------
#Question 7
SELECT 
    product.PRO_ID 'Id', product.PRO_NAME 'Name'
FROM
    `order`,
    product,
    supplier_pricing
WHERE
    1 = 1
        AND ord_date > '2021-10-05'
        AND `order`.PRICING_ID = supplier_pricing.PRICING_ID
        AND product.PRO_ID = supplier_pricing.PRO_ID;

----------------------------------------------
#Question 8
SELECT 
    CUS_NAME 'customer name', cus_gender 'gender'
FROM
    customer
WHERE
    1 = 1
        AND (CUS_NAME LIKE 'A%' OR CUS_NAME LIKE '%A');
#---------------------------------------------
	delimiter $

CREATE PROCEDURE supplier_rating ()

BEGIN
	SELECT supplier.SUPP_ID
		,supplier.SUPP_NAME
		,rating.RAT_RATSTARS
		,CASE 
			WHEN avg(rating.RAT_RATSTARS) = 5
				THEN 'Excellent Service'
			WHEN avg(rating.RAT_RATSTARS) > 4
				THEN 'Good Service'
			WHEN avg(rating.RAT_RATSTARS) > 2
				THEN 'Average'
			ELSE 'Poor Service'
			END AS Type_of_Service
	FROM rating
		,`order`
		,supplier
		,supplier_pricing
WHERE
    1 = 1
        AND rating.ORD_ID = `order`.ORD_ID
		AND supplier.SUPP_ID = supplier_pricing.SUPP_ID
		AND supplier_pricing.PRICING_ID = `order`.PRICING_ID
	GROUP BY supplier.SUPP_ID;
END;
