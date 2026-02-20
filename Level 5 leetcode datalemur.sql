-- clients with completed trades --
SELECT
    u.city,
    COUNT(t.order_id) AS total_orders
FROM
    trades AS t 
    INNER JOIN users AS u
    ON t.user_id = u.user_id
WHERE
    t.status = 'Completed'
GROUP BY
    u.city
ORDER BY
    total_orders DESC
LIMIT 3;


-- facebook page with no likes --

SELECT
    p.page_id
FROM
    pages as p
    LEFT JOIN page_likes AS pl
    ON p.page_id = pl.page_id
WHERE
    pl.page_id IS NULL;
    
    
    
    -- laptop vs. mobile viewership --

SELECT
    SUM(
        CASE
            WHEN device_type = 'laptop' THEN 1 ELSE 0
        END
    ) AS laptop_views,
    SUM(
        CASE
        WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0
        END
    ) AS mobile_views
FROM
    viewership;
    
    
    
    
    -- purchasing activity by product type --

SELECT
    t1.order_date,
    t1.product_type,
    (
        SELECT
            SUM(quantity)
        FROM
            total_trans AS t2
        WHERE
            t2.order_date <= t1.order_date AND
            t2.product_type = t1.product_type
    ) AS cum_purchased
FROM
    total_trans AS t1;
    
    
    
    
    
    -- microsoft teams power users --

SELECT
    sender_id,
    COUNT(message_id) AS message_count
FROM
    messages
WHERE
    DATE_PART('year', sent_date) = 2022 AND
    DATE_PART('month', sent_date) = 8
GROUP BY
    sender_id
ORDER BY
    message_count DESC
LIMIT 2;





-- highest number of products --

SELECT
    user_id,
    product_sum
FROM
(
    SELECT
        user_id,
        COUNT(product_id) AS product_sum,
        SUM(spend) AS total_spend
    FROM
        user_transactions
    GROUP BY
        user_id
) AS temp_tbl
WHERE
    total_spend >= 1000
ORDER BY
    product_sum DESC,
    total_spend DESC
LIMIT 3;




-- histogram of tweets --

WITH tweet_counts AS
(
    SELECT
        COUNT(tweet_id) AS tweet_count
    FROM
        tweets
    WHERE
        DATE_PART('year', tweet_date) = 2022
    GROUP BY
        user_id
)

SELECT
    COUNT(tweet_count) AS tweet_bucket,
    tweet_count AS user_num
FROM
    tweet_counts
GROUP BY
    tweet_count
ORDER BY
    tweet_bucket ASC;
    
    
    
    
    -- spare server capacity --

WITH space_demand AS
(
    SELECT
        datacenter_id,
        SUM(monthly_demand) AS total_monthly_demand
    FROM
        forecasted_demand
    GROUP BY
        datacenter_id
)

SELECT
    dc.datacenter_id,
    (dc.monthly_capacity - sd.total_monthly_demand) AS spare_capacity
FROM
    datacenters AS dc
    INNER JOIN space_demand AS sd
    ON dc.datacenter_id = sd.datacenter_id
ORDER BY
    dc.datacenter_id ASC;
    
    
    
    
    
    -- repeat purchases on multiple days --

WITH purchases_by_users AS
(
    SELECT
        user_id,
        product_id, DATE(purchase_date),
        DENSE_RANK() OVER(PARTITION BY user_id, product_id ORDER BY DATE(purchase_date) ASC) AS purchase_num
    FROM
        purchases
)

SELECT
    COUNT(DISTINCT user_id) AS users_num
FROM
    purchases_by_users
WHERE
    purchase_num > 1;
    
    
    
    
    
    -- duplicate job listings --

WITH duplicated_listings AS
(
    SELECT
        company_id,
        title,
        description,
        COUNT(job_id) AS job_postings
    FROM
        job_listings
    GROUP BY
        company_id,
        title,
        description
    HAVING
        COUNT(job_id) > 1
)

