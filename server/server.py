
from flask_cors import CORS #imp
from flask import Flask,request,jsonify
import json

import util

prt = 9000
app = Flask(__name__)
CORS(app)



@app.route('/clientadd',methods=['POST'])
def clientadd():
    value=request.get_json()
    requird=['cname','cmobileno']
    if not all(key in value for key in requird):
         return {'error':'cname or cmobile will be None or null','status':'fail'},400
        
    cmobileno=value['cmobileno']
    cname=value['cname']
    # print(cname)

    fetchdata=util.findclient(cmobileno) #find client in db 
    print(fetchdata) 
    
    if(fetchdata==None):
        # insert in db
        status=util.insertclient(cname,cmobileno)
        return {'status':status},200
    
    return {'status':fetchdata},200 #user is already exisit so retrun user
   
        
@app.route('/clientdelete',methods=['POST'])
def clientdelete():
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
    "paymentmode" :"cash"
    }
    """
    value=request.get_json()
    requird=["cmobileno","paisbill","padescription","paamount","paymentmode"]
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
        
    cmobileno=value['cmobileno'] #string
    paisbill=int(value['paisbill']) #int
    padescription=value['padescription'] #stirng
    paamount=float(value['paamount']) #doble
    paymentmode=value['paymentmode'] #stirng
   
    status=util.addItemInPaidTable(cmobileno,padescription,paisbill,paymentmode,paamount) #find client in db 
    print(status) 

    return {'status':status},200 #user delted

@app.route('/additeminpayabletable',methods=['POST'])
def additeminpayabletable():
    """body
    {
    "cmobileno": "1234",
    "pyisbill": "1",
    "pydescription": "flsfjfsjf",
    "pyamount": "1000.12"
    }
    """
    value=request.get_json()
    requird=["cmobileno","pyisbill","pydescription","pyamount"]
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
        
    cmobileno=value['cmobileno'] #string
    pyisbill=int(value['pyisbill']) #int
    pydescription=value['pydescription'] #stirng
    pyamount=float(value['pyamount']) #doble

   
    status=util.addItemInPayableTable(cmobileno,pydescription,pyisbill,pyamount) #find client in db 
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
        sno,cmobileno,padate,paisbill,padescription,pamount,paymentmode=i
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
        sno,cmobileno,pydate,pyisbill,pydescription,pyamount=i
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






app.run(debug=True,port=prt,host='0.0.0.0')