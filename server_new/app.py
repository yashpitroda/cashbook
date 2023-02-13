from flask_cors import CORS #imp
from flask import Flask,request,jsonify
from flask_smorest import Api

from models.user_mod import UserModel
from models.supplier import Supplier
from models.purchase import Purchase 
from models.cashbank import CashBankClass

prt = 9000
app = Flask(__name__)
CORS(app)


@app.route('/addinpurchase',methods=['POST'])
async def addinpurchase():
    value=request.get_json()
    isBill =value [ "isBill"]
    cOrCr =value ['cOrCr']
    cashOrBank  =value ['cashOrBank']
    paidAmount  =value ['paidAmount']
    billAmount =value [ "billAmount"]
    updatedAdavanceAmount   =value['updatedAdavanceAmount']
    updatedOutstandingAmount   =value['updatedOutstandingAmount']
    sid  =value[ "sid"]
    firmname =value ['firmname']
    smobileno  =value ['smobileno']
    useremail  =value ['useremail']
    date =value ['date']
    remark  =value ['remark']
    new_purchase_obj=Purchase(biilAmount=billAmount,cashOrBank=cashOrBank,cOrCr=cOrCr,date=date,isBill=isBill,paidAmount=paidAmount,remark=remark,supplierId=sid,useremail=useremail)
    status=await new_purchase_obj.insert_IN_purchase_2()
   
    print(status)
    if(status=="success"):
        return {'status':status},200
    else:
         return {'status':"database error"},200
    

@app.route('/useradd',methods=['POST'])
async def useradd():
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


@app.route('/supplieradd',methods=['POST'])
async def supplieradd():
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

       
@app.route('/supplierdelete',methods=['POST'])
async def supplierdelete():
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

@app.route('/fetchsupplier',methods=['POST'])
async def fetchsupplier():
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

@app.route('/fetchpurchase',methods=['POST'])
async def fetchpurchase():
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
        pid,supplierId,biilAmount,paidAmount,advanceAmount,outstandingAmount,date,remark,isBill,cOrCr,cashOrBank,cashBankId,useremail=row # i is tupple
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
            "cashOrBank":cashOrBank, #in string   
            "cashBankId":cashBankId, #in string   
            "useremail":useremail, #in string   
        }
       
        result_cashbank=await CashBankClass.find_one_IN_CashBank_BY_CBID(cbid=cashBankId)
        if(result=="database error" or result_cashbank=="database error"):
            status="error"
        else:
            status="success"
        # print(result_cashbank)
        for row1 in result_cashbank:
            cbid,is_paymentmode,date,cash_debit,bank_debit,cash_credit,bank_credit,cash_balance,bank_balance,particulars,useremail=row1
            cash_bank_map={
                "cbid":cbid,
                "is_paymentmode":is_paymentmode,
                "date":date,
                "cash_debit":cash_debit,
                "bank_debit":bank_debit,
                "cash_credit":cash_credit,    
                "bank_credit":bank_credit, #in string   
                "cash_balance":cash_balance, #in string   
                "bank_balance":bank_balance, #in string   
                "particulars":particulars, #in string   
                "useremail":useremail, #in string   
            }
         
        temp={"puchase_map":purchase_map,"cash_bank_map":cash_bank_map}
        purchaseTableDataList.append(temp)
        
    # print(supplierTableDataList)
    print("/fatchsupplier Completed")
    return {"status":status,'datalist': purchaseTableDataList},200 

   
@app.route('/supplierupdate',methods=['POST'])
async def supplierupdate():
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

if __name__ == "__main__":
    app.run(port=prt, debug=True,host='0.0.0.0')
