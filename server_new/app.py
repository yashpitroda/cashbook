from flask_cors import CORS #imp
from flask import Flask,request,jsonify
from flask_smorest import Api

from models.user_mod import UserModel
from models.supplier import Supplier
from models.purchase import Purchase 
# from models.cashbank import CashBankClass

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


# @app.route('/users/currentuser',methods=['POST'])
# async def usercurrentuser():
#     value=request.get_json()
#     requird=['useremail']
#     if not all(key in value for key in requird):
#          return {'error':'cname or cmobile will be None or null','status':'fail'},400  
#     useremail=value["useremail"] 
    
#     fetchdata=await UserModel.findThisUserwithUserEmail(useremail=useremail) 
#     uid,username,useremail,userimageurl=fetchdata
    
#     result_cb=await CashBankClass.find_cash_bal_and_bank_bal_by_latest_row_in_cashbook_by_useremail(useremail=useremail)
#     for row in result_cb:
#         cash_balance,bank_balance=row
    
#     responsedata={
#         "uid":uid,
#         "username":username,
#         "useremail":useremail,
#         "userimageurl":userimageurl,
#         "cash_balance":cash_balance,
#         "bank_balance":bank_balance
#     } 
#     return {'data':responsedata},200 #user is already exisit so retrun user


@app.route('/supplier/addone',methods=['POST'])
async def supplieraddone():
    """
    {
    "cname": "keval",
    "cmobileno": "98965943",
    "useremail" : "yash@gmail.com"
    }
    """
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
    """
   
    """
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
    """
     {
    "cmobileno": "1234",
    }
    """
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
    """body
    {"useremail":"yashpitroda200@gmail.com"}
    """
    value=request.get_json()
    requird=['useremail']
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
    useremail=value['useremail']
    
    result=await Supplier.fetchAllItemInsupplierTable(useremail=useremail) #result hold list of tupple -- [(),(),()]
   
    supplierTableDataList=[]
    for i in result:
        sid,sname,firmname,smobileno,semail,useremail,entrydatetime=i # i is tupple
        # outstanding_amount_withbill,outstanding_amount_without_bill,advance_amount_with_bill,advance_amount_without_bill
        outstanding_amount_withbill=0
        outstanding_amount_without_bill=0
        advance_amount_with_bill=0
        advance_amount_without_bill=0
        res_withoutbill=await Purchase.find_advAmt_and_outstandingAmt(isBill=0,supplierId=sid)
        for row in res_withoutbill:
            advance_amount_without_bill,outstanding_amount_without_bill=row
            
        res_withbill=await Purchase.find_advAmt_and_outstandingAmt(isBill=1,supplierId=sid)
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
    # print(supplierTableDataList)
    print("/fatchsupplier Completed")
    return {'datalist': supplierTableDataList},200 

@app.route('/purchase/fetchall',methods=['POST'])
async def purchasefetchall():
    """body
    {"useremail":"yashpitroda200@gmail.com"}
    """
    
    """
     useremail:element["puchase_map"]["useremail"].toString() ,
          pid: element["puchase_map"]["pid"].toString(),
          isBill: element["puchase_map"]["isBill"].toString(),
          biilAmount: element["puchase_map"]["biilAmount"].toString(),
          paidAmount: element["puchase_map"]["paidAmount"].toString(),
          outstandingAmount:
              element["puchase_map"]["outstandingAmount"].toString(),
          advanceAmount: element["puchase_map"]["advanceAmount"].toString(),
          date: stirngToDateTmeFormatter.parse(element["puchase_map"]['date']),
          cOrCr: element["puchase_map"]["cOrCr"].toString(),
          cashOrBank: element["puchase_map"]["cashOrBank"].toString(),
          cashBankId: element["puchase_map"]["cashBankId"].toString(),
          remark: element["puchase_map"]["remark"].toString(),
    """
    value=request.get_json()
    requird=['useremail']
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
    useremail=value['useremail']
    
    result=await Purchase.fetchAllItemInpurchaseTable(useremail=useremail) #result hold list of tupple -- [(),(),()]
    print("ss6")
    status=""
    purchaseTableDataList=[]
    for row in result:
        pid,supplierId,accountId,biilAmount,paidAmount,advanceAmount,outstandingAmount,date,remark,cOrCr,isBill,cashflowId,useremail=row # i is tupple
        purchase_map={
            "pid":pid,
            "supplierId":supplierId,
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
         
        temp={"puchase_map":purchase_map,"cashflow_map":cashflow_map,"account_map":account_map}
        purchaseTableDataList.append(temp)
        
    print(purchaseTableDataList)
    print("/fatchsupplier Completed")
    return {"status":status,'datalist': purchaseTableDataList},200 



# @app.route('/purchase/addone/old',methods=['POST'])
# async def purchaseaddone():
#     value=request.get_json()
#     isBill =value [ "isBill"]
#     cOrCr =value ['cOrCr']
#     cashOrBank  =value ['cashOrBank']
#     paidAmount  =value ['paidAmount']
#     billAmount =value [ "billAmount"]
#     updatedAdavanceAmount   =value['updatedAdavanceAmount']
#     updatedOutstandingAmount   =value['updatedOutstandingAmount']
#     sid  =value[ "sid"]
#     firmname =value ['firmname']
#     smobileno  =value ['smobileno']
#     useremail  =value ['useremail']
#     date =value ['date']
#     remark  =value ['remark']
#     new_purchase_obj=Purchase(biilAmount=billAmount,cashOrBank=cashOrBank,cOrCr=cOrCr,date=date,isBill=isBill,paidAmount=paidAmount,remark=remark,supplierId=sid,useremail=useremail)
#     status=await new_purchase_obj.insert_IN_purchase_2()
#     print(status)
#     if(status=="success"):
#         return {'status':status},200
#     else:
#          return {'status':"database error"},200
     
@app.route('/purchase/addone',methods=['POST'])
async def purchaseaddone():
    value=request.get_json()
    isBill =value [ "isBill"]
    cOrCr =value ['cOrCr']
    accountId  =value ['accountId']
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
    new_purchase_obj=Purchase(biilAmount=billAmount,accountId=accountId,cOrCr=cOrCr,date=date,isBill=isBill,paidAmount=paidAmount,remark=remark,supplierId=sid,useremail=useremail)
    status=await new_purchase_obj.insert_IN_purchase_2()
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
    """body
    {"useremail":"yashpitroda200@gmail.com"}
    """
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
    categoryName =value [ "categoryName"]
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
    """body
    {"useremail":"yashpitroda200@gmail.com",
    ""
    }
    """
    value=request.get_json()
    requird=['useremail',"type"]
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
    useremail=value['useremail']
    type=value['type']
    
    query=f"SELECT * FROM category WHERE useremail='{useremail} and type='{type}' ORDER BY  categoryName ASC"
    result=await utills.SELECT_QUERY_FETCHALL(query=query) #result hold list of tupple -- [(),(),()]
    accountTableDataList=[]
    for row in result:
        categoryId,categoryName,useremail,date=row # i is tupple
        temp={
            "categoryId":categoryId,
            "categoryName":categoryName,
            "type":type,
            "useremail":useremail,    
            "date":date,
        }
        accountTableDataList.append(temp)
    # print(supplierTableDataList)
    print("/fatchcategory Completed")
    return {'datalist': accountTableDataList},200 

   


if __name__ == "__main__":
    app.run(port=prt, debug=True,host='0.0.0.0')
