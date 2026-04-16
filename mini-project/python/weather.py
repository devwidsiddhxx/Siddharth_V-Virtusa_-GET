# ==========================
# Weather Data Analyzer & Forecast Dashboard
# ==========================

import requests
import sqlite3
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime
from sklearn.linear_model import LinearRegression
import numpy as np

API_KEY = "YOUR_API_KEY"
CITY = "Chennai"

# --------------------------
# Database Setup
# --------------------------
conn = sqlite3.connect("weather.db")
cursor = conn.cursor()

cursor.execute("""
CREATE TABLE IF NOT EXISTS weather (
    date TEXT,
    temperature REAL,
    humidity REAL
)
""")

# --------------------------
# Fetch Weather Data
# --------------------------
def fetch_weather():
    url = f"http://api.openweathermap.org/data/2.5/weather?q={CITY}&appid={API_KEY}&units=metric"
    response = requests.get(url).json()

    temp = response['main']['temp']
    humidity = response['main']['humidity']
    date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    cursor.execute("INSERT INTO weather VALUES (?, ?, ?)", (date, temp, humidity))
    conn.commit()

    print(f"Saved Data -> Temp: {temp}°C, Humidity: {humidity}%")

# --------------------------
# Load Data
# --------------------------
def load_data():
    df = pd.read_sql_query("SELECT * FROM weather", conn)
    df['date'] = pd.to_datetime(df['date'])
    return df

# --------------------------
# Visualization
# --------------------------
def plot_data(df):
    plt.figure()
    plt.plot(df['date'], df['temperature'])
    plt.title("Temperature Trend")
    plt.xlabel("Date")
    plt.ylabel("Temperature (°C)")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.show()

# --------------------------
# Prediction
# --------------------------
def predict_temperature(df):
    df = df.copy()
    df['timestamp'] = df['date'].map(datetime.timestamp)

    X = np.array(df['timestamp']).reshape(-1, 1)
    y = df['temperature']

    model = LinearRegression()
    model.fit(X, y)

    future_time = datetime.now().timestamp() + 3600 * 24
    prediction = model.predict([[future_time]])

    print(f"Predicted Temperature for Tomorrow: {prediction[0]:.2f}°C")

# --------------------------
# CLI Menu
# --------------------------
def main():
    while True:
        print("\n1. Fetch Weather Data")
        print("2. Show Trends")
        print("3. Predict Temperature")
        print("4. Exit")

        choice = input("Enter choice: ")

        if choice == '1':
            fetch_weather()
        elif choice == '2':
            df = load_data()
            plot_data(df)
        elif choice == '3':
            df = load_data()
            predict_temperature(df)
        elif choice == '4':
            break
        else:
            print("Invalid choice")

if __name__ == "__main__":
    main()
