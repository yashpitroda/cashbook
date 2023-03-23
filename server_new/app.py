from flask_cors import CORS #imp
from flask import Flask,request,jsonify
from flask_smorest import Api

from models.user_mod import UserModel
from models.supplier import Supplier
from models.purchase import Purchase 

import utills

prt = 9000
app = Flask(__name__)
CORS(app)

@app.route('/users/addone',methods=['POST'])
async def useraddone():
    value=request.get_json()
    requird=['username','useremail','userimageurl']
    if not all(key in value for key in requird):
         return {'error':'cname or cmobile will be None or null','status':'fail'},400   
    new_user=UserModel(username=value['username'],useremail=value['useremail'],userimageurl=value['userimageurl'])   
    fetchdata=await new_user.findThisUser() #find user in db 
    # fetchdata=await UserModel.find_user(new_user) #find user in db 
    if(fetchdata==None):
        # insert in db
        status=await new_user.inserThisUser()
        # status=await UserModel.inserThisUser(new_user)
        return {'status':status},200
    return {'status':fetchdata},200 #user is already exisit so retrun user


@app.route('/supplier/addone',methods=['POST'])
async def supplieraddone():
    value=request.get_json()
    requird=['sname','smobileno','semail','useremail',"entrydatetime","firmname"]
    if not all(key in value for key in requird):
         return {'error':'cname or cmobile will be None or null','status':'fail'},400
    
    new_supplier=Supplier(firmname=value['firmname'],sname=value['sname'],semail=value['semail'],smobileno=value['smobileno'],entrydatetime=value['entrydatetime'],useremail=value['useremail'])
    
    fetchdata=await new_supplier.findsupplier() #find supplier in db 
    # print(fetchdata) 
        # go without email
    if(fetchdata==None):
        # insert in db
        status=await new_supplier.insertsupplier()
        print("/supplieradd Completed") 
        return {'status':status},200
    print("/supplieradd Completed") 
    return {'status':fetchdata},200 #user is already exisit so retrun user

@app.route('/supplier/updateone',methods=['POST'])
async def supplierupdateone():
    value=request.get_json()
    requird=['sname','smobileno','semail','useremail',"entrydatetime","firmname","oldcmobileno"]
    if not all(key in value for key in requird):
         return {'error':'cname or cmobile will be None or null','status':'fail'},400
     
    updated_supplier=Supplier(firmname=value['firmname'],sname=value['sname'],semail=value['semail'],smobileno=value['smobileno'],entrydatetime=value['entrydatetime'],useremail=value['useremail'])
    oldcmobileno=value['oldcmobileno']

    status=await updated_supplier.updatesupplier(oldcmobileno)
    print("/supplierupdate Completed") 
    return {'status':status},200

@app.route('/supplier/deleteone',methods=['POST'])
async def supplierdeleteone():
    value=request.get_json()
    requird=['smobileno','useremail']
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
        
    smobileno=value['smobileno']
    useremail=value['useremail']
   
    status=await Supplier.deletesupplier(smobileno=smobileno,useremail=useremail) #find supplier in db 
    # print(status)
    print("/supplierdelete Completed") 

    return {'status':status},200 #user delted

@app.route('/supplier/fetchall',methods=['POST'])
async def supplierfetchall():
    value=request.get_json()
    requird=['useremail']
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
    useremail=value['useremail']
    
    result=await Supplier.fetchAllItemInsupplierTable(useremail=useremail) #result hold list of tupple -- [(),(),()]
   
    supplierTableDataList=[]
    for i in result:
        sid,sname,firmname,smobileno,semail,useremail,entrydatetime=i # i is tupple
        outstanding_amount_withbill=0
        outstanding_amount_without_bill=0
        advance_amount_with_bill=0
        advance_amount_without_bill=0
        res_withoutbill=await Purchase.find_advAmt_and_outstandingAmt(isBill=0,supplierId=sid,useremail=useremail)
        for row in res_withoutbill:
            advance_amount_without_bill,outstanding_amount_without_bill=row
            
        res_withbill=await Purchase.find_advAmt_and_outstandingAmt(isBill=1,supplierId=sid,useremail=useremail)
        for row1 in res_withbill:
            advance_amount_with_bill,outstanding_amount_withbill=row1
        temp={
            "sid":sid,
            "sname":sname,
            "firmname":firmname,
            "smobileno":smobileno,
            "semail":semail,
            "useremail":useremail,    
            "entrydatetime":entrydatetime, #in string   
            "outstanding_amount_withbill":outstanding_amount_withbill, #in string   
            "outstanding_amount_without_bill":outstanding_amount_without_bill, #in string   
            "advance_amount_with_bill":advance_amount_with_bill, #in string   
            "advance_amount_without_bill":advance_amount_without_bill, #in string   
        }
        supplierTableDataList.append(temp)
    print("/fatchsupplier Completed")
    return {'datalist': supplierTableDataList},200 

