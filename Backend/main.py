from flask import Flask, request, jsonify
from flask_cors import CORS
from Appconfig.system_log import log_to_store_procedure
from auth.Forgotpassword.Otp_genrator import generate_otp, store_otp_in_database
from auth.Forgotpassword.Otp_verification import execute_stored_procedure_get_code
from auth.Forgotpassword.reset_pin import execute_sp_user_reset_pin
from auth.Login.login import execute_login_stored_procedure, call_sp_user_failed_login_attempt
from auth.Register.Register import Register
from Appconfig.app_config import send_email, fetch_email_subject, fetch_email_body, fetch_sms, send_sms
from Appconfig.user_audit_insert import user_audit_insert

app = Flask(__name__)
CORS(app)


@app.route('/register', methods=['POST'])
def register_and_email():
    try:
        data = request.get_json()
        email = data.get('email')
        pin = data.get('pin')
        mobile_number = data.get('mobile_number')
        full_name = data.get('full_name')

        register_instance = Register(
            server='20.233.15.82,2522',
            database='BlinqMobileDB_Dev',
            username='mobiledbdevuser',
            password='eP7R4bEQ8oRsK3hK3o'
        )

        # Perform registration
        registration_result = register_instance.register_consumer(
            email, pin, mobile_number, full_name)

        # Fetch email subject and body
        email_subject = fetch_email_subject(request_source='register_and_email')
        email_body = fetch_email_body(request_source_body='register_and_email')

        # Replace placeholders in the email body with user-specific values
        email_body = email_body.replace("[FullName]", full_name)
        email_body = email_body.replace("[Email]", email)
        email_body = email_body.replace("[Username]", email)

        # Now 'email_body' contains the personalized email content

        # Send the email using your email sending mechanism
        send_email(email, email_subject, email_body)

        return jsonify({"status": "success", "message": "Registration successful. Email sent.", "registration_result": registration_result})
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"status": "error", "message": "Internal server error"}), 500





@app.route('/fetch-email-subject', methods=['GET'])
def fetch_email_subject_route():
    request_source = request.args.get('request_source', 'default_value')
    email_subject = fetch_email_subject(request_source)
    return jsonify({"email_subject": email_subject})



@app.route('/fetch-email-body', methods=['GET'])
def fetch_email_body_route():
    request_source_body = request.args.get('request_source_body', 'default_value')
    email_body = fetch_email_body(request_source_body)
    return jsonify({"email_body": email_body})

@app.route('/fetch-sms', methods=['GET'])
def fetch_sms_route():
    sms_content = fetch_sms()
    return jsonify({"sms_content": sms_content})

@app.route('/log-error', methods=['POST'])
def log_error():
    try:
        data = request.get_json()

        # Extract error message, username, and other details from the request data
        error_message = data.get('errorMessage')
        username = data.get('userEmail')  # Assuming 'userEmail' is the key for the email value
        section = data.get('section')
        severity = data.get('severity')
        title = data.get('title')
        message = data.get('message')
        error_details = data.get('errorDetails')  # Corrected variable name

        # Log the error using your function
        log_to_store_procedure(
            section=section,
            severity=severity,
            title=title,
            message=error_message,
            description=error_details,  # Use the correct variable name
            username=username
        )

        return jsonify({'message': 'Log inserted successfully!'}), 200

    except Exception as e:
        return jsonify({'error': f'Error logging: {e}'}), 500


@app.route('/user_audit_insert', methods=['POST'])
def call_user_audit_insert():
    try:
        data = request.get_json()
        user_id = data.get('user_id')
        section = data.get('section')
        title = data.get('title')
        description = data.get('description')

        user_audit_insert(user_id, section, title, description)

        return jsonify({'message': 'inserted successfully!'}), 200

    except Exception as e:
        return jsonify({'error': f'Error logging: {e}'}), 500


@app.route('/get_user_login_by_email', methods=['POST'])
def get_user_login():
    if request.method == 'POST':
        # Get email and pin parameters from Flutter app
        data = request.get_json()
        email_param = data.get('email')
        pin_param = data.get('pin')

        # Call the function
        result, stored_hash_pin ,is_locked,user_id= execute_login_stored_procedure(email_param)

        if not result:
            return jsonify({"error": "User not found"})
        if is_locked == True:
            return jsonify({"error": "Your account is temporary locked. Contact to adminstrator"})

        salt = result[0].get('salt')  # Adjust 'salt' based on the actual column name in your result

        # Create an instance of the Register class
        register_instance = Register(server='20.233.15.82,2522', database='BlinqMobileDB_Dev', username='mobiledbdevuser', password='eP7R4bEQ8oRsK3hK3o')

        # Call the hash_pin_with_salt method from the Register class
        hashed_pin = register_instance.hash_pin_with_salt(pin_param, salt)

        # Check if both 'hashed_pin' and 'stored_hashed_pin' are defined
        if hashed_pin is not None and stored_hash_pin is not None and hashed_pin == stored_hash_pin :
            if user_id is not None:
                print(f"User ID: {user_id}")

                result = user_audit_insert(user_id, None, None, None)
                print(result)

            # call_sp_user_failed_login_attempt(email_param,pin_param)
            return jsonify({"message": "Login successful"})


        else:
            call_sp_user_failed_login_attempt(email_param,pin_param)
            status, message =  call_sp_user_failed_login_attempt(email_param, pin_param)
            return jsonify({"status": status, "error": message})