SELECT
    COUNT(DISTINCT company_id) AS duplicate_companies
FROM
    duplicated_listings;
    
    
    
    
    
    -- average post hiatus --

SELECT
    user_id,
    DATEDIFF(
        MAX(DATE(post_date)),
        MIN(DATE(post_date))
    ) AS days_between
FROM posts
WHERE YEAR(post_date) = 2021
GROUP BY user_id
HAVING COUNT(post_id) > 1;




-- app clickthrough rate ctr --

SELECT
    app_id,
    ROUND(
        100 *
        SUM(CASE WHEN event_type = 'click' THEN 1.0 ELSE 0.0 END) /
        SUM(CASE WHEN event_type = 'impression' THEN 1.0 ELSE 0.0 END),
        2
    ) AS ctr
FROM
    events
WHERE
    DATE_PART('year', timestamp) = 2022
GROUP BY
    app_id;
    
    
    
    
    
    -- third transaction by users --

WITH transactions_rank AS
(
    SELECT
        user_id,
        spend,
        transaction_date,
        DENSE_RANK() OVER (PARTITION BY user_id ORDER BY transaction_date ASC) AS ranking
    FROM
        transactions
)

SELECT
    user_id,
    spend,
    transaction_date
FROM
    transactions_rank
WHERE
    ranking = 3;
    
    
    
    
    
    -- linkedin power creators --

SELECT
    p.profile_id
FROM
    personal_profiles AS p
    INNER JOIN company_pages AS c
    ON p.employer_id = c.company_id
WHERE
    p.followers > c.followers
ORDER BY
    p.profile_id ASC;
    
    
    
    
    
    -- photoshop revenue analysis --

SELECT 
    customer_id,
    SUM(revenue) AS revenue
FROM
    adobe_transactions
WHERE
    product != 'Photoshop' AND
    customer_id IN (SELECT DISTINCT customer_id FROM adobe_transactions WHERE product = 'Photoshop')
GROUP BY
    customer_id;
    
    
    
    
    
    -- data science skills --

SELECT
    candidate_id
FROM
    candidates
GROUP BY
    candidate_id
HAVING
    SUM(
        (CASE WHEN skill = 'Python' THEN 1 ELSE 0 END) +
        (CASE WHEN skill = 'Tableau' THEN 1 ELSE 0 END) +
        (CASE WHEN skill = 'PostgreSQL' THEN 1 ELSE 0 END)
    ) = 3
ORDER BY
    candidate_id ASC;
    
    
    
    
    
    -- histogram of users and purchases --

WITH latest_transactions AS
(
    SELECT
        transaction_date,
        user_id,
        product_id,
        DENSE_RANK() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) AS latest_purchase
    FROM 
        user_transactions
)

SELECT
    transaction_date,
    COUNT(DISTINCT user_id) AS number_of_users,
    SUM(latest_purchase) AS number_of_products
FROM
    latest_transactions
WHERE
    latest_purchase = 1
GROUP BY
    transaction_date
ORDER BY
    transaction_date;
    
    
    
    
    
    -- subject matter experts --

SELECT 
    employee_id
FROM 
    employee_expertise
GROUP BY
    employee_id
HAVING
    (COUNT(DISTINCT domain) = 2 AND SUM(years_of_experience) >= 12) OR
    (COUNT(DISTINCT domain) = 1 AND SUM(years_of_experience) >= 8);
    
    
    
    
    -- final account balance --

SELECT
    account_id,
    SUM(
        CASE
            WHEN transaction_type = 'Deposit' THEN amount
            ELSE -amount
        END
    ) AS final_balance
FROM
    transactions
GROUP BY
    account_id;
    
    
    
    
    -- compensation outliers --

