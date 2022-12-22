
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
    
def addItemInPaidTable(cmobileno,padescription,paisbill,paymentmode,paamount):
    try:
        query=f"INSERT INTO paid_table (cmobileno,paisbill,padescription,paamount,paymentmode) VALUES ('{cmobileno}', '{paisbill}', '{padescription}', '{paamount}', '{paymentmode}');"
        print(query)
        cursor.execute(query)
        db.commit()
        return "added in paid_table success"
    except Exception as e:
        print(e)
        return "database error"
    
def addItemInPayableTable(cmobileno,pydescription,pyisbill,pyamount):
    try:
        query=f"INSERT INTO payable_table (cmobileno,pyisbill,pydescription,pyamount) VALUES ('{cmobileno}', '{pyisbill}', '{pydescription}', '{pyamount}');"
        print(query)
        cursor.execute(query)
        db.commit()
        return "added in payable_table success"
    except Exception as e:
        print(e)
        return "database error"
    
def deleteItemInPayableTable(sno):
    try:
        query=f"delete from payable_table where sno='{sno}'"
        print(query)
        cursor.execute(query)
        db.commit()
        return "delete item in payable_table success"
    except Exception as e:
        print(e)
        return "database error"
    
def deleteItemInPaidTable(sno):
    try:
        query=f"delete from paid_table where sno='{sno}'"
        print(query)
        cursor.execute(query)
        db.commit()
        return "delete item in paid_table success"
    except Exception as e:
        print(e)
        return "database error"
    
def fetchAllItemInPaidTable():
    try:
        query=f"SELECT * FROM paid_table"
        print(query)
        cursor.execute(query)
        fetchdata= cursor.fetchall()
        return fetchdata
    except Exception as e:
        print(e)
        return "database error"
    
def fetchAllItemInPayableTable():
    try:
        query=f"SELECT * FROM payable_table"
        print(query)
        cursor.execute(query)
        fetchdata= cursor.fetchall()
        return fetchdata
    except Exception as e:
        print(e)
        return "database error"