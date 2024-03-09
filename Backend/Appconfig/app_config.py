from flask import Flask
import pyodbc
from Appconfig.Connection import DBConnection

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
def fetch_email_subject(request_source):
    if request_source == 'register_and_email':
        return execute_stored_procedure('RegisterEmailSubject') or "Default Email Subject"
    elif request_source == 'generate_and_store_otp':
        return execute_stored_procedure('PINChangeCodeEmailSubject') or "Default Email Subject"
    else:
        # Handle other cases or return a default value
        return "Default Email Subject"

def fetch_email_body(request_source_body):
    if request_source_body == 'register_and_email':
        return execute_stored_procedure('RegisterEmail') or "Default Email Body"
    elif request_source_body == 'generate_and_store_otp':
        return execute_stored_procedure('PINChangeCodeEmail') or "Default Email Body"
    else:
        # Handle other cases or return a default value
        return "Default Email Body"

def send_sms(mobile, body):
    print(f"Sending SmS to {mobile} with subject: {body}")

def fetch_sms():
    return execute_stored_procedure('PINChangeSMS') or "Default SMS"