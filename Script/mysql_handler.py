import json
import pymysql

coneccion = pymysql.connect(host='localhost', user='root', password='Unapieza12', db='sk8fortec')
cursor = coneccion.cursor()


def insertar(procedure, request):
    args = [json.dumps(request)]
    cursor.callproc(procedure, args)
    print("Insertado")

def mysql_functions_facade(request):
    #request = json.loads(request)
    #opcode = request['opcode']
    opcode = 5

    request = json.loads('{"dato": [{"Usuario" : {"Nombre" : "Esteban", "Identificacion" : "305210664", \
        "ApellidoPat" : "Campos", "ApellidoMat" : "Granados", "FechaNacimiento" : "1999-01-11", "NumeroTelefonico" : \
        "84473498", "Direccion" : {"Direccion" : "45", "Ciudad" : "Turrialba", "Canton" : "Turrialba", "Provincia" : \
        "Cartago", "Pais" : "Costa Rica"}}, "Puntos" : -1}]}')
    print(request["dato"][0]["Usuario"])

    if opcode == 0:
        insertar('InsercionArticulos', request['dato'])
    elif opcode == 1:
        insertar('InsercionProductos', request['dato'])
    elif opcode == 2:
        insertar('InsercionMarca', request['dato'])
    elif opcode == 3:
        insertar('InsercionActualizacionArticuloPunto', request['dato'])
    elif opcode == 4:
        insertar('InsercionEmpleados', request['dato'])
    elif opcode == 5:
        insertar('InsertarClientes', request['dato'])
    elif opcode == 6:
        insertar('InsertarPuntosCliente', request['dato'])
    elif opcode == 7:
        insertar('InsertarPuestoEmpleado', request['dato'])
    else:
        print("Wrong opcode")

mysql_functions_facade("")
