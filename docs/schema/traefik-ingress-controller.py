# diagram.py
from diagrams import Diagram
from diagrams.k8s.compute import Deploy
from diagrams.k8s.compute import Pod
from diagrams.k8s.network import Service
from diagrams.k8s.network import Ingress

graph_attr = {
    "margin":"-1.5, -1.8"
}

with Diagram("Ingress Controller", filename="traefik-ingress-controller", graph_attr=graph_attr, show=False):
    Service("traefik") >> Ingress("whoami.dev.localhost") >> Service("whoami") >> [Pod("whoami-a1c4ad"),
        Pod("whoami-a1c4ad"),
        Pod("whoami-v0.1.1")] << Deploy("whoami")
