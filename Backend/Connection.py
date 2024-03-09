

import pyodbc

DB_CONFIG = {
    'server': '20.233.15.82,2522',
    'database': 'BlinqMobileDB_Dev',
    'username': 'mobiledbdevuser',
    'password': 'eP7R4bEQ8oRsK3hK3o'
}

class DBConnection:
    @staticmethod
    def get_connection():
        connection_string = (
            f"DRIVER={{SQL Server}};SERVER={DB_CONFIG['server']};"
            f"DATABASE={DB_CONFIG['database']};UID={DB_CONFIG['username']};PWD={DB_CONFIG['password']}"
        )
        return pyodbc.connect(connection_string)
