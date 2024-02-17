-- Создать таблицы со следующими структурами и загрузить данные из csv-файлов
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    gender VARCHAR(50),
    DOB VARCHAR(50),
    job_title VARCHAR(255),
    job_industry_category VARCHAR(255),
    wealth_segment VARCHAR(255),
    deceased_indicator CHAR(1),
    owns_car CHAR(50),
    address VARCHAR(255),
    postcode INT,
    state VARCHAR(50), 
    country VARCHAR(100), 
    property_valuation INT
);

![customer_table_structure](../screenshots/screenshot_1.png)

COPY customers
FROM 'https://github.com/nikatonika/SQL_task_2/data/customer.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    transaction_date VARCHAR(50),  
    online_order BOOLEAN,
    order_status VARCHAR(50), 
    brand VARCHAR(255),
    product_line VARCHAR(255),
    product_class VARCHAR(255),
    product_size VARCHAR(255),
    list_price DECIMAL(10, 2),
    standard_cost DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Вставка скриншота: transaction_table_structure
-- ![transaction_table_structure](screenshots/screenshot_3.png)

-- Вставка скриншота: transaction_table_data_import
-- ![transaction_table_data_import](screenshots/screenshot_4.png)

COPY transactions
FROM 'https://github.com/nikatonika/SQL_task_2/data/transaction.csv'
DELIMITER ',' CSV HEADER;

-- Выполнить следующие запросы:

-- Запрос 1: Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов.
SELECT DISTINCT brand
FROM transactions
WHERE standard_cost > 1500;

-- Вставка скриншота: unique_brands_over_1500
-- ![unique_brands_over_1500](screenshots/screenshot_5.png)

-- Запрос 2: Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно.
SELECT *
FROM transactions
WHERE transaction_date BETWEEN '2017-04-01' AND '2017-04-09'
AND order_status = 'Approved';

-- Вставка скриншота: approved_transactions_2017
-- ![approved_transactions_2017](screenshots/screenshot_6.png)

-- Запрос 3: Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'.
SELECT DISTINCT c.job_title
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
WHERE c.job_industry_category IN ('IT', 'Financial Services')
AND c.job_title LIKE 'Senior%';

-- Вставка скриншота: senior_jobs_IT_FinancialServices
-- ![senior_jobs_IT_FinancialServices](screenshots/screenshot_7.png)

-- Запрос 4: Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services.
SELECT DISTINCT t.brand
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
WHERE c.job_industry_category = 'Financial Services';

-- Вставка скриншота: brands_by_FinancialServices_customers
-- ![brands_by_FinancialServices_customers](screenshots/screenshot_8.png)

-- Запрос 5: Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'.
SELECT DISTINCT c.first_name, c.last_name
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.online_order = 'TRUE' -- Сравниваем с текстовым представлением истины
AND t.brand IN ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
LIMIT 10;

-- Вставка скриншота: online_orders_top_10_customers
-- ![online_orders_top_10_customers](screenshots/screenshot_9.png)

-- Запрос 6: Вывести всех клиентов, у которых нет транзакций.
SELECT c.first_name, c.last_name
FROM customers c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.transaction_id IS NULL;

-- Вставка скриншота: customers_without_transactions
-- ![customers_without_transactions](screenshots/screenshot_10.png)

-- Запрос 7: Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.
SELECT c.first_name, c.last_name, t.standard_cost
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
WHERE c.job_industry_category = 'IT'
AND t.standard_cost = (
    SELECT MAX(standard_cost)
    FROM transactions
);

-- Вставка скриншота: max_standard_cost_IT_customers
-- ![max_standard_cost_IT_customers](screenshots/screenshot_11.png)

-- Запрос 8: Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'.
SELECT DISTINCT c.first_name, c.last_name, c.job_industry_category
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
WHERE (c.job_industry_category = 'IT' OR c.job_industry_category = 'Health')
AND t.transaction_date BETWEEN '2017-07-07' AND '2017-07-17'
AND t.order_status = 'Approved';

-- Вставка скриншота: IT_Health_approved_transactions
-- ![IT_Health_approved_transactions](screenshots/screenshot_12.png)
