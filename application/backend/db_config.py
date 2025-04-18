import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host='localhost',
        user='root',
        password='SQL@ICT234',
        database='itds283_sec2_gr21'
    )
