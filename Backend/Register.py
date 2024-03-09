import hashlib
import secrets
import pyodbc

from user_audit_insert import user_audit_insert


class Register:
    def __init__(self, server, database, username, password):
        self.server = server
        self.database = database
        self.username = username
        self.password = password

    def generate_salt(self):
        return secrets.randbelow(1000000)

    def hash_pin_with_salt(self, pin, salt):
        combined_data = f"{pin}{salt}".encode('utf-8')
        hashed_data = hashlib.sha256(combined_data).hexdigest()
        return hashed_data

    def register_consumer(self, email, pin, mobile_number, full_name):
        connection = None
        try:
            connection = pyodbc.connect(
                f"DRIVER={{SQL Server}};SERVER={self.server};DATABASE={self.database};UID={self.username};PWD={self.password}"
            )
            cursor = connection.cursor()

            salt = self.generate_salt()
            hashed_pin = self.hash_pin_with_salt(pin, salt)

            cursor.execute(
                "EXEC sp_user_insert @email=?, @saltkey=?, @hash_pin=?, @mobile=?, @full_name=?",
                (email, salt, hashed_pin, mobile_number, full_name)
            )

            # Fetch the result set after the execution of the stored procedure
            # Assuming the following code is inside your register_consumer method

            result_set = cursor.fetchone()
            user_id = result_set.user_id if hasattr(result_set, 'user_id') else None

            if user_id is not None:
                print(f"User ID: {user_id}")

                result = user_audit_insert(user_id, None, None, None)
                print(result)


            if result_set:
                # Assuming the result set has at least two columns
                result = {"status": result_set.status, "message": result_set.message}
                print(f"Number of rows affected: {cursor.rowcount}")
                print(f"Registration result: {result}")
                connection.commit()
            else:
                # Handle the case where no result set is returned
                print("No result set returned. Check the stored procedure.")
                result = {"status": "failure", "message": "Registration failed. No result set returned."}

            return result

        except pyodbc.Error as e:
            print(f"PyODBC Error during registration: {e}")
            return {"status": "failure", "message": f"Registration failed: {e}"}

        except Exception as e:
            print(f"Error during registration: {e}")
            return {"status": "failure", "message": f"Registration failed: {e}"}

        finally:
            if connection:
                connection.close()
