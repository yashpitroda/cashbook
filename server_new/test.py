from flask_cors import CORS #imp
from flask import Flask,request,jsonify
from flask_smorest import Api

import mysql.connector

prt = 9000
app = Flask(__name__)
CORS(app)

@app.route('/test',methods=['GET'])
def test():
        
    cnx = mysql.connector.connect(user='root', database='cashbook', password="yash2020",)
    cnx.autocommit=True
    cursor = cnx.cursor()
    query="INSERT INTO test value ('ccc');"
    cursor.execute(query)
    
   
    # cnx.commit()
    cursor.close()
    cnx.close()

    return {'status':""},200 #user is already exisit so retrun user


if __name__ == "__main__":
    app.run(port=prt, debug=True,host='0.0.0.0')
