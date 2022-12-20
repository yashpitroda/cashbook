
from flask_cors import CORS #imp
from flask_mysqldb import MySQL
from flask import Flask,request,jsonify

import util



prt = 9000
app = Flask(__name__)
CORS(app)
# app.config['MYSQL_HOST'] = 'localhost'
# app.config['MYSQL_USER'] = 'root'
# app.config['MYSQL_PASSWORD'] = 'yash2020'
# app.config['MYSQL_DB'] = 'cashbook'

# mysql=MySQL(app)
# print(mysql)


@app.route('/clientadd',methods=['POST'])
def clientadd():
    
    value=request.get_json()
    # print(value)
    requird=['cname','cmobileno']
    if not all(key in value for key in requird):
         return {'error':'cname or cmobile will be None or null','status':'fail'},400
        
    cmobileno=value['cmobileno']
    cname=value['cname']
    # print(cname)

    try:
        # query = f"SELECT * FROM client WHERE cmobileno={cmobileno}" #find client in db
        # cursor.execute(query)
        # fatchData=cursor.fetchone() #user is exist or not
        fetchdata=util.findclient(cmobileno) #find client in db
        print(fetchdata) 
        if(fetchdata==None):
            #insert in db
            # query=f"INSERT INTO client(cname,cmobileno) values('{cname}','{cmobileno}')"
            # print(query)
            # cursor.execute(query)
            # mysql.connection.commit()
            status=util.insertclient(cname,cmobileno)
            return {'status':status},200
        return {'status':'Client already exists'},200
    except Exception as e:
        print(e)
        return {'error':e,'status':'fail'},400
        
# @app.route('/clientdelete',method=["POST"])
# def clientdelete():
#     cursor = mysql.connection.cursor()
    
   

    
    # return jsonify('print suceess')

app.run(debug=True,port=prt,host='0.0.0.0')