
import traceback

from Appconfig.Connection import DBConnection


def log_to_store_procedure(section, severity, title, message, description, username):
    try:
        # Create an instance of the DBConnection class
        db_connection = DBConnection()

        # Establish a connection using the DBConnection instance
        connection = db_connection.get_connection()
        cursor = connection.cursor()
        # salt_for_reset_pin = register_instance.generate_salt()

        # Use '?' as placeholders for parameters in the SQL query
        cursor.execute("EXEC sp_system_logging_insert ?, ?, ?, ?, ?, ?",
                       (section, severity, title, message, description, username))

        # Commit the transaction
        connection.commit()
    except Exception as e:
        print(f"Error inserting log: {e}")
        traceback.print_exc()

    finally:
        # Close the cursor and connection
        cursor.close()
        connection.close()