@app.route('/generate_and_store_otp_sms', methods=['POST'])
def generate_and_store_otp_sms():
    try:
        data = request.get_json()
        email = data.get('email')
        mobile = data.get('mobile')
        otp = generate_otp()
        store_otp_in_database(email, mobile, otp)

        print(f"Generated OTP: {otp}")
        return jsonify({"status": "success", "message": otp})
        otp = generate_otp()
        store_otp_in_database(email, mobile, otp)
        print(f"Generated OTP: {otp}")
        sms = fetch_sms()

        sms = sms.replace("[Code]", otp)

        send_sms(mobile, sms)
        # store_otp_in_database(email, mobile, otp)

        return jsonify({"status": "success", "message": "OTP generated and stored successfully."})
    except Exception as e:
        return jsonify({"status": "error", "message": f"Error: {e}"}), 500


@app.route('/generate_and_store_otp_email', methods=['POST'])
def generate_and_store_otp():
    try:
        data = request.get_json()
        email = data.get('email')
        mobile = data.get('mobile')
        otp = generate_otp()
        store_otp_in_database(email, mobile, otp)

        print(f"Generated OTP: {otp}")
        return jsonify({"status": "success", "message": otp})

        # store_otp_in_database(email, mobile, otp)

        # time.sleep(20)
        # fetch_email_subject(request_source='generate_and_store_otp')
        email_subject = fetch_email_subject(request_source='generate_and_store_otp')
        email_body = fetch_email_body(request_source_body='generate_and_store_otp')

        # Replace placeholders in the email body with user-specific values
        email_body = email_body.replace("[FullName]", email)
        email_body = email_body.replace("[Email]", email)
        email_body = email_body.replace("[Code]", otp)
        send_email(email, email_subject, email_body)

        return jsonify({"status": "success", "message": "OTP generated and stored successfully."})
    except Exception as e:
        return jsonify({"status": "error", "message": f"Error: {e}"}), 500



@app.route('/receive_otp_data', methods=['POST'])
def receive_otp_data():
    try:
        data = request.get_json()
        otp_data = {
            'fieldOne': data.get('fieldOne'),
            'fieldTwo': data.get('fieldTwo'),
            'fieldThree': data.get('fieldThree'),
            'fieldFour': data.get('fieldFour'),
            'fieldFive': data.get('fieldFive'),
            'fieldSix': data.get('fieldSix'),
        }
        email_address = data.get('emailAddress')

        otp_code = ''.join([otp_data[field] for field in ['fieldOne', 'fieldTwo', 'fieldThree', 'fieldFour', 'fieldFive', 'fieldSix']])
        result = execute_stored_procedure_get_code(otp_code, email_address)

        if result['status'] == 'success':
            response_data = {'status': 'success', 'message': 'OTP verification successful'}
        else:
            response_data = {'status': 'error', 'message': 'OTP verification failed'}

        return jsonify(response_data)

    except Exception as e:
        print('Error processing OTP data:', str(e))
        response_data = {'status': 'error', 'message': str(e)}
        return jsonify(response_data)




@app.route('/reset_pin', methods=['POST'])
def reset_pin():
    try:
        # Get data from the request
        data = request.get_json()
        email = data.get('email')
        reset_pin = data.get('reset_pin')

        # Replace with the actual hashing logic for the entered password
        entered_password_hash = 'hashed_password'

        # Set the salt value
        salt = Register.generate_salt(Register)

        # Execute the stored procedure
        result = execute_sp_user_reset_pin(email, salt, entered_password_hash)

        if result:
            status, message = result
            return jsonify({"status": status, "message": message})
        else:
            return jsonify({"status": "Failed", "message": "Failed to execute stored procedure."})

    except Exception as e:
        return jsonify({"status": "Error", "message": f"An error occurred: {str(e)}"})



#
# @app.route('/reset_pin', methods=['POST'])
# def reset_pin():
#     try:
#         data = request.get_json()
#
#         email = data.get('email')
#         salt =Register.generate_salt(Register)
#         entered_password_hash = data.get('entered_password_hash')
#
#         if not email or not salt or not entered_password_hash:
#             return jsonify({'error': 'Missing required data'}), 400
#
#         result = execute_sp_user_reset_pin(email, salt, entered_password_hash)
#
#         if result:
#             return jsonify({'status': 'success', 'result': result}), 200
#         else:
#             return jsonify({'status': 'error', 'message': 'Failed to reset PIN'}), 500
#
#     except Exception as e:
#         return jsonify({'status': 'error', 'message': f'Internal Server Error: {str(e)}'}), 500
#

if __name__ == '__main__':
    app.run(host='192.168.100.149', port=84)
