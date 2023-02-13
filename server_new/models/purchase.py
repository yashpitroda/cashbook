import time
import utills

class Purchase():
    def __init__(self,biilAmount,paidAmount,cashOrBank,remark,date,cOrCr,isBill,supplierId,useremail):
        self.biilAmount=biilAmount
        self.paidAmount=paidAmount
        self.advanceAmount=0
        self.outstandingAmount=0
        self.date=date
        self.remark=remark
        self.cashOrBank=cashOrBank
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
        
    async def insert_IN_purchase_2(self):
        try:
            conn = await utills.createConn()
            cur = await conn.cursor()
            # print(self.cash_bank)
            query = f"INSERT INTO purchase(supplierId,cashOrBank,isBill,biilAmount,paidAmount,cOrCr,remark,useremail,date,cashBankId) values({self.supplierId},{self.cashOrBank},{self.isBill},{self.biilAmount},{self.paidAmount},{self.cOrCr},'{self.remark}','{self.useremail}','{self.date}',{1})"
            await cur.execute(query)
            await conn.commit()
            current_pid=cur.lastrowid
            print(current_pid)
            await cur.close()
            conn.close()
            
            # print(cur.lastrowid)
            # print(cur.rowcount)
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=f"SELECT advanceAmount,outstandingAmount FROM purchase WHERE pid = (SELECT MAX(pid) FROM purchase WHERE pid<{current_pid} and isBill={self.isBill} and supplierId='{self.supplierId}' and useremail='{self.useremail}')"
            await cur.execute(query)
            fetchdata = await cur.fetchall()
            await cur.close()
            conn.close()
            old_advance_amount=0
            old_outstanding_amount=0
            for row in fetchdata:
                old_advance_amount,old_outstanding_amount=row
            current_outstanding_amount=self.biilAmount-self.paidAmount+old_outstanding_amount
            if(current_outstanding_amount>old_advance_amount):
                self.advanceAmount=0
                self.outstandingAmount=current_outstanding_amount-old_advance_amount
            else:
                self.outstandingAmount=0
                self.advanceAmount=-(current_outstanding_amount-old_advance_amount)
            # print("-------")
            # print(self.advance_amount)
            # print(self.outstanding_amount)
            
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=f"UPDATE purchase SET advanceAmount={self.advanceAmount},outstandingAmount={self.outstandingAmount}  WHERE pid={current_pid}"
            await cur.execute(query)
            await conn.commit()    
            await cur.close()
            conn.close()
            
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=f"SELECT max(cash_bank.cbid) FROM cash_bank where useremail='{self.useremail}'"
            await cur.execute(query)
            fetchdata = await cur.fetchall()
            await cur.close()
            conn.close()
            current_cbid=0 
            for row in fetchdata:
                current_cbid,=row
            # print(current_cbid)
            
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=f"SELECT cash_balance,bank_balance FROM cash_bank where cbid=(SELECT max(cash_bank.cbid) FROM cash_bank where cbid<{current_cbid})"
            await cur.execute(query)
            fetchdata = await cur.fetchall()
            await cur.close()
            conn.close()
            old_bank_balance=0 
            old_cash_balance=0 
            for row in fetchdata:
                old_cash_balance,old_bank_balance=row
                
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=""
            if(self.cashOrBank==1):
                query=f"UPDATE cash_bank SET cash_debit=0,cash_balance={old_cash_balance},bank_balance={old_bank_balance}-bank_balance WHERE cbid={current_cbid}"
            if(self.cashOrBank==0):
                query=f"UPDATE cash_bank SET bank_debit=0,cash_balance={old_cash_balance}-cash_balance,bank_balance={old_bank_balance} WHERE cbid={current_cbid}"
            await cur.execute(query)
            await conn.commit()    
            await cur.close()
            conn.close()
            
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=f"UPDATE purchase SET cashBankId={current_cbid} WHERE pid={current_pid}"
            await cur.execute(query)
            await conn.commit()    
            await cur.close()
            conn.close()
            return "success"
        except Exception as e:
            print(e)
            return "database error"
        
    async def find_advAmt_and_outstandingAmt(isBill,supplierId):
        try:
            # print(useremail)
            conn = await utills.createConn()
            cur = await conn.cursor()
            query = f"SELECT advanceAmount,outstandingAmount FROM purchase WHERE pid = (SELECT MAX(pid) FROM purchase WHERE isBill={isBill} and supplierId={supplierId})  ORDER BY date DESC"
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
   