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