@app.route('/purchase/fetchall',methods=['POST'])
async def purchasefetchall():
    value=request.get_json()
    requird=['useremail']
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
    useremail=value['useremail']
    
    result=await Purchase.fetchAllItemInpurchaseTable(useremail=useremail) #result hold list of tupple -- [(),(),()]
    status=""
    purchaseTableDataList=[]
    for row in result:
        pid,supplierId,categoryId,accountId,biilAmount,paidAmount,advanceAmount,outstandingAmount,date,remark,cOrCr,isBill,cashflowId,useremail=row # i is tupple
        purchase_map={
            "pid":pid,
            "supplierId":supplierId,
            "categoryId":categoryId,
            "biilAmount":biilAmount,
            "paidAmount":paidAmount,
            "advanceAmount":advanceAmount,    
            "outstandingAmount":outstandingAmount, #in string   
            "date":date, #in string   
            "remark":remark, #in string   
            "isBill":isBill, #in string   
            "cOrCr":cOrCr, #in string   
            "accountId":accountId, #in string   
            "cashflowId":cashflowId, #in string   
            "useremail":useremail, #in string   
        }
        print("result_category")
        query = f"SELECT * FROM category WHERE categoryId={categoryId}"
        
        result_category=await utills.SELECT_QUERY_FETCHALL(query=query)
        print(result_category)
        
        for row_ in result_category:
            categoryId,categoryName,type,useremail,date=row_
            category_map={
                "categoryId":categoryId,
                "categoryName":categoryName,
                "type":type,
                "useremail":useremail,
                "date":date,
            }
        query = f"SELECT * FROM cashflow WHERE cashflowId={cashflowId}"
        result_cashflow=await utills.SELECT_QUERY_FETCHALL(query=query)
        if(result=="database error" or result_cashflow=="database error"):
            status="error"
        else:
            status="success"
        # print(result_cashbank)
        for row1 in result_cashflow:
            cashflowId,date,accountId,debit,credit,balance,particulars,useremail=row1
            cashflow_map={
                "cashflowId":cashflowId,
                "accountId":accountId,
                "date":date,
                "debit":debit,
                "credit":credit,
                "balance":balance,    
                "particulars":particulars,
                "useremail":useremail,
            }
            
        query = f"SELECT * FROM account WHERE accountId={accountId}"
        result_account=await utills.SELECT_QUERY_FETCHALL(query=query)
        for row2 in result_account:
            accountId,accountName,date,useremail=row2
            account_map={
                "accountId":accountId,
                "date":date,
                "accountName":accountName,
                "balance":balance,    
                "useremail":useremail, 
            }
         
        temp={"puchase_map":purchase_map,"cashflow_map":cashflow_map,"account_map":account_map,"category_map":category_map}
        purchaseTableDataList.append(temp)
        
    # print(purchaseTableDataList)
    print("/fatchpurchase Completed")
    return {"status":status,'datalist': purchaseTableDataList},200 
     
@app.route('/purchase/addone',methods=['POST'])
async def purchaseaddone():
    value=request.get_json()
    isBill =value [ "isBill"]
    cOrCr =value ['cOrCr']
    accountId  =value ['accountId']
    categoryId  =value ['categoryId']
    paidAmount  =value ['paidAmount']
    billAmount =value [ "billAmount"]
    updatedAdavanceAmount  =value['updatedAdavanceAmount']
    updatedOutstandingAmount   =value['updatedOutstandingAmount']
    sid  =value[ "sid"]
    firmname =value ['firmname']
    smobileno  =value ['smobileno']
    useremail  =value ['useremail']
    date =value ['date']
    remark  =value ['remark']
    new_purchase_obj=Purchase(biilAmount=billAmount,accountId=accountId,categoryId=categoryId,cOrCr=cOrCr,date=date,isBill=isBill,paidAmount=paidAmount,remark=remark,supplierId=sid,useremail=useremail)
    status=await new_purchase_obj.insert_IN_purchase()
    print(status)
    if(status=="success"):
        return {'status':status},200
    else:
         return {'status':"database error"},200
     

     
