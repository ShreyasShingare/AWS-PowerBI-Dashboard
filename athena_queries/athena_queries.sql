-- Overall No-Show Percentage:
SELECT
    ROUNT(
        SUM(CASE WHEN showed_up = 'FALSE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2
    ) AS no_show_rate_percent
FROM fact_appointments;

-- No-Show by Weekday:

SELECT day_of_week(d.date_value) AS weekday,
    SUM(CASE WHEN f.showed_up = 'FALSE' THEN 1 ELSE 0 END) AS no_shows,
    COUNT(*) AS total_appointments,
    ROUND (SUM(CASE WHEN f.showed_up = 'FALSE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS no_show_rate_percent
FROM fact_appointments f
JOIN dim_date d ON f.appointment_date_id = d.date_id
GROUP BY day_of_week(d.date_value)
ORDER BY weekday;

-- No-Show by Gender:

SELECT p.gender,
    SUM(CASE WHEN f.showed_up = 'FALSE' THEN 1 ELSE 0 END) AS no_shows,
    COUNT(*) AS total_appointments,
    ROUND (SUM(CASE WHEN f.showed_up = 'FALSE' THEN 1 ELSE 0 END) * 100.0/ COUNT(*), 2) AS no_show_rate_percent
FROM fact_appointments f
JOIN dim_patient p ON f.patient_id = p.patient_id
GROUP BY p.gender
ORDER BY p.gender;

-- Age Group Analysis:

SELECT
    CASE
        WHEN p.age < 18 THEN 'Child'
        WHEN p.age BETWEEN 18 AND 39 THEN 'Young Adult'
        WHEN p.age BETWEEN 40 AND 64 THEN 'Middle Age'
    ELSE 'Senior'
    END AS age group,
    SUM(CASE WHEN f.showed_up = 'FALSE' THEN 1 ELSE 0 END) AS no_shows,
    COUNT(*) AS total_appointments,
    ROUND(SUM(CASE WHEN f.showed_up = 'FALSE' THEN 1 ELSE 0 END) * 100.0/ COUNT(*), 2) AS no_show_rate_percent
FROM fact_appointments f
JOIN dim_patient p ON f.patient_id = p.patient_id
GROUP BY 1
ORDER BY 1;

-- No-Show by Neighbourhood:

SELECT n.neighbourhood_name,
    SUM(CASE WHEN f.showed_up = 'FALSE' THEN 1 ELSE 0 END) AS no_shows,
    COUNT(*) AS total_appointments,
    ROUND (SUM(CASE WHEN f.showed_up = 'FALSE' THEN 1 ELSE 0 END) * 100.0/ COUNT(*), 2) AS no_show_rate_percent
FROM fact_appointments f
JOIN dim_neighbourhood n ON f.neighbourhood_id = n.neighbourhood_id
GROUP BY neighbourhood_name
ORDER BY no_shows DESC;

-- Impact of SMS reminder:

SELECT h.sms_received,
    SUM(CASE WHEN f.showed_up = 'FALSE' THEN 1 ELSE 0 END) AS no_shows,
    COUNT(*) AS total_appointments,
    ROUND(SUM(CASE WHEN f.showed_up = 'FALSE' THEN 1 ELSE 0 END) * 100.0/ COUNT(*), 2) AS no_show_rate_percent
FROM fact_appointments f
JOIN dim_health_conditions h ON f.health_condition_id=h.health_condition_id
GROUP BY h.sms_received
ORDER BY h.sms_received;

-- No-Show by day of week:

SELECT day_of_week(d.date_value) AS weekday,
    COUNT(*) AS total_appointments,
    ROUND(SUM(CASE WHEN f.showed_up = 'FALSE' THEN 1 ELSE 0 END) * 100.0/ COUNT(*), 2) AS no_show_rate_percent
FROM fact_appointments f
JOIN dim_date d ON f.appointment_date_id = d.date_id
GROUP BY day_of_week(d.date_value)
ORDER BY weekday;

-- No-Show by medical condition:

SELECT
    SUM(CASE WHEN h.hipertension = 'TRUE' AND f.showed_up = 'FALSE' THEN 1 ELSE 0 END) AS hipertension_no_show,
    SUM(CASE WHEN h.diabetes = 'TRUE' AND f.showed_up = 'FALSE' THEN 1 ELSE 0 END) AS diabetes_no_show,
    SUM(CASE WHEN h.alcoholism = 'TRUE' AND f.showed_up = 'FALSE' THEN 1 ELSE 0 END) AS alcoholism_no_show,
    SUM(CASE WHEN h.handcap = 'TRUE' AND f.showed_up = 'FALSE' THEN 1 ELSE 0 END) AS handcap_no_show
FROM fact_appointments f
JOIN dim_health_conditions h ON f.health_condition_id = h.health_condition_id;
