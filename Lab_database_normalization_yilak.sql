
-- I propose a database normalization to omit redunduncy by merging "catagory", and "film_catagory" and add "film_text" to give a comprhensive table. 

-- Drop existing tables if they exist
DROP TABLE IF EXISTS film_text;
DROP TABLE IF EXISTS film_category;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS country;

-- Create the country table
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(50) NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create the city table
CREATE TABLE city (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    country_id INT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Create the address table
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(100) NOT NULL,
    address2 VARCHAR(100),
    district VARCHAR(50),
    city_id INT,
    postal_code VARCHAR(10),
    phone VARCHAR(20),
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

-- Create the combined film_category table
CREATE TABLE film_category (
    film_id SMALLINT UNSIGNED NOT NULL,
    category VARCHAR(25) NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (film_id, category),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

-- Create the film_text table
CREATE TABLE film_text (
    film_id SMALLINT UNSIGNED NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    PRIMARY KEY (film_id),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

-- Insert sample data
-- Insert data into the country table
INSERT INTO country (country) VALUES ('USA');
INSERT INTO country (country) VALUES ('Canada');

-- Insert data into the city table
INSERT INTO city (city, country_id) VALUES ('New York', 1);
INSERT INTO city (city, country_id) VALUES ('Los Angeles', 1);
INSERT INTO city (city, country_id) VALUES ('Toronto', 2);

-- Insert data into the address table
INSERT INTO address (address, address2, district, city_id, postal_code, phone)
VALUES ('123 Main St', '', 'Manhattan', 1, '10001', '555-1234');
INSERT INTO address (address, address2, district, city_id, postal_code, phone)
VALUES ('456 Maple Ave', 'Apt 2', 'Downtown', 3, 'M5H 2N2', '555-5678');

-- Migrate data to the new film_category table
INSERT INTO film_category (film_id, category, last_update)
SELECT fc.film_id, c.name, fc.last_update
FROM sakila.film_category AS fc
JOIN sakila.category AS c ON fc.category_id = c.category_id;

-- Migrate data to the new film_text table
INSERT INTO film_text (film_id, title, description)
SELECT film_id, title, description
FROM sakila.film;
