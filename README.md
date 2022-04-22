# RaaSI
## Resiliency as a Service Infrastructure


Ever-increasing dependency on infrastructure drives the need for operational resiliency of both physical and digital infrastructure. A standard system approach to resiliency involves customized solutions that are both brittle and constrained by expense. Computation and Communication (CNC) commonly combine to provide generalized solutions. Devices with these capabilities are now widely and often densely dispersed for everyday operations (e.g., wired/wireless routers are everywhere). We propose a platform that marshalls spare CNC resources to provide services in response to events threatening system resiliency. Specifically, our platform monitors existing primary services and, if such services suffer degradation, invokes a secondary service that operates over a mesh of devices to augment the diminished primary service. As the platform offers spare CNC resources to counter degradation, we call our solution RaaSI (Resilience as a Service Infrastructure).


## Features

- Easy to setup through the use of bash scripts
- Set the location and service name of primary services to monitor
- Personalize your secondary services through containerization
- Efficient resource management; meaning multiple secondary services will never be scheduled on top of each other, and only nodes with valid resources will be hosting secondary service containers.
- Easy to manage dashboard to show the metrics and health of your RaaSI cluster
- Availability through the use of deployment scripts
- Secure communication between nodes through the use of a Tigre Calico overlay network
- Distributed data collection through ... DB/FS


## Installation

RaaSI requires the use of static IP address for all nodes in its cluster, since it is not good for any of your IP addresses to change after setting up a cluster. It is also required that you have the correct hostname and IP address added to the /etc/hosts file on each node to be connected to the RaaSI cluster. Finally, it is required to provide RaaSI with a dockerized service (or set of services) that will act as your secondary service to be run on your nodes.

### Installation of the Master Node
The Master Node is used to manage the distribution of containers on all of the other nodes in the RaaSI cluster. It also performs metrics, checks the health of the cluster, and displays all results in a web dashboard hosted on its server.
To set up the Master Node simple run the following bash script on your master node and follow the directions prompted of you. NOTE: The dashboard might take up to 10 mins to initialize.

```sh
sudo ./MasterNodeSetup/masterSetup.sh
```

To get the key used for logging in to the dashboard on the Master Node run the following bash script on your Master Node.

```sh
sudo ./MasterNodeSetup/getDashboardToken.sh
```

### Instalation of the Client Nodes
The Client Nodes are the non-Master Nodes in your RaaSI cluster. These are the nodes that are responsible for storing the secondary services and monitoring the primay service.
To install a Client Node run the following bash scripts on the node that you are wanting to join to the RaaSI cluster.

```sh
sudo ./ClientNodeSetup/clientSideNodeSetup1.sh
sudo ./ClientNodeSetup/clientSideNodeSetup2.sh
```

When prompted to you will also need to run the following bash scripts on your Master Node.

```sh
sudo ./ClientNodeSetup/serverSideNodeSetup1.sh
sudo ./ClientNodeSetup/serverSideNodeSetup2.sh
```

## Adding Secondary Services

## Adding Primary Services


