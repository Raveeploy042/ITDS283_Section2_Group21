from db_config import get_connection

def create_staff(name, username, password):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
    INSERT INTO staffs (StaffName, username, password)
    VALUES (%s,%s, %s)
    """, (name, username, password))
    conn.commit()
    conn.close()
    pass

def get_all_products():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
    SELECT `ProductName`, Type, Brand, Price, Unit,  Location, ImageURL
    FROM products
    """)
    result = cursor.fetchall()
    conn.close()
    return result

def create_orders(name, username, password):
    pass

def get_orders(customer_id, name, contact, address, city, postal_code, country):
    pass

def update_orders(customer_id, name, contact, address, city, postal_code, country):
    pass

def delete_orders(customer_id):
    pass
