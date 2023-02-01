import time
import utills
class Purchase():
    def __init__(self,isbillvalue,firmname,bill_amount,c_cr,cash_bank,remark,smobileno,useremail,date,paidamount):
        self.isbillvalue=isbillvalue
        self.firmname=firmname
        self.smobileno=smobileno
        self.useremail=useremail
        self.date=date
        self.cash_bank=cash_bank
        self.bill_amount=bill_amount
        self.outstanding_amount=0
        self.advance_amount=0
        self.paidamount=paidamount
        self.c_cr=c_cr
        self.remark=remark
        
    async def insert_IN_purchase(self):
        try:
            conn = await utills.createConn()
            cur = await conn.cursor()
          
            query = f"INSERT INTO purchase_entry(cash_bank,firmname,isbillvalue,bill_amount,paidamount,advance_amount,outstanding_amount,c_cr,remark,smobileno,useremail,date,cbid) values({self.cash_bank},'{self.firmname}',{self.isbillvalue},{self.bill_amount},{self.paidamount},{self.advance_amount},{self.outstanding_amount},{self.c_cr},'{self.remark}','{self.smobileno}','{self.useremail}','{self.date}',{1})"
            await cur.execute(query)
            await conn.commit()
            # print(cur.lastrowid)
            # print(cur.rowcount)
            pid=cur.lastrowid
            await cur.close()
            conn.close()
            # return "success"
            return pid
        except Exception as e:
            print(e)
            return "database error"
        
    async def insert_IN_purchase_2(self):
        try:
            print("-------")
            print(self.advance_amount)
            print(self.outstanding_amount)
            conn = await utills.createConn()
            cur = await conn.cursor()
            print("q")
            print(self.cash_bank)
            query = f"INSERT INTO purchase_entry(cash_bank,firmname,isbillvalue,bill_amount,paidamount,c_cr,remark,smobileno,useremail,date,cbid) values({self.cash_bank},'{self.firmname}',{self.isbillvalue},{self.bill_amount},{self.paidamount},{self.c_cr},'{self.remark}','{self.smobileno}','{self.useremail}','{self.date}',{1})"
            await cur.execute(query)
            print("q")
            await conn.commit()
            current_pid=cur.lastrowid
            print(current_pid)
            await cur.close()
            conn.close()
            # print(cur.lastrowid)
            # print(cur.rowcount)
            
            print("q")
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=f"SELECT advance_amount,outstanding_amount FROM purchase_entry WHERE pid = (SELECT MAX(pid) FROM purchase_entry WHERE pid<{current_pid} and isbillvalue={self.isbillvalue} and smobileno='{self.smobileno}' and useremail='{self.useremail}')"
            await cur.execute(query)
            fetchdata = await cur.fetchall()
            await cur.close()
            conn.close()
            old_advance_amount=0
            old_outstanding_amount=0
            
            for row in fetchdata:
                old_advance_amount,old_outstanding_amount=row
            current_outstanding_amount=self.bill_amount-self.paidamount+old_outstanding_amount
            if(current_outstanding_amount>old_advance_amount):
                self.advance_amount=0
                self.outstanding_amount=current_outstanding_amount-old_advance_amount
            else:
                self.outstanding_amount=0
                self.advance_amount=-(current_outstanding_amount-old_advance_amount)
            print("-------")
            print(self.advance_amount)
            print(self.outstanding_amount)
            
            
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=f"UPDATE purchase_entry SET advance_amount={self.advance_amount},outstanding_amount={self.outstanding_amount}  WHERE pid={current_pid}"
            await cur.execute(query)
            print("c")
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
                print(row)
                current_cbid,=row
            print(current_cbid)
            
            
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
                print(row)
                old_cash_balance,old_bank_balance=row
            print(current_cbid)
            
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=""
            if(self.cash_bank==1):
                query=f"UPDATE cash_bank SET cash_debit=0,cash_balance={old_cash_balance},bank_balance={old_bank_balance}-bank_balance WHERE cbid={current_cbid}"
            if(self.cash_bank==0):
                query=f"UPDATE cash_bank SET bank_debit=0,cash_balance={old_cash_balance}-cash_balance,bank_balance={old_bank_balance} WHERE cbid={current_cbid}"
            await cur.execute(query)
            print("c")
            await conn.commit()    
            await cur.close()
            conn.close()
                     
            conn = await utills.createConn()
            cur = await conn.cursor()
            query=f"UPDATE purchase_entry SET cbid={current_cbid} WHERE pid={current_pid}"
            await cur.execute(query)
            print("c")
            await conn.commit()    
            await cur.close()
            conn.close()
            return "success"
            # return pid
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
   