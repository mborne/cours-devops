# diagram.py
from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB

graph_attr = {
    "margin":"-1.8, -1.8"
}

with Diagram("Principe mise à jour", filename="principe-lb-update", graph_attr=graph_attr, show=False):
    ELB("lb") >> [EC2("app01-v0.1.0"),
                  EC2("app02-v0.1.1"),
                  EC2("app03-v0.1.1")] >> RDS("db")
