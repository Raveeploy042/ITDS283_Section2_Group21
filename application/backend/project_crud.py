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

def get_staff(name):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT StaffName, username, password, position
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
    SELECT ProductName, Type, Brand, Price, Unit,  Location, ImageURL
    FROM products
    """)
    result = cursor.fetchall()
    conn.close()
    return result

# def get_product(id):
#     conn = get_connection()
#     cursor = conn.cursor(dictionary=True)
#     cursor.execute("""
#     SELECT `ProductName`, Type, Brand, Price, Unit,  Location, ImageURL
#     FROM products
#     """)
#     result = cursor.fetchall()
#     conn.close()
#     return result

def create_orders(name, username, password):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
    INSERT INTO staffs (CustomerName, username, password)
    VALUES (%s,%s, %s)
    """, (name, username, password))
    conn.commit()
    conn.close()
    pass
'''
`CustomerName` varchar(255) DEFAULT NULL,
  `OrderDate` date DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `transport` varchar(255) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `StaffID` INT(11),
  '''

def get_orders(customer_id, name, contact, address, city, postal_code, country):
    pass

def update_orders(customer_id, name, contact, address, city, postal_code, country):
    pass

def delete_orders(customer_id):
    pass
