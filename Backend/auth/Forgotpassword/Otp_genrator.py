import random
import time
import pyodbc

from Appconfig.Connection import DBConnection


# Generate a 4-digit OTP
def generate_otp():
    otp = ''.join(str(random.randint(0, 9)) for _ in range(6))
    return otp

# Store OTP in the database
def store_otp_in_database(email, mobile, code):
    # Establish a database connection
    db_connection = DBConnection()


    connection = db_connection.get_connection()
    # Create a cursor
    cursor = connection.cursor()

    try:
        # Execute the stored procedure
        cursor.execute("{CALL Mobile.sp_user_code_verification_insert (?, ?, ?)}", email, mobile, code)
        connection.commit()
        print("OTP stored successfully in the database.")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        # Close the cursor and connection
        cursor.close()
        connection.close()