WITH employee_status AS
(
    SELECT 
        e1.employee_id,
        e1.salary,
        e1.title,
        CASE
            WHEN salary > 2 * (SELECT AVG(e2.salary) FROM employee_pay AS e2 WHERE e1.title = e2.title) THEN 'Overpaid'
            WHEN salary < 0.5 * (SELECT AVG(e2.salary) FROM employee_pay AS e2 WHERE e1.title = e2.title) THEN 'Underpaid'
            ELSE 'Near Average'
        END AS status
    FROM 
        employee_pay AS e1
)

SELECT
    employee_id,
    salary,
    status
FROM
    employee_status
WHERE
    status IN ('Underpaid', 'Overpaid');
    
    
    
    
-- average review ratings --

SELECT
    DATE_PART('month', submit_date) AS mth,
    product_id AS product,
    ROUND(AVG(stars), 2) AS avg_stars
FROM
    reviews
GROUP BY
    DATE_PART('month', submit_date),
    product_id
ORDER BY
    mth ASC,
    product ASC;
    
    
    
    
-- tesla unfinished parts --

SELECT DISTINCT
    part
FROM
    parts_assembly
WHERE
    finish_date IS NULL;
    
    
    
-- unique money transfer relationship --

WITH two_way_rel AS (
    SELECT 
        p1.payer_id AS payer,
        p1.recipient_id AS recipient
    FROM payments p1
    INNER JOIN payments p2
        ON p1.payer_id = p2.recipient_id
        AND p1.recipient_id = p2.payer_id
)

SELECT 
    COUNT(*) / 2 AS unique_relationships
FROM two_way_rel;


-- ad campaign roas --

SELECT
    advertiser_id,
    ROUND(
        SUM(CAST(revenue AS DECIMAL(10,2))) / 
        SUM(CAST(spend AS DECIMAL(10,2))), 
        2
    ) AS ROAS
FROM ad_campaigns
GROUP BY advertiser_id
ORDER BY advertiser_id;



-- second day confirmation --

SELECT DISTINCT
    e.user_id
FROM
    emails AS e
    INNER JOIN texts AS t
    ON e.email_id = t.email_id
WHERE
    t.signup_action = 'Confirmed' AND
    DATE_PART('day', t.action_date - e.signup_date) = 1;
    
    
    
-- apple pay volume --

SELECT
    merchant_id,
    SUM(
        CASE
        WHEN LOWER(payment_method) = 'apple pay' THEN transaction_amount
        ELSE 0
        END
    ) AS volume
FROM
    transactions
GROUP BY
    merchant_id
ORDER BY
    volume DESC;
    
    
    
-- average deal size --

SELECT
    ROUND(AVG(yearly_seat_cost * num_seats), 2) AS average_deal_size
FROM
    contracts;
    
    
    
    
    
    -- sending vs. operning snaps --

WITH age_group_activities AS
(
    SELECT
        a.activity_type,
        a.time_spent,
        ab.age_bucket
    FROM
        activities AS a
        INNER JOIN age_breakdown AS ab
        ON a.user_id = ab.user_id
    WHERE
        a.activity_type IN ('send', 'open')
),

open_send_sums AS
(
    SELECT
        age_bucket,
        SUM(CASE WHEN activity_type = 'open' THEN time_spent ELSE 0 END) AS open_sum,
        SUM(CASE WHEN activity_type = 'send' THEN time_spent ELSE 0 END) AS send_sum,
        SUM(time_spent) AS total_sum
    FROM
        age_group_activities
    GROUP BY
        age_bucket
)

SELECT
    age_bucket,
    ROUND((send_sum / total_sum) * 100, 2) AS send_perc,
    ROUND((open_sum / total_sum) * 100, 2) AS open_perc
FROM
    open_send_sums;
    
    
    
    
    -- tweets rolling average --

WITH tweet_posts AS
(
    SELECT
        user_id,
        tweet_date,
        COUNT(tweet_id) AS tweet_count
    FROM
        tweets
    GROUP BY
        user_id,
        tweet_date
)

SELECT
    user_id,
    tweet_date,
    ROUND(
        AVG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),
        2
    ) AS rolling_avg_3days
