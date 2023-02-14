import aiomysql

async def createConn():
    conn = await aiomysql.connect(
        host="localhost",
        user="root",
        password="yash2020",
        # password="",
        db="cashbook",
    )
    return conn

async def SELECT_QUERY_FETCHALL(query):
    try:
            conn = await createConn()
            cur = await conn.cursor()
            await cur.execute(query) 
            fetchedData = await cur.fetchall()
            await cur.close()
            conn.close()
            return fetchedData
    except Exception as e:
            print(e)
            return "database error"
        
async def INSERT_DELETE_UPDATE_QUERY(query):
    try:
            conn = await createConn()
            cur = await conn.cursor()
            await cur.execute(query)
            await conn.commit()
            currentId=cur.lastrowid
            await cur.close()
            conn.close()
            return {"status":"success","id":currentId}
    except Exception as e:
            print(e)
            return {"status":"database error"}