# diagram.py

graph_attr = {
    "margin":"-1.8, -1.8"
}

from diagrams import Cluster, Diagram
from diagrams.k8s.compute import Pod, StatefulSet
from diagrams.k8s.network import Service
from diagrams.k8s.storage import PV, PVC, StorageClass

with Diagram("StatefulSet", filename="postgres-statefulset", graph_attr=graph_attr, show=False):
    with Cluster("PostgreSQL Cluster"):
        sts = StatefulSet("postgres")

        apps = []
        for i in range(3):
            pod = Pod("postgres-{}".format(i))
            pvc = PVC("pgdata-{}".format(i))
            sts - pvc
            apps.append(sts >> pod >> pvc)
