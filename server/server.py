
from flask_cors import CORS #imp
from flask import Flask,request,jsonify
import json
import util

prt = 9000
app = Flask(__name__)
CORS(app)

@app.route('/useradd',methods=['POST'])
async def useradd():
    value=request.get_json()
    requird=['username','useremail','userimageurl']
    if not all(key in value for key in requird):
         return {'error':'cname or cmobile will be None or null','status':'fail'},400
        
    username=value['username']
    useremail=value['useremail']
    userimageurl='aa'
    print(useremail)

    fetchdata=await util.finduser(useremail) #find user in db 
    print(fetchdata,"Aaaaa") 
    
    if(fetchdata==None):
        # insert in db
        status=util.insertuser(username,useremail,userimageurl)
        return {'status':status},200
    
    return {'status':fetchdata},200 #user is already exisit so retrun user

@app.route('/clientadd',methods=['POST'])
def clientadd():
    """
    {
    "cname": "keval",
    "cmobileno": "98965943",
    "useremail" : "yash@gmail.com"
    }
    """
    value=request.get_json()
    requird=['cname','cmobileno','useremail']
    if not all(key in value for key in requird):
         return {'error':'cname or cmobile will be None or null','status':'fail'},400
        
    cmobileno=value['cmobileno']
    cname=value['cname']
    useremail=value['useremail']
    # print(cname)

    fetchdata=util.findclient(cmobileno) #find client in db 
    print(fetchdata) 
    
    if(fetchdata==None):
        # insert in db
        status=util.insertclient(cname,cmobileno,useremail)
        return {'status':status},200
    
    return {'status':fetchdata},200 #user is already exisit so retrun user
   
        
@app.route('/clientdelete',methods=['POST'])
def clientdelete():
    """
     {
    "cmobileno": "1234",
    }
    """
    value=request.get_json()
    requird=['cmobileno']
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
        
    cmobileno=value['cmobileno']
   
    status=util.deleteclient(cmobileno) #find client in db 
    print(status) 

    return {'status':status},200 #user delted

@app.route('/additeminpaidtable',methods=['POST'])
def additeminpaidtable():
    """body
    {
    "cmobileno": "1234",
    "paisbill": "1",
    "padescription": "flsfjfsjf",
    "paamount": "1000.12",
    "paymentmode" :"cash",
    "useremail" : "yash@gmail.com"
    }
    """
    value=request.get_json()
    requird=["cmobileno","paisbill","padescription","paamount","paymentmode","useremail"]
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
        
    cmobileno=value['cmobileno'] #string
    paisbill=int(value['paisbill']) #int
    padescription=value['padescription'] #stirng
    paamount=float(value['paamount']) #doble
    paymentmode=value['paymentmode'] #stirng
    useremail=value["useremail"] #stirng
   
    status=util.addItemInPaidTable(cmobileno,padescription,paisbill,paymentmode,paamount,useremail) #find client in db 
    print(status) 

    return {'status':status},200 #user delted

@app.route('/additeminpayabletable',methods=['POST'])
def additeminpayabletable():
    """body
    {
    "cmobileno": "1234",
    "pyisbill": "1",
    "pydescription": "flsfjfsjf",
    "pyamount": "1000.12",
    "useremail" : "yash@gmail.com"
    }
    """
    value=request.get_json()
    requird=["cmobileno","pyisbill","pydescription","pyamount","useremail"]
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
        
    cmobileno=value['cmobileno'] #string
    pyisbill=int(value['pyisbill']) #int
    pydescription=value['pydescription'] #stirng
    pyamount=float(value['pyamount']) #doble
    useremail=value['useremail'] #doble

   
    status=util.addItemInPayableTable(cmobileno,pydescription,pyisbill,pyamount,useremail) 
    print(status) 

    return {'status':status},200 #user delted

@app.route('/deleteiteminpayabletable',methods=['POST'])
def deleteiteminpayabletable():
    """body
    {
    "sno":"1"
    }
    """
    value=request.get_json()
    requird=["sno"]
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
        
    sno=int(value['sno']) #string
    status=util.deleteItemInPayableTable(sno) 
    print(status) 

    return {'status':status},200 

@app.route('/deleteiteminpaidtable',methods=['POST'])
def deleteiteminpaidtable():
    """body
    {
    "sno":"1"
    }
    """
    value=request.get_json()
    requird=["sno"]
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
        
    sno=int(value['sno']) #string
    status=util.deleteItemInPaidTable(sno) 
    print(status) 

    return {'status':status},200 

