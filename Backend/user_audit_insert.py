

import pyodbc
from Connection import DBConnection
stored_user_id = None


def user_audit_insert(user_id, section, title, description):
    global stored_user_id

    try:
        # Create an instance of the DBConnection class
        db_connection = DBConnection()

        # Establish a connection using the DBConnection instance
        connection = db_connection.get_connection()

        # Create a cursor
        cursor = connection.cursor()

        try:
            if user_id is None and stored_user_id is not None and section != None and title != None and description != None:
                stored_user_id, user_id = user_id, stored_user_id
            elif section == None and title == None and description == None:
                # Conditions are met, so skip the execution of the stored procedure
                return {"status": "success", "message": "Conditions not met, skipping stored procedure execution"}

            cursor.execute(
                "EXEC [Mobile].[sp_user_audit_insert] @user_id=?, @section=?, @title=?, @description=?",
                (user_id, section, title, description)
            )

            # Commit the transaction
            connection.commit()
            # Save the user_id globally
            stored_user_id = user_id

        finally:
            stored_user_id = user_id
            cursor.close()

    except pyodbc.Error as e:
        print(f"PyODBC Error during stored procedure execution: {e}")
        # Handle the error as needed
        return {"status": "failure", "message": f"Error during stored procedure execution: {e}"}

    except Exception as e:
        print(f"Error during stored procedure execution: {e}")
        # Handle the error as needed
        return {"status": "failure", "message": f"Error during stored procedure execution: {e}"}

    finally:
        if connection:
            connection.close()

    return {"status": "success", "message": "Stored procedure executed successfully"}
# def user_audit_insert(user_id, section, title, description):
#     try:
#         db_connection = DBConnection()
#         connection = db_connection.get_connection()
#         cursor = connection.cursor()
#         try:
#             a=user_id
#             print(a)
#             if user_id is not None or a is not None and section != "section_value" and title != "title_value" and description != "description_value":
#                 print(a)
#                 a,user_id=user_id,a
#                 cursor.execute(
#                     "EXEC [Mobile].[sp_user_audit_insert] @user_id=?, @section=?, @title=?, @description=?",
#                     (user_id, section, title, description)
#                 )
#
#             # Commit the transaction
#             connection.commit()
#
#         finally:
#             cursor.close()
#
#     except pyodbc.Error as e:
#         print(f"PyODBC Error during stored procedure execution: {e}")
#         # Handle the error as needed
#         return {"status": "failure", "message": f"Error during stored procedure execution: {e}"}
#
#     except Exception as e:
#         print(f"Error during stored procedure execution: {e}")
#         # Handle the error as needed
#         return {"status": "failure", "message": f"Error during stored procedure execution: {e}"}
#
#     finally:
#         if connection:
#             connection.close()
#
#     return {"status": "success", "message": "Stored procedure executed successfully"}
