from flask_cors import CORS #imp
from flask import Flask,request,jsonify
from flask_smorest import Api

from models.user_mod import UserModel
from models.supplier import Supplier


prt = 9000
app = Flask(__name__)
CORS(app)

# app.config["PROPAGATE_EXCEPTIONS"] = True
# app.config["API_TITLE"] = "Stores REST API"
# app.config["API_VERSION"] = "v1"
# app.config["OPENAPI_VERSION"] = "3.0.3"
# app.config["OPENAPI_URL_PREFIX"] = "/"
# app.config["OPENAPI_SWAGGER_UI_PATH"] = "/swagger-ui"
# app.config["OPENAPI_SWAGGER_UI_URL"] = "https://cdn.jsdelivr.net/npm/swagger-ui-dist/"

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
        temp={
            "sid":sid,
            "sname":sname,
            "firmname":firmname,
            "smobileno":smobileno,
            "semail":semail,
            "useremail":useremail,    
            "entrydatetime":entrydatetime, #in string   
        }
        supplierTableDataList.append(temp)
    # print(supplierTableDataList)
    print("/fatchsupplier Completed")
    return {'datalist': supplierTableDataList},200 

   
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
