# import time
from Appconfig.Connection import DBConnection
def execute_stored_procedure_get_code(code, search_by):
    cursor = None
    connection = None
    try:
        # Set up the connection parameters
        db_connection = DBConnection()

        # Establish a connection using the DBConnection instance
        connection = db_connection.get_connection()

        # Create a cursor
        cursor = connection.cursor()

        # Execute the first stored procedure
        cursor.execute("{CALL Mobile.sp_user_code_verification_getcode(?, ?)}", code, search_by)

        # Fetch the results
        result = cursor.fetchone()

        # Process the results
        if result:
            id, code, email, mobile, start_date, is_code_matched = result
            output = f"ID: {id}, Code: {code}, Email: {email}, Mobile: {mobile}, Start Date: {start_date}, Is Code Matched: {is_code_matched}"
            print(output)

            # Execute the second stored procedure after processing the result
            cursor.execute("EXEC Mobile.sp_user_code_verification_verifycode ?, ?", code, search_by)
            result_verify = cursor.fetchone()

            # Process the result of the second stored procedure
            if result_verify:
                status, message = result_verify
                output += f"\nStatus: {status}, Message: {message}"
                response_data = {'status': status, 'message': message}
            else:
                output += "\nNo result returned for the verification."
                response_data = {'status': 'error', 'message': 'No result returned for the verification.'}

        else:
            output = "No results found"
            response_data = {'status': 'error', 'message': 'No result returned from the first stored procedure.'}

        return response_data

    except Exception as e:
        return {'status': 'error', 'message': f"An error occurred: {str(e)}"}

    finally:
        # Close the cursor and connection
        if cursor:
            cursor.close()
        if connection:
            connection.close()

def convert_to_serializable(obj):
    if isinstance(obj, set):
        return list(obj)
    elif isinstance(obj, dict):
        return {key: convert_to_serializable(value) for key, value in obj.items()}
    elif isinstance(obj, list):
        return [convert_to_serializable(item) for item in obj]
    elif isinstance(obj, tuple):
        return tuple(convert_to_serializable(item) for item in obj)
    else:
        return obj
