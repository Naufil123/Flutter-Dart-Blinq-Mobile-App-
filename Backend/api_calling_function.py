# from flask import Flask, request, jsonify
# from flask_cors import CORS
#
# from Login.login import execute_login_stored_procedure
# from auth.Register.Register import Register
# from Appconfig.app_config import  send_email, fetch_email_subject, fetch_email_body
# from Appconfig.system_log import log_to_store_procedure
# from auth.Register.user_audit_insert import user_audit_insert
#
# app = Flask(__name__)
# CORS(app)
#
#
# @app.route('/register', methods=['POST'])
# def register_and_email():
#     try:
#         data = request.get_json()
#         email = data.get('email')
#         pin = data.get('pin')
#         mobile_number = data.get('mobile_number')
#         full_name = data.get('full_name')
#
#         register_instance = Register(
#             server='20.233.15.82,2522',
#             database='BlinqMobileDB_Dev',
#             username='mobiledbdevuser',
#             password='eP7R4bEQ8oRsK3hK3o'
#         )
#
#         # Perform registration
#         registration_result = register_instance.register_consumer(
#             email, pin, mobile_number, full_name)
#
#         # Fetch email subject and body
#         email_subject = fetch_email_subject()
#         email_body = fetch_email_body()
#
#         # Replace placeholders in the email body with user-specific values
#         email_body = email_body.replace("[FullName]", full_name)
#         email_body = email_body.replace("[Email]", email)
#         email_body = email_body.replace("[Username]", email)
#
#         # Now 'email_body' contains the personalized email content
#
#         # Send the email using your email sending mechanism
#         send_email(email, email_subject, email_body)
#
#         return jsonify({"status": "success", "message": "Registration successful. Email sent.", "registration_result": registration_result})
#     except Exception as e:
#         print(f"Error: {e}")
#         return jsonify({"status": "error", "message": "Internal server error"}), 500
#
#
#
#
#
# @app.route('/fetch-email-subject', methods=['GET'])
# def fetch_email_subject_route():
#     email_subject = fetch_email_subject()
#
#     return jsonify({"email_subject": email_subject})
#
#
#
#
#
# @app.route('/fetch-email-body', methods=['GET'])
# def fetch_email_body_route():
#     email_body = fetch_email_body()
#     return jsonify({"email_body": email_body})
#
#
#
#
#
# @app.route('/user_audit_insert', methods=['POST'])
# def call_user_audit_insert():
#     try:
#         data = request.get_json()
#         user_id = data.get('user_id')
#         section = data.get('section')
#         title = data.get('title')
#         description = data.get('description')
#
#         user_audit_insert(user_id, section, title, description)
#
#         return jsonify({'message': 'inserted successfully!'}), 200
#
#     except Exception as e:
#         return jsonify({'error': f'Error logging: {e}'}), 500
#
#
# @app.route('/get_user_login_by_email', methods=['POST'])
# def get_user_login():
#     if request.method == 'POST':
#         # Get email and pin parameters from Flutter app
#         data = request.get_json()
#         email_param = data.get('email')
#         pin_param = data.get('pin')
#
#         # Call the function
#         result, stored_hash_pin = execute_login_stored_procedure(email_param)
#
#         if not result:
#             return jsonify({"error": "User not found"})
#
#         salt = result[0].get('salt')  # Adjust 'salt' based on the actual column name in your result
#
#         # Create an instance of the Register class
#         register_instance = Register(server='20.233.15.82,2522', database='BlinqMobileDB_Dev', username='mobiledbdevuser', password='eP7R4bEQ8oRsK3hK3o')
#
#         # Call the hash_pin_with_salt method from the Register class
#         hashed_pin = register_instance.hash_pin_with_salt(pin_param, salt)
#
#         # Check if both 'hashed_pin' and 'stored_hashed_pin' are defined
#         if hashed_pin is not None and stored_hash_pin is not None and hashed_pin == stored_hash_pin:
#             # Hashed pins match, login successful
#             return jsonify({"message": "Login successful"})
#         else:
#             # Hashed pins do not match, login failed
#             return jsonify({"error": "Invalid email or pin"})
#
# if __name__ == '__main__':
#     app.run(host='192.168.100.149', port=84)
