from db_config import get_connection
from flask import jsonify
def create_staff(name, username, password):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
    INSERT INTO staffs (StaffName, username, password)
    VALUES (%s,%s, %s)
    """, (name, username, password))
    conn.commit()
    conn.close()
    

def get_staff(name):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT StaffID,StaffName, username, password, position
        FROM staffs
        WHERE username=%s
    """, (name,))
    result = cursor.fetchone()
    conn.close()
    return result



def get_all_products():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
    SELECT  productID ,ProductName, Type, Brand, Price, Unit,  Location, ImageURL
    FROM products
    """)
    result = cursor.fetchall()
    conn.close()
    return result


def get_product(productId):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT productID ,ProductName, Type, Brand, Price, Unit,  Location, ImageURL
        FROM products
        WHERE productID=%s
    """, (productId,))
    result = cursor.fetchone()
    conn.close()
    return result


def create_orders():
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
    INSERT INTO orders (OrderDate, Status)
    VALUES (CURDATE(), 'still in cart');
    """, )
    conn.commit()
    conn.close()

def get_order(orderId):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT OrderID, CustomerName, OrderDate, transport , Address, StaffID, CreatedAt, UpdatedAt,Status
        FROM orders
        WHERE OrderID=%s
    """, (orderId,))
    result = cursor.fetchone()
    conn.close()
    return result

def get_all_order():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT OrderID, CustomerName, OrderDate, transport , Address, StaffID, CreatedAt, UpdatedAt,Status
        FROM orders
    """,)
    result = cursor.fetchall()
    conn.close()
    return result

def update_orders(order_id, customer_name, transport, address, status):
    conn = get_connection()
    cursor = conn.cursor()

    # คำสั่ง SQL สำหรับการอัปเดตคำสั่งซื้อ
    cursor.execute("""
    UPDATE orders
    SET CustomerName = %s, Transport = %s, Address = %s, Status = %s, UpdatedAt = CURRENT_TIMESTAMP
    WHERE OrderID = %s
    """, (customer_name, transport, address, status, order_id))
    
    conn.commit()
    conn.close()

def delete_orders(orderId):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM orders WHERE OrderID = %s", (orderId,))
    conn.commit()
    conn.close()

def create_order_item(order_id, product_id, quantity):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
    INSERT INTO order_items (OrderID, ProductID, Quantity)
    VALUES (%s, %s, %s)
    """, (order_id, product_id, quantity))
    conn.commit()
    conn.close()

def get_order_items(order_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT oi.OrderItemID, p.ProductName, oi.Quantity, p.Price ,p.ImageURL
        FROM order_items oi
        JOIN products p ON oi.ProductID = p.productID
        WHERE oi.OrderID = %s
    """, (order_id,))
    result = cursor.fetchall()
    conn.close()
    return result

def get_all_order_item():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT oi.OrderItemID, p.ProductName, oi.Quantity, p.Price , p.ImageURL
        FROM order_items oi
        JOIN products p ON oi.ProductID = p.productID
    """,)
    result = cursor.fetchall()
    conn.close()
    return result

def update_order_item(order_item_id, quantity):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
    UPDATE order_items
    SET Quantity = %s
    WHERE OrderItemID = %s
    """, (quantity, order_item_id))
    conn.commit()
    conn.close()

def delete_order_item(order_item_id):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
    DELETE FROM order_items
    WHERE OrderItemID = %s
    """, (order_item_id,))
    conn.commit()
    conn.close()

def get_searched_products(search_term):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
    SELECT ProductName, Type, Brand, Price, Unit, Location, ImageURL
    FROM products
    WHERE ProductName LIKE %s OR Type LIKE %s
    """, ('%' + search_term + '%', '%' + search_term + '%'))
    
    result = []
    for row in cursor:
        result.append(row)  # row เป็น dict อยู่แล้ว เพราะใช้ dictionary=True

    conn.close()

    return result


def get_searched_orders(search_term):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    # คำสั่ง SQL ที่ค้นหาจาก CustomerName, OrderID, Address และ ProductName
    cursor.execute("""
    SELECT o.OrderID, o.CustomerName, o.OrderDate, o.transport, o.Address, o.Status, p.ProductName
    FROM orders o
    JOIN order_items oi ON o.OrderID = oi.OrderID
    JOIN products p ON oi.ProductID = p.productID
    WHERE o.CustomerName LIKE %s
    OR o.OrderID LIKE %s
    OR o.Address LIKE %s
    OR p.ProductName LIKE %s
    """, ('%' + search_term + '%', '%' + search_term + '%', '%' + search_term + '%', '%' + search_term + '%'))
    
    result = []
    for row in cursor:
        result.append(row)  # row เป็น dict อยู่แล้ว เพราะใช้ dictionary=True

    conn.close()

    return result