FROM
    tweet_posts;
    
    
    
    
    -- odd and even measurements --

WITH odd_even_measurements AS
(
    SELECT
        measurement_id,
        measurement_value,
        measurement_time,
        DATE(measurement_time) AS measurement_day,
        DENSE_RANK() OVER(PARTITION BY DATE(measurement_time) ORDER BY measurement_time ASC) AS measurment_number
    FROM
        measurements
)

SELECT
    measurement_day,
    SUM(CASE WHEN measurment_number IN (1, 3, 5) THEN measurement_value ELSE 0 END) AS odd_sum,
    SUM(CASE WHEN measurment_number IN (2, 4, 6) THEN measurement_value ELSE 0 END) AS even_sum
FROM
    odd_even_measurements
GROUP BY
    measurement_day;
    
    
    
    -- frequently purchased pairs --

WITH product_transactions AS
(
    SELECT
        t.transaction_id,
        t.product_id,
        p.product_name
    FROM
        transactions AS t
        INNER JOIN products AS p
        ON t.product_id = p.product_id
)

SELECT
    p1.product_name AS product1,
    p2.product_name AS product2,
    COUNT(*) AS combo_num
FROM
    product_transactions AS p1
    INNER JOIN product_transactions AS p2
    ON p1.transaction_id = p2.transaction_id AND p1.product_id > p2.product_id
GROUP BY
    p1.product_name,
    p2.product_name
ORDER BY
    combo_num DESC
LIMIT 3;



-- highest grossing items --

WITH top_sales AS
(
    SELECT
        category,
        product,
        SUM(spend) AS total_spend
    FROM
        product_spend
    WHERE
        DATE_PART('year', transaction_date) = 2022
    GROUP BY
        category,
        product
),

top_sales_ranking AS
(
    SELECT
        category,
        product,
        total_spend,
        DENSE_RANK() OVER(PARTITION BY category ORDER BY total_spend DESC) AS product_rank
    FROM
        top_sales
)

SELECT
    category,
    product,
    total_spend
FROM
    top_sales_ranking
WHERE
    product_rank <= 2;
    
    
    
    -- first transactions --

WITH transaction_ranking AS
(
    SELECT
        user_id,
        spend,
        transaction_date,
        DENSE_RANK() OVER(PARTITION BY user_id ORDER BY transaction_date ASC) AS transaction_num
    FROM
        user_transactions
)

SELECT
    COUNT(DISTINCT user_id) AS users
FROM
    transaction_ranking
WHERE
	transaction_num = 1 AND spend >= 50;
    
    
    
-- linkedin power creators --

WITH power_creators AS
(
    SELECT
        pp.profile_id,
        pp.name AS person_name,
        pp.followers AS person_followers,
        cp.name AS company_name,
        cp.followers AS company_followers,
        (CASE WHEN pp.followers > cp.followers THEN 1 ELSE 0 END) AS power_creator_flag
    FROM
        employee_company AS ec
        INNER JOIN personal_profiles AS pp
        ON ec.personal_profile_id = pp.profile_id
        INNER JOIN company_pages AS cp
        ON ec.company_id = cp.company_id
)

SELECT
    profile_id
FROM
    power_creators
GROUP BY
    profile_id
HAVING
    MIN(power_creator_flag) = 1
ORDER BY
    profile_id;
    
    
    

-- top 5 artists --

WITH artist_top10_appearance AS
(
    SELECT
        a.artist_name,
        COUNT(a.artist_name) AS appearance
    FROM
        global_song_rank AS gsr
        INNER JOIN songs AS s
        ON gsr.song_id = s.song_id
        INNER JOIN artists AS a
        ON s.artist_id = a.artist_id
    WHERE
        gsr.rank <= 10
    GROUP BY
        a.artist_name
),

artist_ranking AS
(
    SELECT
        artist_name,
        appearance,
        DENSE_RANK() OVER(ORDER BY appearance DESC) AS artist_rank
    FROM
        artist_top10_appearance
)

