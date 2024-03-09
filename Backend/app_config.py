from flask import Flask, request, jsonify
import pyodbc
from Connection import DBConnection

app = Flask(__name__)

def execute_stored_procedure(config_name):
    try:
        # Create an instance of the DBConnection class
        db_connection = DBConnection()

        # Establish a connection using the DBConnection instance
        connection = db_connection.get_connection()

        # Create a cursor
        cursor = connection.cursor()

        try:
            cursor.execute(f"EXEC [Mobile].[sp_app_config_getby_configname] @config_name=?", config_name)
            result = cursor.fetchone()

            if result:
                # print(f"Config value for {config_name}: {result.config_value}")
                return result.config_value
            else:
                # print(f"Config value for {config_name} not found.")
                return None
        finally:
            cursor.close()

    except pyodbc.Error as e:
        print(f"PyODBC Error during stored procedure execution: {e}")
        # Handle the error as needed

    except Exception as e:
        print(f"Error during stored procedure execution: {e}")
        # Handle the error as needed

    finally:
        if connection:
            connection.close()

def send_email(to, subject, body):
    print(f"Sending email to {to} with subject: {subject}")
    print(f"Email body:\n{body}")

def fetch_email_subject():
    return execute_stored_procedure('RegisterEmailSubject') or "Default Email Subject"

def fetch_email_body():
    return execute_stored_procedure('RegisterEmail') or "Default Email Body"
