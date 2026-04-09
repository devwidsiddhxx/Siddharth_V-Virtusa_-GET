"""
farecalc.py
CityCab – Fare Calculation System
"""

VEHICLE_RATES    = {"Economy": 10, "Premium": 18, "SUV": 25}
SURGE_MULTIPLIER = 1.5
SURGE_START_HOUR = 17
SURGE_END_HOUR   = 20


def calculate_fare(km, vehicle_type, hour):
    """
    Calculate the ride fare based on distance, vehicle type, and hour.

    Args:
        km           (float): Distance in kilometres.
        vehicle_type (str)  : One of 'Economy', 'Premium', or 'SUV'.
        hour         (int)  : Hour of travel in 24-hour format (0-23).

    Returns:
        dict: base_fare, surge_applied, multiplier, final_fare.

    Raises:
        ValueError: If vehicle_type is not available.
    """
    if vehicle_type not in VEHICLE_RATES:
        available = ", ".join(VEHICLE_RATES.keys())
        raise ValueError(
            f"Service not available for '{vehicle_type}'. "
            f"Choose from: {available}."
        )

    base_fare    = km * VEHICLE_RATES[vehicle_type]
    surge_active = SURGE_START_HOUR <= hour <= SURGE_END_HOUR
    multiplier   = SURGE_MULTIPLIER if surge_active else 1.0
    final_fare   = base_fare * multiplier

    return {
        "base_fare":     base_fare,
        "surge_applied": surge_active,
        "multiplier":    multiplier,
        "final_fare":    final_fare,
    }

#printing statements
def print_receipt(km, vehicle_type, hour, result):
    """Print a formatted price receipt to the console."""
    rate = VEHICLE_RATES[vehicle_type]

    print("\n" + "-" * 38)
    print(f"  CityCab - Price Receipt")
    print("-" * 38)
    print(f"  Vehicle   : {vehicle_type}")
    print(f"  Distance  : {km:.1f} km")
    print(f"  Rate      : Rs.{rate} per km")
    print(f"  Departure : {hour:02d}:00 hrs")
    print("-" * 38)
    print(f"  Base Fare : Rs.{result['base_fare']:.2f}")

    if result["surge_applied"]:
        print(f"  Surge     : {result['multiplier']}x  (Peak 17:00 - 20:00)")
    else:
        print(f"  Surge     : None")

    print("-" * 38)
    print(f"  TOTAL     : Rs.{result['final_fare']:.2f}")
    print("-" * 38 + "\n")


def get_float_input(prompt):
    """Prompt the user until a valid positive float is entered."""
    while True:
        try:
            value = float(input(prompt))
            if value > 0:
                return value
            print("  Please enter a value greater than zero.")
        except ValueError:
            print("  Invalid input. Please enter a number.")


def get_int_input(prompt, lo, hi):
    """Prompt the user until a valid integer within [lo, hi] is entered."""
    while True:
        try:
            value = int(input(prompt))
            if lo <= value <= hi:
                return value
            print(f"  Please enter a number between {lo} and {hi}.")
        except ValueError:
            print("  Invalid input. Please enter a whole number.")


def main():
    print("\n  CityCab - Fare Calculator")
    print("  " + "-" * 28)

    km           = get_float_input("  Distance (km)          : ")
    hour         = get_int_input("  Hour of travel (0-23)  : ", 0, 23)

    print(f"  Vehicle types          : {', '.join(VEHICLE_RATES.keys())}")
    raw          = input("  Select vehicle         : ").strip()
    vehicle_type = next((k for k in VEHICLE_RATES if k.lower() == raw.lower()), raw)

    try:
        result = calculate_fare(km, vehicle_type, hour)
        print_receipt(km, vehicle_type, hour, result)
    except ValueError as e:
        print(f"\n  Error: {e}\n")


if __name__ == "__main__":
    main()