SELECT
    artist_name,
    artist_rank
FROM
    artist_ranking
WHERE
    artist_rank <= 5;
    
    
    


-- signup confirmation rate --

WITH signup_info AS (
    SELECT
        e.email_id,
        e.user_id,
        t.signup_action
    FROM emails e
    LEFT JOIN texts t
        ON e.email_id = t.email_id
)

SELECT
    ROUND(
        (SELECT COUNT(DISTINCT email_id)
         FROM signup_info
         WHERE signup_action = 'Confirmed') 
        /
        COUNT(DISTINCT email_id),
    2) AS confirm_rate
FROM signup_info;



-- consulting bench time --

WITH consulting_days_tbl AS
(
    SELECT
        s.employee_id,
        (ce.end_date - ce.start_date) + 1 AS non_bench_days
    FROM
        staffing AS s
        INNER JOIN consulting_engagements AS ce
        ON s.job_id = ce.job_id
    WHERE
        s.is_consultant = 'true'
)

SELECT
    employee_id,
    365 - SUM(non_bench_days) AS bench_days
FROM
    consulting_days_tbl
GROUP BY
    employee_id;
    
    
    
    -- spotify listening history --

WITH total_plays AS
(
    SELECT
        user_id,
        song_id,
        song_plays
    FROM
        songs_history
    
    UNION ALL
        
    SELECT
        user_id,
        song_id,
        COUNT(song_id)
    FROM
        songs_weekly
    WHERE
        DATE(listen_time) <= '2022-08-04'
    GROUP BY
        user_id,
        song_id
)

SELECT 
    user_id,
    song_id,
    SUM(song_plays) AS song_plays
FROM 
    total_plays
GROUP BY
    user_id,
    song_id
ORDER BY
    song_plays DESC;
    
    
    
    
    -- fill missing product --

WITH grouped_products AS
(
    SELECT
        product_id,
        category,
        name,
        COUNT(category) OVER (ORDER BY product_id) AS category_group
    FROM products
)

SELECT
    product_id,
    CASE
        WHEN category IS NULL THEN FIRST_VALUE(category) OVER (PARTITION BY category_group)
        ELSE category
    END AS category,
    name
FROM
    grouped_products;
    
    
    -- user session activity --

WITH tweeter_sessions AS
(
    SELECT
        user_id,
        session_type,
        SUM(duration) AS total_duration
    FROM 
        sessions
    WHERE
        start_date BETWEEN '2022-01-01' AND '2022-02-01'
    GROUP BY
        user_id,
        session_type
)

SELECT
    user_id,
    session_type,
    DENSE_RANK() OVER(PARTITION BY session_type ORDER BY total_duration DESC) AS ranking
FROM
    tweeter_sessions;
    
    
    
    
    -- invalid search results --

WITH search_details AS
(
    SELECT
        country,
        SUM(num_search) AS total_search,
        SUM(num_search * (invalid_result_pct/100)) AS invalid_searches
    FROM
        search_category
    WHERE
        num_search IS NOT NULL AND invalid_result_pct IS NOT NULL
    GROUP BY
        country
)

SELECT 
    country, 
    total_search, 
    ROUND(invalid_searches/total_search * 100.0,2) invalid_result_pct
FROM 
    search_details;
    
    
    
    -- top rated businesses --

SELECT
    SUM(CASE 
            WHEN review_stars IN (4, 5) 
            THEN 1 
            ELSE 0 
        END) AS business_num,
    ROUND(
        100 *
        SUM(CASE 
                WHEN review_stars IN (4, 5) 
                THEN 1 
                ELSE 0 
            END) 
        / COUNT(business_id),
    2) AS top_business_pct
FROM reviews;



-- same week purchases --

