import pymysql
import json


def conectar_mysql():
    coneccion = pymysql.connect(host='localhost', user='root', password='Unapieza12', db='sk8fortec')
    cursor = coneccion.cursor()
    cursor.execute("SELECT * FROM Usuario;")
    print(cursor.fetchall())

