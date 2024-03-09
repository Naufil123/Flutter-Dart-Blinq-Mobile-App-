import pyodbc
from Appconfig.Connection import DBConnection

def execute_sp_user_reset_pin(email, salt, entered_password_hash):
    try:
        # Create a DBConnection instance
        db_connection = DBConnection()

        # Establish a connection using the DBConnection instance
        connection = db_connection.get_connection()
        cursor = connection.cursor()

        # Call the stored procedure
        cursor.execute("EXEC Mobile.sp_user_reset_pin ?, ?, ?", email, salt, entered_password_hash)
        result = cursor.fetchone()

        # Commit the transaction
        connection.commit()

        return result  # This will contain the result of the stored procedure

    except Exception as e:
        print(f"Error: {e}")
        connection.rollback()
        return None

    finally:
        # Close the cursor and connection
        cursor.close()
        connection.close()
