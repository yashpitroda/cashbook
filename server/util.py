
import mysql.connector

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="yash2020",
    database="cashbook"
)

if db.is_connected():
    print("Database Connected")

cursor = db.cursor()
    
# def findclient(mysql,cmobileno):
#     cursor = mysql.connection.cursor()
#     query = f"SELECT * FROM client WHERE cmobileno={cmobileno}"
#     cursor.execute(query)
#     fatchData=cursor.fetchone() #user is exist or not
#     print(fatchData) 
#     return fatchData

def findclient(cmobileno):
    try:
        # query = f"SELECT * FROM client WHERE cmobileno={cmobileno}"
        query = f"SELECT * FROM client WHERE cmobileno={cmobileno}"
        cursor.execute(query)
        fatchData=cursor.fetchone() #user is exist or not
        print("in utill",fatchData) 
        return fatchData
    except Exception as e:
        print(e)
        return "database error"


def insertclient(cname,cmobileno):
    try:
        query=f"INSERT INTO client(cname,cmobileno) values('{cname}','{cmobileno}')"
        print(query)
        cursor.execute(query)
        db.commit()
        return "new clint added"
    except Exception as e:
        print(e)
        return "database error"
    
def deleteclient(cmobileno):
    try:
        query=f"delete from client where cmobileno='{cmobileno}'"
        print(query)
        cursor.execute(query)
        db.commit()
        return "delete client success"
    except Exception as e:
        print(e)
        return "database error"
    
