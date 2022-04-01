import socket
import sys

if __name__ == '__main__':
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        print("Socket successfully created")
    except socket.error as err:
        print("socket creation failed with error %s" % (err))

    port = 12345
    s.connect((sys.argv[1], port))
    s.send(bytes(sys.argv[2], 'utf-8'))
    print("message ", sys.argv[2], " sent to ", sys.argv[1])
    s.close()
