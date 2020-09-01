# CKA
An environment made as a preparation for the Certified Kubernetes Administrator exam [CKA v1.8]

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

# Replicasets
kubectl get rs

# Pods in the current NS
kubectl get po

# Pods in a different NS
kubectl get po --namespace=name

# Services
kubectl get svc

# Namespaces
kubectl get ns

```

</p>
</details>


<details>
<summary>apiVersion</summary>
<p>

|    Kind    	| apiVersion 	|
|:----------:	|:----------:	|
| ReplicaSet 	|   apps/v1  	|
| Deployment 	|   apps/v1  	|
|  Namespace 	|     v1     	|

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