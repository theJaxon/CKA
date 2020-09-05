# CKA
An environment made as a preparation for the Certified Kubernetes Administrator exam [CKA v1.19]

---

### [Important kubectl commands](https://blog.heptio.com/kubectl-explain-heptioprotip-ee883992a243):

```bash
kubectl explain deploy


# Check all fields in a resource
kubectl explain <resource> --recursive # resource can be pod, deployment, ReplicaSet etc

kubectl explain deploy.spec.strategy
```

---

Dry run and validate 

```
kubectl apply -f fileName.yml --validate --dry-run=client
```

Re-run the file after updating values:
```
kubectl replace -f fileName.yml
```

Create a Namespace
```
kubectl create namsepace NS-name
```

<details>
<summary>kubectl get commands</summary>
<p>

```bash
# View all objects
kubectl get all

# ConfigMaps
kubectl get cm

# Secrets
kubectl get secret

# Replicasets
kubectl get rs

# DaemonSets
kubectl get ds

# Pods in the current NS
kubectl get po

# Pods in a different NS
kubectl get po --namespace=name

# Pods on a specific Node [1]
# --all-namespaces shorthand is -A
kubectl get pods -Ao wide --field-selector spec.nodeName=<node>

# Services
kubectl get svc

# Namespaces
kubectl get ns

# Nodes
kubectl get no

# List all events in the current NS
kubectl get events

# Deployments
kubectl get deploy

```

</p>
</details>


<details>
<summary>kubectl delete commands</summary>
<p>

```bash
# Delete pod
kubectl delete pod <name>
```


</p>
</details>

Filtering using selector:
```bash
kubectl get po --selector app=<appname>
```

Filtering using label:
```bash
kubectl get po -l env=dev
```

* You can use multiple labels too, just use a comma to separate
```bash
kubeclt get po -l env=dev,app=my-app,function=backend
```

Adding Label to Node:
```bash
kubectl label nodes kworker1.example.com size=Large
```

Deleting Label from Node:
```bash
kubectl lable nodes kworker1.example.com size-
```

View scheduler logs
```bash
kubectl logs custom-scheduler --name-space=kube-system
```

Deployment rollout commands:
```bash
# In a nutshell
kubectl rollot [undo/stats/history] deploy/name

# Check rollout status 
kubectl rollout status deploy/name

# Check history of changes made to that deployment
kubectl rollout history deploy/name

# Revert to previous version
kubectl rollout undo deploy/name
```

Editing already deployed files can be done using
```
kubectl edit deploy name
```

---

<details>
<summary>Cluster Maintenance</summary>
<p>

```bash
# Mark node as unusable 
kubectl drain <node>

OR 

kubectl cordon <node>

# Remove the drain restriction
kubectl uncordon <node>
```

Cordon Vs drain:
- Cordon doesn't terminate existing pods on the node but it prevents creation of any new pods on that node
- Drain terminates those pods and they get allocated to a different node

Upgrading a cluster:
```bash
kubeadm upgrade plan
kubeadm upgrade apply
```

Backup resource configuration:
1- Backup all resources 
```bash
kubectl get all -Ao yaml > all_resources.yml
```
>  Implement etcd backup and restore

2- Use etcdctl to backup the etcd server
```bash
ETCD_API=3 etcdctl snapshot save snapshot.db
```

</p>
</details>


---

<details>
<summary>apiVersion</summary>
<p>

|    Kind    	| apiVersion 	|
|:----------:	|:----------:	|
| ReplicaSet 	|   apps/v1  	|
| Deployment 	|   apps/v1  	|
|  Namespace 	|     v1     	|
|   Service  	|     v1     	|

</p>
</details>

---

Components:
ReplicaSet: Requires a `selector` that helps RS identify what pods fall under it

---

Requirements for Master:
- git
- krew

Servers initiated by vagrant
- 2 K8s Controllers
- 2 K8s Worker nodes
- 1 K8s API Load Balancer

OS Used is `bento/centos-8`

address assigned:
* Controller Nodes:
  * 192.168.50.211
  * 192.168.50.212
* Worker Nodes:
  * 192.168.50.221
  * 192.168.50.222
* API LB:
  * 192.168.50.230

Useful Resources:

1- [Get Pods on specific node](https://stackoverflow.com/a/50811992)
