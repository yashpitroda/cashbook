import utills
class CashBankClass():
    def __init__(self,cbid,is_paymentmode,date,cash_debit,bank_debit,cash_credit,bank_credit,cash_balance,bank_balance,particulars,useremail):
        self.cbid=cbid
        self.date=date
        self.is_paymentmode=is_paymentmode
        self.cash_debit=cash_debit
        self.bank_debit=bank_debit
        self.cash_credit=cash_credit
        self.bank_credit=bank_credit
        self.cash_balance=cash_balance
        self.bank_balance=bank_balance
        self.particulars=particulars
        self.useremail=useremail
        
    async def find_one_IN_CashBank_BY_CBID(cbid):
        try:
            conn = await utills.createConn()
            cur = await conn.cursor()
            query = f"SELECT * FROM cash_bank WHERE cbid={cbid}"
            await cur.execute(query) 
            fetchdata = await cur.fetchall()
            await cur.close()
            conn.close()
            return fetchdata
        except Exception as e:
            print(e)
            return "database error"
    
    async def find_cash_bal_and_bank_bal_by_latest_row_in_cashbook_by_useremail(useremail):
        query = f"SELECT cash_balance,bank_balance FROM cash_bank where cbid=(SELECT max(cash_bank.cbid) FROM cash_bank where useremail='{useremail}')"
        r=await utills.SELECT_QUERY_FETCHALL(query)
        return r
        # try:
        #     conn = await utills.createConn()
        #     cur = await conn.cursor()
        #     query = f"SELECT cash_balance,bank_balance FROM cash_bank where cbid=(SELECT max(cash_bank.cbid) FROM cash_bank where useremail='{useremail}')"
        #     await cur.execute(query) 
        #     fetchdata = await cur.fetchall()
        #     await cur.close()
        #     conn.close()
        #     return fetchdata
        # except Exception as e:
        #     print(e)
        #     return "database error"