import conexion
import pymysql

coneccion = pymysql.connect(host='localhost', user='root', password='Unapieza12', db='sk8fortec')
cursor = coneccion.cursor()


def enviar_cliente():
    args = [0]
    cursor.callproc('GenerarCliente', args)
    cursor.execute("SELECT @_GenerarCliente_0;")
    res_json = '{"opcode":1, "dato":' + cursor.fetchall()[0][0] + '}'
    conexion.conectar(res_json.encode())


def enviar_admin():
    args = [0]
    cursor.callproc('GenerarAdministradorSucursal', args)
    cursor.execute("SELECT @_GenerarAdministradorSucursal_0;")
    res_json = '{"opcode":0, "dato":' + cursor.fetchall()[0][0] + '}'
    conexion.conectar(res_json.encode())


def enviar_puntos():
    args = [0]
    cursor.callproc('GenerarPuntos', args)
    cursor.execute("SELECT @_GenerarPuntos_0;")
    res_json = '{"opcode":2, "dato":' + cursor.fetchall()[0][0] + '}'
    conexion.conectar(res_json.encode())


def enviar_puesto():
    args = [0]
    cursor.callproc('GenerarPromocion', args)
    cursor.execute("SELECT @_GenerarPromocion_0;")
    res_json = '{"opcode":3, "dato":' + cursor.fetchall()[0][0] + '}'

    print(res_json)
    conexion.conectar(res_json.encode())


def enviar_promocion():
    args = [0]
    cursor.callproc('GenerarPuestoEmpleado', args)
    cursor.execute("SELECT @_GenerarPuestoEmpleado_0;")
    res_json = '{"opcode":4, "dato":' + cursor.fetchall()[0][0] + '}'
    conexion.conectar(res_json.encode())


def enviar_reporte():
    args = [0]
    cursor.callproc('GenerarReporte', args)
    cursor.execute("SELECT @_GenerarReporte_0;")
    res_json = '{"opcode":5, "dato":' + cursor.fetchall()[0][0] + '}'
    conexion.conectar(res_json.encode())

enviar_cliente()