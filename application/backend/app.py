from flask import Flask, request, jsonify
from flask_cors import CORS
import socket
import project_crud
import datetime
import jwt

app = Flask(__name__)
CORS(app)

# -------------------------------
# Products Routes (CRUD)
# -------------------------------

# Get all products
@app.route('/products', methods=['GET'])
def get_products():
    try:
        products = project_crud.get_all_products()
        return jsonify(products), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Get a specific product by productID
@app.route('/products/<int:product_id>', methods=['GET'])
def get_product(product_id):
    try:
        product = project_crud.get_product(product_id)
        if product:
            return jsonify(product), 200
        else:
            return jsonify({"message": "Product not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# -------------------------------
# Staff Routes
# -------------------------------

# Get staff by username
@app.route('/staffs/<string:username>', methods=['GET'])
def get_staffs(username):
    try:
        staff = project_crud.get_staff(username)
        if staff:
            return jsonify(staff), 200
        else:
            return jsonify({"message": "Staff not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    

SECRET_KEY = 'your_secret_key'  # ควรเก็บใน environment variable สำหรับความปลอดภัย

# ฟังก์ชันในการสร้าง JWT token ที่มีข้อมูลของ staffId
def create_jwt_token(staff_id, username):
    payload = {
        'staff_id': staff_id,
        'username': username,
        'exp': datetime.datetime.now() + datetime.timedelta(hours=1)  # หมดอายุใน 1 ชั่วโมง
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm='HS256')
    return token

@app.route('/login', methods=['POST'])
def login():
    data = request.json

    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        return jsonify({"error": "Both username and password are required"}), 400

    try:
        # ตรวจสอบข้อมูลในฐานข้อมูล
        user = project_crud.get_staff(username)  # ดึงข้อมูลพนักงานจากฐานข้อมูล
        if user and user['password'] == password:  # ตรวจสอบรหัสผ่าน
            # สร้าง JWT Token ที่มีข้อมูล staff_id และ username
            token = create_jwt_token(user['StaffID'], user['username'])
            return jsonify({"message": "Login successful", "token": token}), 200
        else:
            return jsonify({"error": "Invalid username or password"}), 401
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/staffs', methods=['POST'])
def create_staff_api():
    # รับข้อมูลจาก request body (ในรูปแบบ JSON)
    data = request.json
    
    # ตรวจสอบว่ามีข้อมูลที่จำเป็นหรือไม่
    name = data.get("StaffName")
    username = data.get("username")
    password = data.get("password")
    
    if not all([name, username, password]):
        return jsonify({"error": "StaffName, username, and password are required"}), 400
    
    try:
        # เรียกใช้ฟังก์ชัน create_staff จาก project_crud.py
        project_crud.create_staff(name, username, password)
        
        # ส่งข้อความตอบกลับเมื่อสร้างพนักงานสำเร็จ
        return jsonify({"message": "Staff created successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# -------------------------------
# Orders Routes (CRUD)
# -------------------------------

# Create a new order
@app.route('/orders', methods=['POST'])
def create_order():
    try:
        project_crud.create_orders()
        return jsonify({"message": "Order created successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Get order by OrderID
@app.route('/orders/<int:order_id>', methods=['GET'])
def get_order(order_id):
    try:
        order = project_crud.get_order(order_id)
        if order:
            return jsonify(order), 200
        else:
            return jsonify({"message": "Order not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/orders', methods=['GET'])
def get_all_order():
    try:
        order = project_crud.get_all_order()
        if order:
            return jsonify(order), 200
        else:
            return jsonify({"message": "Order not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/orders/<int:order_id>', methods=['PUT'])
def update_order(order_id):
    # รับข้อมูลจาก request body (ในรูปแบบ JSON)
    data = request.json
    
    # ตรวจสอบข้อมูลที่จำเป็น
    name = data.get("CustomerName")
    transport = data.get("Transport")
    address = data.get("Address")
    status = data.get("Status")
    
    if not all([name, transport, address, status]):
        return jsonify({"error": "CustomerName, Transport, Address, and Status are required"}), 400
    
    try:
        # เรียกใช้ฟังก์ชันเพื่ออัปเดตคำสั่งซื้อในฐานข้อมูล
        project_crud.update_orders(order_id, name, transport, address, status)
        return jsonify({"message": "Order updated successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Delete order
@app.route('/orders/<int:order_id>', methods=['DELETE'])
def delete_order(order_id):
    try:
        # เรียกใช้ฟังก์ชันเพื่อทำการลบคำสั่งซื้อในฐานข้อมูล
        project_crud.delete_orders(order_id)
        return jsonify({"message": "Order deleted successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# -------------------------------
# Order Items Routes (CRUD)
# -------------------------------

# Add product to order
@app.route('/order_items', methods=['POST'])
def create_order_item():
    data = request.json
    order_id = data.get("OrderID")
    product_id = data.get("ProductID")
    quantity = data.get("Quantity")
    
    if not all([order_id, product_id, quantity]):
        return jsonify({"error": "OrderID, ProductID, and Quantity are required"}), 400
    
    try:
        project_crud.create_order_item(order_id, product_id, quantity)
        return jsonify({"message": "Product added to order"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Get all items in a specific order
@app.route('/order_items/<int:order_id>', methods=['GET'])
def get_order_items(order_id):
    try:
        order_items = project_crud.get_order_items(order_id)
        if order_items:
            return jsonify(order_items), 200
        else:
            return jsonify({"message": "No items found for this order"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Update quantity of an order item
@app.route('/order_items/<int:order_item_id>', methods=['PUT'])
def update_order_item(order_item_id):
    data = request.json
    quantity = data.get("Quantity")
    
    if not quantity:
        return jsonify({"error": "Quantity is required"}), 400
    
    try:
        project_crud.update_order_item(order_item_id, quantity)
        return jsonify({"message": "Order item updated"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Delete an item from an order
@app.route('/order_items/<int:order_item_id>', methods=['DELETE'])
def delete_order_item(order_item_id):
    try:
        project_crud.delete_order_item(order_item_id)
        return jsonify({"message": "Order item deleted"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# -------------------------------
# Search order
# -------------------------------
@app.route('/search/orders', methods=['GET'])
def search_orders():
    search_term = request.args.get('search_term', '')  # รับคำค้นหาจาก URL query parameter
    try:
        orders = project_crud.get_searched_orders(search_term)
        if orders:
            return jsonify(orders), 200
        else:
            return jsonify({"message": "No orders found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    
# -------------------------------
# Search Product
# -------------------------------
@app.route('/search/products', methods=['GET'])
def search_products():
    search_term = request.args.get('search_term', '')  # รับคำค้นหาจาก URL query parameter
    try:
        products = project_crud.get_searched_products(search_term)
        if products:
            return jsonify(products), 200
        else:
            return jsonify({"message": "No products found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# -------------------------------
# Main
# -------------------------------
if __name__ == '__main__':
    # Get your local IP address
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)
    
    print(f"\n Flask is running! Open in browser: ")
    print(f"    http://{local_ip}:5000/\n")
    
    app.run(debug=True, host='0.0.0.0', port=5000)
