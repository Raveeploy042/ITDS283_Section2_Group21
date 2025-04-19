from flask import Flask, request, jsonify
from flask_cors import CORS
import socket
import project_crud

app = Flask(__name__)
CORS(app)

# Create customer
# @app.route('/products', methods=['POST'])
# def create_customer():
#     data = request.json
#     customer_crud.create_customer(
#         data['CustomerName'],
#         data['ContactName'],
#         data['Address'],
#         data['City'],
#         data['PostalCode'],
#         data['Country']
#     )
#     return jsonify({'message': 'Customer created'}), 201

# Read all customers
@app.route('/products', methods=['GET'])
def get_products():
    return jsonify(project_crud.get_all_products())

@app.route('/staffs/<string:username>', methods=['GET'])
def get_staffs(username):
    return jsonify(project_crud.get_staff(username))

# Update customer
# @app.route('/customers/<int:customer_id>', methods=['PUT'])
# def update_customer(customer_id):
#     data = request.json
#     customer_crud.update_customer(
#         customer_id,
#         data['CustomerName'],
#         data['ContactName'],
#         data['Address'],
#         data['City'],
#         data['PostalCode'],
#         data['Country']
#     )
#     return jsonify({'message': 'Customer updated'})

# # Delete customer
# @app.route('/customers/<int:customer_id>', methods=['DELETE'])
# def delete_customer(customer_id):
#     customer_crud.delete_customer(customer_id)
#     return jsonify({'message': 'Customer deleted'})

if __name__ == '__main__':
    # Get your local IP address
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)
    
    print(f"\n Flask is running! Open in browser:")
    print(f"    http://{local_ip}:5000/\n")
    
    app.run(debug=True, host='0.0.0.0', port=5000)
