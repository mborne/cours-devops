# diagram.py
from diagrams import Diagram
from diagrams.k8s.compute import Deploy
from diagrams.k8s.compute import Pod
from diagrams.k8s.network import Service

graph_attr = {
    "margin":"-1.8, -1.8"
}

with Diagram("Service", filename="whoami-service", graph_attr=graph_attr, show=False):
    Service("whoami") >> [Pod("whoami-a1c4ad"),
        Pod("whoami-a1c4ad"),
        Pod("whoami-v0.1.1")] << Deploy("whoami")
