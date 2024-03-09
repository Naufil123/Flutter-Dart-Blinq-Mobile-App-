import pyodbc
from flask import Flask, request, jsonify
from flask_cors import CORS
from Appconfig.Connection import DBConnection
from auth.Register.Register import Register

app = Flask(__name__)
CORS(app)

def execute_login_stored_procedure(email_param):
    db_connection = DBConnection()
    connection = db_connection.get_connection()

    # Define a variable to store the hash pin
    stored_hash_pin = None

    with connection.cursor() as cursor:
        try:
            cursor.execute("{CALL Mobile.sp_user_getby_email (?)}", email_param)
            result = cursor.fetchall()

            # Check if cursor.description is available
            if cursor.description:
                # Get column names from the cursor description
                column_names = [column[0] for column in cursor.description]
            else:
                # Fallback: If cursor.description is None, use a default column naming
                column_names = [f'Column_{i + 1}' for i in range(len(result[0]))]

            # Process the result (you might want to convert it to a dictionary)
            rows = []
            for row in result:
                row_dict = dict(zip(column_names, row))
                rows.append(row_dict)

                # Print the row
                print("Hash Pin:", row_dict.get('hash_pin'))

                is_locked= row_dict.get('is_account_locked')
                stored_hash_pin = row_dict.get('hash_pin')

            return rows, stored_hash_pin,is_locked

        except pyodbc.Error as ex:
            # Return an error message or handle the error as needed
            return {"error": f"Error: {ex}"}


def call_sp_user_failed_login_attempt(email_param, pin_param):
    try:
        db_connection = DBConnection()
        connection = db_connection.get_connection()

        with connection.cursor() as cursor:
            cursor.execute("{CALL Mobile.sp_user_failed_login_attempt (?, ?)}", email_param, pin_param)
            # Fetch the result
            result = cursor.fetchone()

            if result:
                # Assuming the result has 'status' and 'message' fields
                status = result.status  # Access the 'status' column directly
                message = result.message  # Access the 'message' column directly

                if status and message:
                    print(f"Status: {status}, Message: {message}")
                else:
                    print("Invalid result format from stored procedure.")

        return result

    except Exception as e:
        # Print the error message
        print(f"Error: {str(e)}")
        return None

    finally:
        # Connection is closed here to ensure proper cleanup
        connection.close()