WITH user_count_tbl AS (
    SELECT
        COUNT(DISTINCT up.user_id) AS total_purchase_users,
        COUNT(DISTINCT s.user_id) AS total_signup_users
    FROM signups s
    LEFT JOIN user_purchases up
        ON s.user_id = up.user_id
    WHERE 
        up.purchase_date IS NULL
        OR up.purchase_date BETWEEN s.signup_date 
        AND DATE_ADD(s.signup_date, INTERVAL 1 WEEK)
)

SELECT
    ROUND(
        100 * (total_purchase_users / total_signup_users),
    2) AS single_purchase_pct
FROM user_count_tbl;



-- active user retention --

SELECT
    DATE_PART('month', event_date) AS month,
    COUNT(DISTINCT user_id) AS monthly_active_users
FROM
    user_actions
WHERE
    user_id IN (SELECT DISTINCT user_id FROM user_actions WHERE DATE_PART('month', event_date) = 6) AND
    DATE_PART('month', event_date) = 7 AND
    event_type IN ('sign-in', 'like', 'comment')
GROUP BY
    DATE_PART('month', event_date);
    
    
    
    -- year on year growth rate --

WITH user_spending AS
(
    SELECT
        DATE_PART('year', transaction_date) AS year,
        product_id,
        spend AS curr_year_spend,
        LAG(spend) OVER(PARTITION BY product_id ORDER BY transaction_date ASC) AS prev_year_spend
    FROM 
        user_transactions
)

SELECT
    year,
    product_id,
    curr_year_spend,
    prev_year_spend,
    CASE
        WHEN prev_year_spend IS NULL THEN NULL
        ELSE 
        ROUND(
            ((curr_year_spend / prev_year_spend)-1) * 100,
            2
        )
    END AS yoy_rate
FROM
    user_spending;
    
    
    
    
    -- user shopping sprees --

WITH shopping_spree_transactions AS (
    SELECT
        user_id,
        transaction_date,
        CASE
            WHEN
                LEAD(transaction_date, 1) 
                    OVER (PARTITION BY user_id ORDER BY transaction_date) 
                = DATE_ADD(transaction_date, INTERVAL 1 DAY)
            AND
                LEAD(transaction_date, 2) 
                    OVER (PARTITION BY user_id ORDER BY transaction_date) 
                = DATE_ADD(transaction_date, INTERVAL 2 DAY)
            THEN 1
            ELSE 0
        END AS shopping_spree_flag
    FROM transactions
)

SELECT DISTINCT
    user_id
FROM shopping_spree_transactions
WHERE shopping_spree_flag = 1
ORDER BY user_id;



-- monthly merchant balance --

WITH signed_transactions AS
(
    SELECT
        DATE(transaction_date) AS transaction_date,
        CASE
        WHEN type = 'deposit' THEN amount
        ELSE -amount
        END AS amount
    FROM
        transactions
),

daily_balance_details AS
(
    SELECT
        transaction_date AS transaction_day,
        DATE_PART('month', transaction_date) AS month,
        SUM(amount) AS daily_balance
    FROM
        signed_transactions
    GROUP BY
        transaction_date,
        DATE_PART('month', transaction_date)
)

SELECT
    transaction_day,
    SUM(daily_balance) OVER (PARTITION BY month ORDER BY transaction_day ASC) AS balance
FROM 
    daily_balance_details
ORDER BY
    transaction_day ASC;
    
    
    
    WITH order_details AS (
    SELECT
        o.order_id,
        o.status,
        o.order_timestamp,
        c.signup_timestamp
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE 
        YEAR(c.signup_timestamp) = 2022
        AND MONTH(c.signup_timestamp) = 6
)

SELECT
    ROUND(
        100 *
        SUM(CASE 
                WHEN status = 'completed successfully' 
                THEN 0 
                ELSE 1 
            END)
        / COUNT(DISTINCT order_id),
    2) AS bad_experience_pct
FROM order_details
WHERE 
    DATE(order_timestamp) 
    <= DATE_ADD(DATE(signup_timestamp), INTERVAL 14 DAY);
    
    
    
    
    
    