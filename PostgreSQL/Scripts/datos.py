import psycopg2
import pymysql
import json

conn_p = 0
cur_p = 0

conn_m = [0, 0, 0]
cur_m = [0, 0, 0]

## Manejo de PostgreSQL


def conectar_PostgreSQL():
    global conn_p, cur_p
    conn_p = psycopg2.connect(user='postgres', password='estebandcg1999',host='192.168.43.58', dbname='postgres')
    cur_p = conn_p.cursor()
    #print("Conexion con PostgreSQL completada!")


def conectar_MySQL():
    global conn_m, cur_m
    conn_m[0] = pymysql.connect(host='192.168.43.173', user='root', password='Unapieza12', db='sk8fortec')
    cur_m[0] = conn_m[0].cursor()

    conn_m[1] = pymysql.connect(host='192.168.43.173', user='root', password='Unapieza12', db='sk8fortec2')
    cur_m[1] = conn_m[1].cursor()

    conn_m[2] = pymysql.connect(host='192.168.43.173', user='root', password='Unapieza12', db='sk8fortec3')
    cur_m[2] = conn_m[2].cursor()

    #print("Conexion con MySQL completada!")



def insertar_distribuidor(nombre, telefono):
    cur_p.execute("""INSERT INTO Distribuidor (nombre, telefono) VALUES (%s, %s);""",
                            (nombre, telefono))
    conn_p.commit()



def insertar_pais(nombre):
    cur_p.execute("""INSERT INTO Pais (Nombre) VALUES (%s);""",
                (nombre,))
    conn_p.commit()



def insertar_provincia(idpais, nombre):
    cur_p.execute("""INSERT INTO Provincia (IdPais, Nombre) VALUES (%s, %s);""",
                (idpais, nombre))
    conn_p.commit()



def insertar_canton(idprovincia, nombre):
    cur_p.execute("""INSERT INTO Canton (IdProvincia, Nombre) VALUES (%s, %s);""",
                (idprovincia, nombre))
    conn_p.commit()



def insertar_ciudad(idcanton, nombre):
    cur_p.execute("""INSERT INTO Ciudad (IdCanton, Nombre) VALUES (%s, %s);""",
                (idcanton, nombre))
    conn_p.commit()



def insertar_direccion(idciudad, nombre):
    cur_p.execute("""INSERT INTO Direccion (IdCiudad, Nombre) VALUES (%s, %s);""",
                (idciudad, nombre))
    conn_p.commit()

    
def insertar_direccion(direccion, ciudad, canton, provincia, pais):
    cur_p.execute("""SELECT EXISTS(SELECT 1 FROM Pais WHERE Nombre = %s);""",
                (pais,))
    result_pais = cur_p.fetchall()[0][0]
    if not result_pais:
        insertar_pais(pais)
    cur_p.execute("""SELECT IdPais FROM Pais WHERE Nombre = %s;""",
                (pais,))
    id_pais = cur_p.fetchall()[0][0]


    cur_p.execute("""SELECT EXISTS( SELECT 1 \
FROM Provincia AS Pr \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Pr.Nombre = %s AND Pa.Nombre = %s);""",
                (provincia, pais))
    result_provincia = cur_p.fetchall()[0][0]
    if not result_provincia:
        insertar_provincia(id_pais, provincia)
    cur_p.execute("""SELECT Pr.IdProvincia \
FROM Provincia AS Pr \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Pr.Nombre = %s AND Pa.Nombre = %s;""",
                (provincia, pais))
    id_provincia = cur_p.fetchall()[0][0]


    cur_p.execute("""SELECT EXISTS( SELECT 1\
FROM Canton AS Ca \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Ca.Nombre = %s AND Pr.Nombre = %s AND Pa.Nombre = %s);""",
                (canton, provincia, pais))
    result_canton = cur_p.fetchall()[0][0]
    if not result_canton:
        insertar_canton(id_provincia, canton)
    cur_p.execute("""SELECT Ca.IdCanton \
FROM Canton AS Ca \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Ca.Nombre = %s AND Pr.Nombre = %s AND Pa.Nombre = %s;""",
                (canton, provincia, pais))
    id_canton = cur_p.fetchall()[0][0]


    cur_p.execute("""SELECT EXISTS( SELECT 1 \
FROM Ciudad AS Ci \
INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Ci.Nombre = %s AND Ca.Nombre = %s \
AND Pr.Nombre = %s AND Pa.Nombre = %s);""",
                (ciudad, canton, provincia, pais))
    result_ciudad = cur_p.fetchall()[0][0]
    if not result_ciudad:
        insertar_ciudad(id_canton, ciudad)
    cur_p.execute("""SELECT Ci.IdCiudad \
FROM Ciudad AS Ci \
INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Ci.Nombre = %s AND Ca.Nombre = %s \
AND Pr.Nombre = %s AND Pa.Nombre = %s;""",
                (ciudad, canton, provincia, pais))
    id_ciudad = cur_p.fetchall()[0][0]


    cur_p.execute("""SELECT EXISTS( SELECT 1 \
FROM Direccion AS D \
INNER JOIN Ciudad AS Ci ON Ci.IdCiudad = D.IdCiudad \
INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE D.Nombre = %s AND Ci.Nombre = %s AND Ca.Nombre = %s \
AND Pr.Nombre = %s AND Pa.Nombre = %s);""",
                (direccion, ciudad, canton, provincia, pais))
    result_direccion = cur_p.fetchall()[0][0]
    if not result_direccion:
        insertar_direccion(id_ciudad, direccion)


## Conexion PostgreSQL - MySQL


def decode_message(request):
    request = json.loads(request)
    opcode = request['opcode']
    if opcode == 0:
        #INS_ADMIN
        print(opcode)
    elif opcode == 1:
        #INS_CLIENTE
        message = str(request['dato']).replace('"','').replace("'",'"')[1:-1]
        cur_p.execute("SELECT InsertarCliente(%s)",(message,))
        conn_p.commit()
        result = cur_p.fetchall()
        cur_p.execute("SELECT * FROM FragmentarCliente(%s)",(14,))
        result = "{'opcode':5, 'dato':"+"["+str(cur_p.fetchall()[0][0])+"]}"
        return result.replace("'",'"')
    elif opcode == 2:
        #INS_PUNTOS
##        message = str(request['dato']).replace('"','').replace("'",'"')[1:-1]
##        cur_p.execute("SELECT InsertarPuntos(%s)",(message,))
##        conn_p.commit()
##        result = cur_p.fetchall()
##        cur_p.execute("SELECT * FROM FragmentarPuntos(%s)",(,))
        print(opcode)
    elif opcode == 3:
        #INS_PUESTO
        print(opcode)
    elif opcode == 4:
        #INS_PROMO
        print(opcode)
    elif opcode == 5:
        #INS_REPORTE
        print(opcode)
    else:
        print("opcode invalido!")

conectar_PostgreSQL()
conectar_MySQL()
