from typing import Dict, List, Union

import utills

UserJSON = Dict[str, str]

class Supplier():
    def __init__(self, sname,firmname,smobileno,semail,useremail,entrydatetime):
        self.sname=sname
        self.firmname=firmname
        self.smobileno=smobileno
        self.semail=semail
        self.entrydatetime=entrydatetime 
        self.useremail=useremail
    
    async def findsupplier(self):
        try:
            conn = await utills.createConn()
            cur = await conn.cursor()
            query = f"SELECT * FROM supplier WHERE smobileno={self.smobileno} and useremail='{self.useremail}'"
            await cur.execute(query)
            fatchData = await cur.fetchone()  # user is exist or not
            # print("in utill", fatchData)
            await cur.close()
            conn.close()
            return fatchData
        except Exception as e:
            print(e)
            return "database error"
    
    
    async def insertsupplier(self):
        try:
            conn = await utills.createConn()
            cur = await conn.cursor()
            if(self.semail==None):
                query = f"INSERT INTO supplier(sname,firmname,smobileno,useremail,entrydatetime) values('{self.sname}','{self.firmname}','{self.smobileno}','{self.useremail}','{self.entrydatetime}')"
            else:
                query = f"INSERT INTO supplier(sname,firmname,smobileno,semail,useremail,entrydatetime) values('{self.sname}','{self.firmname}','{self.smobileno}','{self.semail}','{self.useremail}','{self.entrydatetime}')"
            await cur.execute(query)
            await conn.commit()
            await cur.close()
            conn.close()
            return "new clint added"
        except Exception as e:
            print(e)
            return "database error"
        
    async def deletesupplier(smobileno,useremail):
        try:
            conn = await utills.createConn()
            cur = await conn.cursor()
            query = f"delete from supplier where smobileno='{smobileno}' AND useremail='{useremail}' "
            await cur.execute(query)
            await conn.commit()
            await cur.close()
            conn.close()
            return "success"
        except Exception as e:
            print(e)
            return "database error"
    
    
    async def updatesupplier(self,oldcmobileno):
        try:
            conn = await utills.createConn()
            cur = await conn.cursor()
            print(self.semail)
            if(self.semail==None):
                query = f"UPDATE supplier SET sname='{self.sname}',firmname='{self.firmname}',smobileno='{self.smobileno}',semail=Null,useremail='{self.useremail}',entrydatetime='{self.entrydatetime}' WHERE smobileno={oldcmobileno} AND useremail='{self.useremail}'"
                
            else:
                query = f"UPDATE supplier SET sname='{self.sname}',firmname='{self.firmname}',smobileno='{self.smobileno}',semail='{self.semail}',useremail='{self.useremail}',entrydatetime='{self.entrydatetime}' WHERE smobileno={oldcmobileno} AND useremail='{self.useremail}'"
            await cur.execute(query)
            await conn.commit()
            await cur.close()
            conn.close()
            return "clint updated"
        except Exception as e:
            print(e)
            return "database error"
        
    async def fetchAllItemInsupplierTable(useremail):
        try:
            print(useremail)
            conn = await utills.createConn()
            cur = await conn.cursor()
            query = f"SELECT * FROM supplier WHERE useremail='{useremail}' ORDER BY firmname ASC"
            # print(query)
            await cur.execute(query)
            fetchdata = await cur.fetchall()
            # print(fetchdata)
            await cur.close()
            conn.close()
            return fetchdata
        except Exception as e:
            print(e)
            return "database error"

  