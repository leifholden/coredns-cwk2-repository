# CoreDNS Deployment on Edge and Cloud Systems

This repository holds the code and configuration files for my coursework 2
submission to the University of Leeds COMP123M (Cloud Computing) module.

The project investigates the deployment of CoreDNS onto a low-powered virtual
machine (designed to model a device at the network edge) and a more powerful
virtual machine running on Microsoft Azure (designed to model a device running
at the network core/the cloud).

CoreDNS was first configured to run within a Docker container. The file
```/Docker/compose.yaml``` was developed with help from Ben Soer's article
(Soer, 2025). ```kompose convert``` (The Kubernetes Authors, 2025) was 
then used to translate the ```/Docker/compose.yaml``` file into Kubernetes
config files (the result of running this command can be found under the 
```/kubernetes/``` directory). Running with these config files on Minikube, a 
couple of issues were encountered relating to accessing the CoreDNS deployment 
outside of the Kubernetes cluster, Micrsoft 365 Copilot with Enterprise Security 
was used in an assistive role to diagnose and resolve these issues. The full 
details of prompts, attachemnts, responses, and actions taken with Microsoft 
Copilot are described in the ```Material.md``` file.

# Running with k3s
To run the CoreDNS deployment with k3s, first esnure that both Docker and k3s
are installed on your system. Run the following commands (note that depending on
your users priviledges, these commands may need to be run with ```sudo```).

Clone this GitHub repository:

```
git clone git@github.com:leifholden/coredns-cwk2-repository.git
```

Change directory into the repository folder:

```
cd coredns-dwk2-repository
```

Change directory into the ```/kubernetes/``` directory:

```
cd kubernetes
```

Apply all of the config files by running:

```
kubectl apply -f .
```

The CoreDNS pod should now be running, you can check that it has successfully
deployed by running:

```
kubectl get pods
kubectl get deployments
kubectl get services
```

The last of those three commands should output something similar to the
following:

```
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                                        AGE
coredns      LoadBalancer   10.43.184.117   10.0.0.6      1053:32568/TCP,1053:32568/UDP 8080:30106/TCP   40s
kubernetes   ClusterIP      10.43.0.1       <none>        443/TCP                                        4m35s
```

The CoreDNS server can now be queried:

```
dig @<EXTERNAL-IP> -p 1053 A ins1.lab.company.com
```

For k3s, &lt;EXTERNAL-IP&gt; should be allocated as the same IP allocated to one of
your nodes IP interfaces, and so you should be able to run:
```
dig @localhost -p 1053 A ins1.lab.company.com
```
and get the same result.

# Running with Minikube
To run with Minkube, first ensure that Docker and Minikube are installed on your
system. Additionally, ensure that ```kubectl``` is installed, or alias
```kubectl``` to ```minikube kubectl```. Ensure that Minikube is running by 
running ```minikube start```.

Clone this GitHub repository:

```
git clone git@github.com:leifholden/coredns-cwk2-repository.git
```

Change directory into the repository folder:

```
cd coredns-dwk2-repository
```

Change directory into the ```/kubernetes/``` directory:

```
cd kubernetes
```

Apply all of the config files by running:

```
kubectl apply -f .
```

The CoreDNS pod should now be running, you can check that it has successfully
deployed by running:

```
kubectl get pods
kubectl get deployments
kubectl get services
```

The last of those three commands should output something similar to the
following:

```
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                                        AGE
coredns      LoadBalancer   10.43.184.117   <pending>     1053:32568/TCP,1053:32568/UDP 8080:30106/TCP   40s
kubernetes   ClusterIP      10.43.0.1       <none>        443/TCP                                        4m35s
```

With Minikube, an external IP to the CoreDNS service is not automatically
assigned. This issue was resolved with the help of Microsoft 365 Copilot (see
Material.md for details on prompts, attachements, responses, and actions taken).
In summary, to get CoreDNS working like with k3s, the following needs to be
performed.

Run:
```
minikube tunnel
```
This will assign an external IP to the CoreDNS service. This IP is can only be
reached from within (on) the host device. To allow for queries from external
hosts perform the following.

In a new terminal, use ```socat``` to bind the localhost:1053 to 
&lt;EXTERNAL-IP&gt;:1053 ...
```
sudo socat UDP-LISTEN:1053,fork UDP:<EXTERNAL-IP>:1053&
sudo socat TCP-LISTEN:1053,fork TCP:<EXTERNAL-IP>:1053&
```

The DNS service should now be reachable via the localhost IP:
```
dig @localhost -p 1053 A ins1.lab.company.com
```

## References

Soer, B. 2025. Setup A Simple Homelab DNS Server Using CoreDNS and Docker | by Ben Soer | Medium. [Accessed 20 March 2026]. Available from: https://medium.com/@bensoer/setup-a-private-homelab-dns-server-using-coredns-and-docker-edcfdded841a.

The Kubernetes Authors 2025. Translate a Docker Compose File to Kubernetes Resources | Kubernetes. [Accessed 20 March 2026]. Available from: https://kubernetes.io/docs/tasks/configure-pod-container/translate-compose-kubernetes/.