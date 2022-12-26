import mysql.connector
import aiomysql

# db = mysql.connector.connect(
#     host="localhost", user="root", 
#     password="yash2020",
#     # password="",
#     database="cashbook"
# )

# if db.is_connected():
#     print("Database Connected")

# cursor = db.cursor()

# def findclient(mysql,cmobileno):
#     cursor = mysql.connection.cursor()
#     query = f"SELECT * FROM client WHERE cmobileno={cmobileno}"
#     cursor.execute(query)
#     fatchData=cursor.fetchone() #user is exist or not
#     print(fatchData)
#     return fatchData

async def createConn():
    conn = await aiomysql.connect(
        host="localhost",
        user="root",
        password="yash2020",
        # password="",
        db="cashbook",
    )
    return conn

async def finduser(useremail):
    try:
        conn = await createConn()
        cur = await conn.cursor()
        # query = f"SELECT * FROM client WHERE cmobileno={cmobileno}"
        
        query = f"SELECT * FROM users WHERE useremail='{useremail}'"
        await cur.execute(query)
        fatchData = await cur.fetchone()  # user is exist or not
        # print("in utill", fatchData)
        cur.close()
        conn.close()
        return fatchData
    except Exception as e:
        print(e)
        return "database error"



# def findclient(cmobileno):
#     try:
#         # query = f"SELECT * FROM client WHERE cmobileno={cmobileno}"
#         query = f"SELECT * FROM client WHERE cmobileno={cmobileno}"
#         cursor.execute(query)
#         fatchData = cursor.fetchone()  # user is exist or not
#         print("in utill", fatchData)
#         return fatchData
#     except Exception as e:
#         print(e)
#         return "database error"


async def insertuser(username, useremail, userimageurl):
    try:
        conn = await createConn()
        cur = await conn.cursor()
        print("bb")
        query = f"INSERT INTO users (username,useremail,userimageurl) values('{username}','{useremail}','{userimageurl}')"

        await cur.execute(query)
        await conn.commit()
        cur.close()
        conn.close()
        return "new user added in users"
    except Exception as e:
        print(e)
        return "database error"


# def insertclient(cname, cmobileno, useremail):
#     try:
#         query = f"INSERT INTO client(cname,cmobileno,useremail) values('{cname}','{cmobileno}','{useremail}')"
#         print(query)
#         cursor.execute(query)
#         db.commit()
#         return "new clint added"
#     except Exception as e:
#         print(e)
#         return "database error"


# def deleteclient(cmobileno):
#     try:
#         query = f"delete from client where cmobileno='{cmobileno}'"
#         print(query)
#         cursor.execute(query)
#         db.commit()
#         return "delete client success"
#     except Exception as e:
#         print(e)
#         return "database error"


# def addItemInPaidTable(
#     cmobileno, padescription, paisbill, paymentmode, paamount, useremail
# ):
#     try:
#         query = f"INSERT INTO paid_table (cmobileno,paisbill,padescription,paamount,paymentmode,useremail) VALUES ('{cmobileno}', '{paisbill}', '{padescription}', '{paamount}', '{paymentmode}','{useremail}');"
#         print(query)
#         cursor.execute(query)
#         db.commit()
#         return "added in paid_table success"
#     except Exception as e:
#         print(e)
#         return "database error"


# def addItemInPayableTable(cmobileno, pydescription, pyisbill, pyamount, useremail):
#     try:
#         query = f"INSERT INTO payable_table (cmobileno,pyisbill,pydescription,pyamount,useremail) VALUES ('{cmobileno}', '{pyisbill}', '{pydescription}', '{pyamount}','{useremail}');"
#         print(query)
#         cursor.execute(query)
#         db.commit()
#         return "added in payable_table success"
#     except Exception as e:
#         print(e)
#         return "database error"


# def deleteItemInPayableTable(sno):
#     try:
#         query = f"delete from payable_table where sno='{sno}'"
#         print(query)
#         cursor.execute(query)
#         db.commit()
#         return "delete item in payable_table success"
#     except Exception as e:
#         print(e)
#         return "database error"


# def deleteItemInPaidTable(sno):
#     try:
#         query = f"delete from paid_table where sno='{sno}'"
#         print(query)
#         cursor.execute(query)
#         db.commit()
#         return "delete item in paid_table success"
#     except Exception as e:
#         print(e)
#         return "database error"


# def fetchAllItemInPaidTable():
#     try:
#         query = f"SELECT * FROM paid_table"
#         print(query)
#         cursor.execute(query)
#         fetchdata = cursor.fetchall()
#         return fetchdata
#     except Exception as e:
#         print(e)
#         return "database error"


# def fetchAllItemInPayableTable():
#     try:
#         query = f"SELECT * FROM payable_table"
#         print(query)
#         cursor.execute(query)
#         fetchdata = cursor.fetchall()
#         return fetchdata
#     except Exception as e:
#         print(e)
#         return "database error"


# def updateItemInPayableTable(
#     sno, new_cmobileno, new_pyisbill, new_pydescription, new_pyamount
# ):
#     try:
#         query = f"UPDATE payable_table SET cmobileno='{new_cmobileno}',pyisbill='{new_pyisbill}',pydescription='{new_pydescription}',pyamount='{new_pyamount}' WHERE sno='{sno}';"
#         print(query)
#         cursor.execute(query)
#         db.commit()
#         return "update item in payable_table success"
#     except Exception as e:
#         print(e)
#         return "database error"


# def updateItemInPaidTable(
#     sno, new_cmobileno, new_pyisbill, new_pydescription, new_pyamount, new_paymentmode
# ):
#     try:
#         query = f"UPDATE paid_table SET cmobileno='{new_cmobileno}',paisbill='{new_pyisbill}',padescription='{new_pydescription}',paamount='{new_pyamount}',paymentmode='{new_paymentmode}' WHERE sno='{sno}';"
#         print(query)
#         cursor.execute(query)
#         db.commit()
#         return "update item in paid_table success"
#     except Exception as e:
#         print(e)
#         return "database error"
