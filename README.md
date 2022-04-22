# RaaSI
## Resiliency as a Service Infrastructure


Ever-increasing dependency on infrastructure drives the need for operational resiliency of both physical and digital infrastructure. A standard system approach to resiliency involves customized solutions that are both brittle and constrained by expense. Computation and Communication (CNC) commonly combine to provide generalized solutions. Devices with these capabilities are now widely and often densely dispersed for everyday operations (e.g., wired/wireless routers are everywhere). We propose a platform that marshalls spare CNC resources to provide services in response to events threatening system resiliency. Specifically, our platform monitors existing primary services and, if such services suffer degradation, invokes a secondary service that operates over a mesh of devices to augment the diminished primary service. As the platform offers spare CNC resources to counter degradation, we call our solution RaaSI (Resilience as a Service Infrastructure).


## Features

- Easy to setup through the use of CLI
- Automatic detection of devices run on secondary nodes
- Discovery of secondary nodes through secure shell commands
- Detection of primary service failure through customizable API
- Personalize your secondary services through containerization (stored on DockerHub)
- Deployment of secondary services done automatically (through primary service monitoring failure) or manually (through the CLI)
- Efficient resource management; meaning multiple secondary services will never be deployed on the same node, and only nodes with valid resources will be hosting secondary service containers
- Easy to manage dashboard to show the metrics and health of your RaaSI cluster
- High Availability of all nodes considered through tools such as; haproxy and keepalived
- Secure communication between nodes through the use of a Tigre Calico overlay network
- Stateful storage of secondary service data through GlusterFS
- Easy to manage any secondary service with kubernetes
- Security considered through seperation of data from computation, complex tokens used for dashboard authentication, RaaSI script modification monitoring with OSSEC, data encryption done with TLS 1.3
- Static Analysis done with ShellCheck and added to CI/CD 
- Unit testing done with BATS and stored in the testing directory

## RaaSI CLI

To enable simple installation an management of RaaSI users should use the RaaSI CLI found in RaaSIController/RaaSIController.sh. This script walks the user through all of RaaSI's use cases by prompting the user to enter the desirable option. The command to run the CLI is shown below.

```sh
cd RaaSIController
sudo ./RaaSIController.sh
```

The remainder of this document shows the user how to navigate through the CLI and what information is needed from the user to execute each of RaaSI's use cases.


## Installation

RaaSI requires the use of static IP address for all nodes in its cluster, since it is not good for any of your IP addresses to change after setting up a cluster. It is also required that you have the correct hostname and IP address added to the /etc/hosts file on each node to be connected to the RaaSI cluster. Finally, it is required to provide RaaSI with a dockerized service (or set of services) that will act as your secondary service to be run on your nodes.

### Installation of Load Balancer
In order for RaaSI to provide High Availability to its Master Nodes, a load balancer must be installed before the Master Node installation process takes place. To install the load balancer, navigate to "Install RaaSI Components" and "Install Load Balancers." This will install three load balancers for your Master Nodes to use. the reason why we are installing three load balancers is to provide High Availability to the load balancers.

### Installation of Master Nodes
Master Nodes are used to manage the distribution of containers on all of the other nodes in the RaaSI cluster. They also perform metrics, check the health of the cluster, and display all results in a web dashboard hosted on the Primary Master Nodes' server.
To set up the Primary Master Node simple navigate to "Install RaaSI Components" and "Install Primary Master Controller." Once the script begins activating, follow the prompts to setup your Primary Master Node. NOTE: The dashboard might take up to 10 mins to initialize.

To get the key used for logging in to the dashboard on the Master Node run the following bash script on your Master Node.

```sh
sudo ./MasterNodeSetup/getDashboardToken.sh
```

To install your backup master nodes, select "Install Backup Master Controllers" in the "Install RaaSI Components" menu and follow the instructions given to you by the script.

### Instalation of the Client Nodes
The Client Nodes are the non-Master Nodes in your RaaSI cluster. These are the nodes that are responsible for running the secondary services. To install your client nodes, navigate to "Install RaaSI Components" and "Install Worker Nodes". Once the client node installation script executes, follow the prompts given to you to successfully install your client nodes. At the end of the script, the  user will be asked to search for devices on the given node. These devices are the ones that will be used when running the secondary service on that node. Enter the device needed, and the script will search for it on the node. If the device is found, the script will label that node for the secondary service to be placed on.

### Installation of GlusterFS
GlusterFS is used by RaaSI to provide statefullness to the data stored on secondary services. Due to this statefullness, the data collected by the secondary services will not disappear if the secondary service ends or if the node hosting the secondary service is terminated. To install GlusterFS on RaaSI, navigate to "Install RaaSI Components" and "Install GlusterFS Persistence Volume." Once initiated, follow the prompts given by the script to setup the GlusterFS Persistence Volume.

## Adding Secondary Services
RaaSI is built on users adding secondary services to provide resiliency for an outage in a primary service. Containerization is used to virutualize the needed secondary services. These containerized secondary services are then pushed to client nodes in pods through kubernetes. In order for these secondary services to be created, users must create the containerized image and push it to DockerHub. Once this image has been pushed, the user can run the RaaSI CLI and navigate to "Configure RaaSI Cluster" and "Add Secondary Service." Once there, the user must follow the prompts given to them in order for the secondary service to be properly added. The user can add as many secondary services as needed by running this script multiple times.  

## Adding Primary Services
Primary services are monitored through an API written in python. This API allows users to create their own, unique, scripts to monitor the health of their primary services. Once the primary service monitor API has been modified to check the health of the specific primary service, the user can run the RaaSI CLI and navigate to "Configure RaaSI Cluster" and "Monitor Primary Service." This will montor the primary service and deploy secondary services related to the primary service if the primary service fails its health check.