@app.route('/account/addone',methods=['POST'])
async def accountaddone():
    value=request.get_json()
    print(value)
    accountName =value [ "accountName"]
    initialAmount =value ['initialAmount']
    date  =value ['date']
    useremail  =value ['useremail']
    
    # insert in account
    query=f"INSERT INTO account (accountName, date, useremail) VALUES ('{accountName}', '{date}', '{useremail}');"
    res_map1= await utills.INSERT_DELETE_UPDATE_QUERY(query=query)
    accountId=res_map1['id']
    print(accountId)
    
    query2=f"INSERT INTO cashflow(date,accountId,useremail,credit,balance) VALUES ('{date}','{accountId}','{useremail}','{initialAmount}','{initialAmount}');"
    res_map2= await utills.INSERT_DELETE_UPDATE_QUERY(query=query2)
    
    if((res_map1['status']=="success") and (res_map2['status']=="success")):
        return {'status':"success"},200
    else:
        return {'status':"database error"},200
    
@app.route('/account/fetchall',methods=['POST'])
async def accountfetchall():
    value=request.get_json()
    requird=['useremail']
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
    useremail=value['useremail']
    
    query=f"SELECT * FROM account WHERE useremail='{useremail}' ORDER BY accountName ASC"
    result=await utills.SELECT_QUERY_FETCHALL(query=query) #result hold list of tupple -- [(),(),()]
    accountTableDataList=[]
    for row in result:
        accountId,accountName,date,useremail=row # i is tupple
        query=f"SELECT balance FROM cashflow WHERE cashflowId = (SELECT MAX(cashflowId) FROM cashflow WHERE accountId={accountId} and useremail='{useremail}')"
        result2=await utills.SELECT_QUERY_FETCHALL(query=query) #result hold list of tupple -- [(),(),()]
        for row in result2:
                balance,=row
        temp={
            "accountId":accountId,
            "accountName":accountName,
            "date":date,
            "balance":balance,
            "useremail":useremail,    
        }
        accountTableDataList.append(temp)
    # print(supplierTableDataList)
    print("/fatchAccount Completed")
    return {'datalist': accountTableDataList},200 

@app.route('/category/addone',methods=['POST'])
async def categoryaddone():
    value=request.get_json()
    print(value)
    categoryName =value [ 'categoryName']#categorytName
    type =value ['type']
    date  =value ['date']
    useremail  =value ['useremail']
    
    # insert in account
    query=f"INSERT INTO category (categoryName, date, useremail,type) VALUES ('{categoryName}', '{date}', '{useremail}','{type}');"
    res_map= await utills.INSERT_DELETE_UPDATE_QUERY(query=query)
    categoryId=res_map['id']

    if((res_map['status']=="success")):
        return {'status':"success"},200
    else:
        return {'status':"database error"},200
    
@app.route('/category/fetchall',methods=['POST'])
async def categoryfetchall():
    value=request.get_json()
    requird=['useremail',"type"]
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
    useremail=value['useremail']
    type=value['type']
    
    query=f"SELECT * FROM category WHERE useremail='{useremail}' and type='{type}' ORDER BY categoryName ASC"
    result=await utills.SELECT_QUERY_FETCHALL(query=query) #result hold list of tupple -- [(),(),()]
    accountTableDataList=[]
    for row in result:
        categoryId,categoryName,type,useremail,date=row # i is tupple
        temp={
            "categoryId":categoryId,
            "categoryName":categoryName,#categorytName
            "type":type,
            "useremail":useremail,    
            "date":date,
        }
       
        accountTableDataList.append(temp)
    # print(supplierTableDataList)
    print("/fatchcategory Completed")
    return {'datalist': accountTableDataList},200


  

@app.route('/test',methods=['POST'])
async def test():
    
    # value=request.get_json()
    # requird=['useremail',"type","accountId"]
    # if not all(key in value for key in requird):
    #      return {'error':'cmobile will be None or null','status':'fail'},400
    # useremail=value['useremail']
    # type=value['type']
    # accountId=value["accountId"]
    
    conn = await utills.createConn()
    cur = await conn.cursor()
    # query=f"SELECT balance FROM cashflow where cashflowId=(SELECT max(cashflowId) FROM cashflow where cashflowId<{current_cashflowId} and accountId={self.accountId} and useremail='{self.useremail}')"
    query=f"SELECT balance FROM cashflow where accountId={36} and useremail='yashpitroda200@gmail.com' and date=(SELECT MAX(date) FROM cashflow WHERE date<(SELECT date FROM cashflow WHERE cashflowId={187}) and accountId={36} and useremail='yashpitroda200@gmail.com')"
    
    await cur.execute(query)
    fetchdata = await cur.fetchall()
    await cur.close()
    conn.close()
    old_balance=0 
    for row in fetchdata:
        old_balance,=row
    print(old_balance)
    print("com")
    # print(supplierTableDataList)
    print("/fatchcategory Completed")
    return {'datalist': old_balance},200 

   


if __name__ == "__main__":
    app.run(port=prt, debug=True,host='0.0.0.0')
