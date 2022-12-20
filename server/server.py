
from flask_cors import CORS #imp
from flask import Flask,request,jsonify

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
   
        
@app.route('/clientdelete/',methods=['POST'])
def clientdelete():
    value=request.get_json()
    requird=['cmobileno']
    if not all(key in value for key in requird):
         return {'error':'cmobile will be None or null','status':'fail'},400
        
    cmobileno=value['cmobileno']
   
    status=util.deleteclient(cmobileno) #find client in db 
    print(status) 

    return {'status':status},200 #user delted
   



    
   

    


app.run(debug=True,port=prt,host='0.0.0.0')