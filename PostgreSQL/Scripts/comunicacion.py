from socket import *
import json
from _thread import start_new_thread
import datos

port = 6679
ip_address = gethostbyname(gethostname())

def iniciar_server():
    try:
        server = socket()
        server.bind(('', port))
        server.listen(3)
        print("Server iniciado! Esperando conexiones...")
    except:
        print("Error al iniciar el server!")
        return
    while True:
        conne, addr = server.accept()
        print("[-] conneected to " + addr[0] + ":" + str(addr[1]))

        start_new_thread(client_thread, (conne,))

def client_thread(conne):
    conne.send("Conectado!\n".encode())

    while True:
        data = conne.recv(1024)
        if not data:
            break
        print(data)
        data = datos.decode_message(data)
        conne.send(data.encode())
    conne.close()

iniciar_server()
