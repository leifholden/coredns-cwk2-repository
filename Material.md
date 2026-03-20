# Use of Microsoft 365 Copilot with Enterprise Security

The following table outlines how Microsoft 365 Copilot with Enterprise Security was used in an assistive role to help debug configuration issues. The table includes prompts, attachments, Copilot's responses, and how I have acted on Copilots responses.

The Version of Microsoft 365 Copilot with Enterprise Security used was 2.20260317.17.0

##Prompt 1

I have created the attached docker compose.yaml file which describes a container deployment of coredns that is configured with a Corefile. When I run 'docker compose up -d' docker creates this container and I am able to run 'dig @localhost -p 1053 a ins1.lab.company.com' which returns the correct IP Address for ins1.lab.company.com which I have specified in another file db.lab.company.com. I now want to be able to run this container in a Minikube cluster. I have converted the compose.yaml file into kubernetes configuration files using the 'Kompose convert -f compose.yaml'. This generated the coredns-deployment.yaml and coredns-service.yaml file attached (it also created a coredns-cm0-configmap.yaml which I haven't uploaded). I have started my Minikube cluster with 'minikube start', and have run 'kubectl apply -f coredns-cm0-configmap.yaml,coredns-deployment.yaml,coredns-service.yaml' which started the coredns container within a minicube pod. However, when I run 'dig @localhost -p 1053 ins1.lab.company.com' I am unable to connect to the coredns container running within minikube. What am I doing incorrectly, and how can I solve this issue?

##Attachemnts for prompt 1

compose.yaml , coredns-deployment.yaml , coredns-service.yaml

##Copilot response to prompt 1

You’ve done most of the heavy lifting—CoreDNS works in Docker, Kompose produced the K8s manifests, and the Pod is up. The remaining issue is exposure: in Kubernetes your Service is ClusterIP by default, which is only reachable inside the cluster. Running dig @localhost -p 1053 … on your host won’t reach that Service unless you expose it beyond the cluster.
Below I’ll explain what’s happening and give you three good ways to solve it (NodePort, LoadBalancer via minikube tunnel, or host networking), plus a quick checklist for the Corefile/ConfigMap path mapping.

### Why dig @localhost -p 1053 works in Docker but not Minikube
In Docker Compose you mapped host port 1053 to container port 53 directly:
```
ports:
  - "1053:53"
  - "1053:53/udp"
```
