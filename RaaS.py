import os
import subprocess
import sys
import re
import socket
import time
import threading

primary_service = "192.168.10.113"


def setup():
    response = subprocess.check_output(("ip","a"))
    pattern = re.compile(r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})')
    flag = False
    lines = response.split("\n")
    myip = ""
    for line in lines:
        if line.startswith("2"):
            flag = True
        if flag and "inet " in line:
            print(line)
            aa = pattern.search(line)
            if aa:
              myip = aa.group()
            print(myip)
            flag = False
    original_stdout = sys.stdout
    with open("/storage/ips", 'a') as f:
        sys.stdout = f  # Change the standard output to the file we created.
        print(myip)
        sys.stdout = original_stdout  # Reset the standard output to its original value
    print("setup")
    connected = check_ping(primary_service)
    role = ""
    file = "~/RoleFile.txt"
    if connected:
        role = "Assigner\n"
        neighbors = find_neighbors(myip)
        print("Waiting for cameras to boot up...")
        time.sleep(10)
        for neighbor in neighbors:
            message_camera(neighbor, "")
            role += "Interface: " + neighbor + "\n"
    else:
        role = "Camera\n"
        assigner = find_assigner()
        millisec = time.time() * 1000
        print(assigner)
        role += "Assigner: " + assigner[0] + "\n"
        role += "Assigned at: " + str(millisec)
        file = "~/RoleFile.txt"

    original_stdout = sys.stdout
    with open(file, 'w') as f:
        sys.stdout = f  # Change the standard output to the file we created.
        print(role)
        sys.stdout = original_stdout  # Reset the standard output to its original value
    return file


def message_camera(ip, message):
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        print("Socket successfully created")
    except socket.error as err:
        print("socket creation failed with error %s" % (err))

    port = 12345
    s.connect((ip, port))
    s.send(bytes(message, 'utf-8'))
    print("message ", message, " sent to ", ip)
    s.close()


def find_assigner():
    assigner_ip = ""
    s = socket.socket()
    port = 12345
    s.bind(('', port))
    s.listen(5)
    while True:
        # Establish connection with client.
        c, addr = s.accept()
        print('Got connection from', addr)
        assigner_ip = addr
        c.close()
        break
    return assigner_ip


def check_ping(hostname):
    response = os.system("ping -c 1 " + hostname)
    # if not run in privileged mode
    # response = os.system("ping " + hostname)
    if response == 0:
        print("Alive")
        pingstatus = True
    else:
        print("Dead")
        pingstatus = False

    return pingstatus


def find_neighbors(myip):
    print("findNeighbors")
    result = []
    with open("/storage/ips", "r") as f:
        for lines in f:
            result.append(lines.stip())
    print(result)
    return result
    # method used for finding all the neighboring nodes to the assigner


def check_setup():
    print("check_setup")
    if os.path.exists("~/RoleFile.txt"):
        print("setup done")
        return True
    else:
        print("setup needed")
        return False
    # method used to check if setup has already occurred


def assigner_monitor(neighbors):
    print("assigner_monitor")
    camera_monitor()
    check_neighbor_life(neighbors)


def camera_monitor():
    print("camera_monitor")
    print("Executing Command: ")
    response = os.system("vboxmanage startvm --type headless Network")
    print("vboxmanage startvm --type headless Network")


def init_assigner(neighbors):
    print("init_assigner")
    while True:
        time.sleep(2)
        if not check_ping(primary_service):
            print(neighbors)
            for neighbor in neighbors:
                message_camera(neighbor, "begin")
            break
    assigner_monitor(neighbors)


def check_neighbor_life(neighbors):
    while True:
        time.sleep(10)
        for neighbor in neighbors:
            if not check_ping(neighbor):
                print(neighbor, " is down")


def check_assigner_life(assigner, time_stamp):
    print("check assigner life")
    while True:
        time.sleep(5)
        if not check_ping(assigner):
            print("assigner down")
            break

def new_assigner(time_stamp):
    print("assigning new assigner")

    original_stdout = sys.stdout
    with open("/storage/poll", 'a') as f:
        sys.stdout = f  # Change the standard output to the file we created.
        print(time_stamp)
        sys.stdout = original_stdout  # Reset the standard output to its original value
    # write my time_stamp to global fs file
    time.sleep(5)
    assigner = True
    # look at all time_stamps in the file
    with open("/storage/poll", 'w') as f:
        for lines in f:
            if float(lines.strip()) < float(time_stamp):
                assigner = False
    # compare my time_stamp
    # if mine is the smallest I am the new assigner
    # file = /storage/poll

    if assigner:
        file = "~/RoleFile.txt"
        role = "Assigner\n"
        neighbors = find_neighbors()
        print("Waiting for cameras to boot up...")
        time.sleep(10)
        for neighbor in neighbors:
            message_camera(neighbor, "")
            role += "Interface: " + neighbor + "\n"
        print("hello")
        original_stdout = sys.stdout
        with open(file, 'w') as f:
            sys.stdout = f  # Change the standard output to the file we created.
            print(role)
            sys.stdout = original_stdout  # Reset the standard output to its original value
        neighbors = get_neighbors()
        init_assigner(neighbors)
    else: # if not assigner
        role = "Camera\n"
        assigner = find_assigner()
        millisec = time.time() * 1000
        print(assigner)
        role += "Assigner: " + assigner[0] + "\n"
        role += "Assigned at: " + str(millisec)
        file = "~/RoleFile.txt"
        original_stdout = sys.stdout
        with open(file, 'w') as f:
            sys.stdout = f  # Change the standard output to the file we created.
            print(role)
            sys.stdout = original_stdout  # Reset the standard output to its original value
        check_assigner_life(assigner[0], str(millisec))


def init_camera(assigner):
    print("init_camera")
    s = socket.socket()
    port = 12345
    s.bind(('', port))
    s.listen(5)
    while True:
        # Establish connection with client.
        c, addr = s.accept()
        print('Got connection from', addr)
        msg = c.recv(1024)
        if msg.decode("utf-8").startswith("begin"):
            c.close()
            break
    camera_monitor()


def get_neighbors():
    result = []
    pattern = re.compile(r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})')
    with open("~/RoleFile.txt", "r") as f:
        for line in f:
            if line.startswith('Interface: '):
                result.append(pattern.search(line)[0])
    return result


if __name__ == '__main__':
    file = "~/RoleFile.txt"
    # run setup
    if not check_setup():
        file = setup()
    role = ""
    with open(file, "r") as f:
        role = f.readline()

    if role.startswith("Assigner"):
        neighbors = get_neighbors()
        x = threading.Thread(target=init_assigner, args=(neighbors,))
        y = threading.Thread(target=init_camera, args=("127.0.0.1",))
        x.start()
        y.start()
    else:
        assigner = ""
        with open(file, "r") as f:
            for line in f:
                if line.startswith("Assigner: "):
                    assigner = line.split(" ")[1]
                if line.startswith("Assigned at: "):
                    time_stamp = line.split(" ")[1]
        x = threading.Thread(target=init_camera, args=(assigner,))
        y = threading.Thread(target=check_assigner_life, args=(assigner,time_stamp,))
        x.start()
        y.start()
