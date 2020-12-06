# CKA
![CKA](https://img.shields.io/badge/-CKA-0690FA?style=for-the-badge&logo=kubernetes&logoColor=white)
![K8s](https://img.shields.io/badge/-kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)

An environment made as a preparation for the Certified Kubernetes Administrator exam [CKA v1.19]

---

### :pencil: Objectives:

<details>
<summary>1- Cluster Architecture, Installation & Configuration 25%</b></summary>
<p>

1. Manage role based access control (RBAC)
2. Use Kubeadm to install a basic cluster
3. Manage a highly-available Kubernetes cluster
4. Provision underlying infrastructure to deploy a Kubernetes cluster
5. Perform a version upgrade on a Kubernetes cluster using Kubeadm
6. Implement etcd backup and restore

</p>
</details>


<details>
<summary>2- Workloads & Scheduling 15%</b></summary>
<p>

1. Understand deployments and how to perform rolling update and rollbacks
2. Use ConfigMaps and Secrets to configure applications
3. Know how to scale applications
4. Understand the primitives used to create robust, self-healing, application deployments [Probes]
5. Understand how resource limits can affect Pod scheduling [resources for pods and quota for namespaces]
6. Awareness of manifest management and common templating tools

</p>
</details>

<details>
<summary>3- Services & Networking 20%</b></summary>
<p>

1. Understand host networking configuration on the cluster nodes
2. Understand connectivity between Pods
3. Understand ClusterIP, NodePort, LoadBalancer service types and endpoints
4. Know how to use Ingress controllers and Ingress resources
5. Know how to configure and use CoreDNS
6. Choose an appropriate container network interface plugin

</p>
</details>

<details>
<summary>4- Storage 10%</b></summary>
<p>

1. Understand storage classes, persistent volumes
2. Understand volume mode, access modes and reclaim policies for volumes
3. Understand persistent volume claims primitive
4. Know how to configure applications with persistent storage

</p>
</details>

<details>
<summary>5- Troubleshooting 30%</b></summary>
<p>

1. Evaluate cluster and node logging
2. Understand how to monitor applications
3. Manage container stdout & stderr logs
4. Troubleshoot application failure
5. Troubleshoot cluster component failure
6. Troubleshoot networking

</p>
</details>

---

### Cluster components:
Kubernetes cluster consists of one or more master nodes + one or more worker nodes, the master node components are called `Control plane`.

#### Control plane components:
- **kube-api** server
- **etcd** Key value store
- **kube-scheduler** that allocates nodes for pods
- **kube-controller-manager** and there are different types of controllers like `replication controller`, `endpoints controller`, `service account controller` and `Token controller`

#### Worker nodes components:
- **Kubelet** Ensures pods are running on the nodes
- **kube-proxy** Maintains network rules on the nodes to keep `SVCs` working. 

---

### [Important kubectl commands](https://blog.heptio.com/kubectl-explain-heptioprotip-ee883992a243):

```bash
k <command> -v=<number> # For verbose output, useful for debugging
k cluster-info 
k config -h
k config view # View content of ~/.kube/config | /etc/kubernetes/admin.conf

# Auto completion enable
k completion -h 
vi ~/.bashrc
alias k=kubectl
source <(kubectl completion bash | sed 's/kubectl/k/g')
source ~/.bashrc

kubectl explain deploy

# Check all fields in a resource
kubectl explain <resource> --recursive # resource can be pod, deployment, ReplicaSet etc

kubectl explain deploy.spec.strategy

kubectl config -h

kubectl proxy # runs on port 8001 by default 
# use curl http://localhost:8801 -k to see a list of API groups

# NOT kubectl but useful
journalctl -u kubelet
journalctl -u kube-apiserver

# Dry run and validate
kubectl apply -f fileName.yml --validate --dry-run=client

# View certificate (Decoded) 
openssl x509 -in /etc/kubernetes/pki/<name>.crt -text -noout

```

---

### :file_folder: Important Directories:
```bash
/etc/kubernetes/pki/ # Here all certs and keys are stored

# ETCD certs 
/etc/kubernetes/pki/etcd

/etc/kubernetes/manifests # Static pods definition files that are used for bootstraping kubernetes are located here
  /etcd.yaml
  /kube-apiserver.yaml
  /kube-controller-manager.yaml
  /kube-scheduler.yaml

$HOME/.kube/config # --kubeconfig file

/var/lib/docker # ["aufs", "containers", "image", "volumes"]

/var/lib/kubelet/config.yaml # kubelet config file that contains static pod path //usually /etc/kubernetes/manifests

/var/logs/containers # logs are stored here 

```

* API Serves on port `6443` by default

![kubeconfig](https://github.com/theJaxon/CKA/blob/master/etc/kubeconfig.png)

- A single kubeconfig file can have information related to multiple kubernetes clusters (different servers).
There are 3 core fields in the kubeconfig file:
1. cluster field: includes details related to the URL of the cluster `server` and associated info.
2. user field: contains info about [authentication](https://kubernetes.io/docs/reference/access-authn-authz/authentication/) mechanisms for the user which can be either
  1. user/password
  2. certificates
  3. tokens

3. context field: groups information related to cluster, user and namespaces.

* To remove any field from the kubeconfig use the unset command 

```bash
# Remove context from kubeconfig 
k config unset contexts.<name>

# Remove user from kubeconfig 
k config unset users.<name>
```

* While kubeconfig can be loaded from the known locations as `.kube` in home dir or $KUBECONFIG ENV var, sometimes you want to exactly know from where it gets loaded an here the -v is really helpful 
```bash
k config view -v=10
```

#### Create a kubeconfig file: 
```bash
# 1. Generate the base config file
k config --kubeconfig=<name> set-cluster <cluster-name> --server=https://<address>

# 2. Add user details 
k config --kubeconfig=<name> set-credentials <username> --username=<username> --password=<pwd>

# 3. set context in the kubeconfig file 
k config --kubeconfig=<name> set-context <name> --cluster=<cluster-name> --namespace=<ns> --user=<user>

```
---

### Important Documentation page sections:

- [kubeadm check required ports](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports) 

- [Application Introspection and Debugging](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application-introspection/)

---

### :bulb: Imperative usage of kubectl command:
```bash
# View api-resources 
k api-resources -h

# View only the namespaced api-resources
k api-resources --namespaced=True

# Add annotation to deployment
k annotate deploy/<name> k=v

# Create namespace 
k create ns <name>

# Create deployment and set an env variable for it
k create deploy <name> --image=<name> 
k set env deploy/<name> K=v

# Create ConfigMap from env varibales and use it in a deployment
k create cm <name> --from-literal=K=v --from-literal=K=v 
k set env deploy/<name> --from=cm/<name>

# Those key value pairs can be stored in a .env file and also be used 
k create cm <name> --from-env-file=<name>.env
k set env deploy/<name> --from=cm/<name>

# Limit the values that will be used from a configMap using --keys option
k set env deploy/<name> --from=cm/<name> --keys="key,key" 

# Set resources for deployment 
k set resources -h 
k set resources deploy/<name> --requests=cpu=200m,memory=512Mi --limits=cpu=500m,memory=1Gi

# Create HorizontalPodAutoscaler resource [HPA] for a deployment
k autoscale deploy <name> --min=<number> --max=<number> --cpu-percent=<number>
k get hpa

# Create a secret 
k create secret generic <name> --from-literal=K=v

# Delete resource 
k delete <resource> --force --grace-period=0 

# Get using labels, either --selector or -l followed by key value pairs
k get po --selector | -l k=v # Can be done for multiple labels just separate using a comman k=v,k=v etc

# Get pods with the same label across all namespaces [-A is short for --all-namespaces]
k get po -l k=v -A

# Run a pod 
k run <name> --image=<name> -o yaml --dry-run=client > <name>.yml
k apply -f <name>.yml

# Define an env variable for a pod using --env
k run <name> --image=<name> --env K=v --env K=v -o yaml --dry-run=client 


## Labelling
# Label a node
k label nodes <node-name> k=v

# Delete a lable from the node
k label nodes <node-name> k-

## Rollout commands
k rollout -h 
k rollout [history/pause/restart/resume/status/undo] deploy/<name>

# View details of a specific revision
k rollout history deploy/<name> --revision=<number>

# Scale replicas of a deployment 
k scale deploy/<name> --replicas=<number>

```

---

<details>
<summary>Cluster Maintenance</summary>
<p>

```bash
# Mark node as unusable 
k drain <node> | k cordon <node>

# Remove the drain restriction
k uncordon <node>
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
> :bell: Implement etcd backup and restore :bell:

2- Use etcdctl to backup the etcd server
```bash
ETCD_API=3 etcdctl snapshot save snapshot.db
```

</p>
</details>


---

#### User certificates:
There are 3 essential certs found in ~/.kube/config file (can also be viewed using `k config view`), those are:
1. client-certificate-data # public key cert
2. client-key-data # private key 
3. certificate-authority-data # CA public key cert

#### Kubernetes user accounts [Authentication]:
- There are no `user` objects in k8s.
- User account is just an authorized cert + RBAC authorization

There are 5 steps involved in creating the user, the steps should result in 2 files being created, those are:
1. private.key
2. certificate.crt

Those 2 can be used to talk to the `API-server`

![add-user](https://github.com/theJaxon/CKA/blob/master/etc/add-user.png)

Steps explained:
```bash
# 1. create a new private key 
openssl genrsa -out <name>.key 2048

# 2. Create a CSR and encode it 
openssl req -new -key <name>.key -out <name>.csr -subj "/CN=<name>"
cat <name>.csr | base64 | tr -d '\n'

# 3. Create k8s CSR object using the generated openssl csr
# https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#create-certificatesigningrequest
k apply -f csr.yml
k get csr

# 4. Approve k8s csr 
k certificate approve <name>

# 5. Grab .crt content from the approved csr and decode it into a file
k get csr <name> -o jsonpath='{.status.certificate}' | base64 -d > <name>.crt
```

Kubernetes CSR file sample:
```yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: <name>
spec:
  groups:
  - system:authenticated
  request: # Place your <csr> base64 encoded here
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
```

That's all .. now we can use our **`.crt`** and **`.key`** to talk to the API server

![Authentication](https://github.com/theJaxon/CKA/blob/master/etc/Authentication.png)

To use them we create a new context 
```bash
# 1. set the credentials
k config set-credentials <name> --client-certificate=<name>.crt --client-key=<name>.key 

# 2. Verify that credentials were added 
k config view

# 3. create and set context 
k config set-context <user> --cluster=<name> --user=<name>
k config get-contexts

# 4. use context to verify 
k --context <name> get po
```

---

### Authorization:
Authorization modules in K8s include:
1. AlwaysAllow # For testing only 
2. AlwaysDeny # For testing only 
3. **RBAC**
4. ABAC
5. Node
6. Webhook

---

### Talking to the server without proxy:
While the easy approach is to just use `k proxy &` and then curl request would work on port `8001`, there are other approaches like
1. Using **Bearer Token** for authentication:
By default kubernetes creates a secret for each `service account` so for the default namespace a secret is created as `default-token-*`

To be able to make a curl request to the server grab the secret 
```
# 1- Grab the Server URL
k config view 

# 2- Copy the token
k describe secret default-token-*

# 3- use curl to access the server as follows
curl -k https://<server-address>/api/v1 --header "Authorization: Bearer <token>"
```


---

#### JSON Path queries:
```bash
# First view the returned output from the command, you will narrow this output down
kubectl get <object> -o json 

# Filter the output
kubectl get pods -o=jsonpath='{.items[0].spec.containers[0].image}'

# You can query more than one item at a time
kubectl get po -o=jsonpath='{.items[*].metadata.name}{.items[*].status.capacity.cpu}'

# Prettifying the output using tabs or newlines
kubectl get po -o=jsonpath='{.items[*].metadata.name}{"\n"}{.items[*].status.capacity.cpu}'

# Loops 
'{range .items[*]}
  {.metadata.name}{"\t"} {.status.capacity.cpu}{"\n"}
{end}
'

# FInal form
kubectl get nodes -o=jsonpath='{range .items[*]} {.metadata.name} {"\t"} {.status.capacity.cpu} {"\n"} {end}'

# Custom column iteration
kubectl get nodes  -o=custom-columns=NODE:.metadata.name,CPU:.status.capacity.cpu

```

---
### Referencing Values:
#### From pod fields:

<details>
<summary>metadata</b></summary>
<p>

.name
.namespace
.uid

</p>
</details>

<details>
<summary>spec</b></summary>
<p>

.nodeName
.serviceAccountName

</p>
</details>

<details>
<summary>status</b></summary>
<p>

.hostIP
.podIP

</p>
</details>

---

#### From container resources fields:

<details>
<summary>requests</b></summary>
<p>

.cpu
.memory

</p>
</details>

<details>
<summary>limits</b></summary>
<p>

.cpu
.memory

</p>
</details>

### :diamonds: Storage: 
```
.pod.spec.containers.volumeMounts
  . readOny: True 
```

---

### :diamonds: 1- Cluster Architecture, Installation & Configuration 25%:
#### :gem: 1- Manage role based access control (RBAC)
After creating a user account and configuring keys and certs we then create ClusterRole (or a Role) and ClusterRoleBinding (or a RoleBinding)
```bash
# Create a Role 
k create role -h 
k create role <ns> --verb=get,watch,create,update,patch,delete --resource=deploy,po,rs -n <ns> -o yaml --dry-run=client > ns-role.yml

# Bind the user to the role 
k create rolebinding -h
k create rolebinding <username-binding> --role=<ns> --user=<username> -n <ns>
```

Test the effect of the role by using --context:
```
k --context=<context-name> <verb> <object> <name>
```


#### :gem: 6- Implement etcd backup and restore
```bash
yum provides */etcd
yum install -y etcd # This also installs etcdctl
etcdctl -h
ETCDCTL_API=3 etcdctl -h # View help menu of API V3 for etcd
ETCDCTL_API=3 etcdctl snapshot save -h
ps aux | grep etcd

# From the help we figure the parameters needed as 
# --cacert --cert --key --endpoints
ETCDCTL_API=3 etcdctl --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key  --endpoints https://127.0.0.1:2379 snapshot save <location>
```
* Create a backup of ETCD database (API V3 is used), write the backup to `/var/exam/etcd-backup`

Search for **etcdctl snapshot save** in the documentation page which should result in [Operating etcd clusters for k8s](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)

### :diamonds: Workloads & Scheduling:

#### :gem:  1- Understand deployments and how to perform rolling update and rollbacks:

```bash
k create deploy/<name> --image=<name> --replicas=1
k rollout status deploy/<name>

k rollout history deploy/<name>

# Manually annotate the current revision
k annotate deploy/<name> kubernetes.io/change-cause="Initial deployment"

# Annotate the upcoming revision using the specified command 
k set image deploy/<name> name=<image> --record

# Rollback help
k rollout undo -h

# Rollback to the last revision 
k rollout undo deploy/<name>

# Rollback to specific revision with the --to-revision flag
k rollout undo deploy/<name> --to-revision=<number>


```

<details>
<summary>k explain deploy.spec.strategy.rollingUpdate</summary>
<p>

```bash
.maxSurge # Max no of pods above the desired limit [For the new revision]
.maxUnavailable # Max no of pods that can be absent from the old revision during the rollout
```

</p>
</details>

#### :gem: 2- Use ConfigMaps and Secrets to configure applications:

- Create configMaps imperatively:
```bash
# cm from file
k create cm <name> --from-file=<file-name>.<extension>

# cm from env file 
k create cm <name> --from-env-file=<file-name>.env

# cm from literals 
k create cm <name> --from-literal=K=v --from-literal=K=v
```

- Use configMaps as volumes:
  1. Mount configMap item in a specific path
  * The key is usally a name of a file and all you do is mount the specific file to a specific path.
  ```bash
  # Create a simple configMap
  k create cm test-cm --from-literal=DISTRO=ubuntu --from-literal=CODENAME=focal

  # Generate pod definition
  k run busybox --image=busybox -o yaml --dry-run=client > busybox.yml --command sleep 3600

  # Modify the file to use only the DISTRO item from the configMap
  spec:
  volumes:
  - name: test-v
    configMap:
      name: test-cm
      items:
      - key: DISTRO
        path: distro.name
  containers:
  - command:
    - sleep
    - "3600"
    image: busybox
    name: busybox
    volumeMounts:
    - name: test-v
      mountPath: /tmp
  # Verify
  k exec -it busybox -- cat /tmp/distro.name # shows ubuntu
  ```

  2. Mount the whole configMap to a specific path 

:mag: Search the docs for:
```bash
#Configmap volume
also can be reached via 
k explain pod.spec.volumes.configmap
```

#### :gem: 3- Know how to scale applications
```bash
# Scale a deployment 
k scale deploy/<name> --replicas=<number>

# Conditionally scale using hpa 
k autoscale deploy/<name> --min=<number> --max=<number> --cpu-percent=<number>
```

---

#### Static pods:
* Static pods are directly attached to the kubelet daemon
* The files used for static pods are placed using `staticPodPath` section of the kubelet file in the **kubelet config file**
* static pod path can be found using:
```bash
#1- Search in kubelet config file
cat /var/lib/kubelet/config.yaml

#2- Use kube proxy 
k proxy &
curl localhost:8001/api/v1/nodes/<node-name>/proxy/configz
```
* The path for static pods is usually `/etc/kubernetes/manifests`

---

#### :gem: 5- Understand how resource limits can affect Pod scheduling:
Scheduling on specific nodes using labels and node name:
```bash
k label nodes <name> k=v
k explain pod.spec.nodeSelector 
containers:
  spec:
    nodeSelector:
      k=v

# Using nodeName directly
k explain pod.spec.nodeName
containers:
  spec:
    nodeName: <node-name>
```

```bash
k explain pod.spec.affinity
```

* Affinity, antiAffinity and taints all impact scheduling and limit which pods can be scheduled to which nodes.
* Affinity can be applied at 2 levels, at **Nodes** and at **Pods**
* NodeAffinity sets affinity rules on nodes: specifies which nodes a pod can be scheduled on.
* Inter-pod affinity sets affinity rules between pods
* Taints and tolerations ensues that pods aren't scheduled on inapporpriate nodes
* Taints and tolerations have no effect on daemonsets
* Tains are ignored if the pod has a toleration

There are 3 types of taints `k explain node.spec.taints`
1. NoSchedule: Prevents scheduling of new pods.
2. PreferNoSchedule: doesn't schedule new pods unless there's no other option
3. NoExecute: migrate all pods away from this node



#### :gem: 6- Awareness of manifest management and common templating tools:
**pod.spec**:
There are many fields under the `containers` in the spec, the most signifacnt ones are:
1. **Scheduling**: This helps in selecting the node where the pod will be deployed to either directly through `nodeName` , `nodeSelector` which uses a lable or using `affinity` and `tolerations`

2. **SecurityContext**: defines security attributes like `runAsUser`, `capabilites`
```bash
k explain pod.spec.containers.securityContext

# There's also securityContext available at the spec level 
k explain pod.spec.securityContext
```

<details>
<summary>k explain pod.spec</summary>
<p>

```bash
.securityContext.runAsUser
```

</p>
</details>

<details>
<summary>k explain pod.spec.containers</summary>
<p>

```bash
.securityContext.capabilites
```

</p>
</details>

3. **Lifecycle** 
  . `restartPolicy`: defines action taken after the termination of a pod.
  . `terminationGracePeriodSeconds`: fine-tune the periods after which processes running in the containers of a terminating pod are killed, The grace period is the duration in seconds after the processes running in the pod are sent a termination signal and the time when the processes are forcibly halted with a kill signal.
  . `activeDeadlineSeconds` Optional duration in seconds the pod may be active on the node relative to StartTime before the system will actively try to mark it failed and kill associated containers

<details>
<summary>k explain pod.spec</summary>
<p>

```bash
.restartPolicy
.terminationGracePeriodSeconds
.activeDeadlineSeconds
```

</p>
</details>

4. **ServiceAccount**: Gives specific rights to pods using a specific `serviceAccountName`

5. Hostname & Name resolution: 
`hostAliases`: List of hosts and IPs that gets added to `/etc/hosts` file.
`dnsConfig`:  Specifies the DNS parameters of a pod and update `/etc/resolv.conf`
`hostname`: Specifies the hostname of the Pod If not specified

<details>
<summary>k explain pod.spec</summary>
<p>

```bash
.dnsConfig
.hostAliases
```

</p>
</details>


---

### :diamonds: Troubleshooting:

```bash
k top nodes # metrics-server needs to be deployed
```

#### :gem: Evaluate cluster and node logging:

```bash
# View kubelet logs 
journalctl -u kubelet

# View logs for core componentes 
cd /var/log/containers 
cat $(ls kube-proxy*) | tail -n 1
cat $(ls coredns*) | tail -n 1
cat $(ls kube-apiserver*) | tail -n 1

# View kube-system ns pods
k get po -n kube-system

k logs <name> -n kube-system

k describe po etcd-controller -n kube-system

# Switch to kube-system namespace 
k config set-context --current --namespace=kube-system
```

#### :gem: Manage container stdout & stderr logs:
```bash
# View logs from all containers with specific label in a specific ns 
k logs -l k=v --all-containers -n <ns> 


```

---

### Practice Qs:
1- Create a pod from the image nginx
```bash
k run nginx --image=nginx
```

2- Create a new Deployment with the below attributes using your own deployment definition file
Name: httpd-frontend; Replicas: 3; Image: httpd:2.4-alpine

```bash
k create deploy httpd-fronted --image=httpd:2.4-alpine --replicas=3
```

3- Deploy a pod named nginx-pod using the nginx:alpine image "Use imperative commands only."
```bash
k run nginx-pod --image=nginx:alpine
```

4- Deploy a redis pod using the redis:alpine image with the labels set to tier=db.

Either use imperative commands to create the pod with the labels. Or else use imperative commands to generate the pod definition file, then add the labels before creating the pod using the file.

```bash
k run redis --image=redis:alpine --labels="tier=db"
```

5- Create a service redis-service to expose the redis application within the cluster on port 6379. Use imperative commands
```bash
k expose po redis --port=6379 --target-port=6379 --name=redis-service
```

6- Create a deployment named webapp using the image kodekloud/webapp-color with 3 replicas. Try to use imperative commands only. Do not create definition files.
```bash
k create deploy webapp --image=kodekloud/webapp-color --replicas=3
```

7- Create a new pod called custom-nginx using the nginx image and expose it on container port 8080
```bash
k run custom-nginx --image=nginx --port=8080 
```

8- Create a new namespace called dev-ns.
```bash
k create ns dev-ns
```

9- Create a new deployment called redis-deploy in the dev-ns namespace with the redis image. It should have 2 replicas.
```bash
k create deploy redis-deploy --image=redis --replicas=2 -n dev-ns
```

10- Create a pod called httpd using the image httpd:alpine in the default namespace. 
Next, create a service of type ClusterIP by the same name (httpd). The target port for the service should be 80.
```bash
k run httpd --image=httpd:alpine 
k expose po/httpd --port=80 --target-port=80
```

11- Create a taint on node01 with key of 'spray', value of 'mortein' and effect of 'NoSchedule'
```bash
k taint -h
k taint nodes node01 spray=mortein:NoSchedule
```

12- Create another pod named 'bee' with the NGINX image, which has a toleration set to the taint Mortein
 Image name: nginx
Key: spray
Value: mortein
Effect: NoSchedule
Status: Running 

```bash
k explain pod.spec.tolerations
k run bee --image=nginx -o yaml --dry-run=client > nginx.yml 
# Add to the file 
spec:
  tolerations:
  - effect: NoSchedule
    key: spray 
    value: mortein
    operator: Equal
```

13- Remove the taint on master/controlplane, which currently has the taint effect of NoSchedule

```
k taint nodes controleplane node-role.kubernetes.io/master-
```

14- Apply a label color=blue to node node01

```bash
k label nodes node1 color=blue
```

15- Create a new deployment named blue with the nginx image and 6 replicas

```bash
k create deploy blue --image=nginx --replicas=6
```

16- Set Node Affinity to the deployment to place the pods on node01 only
Name: blue
Replicas: 6
Image: nginx
NodeAffinity: requiredDuringSchedulingIgnoredDuringExecution
Key: color
values: blue 

```bash
k explain pod.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms
matchExpressions # labels 
  key:
  operator:
  values:

k create deploy blue --image=nginx --replicas=6 -o yaml --dry-run=client > nginx.yml
```

17- Create a new deployment named red with the nginx image and 3 replicas, and ensure it gets placed on the master/controlplane node only.

Use the label - node-role.kubernetes.io/master - set on the master/controlplane node.

Name: red
Replicas: 3
Image: nginx
NodeAffinity: requiredDuringSchedulingIgnoredDuringExecution
Key: node-role.kubernetes.io/master
Use the right operator 

```
k create deploy red --image=nginx --replicas=3 -o yaml --dry-run=client
```

18- Deploy a DaemonSet for FluentD Logging.

Use the given specifications.

    Name: elasticsearch
    Namespace: kube-system
    Image: k8s.gcr.io/fluentd-elasticsearch:1.20

```bash
k create deploy elasticsearch --image=k8s.gcr.io/fluentd-elasticsearch:1.20 -n kube-system -o yaml --dry-run=client > elastic.yml
# Modify and change the kind to DaemonSet, remove replicas and strategy
```

19- Create a static pod named static-busybox that uses the busybox image and the command sleep 1000
```
cd /etc/kubernetes/manifests
k run static-busybox --image=busybox -o yaml --dry-run=client > busybox.yml --command sleep 1000
```

delete static pod named static-greenbox
```bash
# ssh into the node containing the pod definition file 
k get po -o wide # See which node the pod is on
k get nodes -o wide # Get node ip
ssh ip-address
cat /var/lib/kubelet/config.yml # Check the staticPodPath
cd /static/pod/path
rm file.yml 
```

20- Create a new Secret named 'db-secret' with the data given(on the right).

You may follow any one of the methods discussed in lecture to create the secret.

Secret Name: db-secret
Secret 1: DB_Host=sql01
Secret 2: DB_User=root
Secret 3: DB_Password=password123 

```
k create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123
```

21- Configure webapp-pod to load environment variables from the newly created secret.
Delete and recreate the pod if required.

Pod name: webapp-pod
Image name: kodekloud/simple-webapp-mysql
Env From: Secret=db-secret 

```
k create secret generic --from-literal=Secret=db-secret
k get po webapp-pod -o yaml > webapp-pod.yaml
k set env po/webapp-pod --from=secret/db-secret 
```

22- Create a multi-container pod with 2 containers.
Use the spec given on the right.

Name: yellow
Container 1 Name: lemon
Container 1 Image: busybox
Container 2 Name: gold
Container 2 Image: redis

```
k run lemon --image=busybox --labels="name=yellow" -o yaml --dry-run=client > multi.yml 
vi multi.yml

- name: gold
  image: redis
```

Edit the pod to add a sidecar container to send logs to ElasticSearch. Mount the log volume to the sidecar container..
Only add a new container. Do not modify anything else. Use the spec on the right.

Name: app
Container Name: sidecar
Container Image: kodekloud/filebeat-configured
Volume Mount: log-volume
Mount Path: /var/log/event-simulator/
Existing Container Name: app
Existing Container Image: kodekloud/event-simulator

```
k get po app -o yaml > app.yml
vi app.yml
containers:
- image: kodekloud/filebeat-configured
  name: sidecar
  volumeMounts:
  - name: log-volume
    mountPath: /var/log/event-simulator
```

Create the necessary roles and role bindings required for the dev-user to create, list and delete pods in the default namespace.

Use the given spec

Role: developer
Role Resources: pods
Role Actions: list
Role Actions: create
RoleBinding: dev-user-binding
RoleBinding: Bound to dev-user

```bash
k create role developer --resource=po --verb=list,create -n default -o yaml --dry-run=client > developer.yml
k apply -f developer.yml

k create rolebinding dev-user-binding --role=developer --user=dev-user --namespace=default -o yaml --dry-run=client > dev-user-binding.yml
k apply -f dev-user-binding.yml
```

A new user michelle joined the team. She will be focusing on the nodes in the cluster. Create the required ClusterRoles and ClusterRoleBindings so she gets access to the nodes.

Grant permission to list nodes 
```bash
k create clusterrole michelle --verb=list --resource=node 
k create clusterrolebinding michelle --clusterrole=michelle --user=michelle
```

michelle's responsibilities are growing and now she will be responsible for storage as well. 
Create the required ClusterRoles and ClusterRoleBindings to allow her access to Storage.

Get the API groups and resource names from command kubectl api-resources. Use the given spec.

ClusterRole: storage-admin
Resource: persistentvolumes
Resource: storageclasses
ClusterRoleBinding: michelle-storage-admin
ClusterRoleBinding Subject: michelle
ClusterRoleBinding Role: storage-admin 
```bash
k create clusterrole storage-admin --resource=pv,sc --verb=create,list,delete -o yaml --dry-run=client > storage-admin.yml
k apply -f storage-admin.yml 

k create clusterrolebinding michelle-storage-admin --clusterrole=storage-admin --user=michelle -o yaml --dry-run=client > michelle-storage-admin.yml
k apply -f michelle-storage-admin.yml
```


---

### Good to know:
- Creating custom resource definitions [crd]
