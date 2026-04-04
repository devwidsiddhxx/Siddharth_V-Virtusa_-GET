# Digital Library SQL Project

### Name : Siddharth V - SRMIST,Chennai - Siddx.1184@gmail.com

## Overview

This project implements a simple relational database for managing a digital library system. It tracks books, students, and issued books, and includes queries to analyze overdue records and borrowing trends.

## Tables

* **Books** – Stores book details (title, author, category)
* **Students** – Stores student information
* **IssuedBooks** – Tracks which student borrowed which book and when

## Features

* Identify books that are overdue (not returned within 14 days)
* Find the most borrowed book categories
* Remove inactive student records (no activity for 3+ years)
* Calculate a simple fine for overdue books

## How to Run

1. Open SQL Server Management Studio (SSMS)
2. Create a new query
3. Copy and run the SQL script provided
4. View results in the output grid

## Notes

* The script includes sample data for testing
* Fine is calculated as ₹5 per day after 14 days
* Designed using basic SQL concepts like JOIN, GROUP BY, and DATEDIFF
