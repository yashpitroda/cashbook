from typing import Dict, List, Union

import utills

UserJSON = Dict[str, str]

class UserModel():
    def __init__(self, username,useremail,userimageurl):
        self.username=username
        self.useremail=useremail
        self.userimageurl=userimageurl
    
    def toJSON(self) -> UserJSON:
        return {
            "username": self.username,
            "useremail": self.useremail,
            "userimageurl": self.userimageurl,
        }
        
    async def findThisUser(self):
            try:
                conn = await utills.createConn()
                cur = await conn.cursor()
                query = f"SELECT * FROM users WHERE useremail='{self.useremail}'"
                await cur.execute(query)
                fatchData = await cur.fetchone()  # user is exist or not
                await cur.close()
                conn.close()
                return fatchData
            except Exception as e:
                print(e)
                return "database error"
            
    async def findThisUserwithUserEmail(useremail):
            try:
                conn = await utills.createConn()
                cur = await conn.cursor()
                query = f"SELECT * FROM users WHERE useremail='{useremail}'"
                await cur.execute(query)
                fatchData = await cur.fetchone()  # user is exist or not
                await cur.close()
                conn.close()
                # print(fatchData)
                return fatchData
            except Exception as e:
                print(e)
                return "database error"
    
    async def inserThisUser(self):
        try:
            conn = await utills.createConn()
            cur = await conn.cursor()
            query = f"INSERT INTO users (username,useremail,userimageurl) values('{self.username}','{self.useremail}','{self.userimageurl}')"
            await cur.execute(query)
            await conn.commit()
            await cur.close()
            conn.close()
            return "success"
        except Exception as e:
            print(e)
            return "database error"
        
        
        
 
        
        

    # @classmethod
    # def find_by_username(cls, username: str) -> "UserModel":
    #     return cls.query.filter_by(username=username).first()

    # @classmethod
    # def find_by_id(cls, _id: int) -> "UserModel":
    #     return cls.query.filter_by(id=_id).first()

    # def save_to_db(self) -> None:
    #     db.session.add(self)
    #     db.session.commit()

    # def delete_from_db(self) -> None:
    #     db.session.delete(self)
    #     db.session.commit()
