import time
import utills

class Purchase():
    def __init__(self,biilAmount,paidAmount,accountId,remark,date,cOrCr,isBill,supplierId,useremail):
        self.biilAmount=biilAmount
        self.paidAmount=paidAmount
        self.advanceAmount=0
        self.outstandingAmount=0
        self.date=date
        self.remark=remark
        self.accountId=accountId
        self.cOrCr=cOrCr
        self.isBill=isBill
        self.useremail=useremail
        self.supplierId=supplierId
    
    async def fetchAllItemInpurchaseTable(useremail):
        try:
            print(useremail)
            conn = await utills.createConn()
            cur = await conn.cursor()
            query = f"SELECT * FROM purchase WHERE useremail='{useremail}' ORDER BY date DESC"
            await cur.execute(query)
            fetchdata = await cur.fetchall()
            await cur.close()
            conn.close()
            return fetchdata
        except Exception as e:
            print(e)
            return "database error"
        
    # async def insert_IN_purchase(self):
    #     try:
    #         conn = await utills.createConn()
    #         cur = await conn.cursor()
          
    #         query = f"INSERT INTO purchase(cash_bank,isbillvalue,bill_amount,paidamount,advance_amount,outstanding_amount,c_cr,remark,smobileno,useremail,date,cbid) values({self.cash_bank},{self.isbillvalue},{self.bill_amount},{self.paidamount},{self.advance_amount},{self.outstanding_amount},{self.c_cr},'{self.remark}','{self.smobileno}','{self.useremail}','{self.date}',{1})"
    #         await cur.execute(query)
    #         await conn.commit()
    #         # print(cur.lastrowid)
    #         # print(cur.rowcount)
    #         pid=cur.lastrowid
    #         await cur.close()
    #         conn.close()
    #         # return "success"
    #         return pid
    #     except Exception as e:
    #         print(e)
    #         return "database error"
        
    async def insert_IN_purchase_3(self):
        try:
            # conn = await utills.createConn()
            # cur = await conn.cursor()
            # # query=f"SELECT cashflowId FROM cashflow where cashflowId=(SELECT max(cashflowId) FROM cashflow where accountId={self.accountId} and useremail='{self.useremail}')"
            # # query=f"SELECT cashflowId FROM cashflow where cashflowId=(SELECT max(cashflowId) FROM cashflow where accountId={self.accountId} and useremail='{self.useremail}')"
            # query=f"select cashflowId from cashflow where accountId={self.accountId} and useremail='{self.useremail}' and date=(SELECT max(date) FROM cashflow where accountId={self.accountId} and useremail='{self.useremail}')"
            
            # await cur.execute(query)
            # fetchdata = await cur.fetchall()
            # await cur.close()
            # conn.close()
            # cashflowId=0 
            # for row in fetchdata:
            #     cashflowId,=row
            # print(f"cashflowid={cashflowId}")
            print(self.date)
            print(type(self.date))
            
            conn = await utills.createConn()
            cur = await conn.cursor()
            query = f"INSERT INTO purchase(accountId,supplierId,isBill,biilAmount,paidAmount,cOrCr,remark,useremail,date) values({self.accountId},{self.supplierId},{self.isBill},{self.biilAmount},{self.paidAmount},{self.cOrCr},'{self.remark}','{self.useremail}','{self.date}');"
            await cur.execute(query)
            await conn.commit()
            current_pid=cur.lastrowid
            await cur.close()
            conn.close()
            print(f"curent pid={current_pid}")
            
            
            # conn = await utills.createConn()
            # cur = await conn.cursor()
            # query=f"select pid from purchase where  date = (SELECT MAX(date) FROM purchase WHERE date<CONVERT(DATETIME,'{self.date}')  and isBill={self.isBill} and supplierId={self.supplierId} and useremail='{self.useremail}') "
            # await cur.execute(query)
            # fetchdata = await cur.fetchall()
            # await cur.close()
            # conn.close()
            # ppppid=0 
            # for row in fetchdata:
            #     ppppid,=row
            # print(f"pppid: {ppppid}")
            conn = await utills.createConn()
            cur = await conn.cursor()
            # query=f"SELECT advanceAmount,outstandingAmount FROM purchase WHERE pid = (SELECT MAX(pid) FROM purchase WHERE pid<{current_pid} and isBill={self.isBill} and supplierId='{self.supplierId}' and useremail='{self.useremail}')"
            query=f"SELECT advanceAmount,outstandingAmount FROM purchase WHERE pid=(select pid from purchase where isBill={self.isBill} and supplierId={self.supplierId} and useremail='{self.useremail}' and date = (SELECT MAX(date) FROM purchase WHERE date<(select date from purchase where pid={current_pid} ) and isBill={self.isBill} and supplierId={self.supplierId} and useremail='{self.useremail}')) "
            await cur.execute(query)
            fetchdata = await cur.fetchall()
            await cur.close()
            conn.close()
            print("--f-")
            print(fetchdata)
            print("--f-")
            old_advance_amount=0
            old_outstanding_amount=0
            for row in fetchdata:
                old_advance_amount,old_outstanding_amount=row
            print("-------")
            print(f"old adv amt:{old_advance_amount}")
            print(f"old ot amt:{old_outstanding_amount}")
            current_outstanding_amount=self.biilAmount-self.paidAmount+old_outstanding_amount
            if(current_outstanding_amount>old_advance_amount):
                self.advanceAmount=0
                self.outstandingAmount=current_outstanding_amount-old_advance_amount
            else:
                self.outstandingAmount=0
                self.advanceAmount=-(current_outstanding_amount-old_advance_amount)
            print("-------")
            print(f"new adv amt:{self.advanceAmount}")
            print(f"new ot amt:{self.outstandingAmount}")
            
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=f"UPDATE purchase SET advanceAmount={self.advanceAmount},outstandingAmount={self.outstandingAmount}  WHERE pid={current_pid}"
            await cur.execute(query)
            await conn.commit()    
            await cur.close()
            conn.close()
            #done
            
            conn = await utills.createConn()
            cur = await conn.cursor()
            # query = f"INSERT INTO purchase(accountId,supplierId,isBill,biilAmount,paidAmount,cOrCr,remark,useremail,date,cashflowId) values({self.accountId},{self.supplierId},{self.isBill},{self.biilAmount},{self.paidAmount},{self.cOrCr},'{self.remark}','{self.useremail}','{self.date}',{cashflowId});"
            
            query = f" INSERT INTO cashflow (date, accountId, debit, credit, balance, particulars, useremail) VALUES ( '{self.date}',{self.accountId},{self.paidAmount}, '0', {self.paidAmount},'remark_info' , '{self.useremail}');"
            await cur.execute(query)
            await conn.commit()
            current_cashflowId=cur.lastrowid
            print(current_cashflowId)
            await cur.close()
            conn.close()
            print(f"current_cashflowId:{current_cashflowId}")
            
            
            
            conn = await utills.createConn()
            cur = await conn.cursor()
            # query=f"SELECT balance FROM cashflow where cashflowId=(SELECT max(cashflowId) FROM cashflow where cashflowId<{current_cashflowId} and accountId={self.accountId} and useremail='{self.useremail}')"
            query=f"SELECT balance FROM cashflow where accountId={self.accountId} and useremail='{self.useremail}' and date=(SELECT MAX(date) FROM cashflow WHERE date<(SELECT date FROM cashflow WHERE cashflowId={current_cashflowId}) and accountId={self.accountId} and useremail='{self.useremail}')"
            await cur.execute(query)
            fetchdata = await cur.fetchall()
            await cur.close()
            conn.close()
            old_balance=0 
            print("comc")
            print(fetchdata)
            for row in fetchdata:
                old_balance,=row
            print(f"old_balance:{old_balance}")
                
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=f"UPDATE cashflow SET balance={old_balance}-balance WHERE cashflowId={current_cashflowId}"
            await cur.execute(query)
            await conn.commit()    
            await cur.close()
            conn.close()
            
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=f"UPDATE purchase SET cashflowId={current_cashflowId} WHERE pid={current_pid}"
            await cur.execute(query)
            await conn.commit()    
            await cur.close()
            conn.close()
            return "success"
        except Exception as e:
            print(e)
            return "database error"

    # async def insert_IN_purchase_2(self):
    #     try:
    #         conn = await utills.createConn()
    #         cur = await conn.cursor()
    #         # query=f"SELECT cashflowId FROM cashflow where cashflowId=(SELECT max(cashflowId) FROM cashflow where accountId={self.accountId} and useremail='{self.useremail}')"
    #         query=f"SELECT cashflowId FROM cashflow where cashflowId=(SELECT max(cashflowId) FROM cashflow where accountId={self.accountId} and useremail='{self.useremail}')"
            
    #         await cur.execute(query)
    #         fetchdata = await cur.fetchall()
    #         await cur.close()
    #         conn.close()
    #         cashflowId=0 
    #         for row in fetchdata:
    #             cashflowId,=row
    #         print("qw")
    #         conn = await utills.createConn()
    #         cur = await conn.cursor()
    #         print(self.supplierId)
    #         query = f"INSERT INTO purchase(accountId,supplierId,isBill,biilAmount,paidAmount,cOrCr,remark,useremail,date,cashflowId) values({self.accountId},{self.supplierId},{self.isBill},{self.biilAmount},{self.paidAmount},{self.cOrCr},'{self.remark}','{self.useremail}','{self.date}',{cashflowId});"
    #         await cur.execute(query)
    #         print(self.supplierId)
    #         await conn.commit()
    #         current_pid=cur.lastrowid
    #         print(current_pid)
    #         await cur.close()
    #         conn.close()
    #         print("hehe")
    #         # print(cur.lastrowid)
    #         # print(cur.rowcount)
    #         conn = await utills.createConn()
    #         cur = await conn.cursor()
    #         query=f"SELECT advanceAmount,outstandingAmount FROM purchase WHERE pid = (SELECT MAX(pid) FROM purchase WHERE pid<{current_pid} and isBill={self.isBill} and supplierId='{self.supplierId}' and useremail='{self.useremail}')"
    #         await cur.execute(query)
    #         fetchdata = await cur.fetchall()
    #         await cur.close()
    #         conn.close()
    #         old_advance_amount=0
    #         old_outstanding_amount=0
    #         for row in fetchdata:
    #             old_advance_amount,old_outstanding_amount=row
    #         current_outstanding_amount=self.biilAmount-self.paidAmount+old_outstanding_amount
    #         if(current_outstanding_amount>old_advance_amount):
    #             self.advanceAmount=0
    #             self.outstandingAmount=current_outstanding_amount-old_advance_amount
    #         else:
    #             self.outstandingAmount=0
    #             self.advanceAmount=-(current_outstanding_amount-old_advance_amount)
    #         # print("-------")
    #         # print(self.advance_amount)
    #         # print(self.outstanding_amount)
            
    #         conn = await utills.createConn()
    #         cur = await conn.cursor()
    #         query=f"UPDATE purchase SET advanceAmount={self.advanceAmount},outstandingAmount={self.outstandingAmount}  WHERE pid={current_pid}"
    #         await cur.execute(query)
    #         await conn.commit()    
    #         await cur.close()
    #         conn.close()
            
    #         conn = await utills.createConn()
    #         cur = await conn.cursor()
    #         query=f"SELECT max(cashflow.cashflowId) FROM cashflow where useremail='{self.useremail}'"
    #         await cur.execute(query)
    #         fetchdata = await cur.fetchall()
    #         await cur.close()
    #         conn.close()
    #         current_cashflowId=0 
    #         for row in fetchdata:
    #             current_cashflowId,=row
    #         # print(current_cbid)
            
    #         conn = await utills.createConn()
    #         cur = await conn.cursor()
    #         query=f"SELECT balance FROM cashflow where cashflowId=(SELECT max(cashflowId) FROM cashflow where cashflowId<{current_cashflowId} and accountId={self.accountId} and useremail='{self.useremail}')"
    #         await cur.execute(query)
    #         fetchdata = await cur.fetchall()
    #         await cur.close()
    #         conn.close()
    #         old_balance=0 
    #         for row in fetchdata:
    #             old_balance,=row
                
    #         conn = await utills.createConn()
    #         cur = await conn.cursor()
    #         query=f"UPDATE cashflow SET balance={old_balance}-balance WHERE cashflowId={current_cashflowId}"
    #         await cur.execute(query)
    #         await conn.commit()    
    #         await cur.close()
    #         conn.close()
            
    #         conn = await utills.createConn()
    #         cur = await conn.cursor()
    #         query=f"UPDATE purchase SET cashflowId={current_cashflowId} WHERE pid={current_pid}"
    #         await cur.execute(query)
    #         await conn.commit()    
    #         await cur.close()
    #         conn.close()
    #         return "success"
    #     except Exception as e:
    #         print(e)
    #         return "database error"
        
    async def find_advAmt_and_outstandingAmt(isBill,supplierId,useremail):
        try:
            # print(useremail)
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=f"SELECT advanceAmount,outstandingAmount FROM purchase WHERE pid=(select pid from purchase where isBill={isBill} and supplierId={supplierId} and useremail='{useremail}' and date = (SELECT MAX(date) FROM purchase WHERE isBill={isBill} and supplierId={supplierId} and useremail='{useremail}')) "
            # query = f"SELECT advanceAmount,outstandingAmount FROM purchase WHERE pid = (SELECT MAX(pid) FROM purchase WHERE isBill={isBill} and supplierId={supplierId})  ORDER BY date DESC"
            await cur.execute(query)
            fetchdata = await cur.fetchall()
            await cur.close()
            conn.close()
            return fetchdata
        except Exception as e:
            print(e)
            return "database error"
        
    async def delete_lastRow_IN_purchase(self):
        try:
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=""
            if(self.isbillvalue==1):
                query = f"DELETE FROM purchase_withbill ORDER BY pid DESC LIMIT 1"
            if(self.isbillvalue==0):
                query = f"DELETE FROM purchase_withoutbill ORDER BY pid DESC LIMIT 1"
            await cur.execute(query)
            await conn.commit()
           
            await cur.close()
            conn.close()
            return "success"
        except Exception as e:
            print(e)
            return "database error"
   