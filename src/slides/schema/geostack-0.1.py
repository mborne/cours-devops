# diagram.py
from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB

graph_attr = {
    "margin":"-1.8, -1.8"
}

with Diagram("GeoStack 0.1", filename="geostack-0.1", graph_attr=graph_attr, show=False):
    EC2("GeoServer") >> RDS("PostgreSQL")
