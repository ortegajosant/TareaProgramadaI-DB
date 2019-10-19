import psycopg2

port = 5432
ip = '192.168.43.58'


def conectar(request):
    conn_p = psycopg2.connect(user='postgres', password='estebandcg1999',host=ip, port=str(port), dbname='postgres')
    cur_p = conn_p.cursor()
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


conectar()
# escuchar_thread()