@app.route('/fetchallpaidtable',methods=['POST'])
def fetchallpaidtable():
    """body
    
    """
    result=util.fetchAllItemInPaidTable() #result hold list of tupple -- [(),(),()]
    """
    {
    "datalist": [
        {
        "cmobileno": "1234",
        "padate": "Thu, 22 Dec 2022 11:42:47 GMT",
        "padescription": "flsfjfsjf",
        "paisbill": 1,
        "pamount": 1000.12,
        "paymentmode": "cash",
        "sno": 1
        },
        {
        "cmobileno": "1234",
        "padate": "Thu, 22 Dec 2022 11:42:47 GMT",
        "padescription": "flsfjfsjf",
        "paisbill": 1,
        "pamount": 1000.12,
        "paymentmode": "cash",
        "sno": 3
        }
    ]
    }
    """
    # print(result) 
    # print(jsonify(result)) 
    #dumps : is used to convert all row into list form:[] 
    # print(json.dumps(result,default=str)) #default=str mean covert all paramiter to stirng 
    # print(json.decode(response.body)); -- frented side
    # listOfPaidTableData=json.dumps(result,default=str)
    
    PaidTableDataList=[]
    for i in result:
        sno,cmobileno,padate,paisbill,padescription,pamount,paymentmode=i # i is tupple
        temp={
            "sno":sno,
            "cmobileno":cmobileno,
            "padate":padate,
            "paisbill":paisbill,
            "padescription":padescription,
            "pamount":pamount,
            "paymentmode":paymentmode,
        }
        PaidTableDataList.append(temp)
    print(PaidTableDataList)
    return {'datalist': PaidTableDataList},200 


@app.route('/fetchallpayabletable',methods=['POST'])
def fetchallpayabletable():
    """body
    
    """
    result=util.fetchAllItemInPayableTable() #result hold list of tupple -- [(),(),()]
    """
    {
    "datalist": 
        [
            {
            "cmobileno": "1234",
            "padate": "Thu, 22 Dec 2022 14:39:16 GMT",
            "padescription": "flsfjfsjf",
            "paisbill": 1,
            "pamount": 7889.12,
            "sno": 3
            },
            {
            "cmobileno": "1234",
            "padate": "Thu, 22 Dec 2022 14:39:28 GMT",
            "padescription": "flsfjfsjf",
            "paisbill": 1,
            "pamount": 3422.12,
            "sno": 4
            },
        ]
    }
    """
    PayableTableDataList=[]
    for i in result:
        sno,cmobileno,pydate,pyisbill,pydescription,pyamount=i # i is tupple
        temp={
            "sno":sno,
            "cmobileno":cmobileno,
            "pydate":pydate,
            "pyisbill":pyisbill,
            "pydescription":pydescription,
            "pyamount":pyamount,
        }
        PayableTableDataList.append(temp)
    print(PayableTableDataList)
    return {'datalist': PayableTableDataList},200 

@app.route('/updateiteminpayabletable',methods=['POST'])
def updateiteminpayabletable():
    """body
    {
    "sno":"5",
    "cmobileno": "1234",
    "pyisbill": "0",
    "pydescription": "i am yash",
    "pyamount": "1111.55"
    }
    """
    value=request.get_json()
    requird=["sno",'cmobileno','pyisbill','pydescription','pyamount']
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
        
    sno=int(value['sno']) 
    new_cmobileno=value['cmobileno'] #string
    new_pyisbill=int(value['pyisbill']) #int
    new_pydescription=value['pydescription'] #stirng
    new_pyamount=float(value['pyamount']) #doble
    
    status=util.updateItemInPayableTable(sno,new_cmobileno,new_pyisbill,new_pydescription,new_pyamount) 
    return {'status':status},200 


@app.route('/updateiteminpaidtable',methods=['POST'])
def updateiteminpaidtable():
    """body
    {
    "sno":"5",
    "cmobileno": "1234",
    "paisbill": "0",
    "padescription": "i am yash",
    "paamount": "1111.55",
    "paymentmode":"cash"
    }
    """
    value=request.get_json()
    requird=["sno",'cmobileno','paisbill','padescription','paamount',"paymentmode"]
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
        
    sno=int(value['sno']) 
    new_cmobileno=value['cmobileno'] #string
    new_paisbill=int(value['paisbill']) #int
    new_padescription=value['padescription'] #stirng
    new_paamount=float(value['paamount']) #doble
    new_paymentmode=value["paymentmode"] #string
    
    status=util.updateItemInPaidTable(sno,new_cmobileno,new_paisbill,new_padescription,new_paamount,new_paymentmode) 
    return {'status':status},200 


app.run(debug=True,port=prt,host='0.0.0.0')
