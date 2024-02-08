# CKA
![CKA](https://img.shields.io/badge/-CKA-0690FA?style=for-the-badge&logo=kubernetes&logoColor=white)
![K8s](https://img.shields.io/badge/-kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)

An environment made as a preparation for the Certified Kubernetes Administrator exam [CKA v1.29]

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

**--recursive** with `k explain`
```
k explain pod.spec.containers --recursive | less
```

```bash
k <command> -v=<number> # For verbose output, useful for debugging
k cluster-info 
k cluster-info dump
k config -h
k config view # View content of ~/.kube/config | /etc/kubernetes/admin.conf

k get events # Displays events for the current ns 
k get events -n <ns>
# Filter out normal events so that warnings are better shown
k get events --field-selector type!=Normal 

# Auto completion enable
k completion -h 
vi ~/.bashrc
alias k=kubectl
source <(kubectl completion bash | sed 's/kubectl/k/g')
export do="--dry-run=client -o yaml"
source ~/.bashrc

vi ~/.vimrc
set tabstop=2 shiftwidth=2 expandtab ai

# if there's an issue with indentation https://stackoverflow.com/questions/426963/replace-tabs-with-spaces-in-vim
:retab

k explain deploy

# Check all fields in a resource
k explain <resource> --recursive # resource can be pod, deployment, ReplicaSet etc

k explain deploy.spec.strategy

k config -h

k proxy # runs on port 8001 by default 
# use curl http://localhost:8801 -k to see a list of API groups

# NOT kubectl but useful
journalctl -u kubelet
journalctl -u kube-apiserver

# Dry run and validate
k apply -f fileName.yml --validate --dry-run=client

kubelet -h
```

---

### :file_folder: Important Directories:
```bash
/etc/kubernetes/pki/ # Here all certs and keys are stored

# ETCD certs 
/etc/kubernetes/pki/etcd

/etc/cni

/etc/kubernetes/manifests # Static pods definition files that are used for bootstraping kubernetes are located here
  /etcd.yaml
  /kube-apiserver.yaml
  /kube-controller-manager.yaml
  /kube-scheduler.yaml

/etc/kubernetes/kubelet.conf # On Worker nodes 

$HOME/.kube/config # --kubeconfig file

/var/lib/docker # ["aufs", "containers", "image", "volumes"]

/var/lib/kubelet/config.yaml # kubelet config file that contains static pod path //usually /etc/kubernetes/manifests

/var/log/pods # The output of kubectl log <pod> is coming from here with a different formatting

/var/log/containers # docker logs are stored here 

/usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
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
- [Tasks](https://kubernetes.io/docs/tasks/)

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

k get all 

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
# Search docs for authentication or User word
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

#### Using NetworkPolicies to restrict pod communication:
* By default all the pods in the cluster can communicate with each others without restrictions.
* Network Policy is used to modify this behavior

#### How the spec is organized:

![NetPol](https://github.com/theJaxon/CKA/blob/master/etc/NetPol.jpg)

* Check the repo [Kubernetes Network Policy Recipes](https://github.com/ahmetb/kubernetes-network-policy-recipes)

```bash
# View Network policies in the current ns 
k get netpol
```

#### Blocking all incoming traffic using blank Netpol:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-policy 
spec:
  podSelector: {} # Select all pods 
  ingress: [] # No traffic is whitelisted
```
* From [Ahmet Balkan talk at Kubecon](https://www.youtube.com/watch?v=3gGpMmYeEO8)

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

---

#### :gem: 2- Use Kubeadm to install a basic cluster
```bash
# 1. initialize the cluster and the first control plane
sudo kubeadm init

# Initialize from a given config file 
kubeadm init --config=/<path>/<file>.cfg

# 2. Install Pod Network Addon [Flannel, Calico, etc ..]
k apply -f <Network-addon>.yml

# 3. OPTIONAL For HA Cluster
# Join more control plane nodes
sudo kubeadm join <control-plane-host>:<control-plane-port> \
-- token <token> --discovery-token-ca-cert-hash sha256:<hash> \
-- control-plane --certificate-key <certificate-decryption-key>

# 4. Join Worker Nodes 
sudo kubeadm join <control-plane-host>:<control-plane-port> \
--token <token> --discovery-token-ca-cert sha256:<hash>
```

![kubeadm](https://github.com/theJaxon/CKA/blob/master/etc/Kubeadm.jpg)

* Check [kubeadm deep dive](https://youtu.be/DhsFfNSIrQ4)

#### :gem: 5- Perform a version upgrade on a Kubernetes cluster using Kubeadm
Refer to [kubeadm upgrade docs](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)
```bash
# Master node
# Drain the node 
k drain <node> --ignore-daemonsets --delete-local-data
apt-get update && apt-get install -y kubeadm=1.19.x
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v1.19.x

# Upgrade kubelet and kubectl 
apt-get install -y kubelet=1.19.x kubectl=1.19.x

systemctl restart kubelet

# Uncordon the node
k uncordon <node>

# Worker node 
k drain <node> --ignore-daemonsets --delete-local-data
```

#### :gem: 6- Implement etcd backup and restore
```bash
etcdctl snapshot save 
etcdctl snapshot status <location>
etcdctl snapshot restore
```

```bash
yum provides */etcd
yum install -y etcd # This also installs etcdctl
etcdctl -h
ETCDCTL_API=3 etcdctl -h # View help menu of API V3 for etcd
ETCDCTL_API=3 etcdctl snapshot save -h
ps aux | grep etcd

# From the help we figure the parameters needed as 
# --cacert --cert --key --endpoints
ETCDCTL_API=3 etcdctl \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/apiserver-etcd-client.crt \
--key=/etc/kubernetes/pki/apiserver-etcd-client.key snapshot save <location>
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

### :diamonds: Services & Networking:

#### :gem: 4. Know how to use Ingress controllers and Ingress resources:
```bash
# 1. Create an Ingress controller 
k apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/baremetal/deploy.yaml

# Get the ports on which the ingress controller listens 
k get svc -n ingress-nginx 

# Test HTTP and HTTPS 
curl <worker-ip>:<port-number>
curl -k https://<worker-ip>:<port-number>

```

---

### :diamonds: Troubleshooting:
* Logs of the pods are stored in the node running the pod at **`/var/log/pods`**

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

# Logs at node level 

```

#### :gem: Manage container stdout & stderr logs:
```bash
# View logs from all containers with specific label in a specific ns 
k logs -l k=v --all-containers -n <ns> 

```

#### :gem: Multiple Schedulers:
```bash
# From documentation get the page about multi schedulers
# https://kubernetes.io/docs/tasks/extend-kubernetes/configure-multiple-schedulers/
k apply -f my-scheduler.yml
k edit clusterrole system:kube-scheduler
resourceNames:
- kube-scheduler
- my-scheduler # Add this 

# When creating a pod just add
k explain pod.spec.schedulerName
schedulerName: 
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

Create a network policy to allow traffic from the 'Internal' application only to the 'payroll-service' and 'db-service'
Use the spec given on the right. You might want to enable ingress traffic to the pod to test your rules in the UI.

Policy Name: internal-policy
Policy Types: Egress
Egress Allow: payroll
Payroll Port: 8080
Egress Allow: mysql
MYSQL Port: 3306 

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: internal-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      name: internal
  policyTypes:
  - Egress
  egress:
  - to:
      podSelector:
        matchLabels:
          name: mysql
    ports:
    - protocol: TCP
      port: 3306 # MYSQL
  - to:
      podSelector:
        matchLabels:
          name: payroll
    ports:
    - protocol: TCP
      port: 8080
```

Configure a volume to store these logs at /var/log/webapp on the host
Use the spec given on the right.
Name: webapp
Image Name: kodekloud/event-simulator
Volume HostPath: /var/log/webapp
Volume Mount: /log 

```yaml
volumes:
- name: webapp-v
  hostPath:
    path: /var/log/webapp

containers:
- name: webapp
  image: kodekloud/event-simulator
  volumeMounts:
  - name: webapp-v
    mountPath: /log
```

Create a 'Persistent Volume' with the given specification.

Volume Name: pv-log
Storage: 100Mi
Access modes: ReadWriteMany
Host Path: /pv/log 

```yml
k explain pv # Follow the link and copy the NFS example 
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-log
spec:
  capacity:
    storage: 100Mi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  hostPath:
    path: /pv/log
```

Let us claim some of that storage for our application. Create a 'Persistent Volume Claim' with the given specification.

Volume Name: claim-log-1
Storage Request: 50Mi
Access modes: ReadWriteOnce
```yaml
k explain pvc # Follow the link and copy the sample

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: claim-log-1
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 50Mi
```

Update the webapp pod to use the persistent volume claim as its storage.

Replace hostPath configured earlier with the newly created PersistentVolumeClaim

Name: webapp
Image Name: kodekloud/event-simulator
Volume: PersistentVolumeClaim=claim-log-1
Volume Mount: /log 

```yaml
volumes:
- name: pvc-v
  persistentVolumeClaim:
    claimName: claim-log-1
containers:
- name: webapp
  image: kodekloud/event-simulator
  volumeMounts:
  - name: pvc-v
    mountPath: /log
```

Create a new pod called nginx with the image nginx:alpine. 
The Pod should make use of the PVC local-pvc and mount the volume at the path `/var/www/html`.

The PV local-pv should in a bound state.
Pod created with the correct Image?
Pod uses PVC called local-pvc?
local-pv bound?
nginx pod running?
Volume mounted at the correct path? 

```bash
# Generate pod file 
k run nginx --image=nginx:alpine -o yaml --dry-run=client > nginx.yml
```
Modify the generated file:
```yaml
volumes:
- name: test 
  persistentVolumeClaim:
    claimName: local-pvc
containers:
- name: nginx
  image: nginx:alpine
  volumeMounts:
  - name: test 
    mountPath: /var/www/html

```

Create a new Storage Class called delayed-volume-sc that makes use of the below specs:

provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer

Storage Class uses: kubernetes.io/no-provisioner ?
Storage Class volumeBindingMode set to WaitForFirstConsumer ?

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: delayed-volume-sc
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

You are requested to change the URLs at which the applications are made available. Make the video application available at /stream.

Ingress: ingress-wear-watch
Path: /stream
Backend Service: video-service
Backend Service Port: 8080 

```yaml
k edit ingress -n app-space ingress-wear-watch

spec:
  rules:
  - http:
    paths:
    - backend:
      serviceName: video-service
      servicePort: 8080
    path: /stream
```

You are requested to add a new path to your ingress to make the food delivery application available to your customers. Make the new application available at /eat.

Ingress: ingress-wear-watch
Path: /eat
Backend Service: food-service
Backend Service Port: 8080 

```yaml
k edit ingress -n app-space ingress-wear-watch

spec:
  rules:
    paths:
    - path: /eat
      backend:
        serviceName: food-service
        servicePort: 8080
```

You are requested to make the new application available at /pay.
Identify and implement the best approach to making this application available on the ingress controller and test to make sure its working. Look into annotations: rewrite-target as well.

Ingress Created
Path: /pay
Configure correct backend service
Configure correct backend port

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: pay-ingress
  namespace: critical-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /pay
        pathType: ImplementationSpecific
        backend:
          service: # k get svc --all-namespaces
            name: pay-service
            port: 8282
```

Print the names of all deployments in the admin2406 namespace in the following format:
DEPLOYMENT CONTAINER_IMAGE READY_REPLICAS NAMESPACE
<deployment name> <container image used> <ready replica count> <Namespace>
. The data should be sorted by the increasing order of the deployment name.

Example:
DEPLOYMENT CONTAINER_IMAGE READY_REPLICAS NAMESPACE
deploy0 nginx:alpine 1 admin2406
Write the result to the file /opt/admin2406_data.

Hint: Make use of -o custom-columns and --sort-by to print the data in the required format.

```
k get deploy -n admin2046 -o custom-columns='DEPLOYMENT:metadata.name,CONTAINER_IMAGE:spec.template.spec.containers[*].image.READY_REPLICAS:spec.replicas,NAMESPACE:metadata.namespace'
```

Create a new deployment called nginx-deploy, with image nginx:1.16 and 1 replica. Next upgrade the deployment to version 1.17 using rolling update. Make sure that the version upgrade is recorded in the resource annotation.

Weight: 12

    Image: nginx:1.16
    Task: Upgrade the version of the deployment to 1:17
    Task: Record the changes for the image upgrade

```bash
k create deploy nginx-deploy --image=nginx:1.16 --replicas=1 $do > nginx.yml
k apply -f nginx.yml

k set image deploy/nginx-deploy nginx=nginx:1.17 --record
k rollout history deploy nginx-deploy
```

Create a pod called secret-1401 in the admin1401 namespace using the busybox image. The container within the pod should be called secret-admin and should sleep for 4800 seconds.

```yaml
k run secret-1401 --image=busybox -n admin1401 --command sleep 4800 $do > busybox.yml
# Modify containers section 
name: secret-admin

# Volume part
volumes:
- name: dotfile-secret-v
  secret:
    secretName: dotfile-secret

volumeMounts:
- name: dotfile-secret-v
  mountPath: /etc/secret-volume
  readOnly: True
```

The container should mount a read-only secret volume called secret-volume at the path /etc/secret-volume. The secret being mounted has already been created for you and is called dotfile-secret.


Create a Pod called redis-storage with image: redis:alpine with a Volume of type emptyDir that lasts for the life of the Pod. Specs on the right.

Pod named 'redis-storage' created
Pod 'redis-storage' uses Volume type of emptyDir
Pod 'redis-storage' uses volumeMount with mountPath = /data/redis 

```yaml
k run redis-storage --image=redis:alpine $do > redis-storage.yml
vi redis-storage.yml

spec:
  volumes:
  - name: redis-storage-v
    emptyDir: {}

  containers:
  - image: redis:alpine
    name: redis-storage
    volumeMounts:
    - name: redis-storage-v
      mountPath: /data/redis
```

Create a new pod called super-user-pod with image busybox:1.28. Allow the pod to be able to set system_time

The container should sleep for 4800 seconds

Pod: super-user-pod
Container Image: busybox:1.28
SYS_TIME capabilities for the conatiner?

```yaml
k run super-user-pod --image=busybox:1.28 $do > super-user-pod.yml --command sleep 4800
k explain pod.spec.containers.securityContext
vi super-user-pod.yml

containers:
- command:
  - sleep
  - "4800"
  image: busybox:1.28
  name: super-user-pod
  securityContext:
    capabilities:
      add:
        - SYS_TIME
```

Create a new deployment called nginx-deploy, with image nginx:1.16 and 1 replica. Record the version. Next upgrade the deployment to version 1.17 using rolling update. Make sure that the version upgrade is recorded in the resource annotation.

Deployment : nginx-deploy. Image: nginx:1.16
Image: nginx:1.16
Task: Upgrade the version of the deployment to 1:17
Task: Record the changes for the image upgrade 

```yaml
k create deploy nginx-deploy --image=nginx:1.16 --replicas=1 $do > nginx-16.yml
k apply -f nginx-16.yml
k annotate deploy/nginx-deploy kubernetes.io/change-cause="1.16"
k set image deploy/nginx-deploy nginx=nginx:1.17 --record
k rollout history deploy/nginx-deploy
```

Create a new user called john. Grant him access to the cluster. John should have permission to create, list, get, update and delete pods in the development namespace . The private key exists in the location: /root/CKA/john.key and csr at /root/CKA/john.csr

Important Note: As of kubernetes 1.19, the CertificateSigningRequest object expects a signerName.

Please refer documentation below to see the example usage:
https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#create-certificate-request-kubernetes-object

CSR: john-developer Status:Approved
Role Name: developer, namespace: development, Resource: Pods
Access: User 'john' has appropriate permissions 

Create an nginx pod called nginx-resolver using image nginx, expose it internally with a service called nginx-resolver-service. Test that you are able to look up the service and pod names from within the cluster. Use the image: busybox:1.28 for dns lookup. Record results in /root/CKA/nginx.svc and /root/CKA/nginx.pod

Pod: nginx-resolver created
Service DNS Resolution recorded correctly
Pod DNS resolution recorded correctly 

```bash
k run nginx-resolver --image=nginx $do > nginx.yml
k apply -f nginx.yml
k expose pod nginx-resolver --port=80 --target-port=80 --name=nginx-resolver-service
```

Create a new service account with the name pvviewer. 
Grant this Service account access to list all PersistentVolumes in the cluster by creating an appropriate cluster role called pvviewer-role and ClusterRoleBinding called pvviewer-role-binding.
Next, create a pod called pvviewer with the image: redis and serviceAccount: pvviewer in the default namespace

ServiceAccount: pvviewer
ClusterRole: pvviewer-role
ClusterRoleBinding: pvviewer-role-binding
Pod: pvviewer
Pod configured to use ServiceAccount pvviewer ? 

```bash
k create sa pviewer
k create clusterrole pviewer-role -h 
k create clusterrole pviewer-role --verb=list --resource=pv
k create clusterrolebinding pviewer-role-binding --clusterrole=pviewer-role --serviceaccount=default:pviewer
k run pviewer --image=redis --serviceaccount=pviewer $do > pviewer.yml
k apply -f pviewer.yml
```

List the InternalIP of all nodes of the cluster. Save the result to a file /root/CKA/node_ips

Answer should be in the format: InternalIP of master<space>InternalIP of node1<space>InternalIP of node2<space>InternalIP of node3 (in a single line)
```
k get nodes -o jsonpath='{.items[*].status.addresses[*].address}' > /root/CKA/node_ips
```

Create a pod called multi-pod with two containers.
Container 1, name: alpha, image: nginx
Container 2: beta, image: busybox, command sleep 4800.

Environment Variables:
container 1:
name: alpha

Container 2:
name: beta

Pod Name: multi-pod
Container 1: alpha
Container 2: beta
Container beta commands set correctly?
Container 1 Environment Value Set
Container 2 Environment Value Set

```yaml
k run multi-pod --image=busybox --env=name=beta $do > multi-pod.yml --command sleep 4800
vi multi-pod.yml

containers:
- name: alpha
  image: nginx 
  env:
  - name: name
    value: alpha
```

Create a Pod called non-root-pod , image: redis:alpine
runAsUser: 1000
fsGroup: 2000

```yaml
k run non-root-pod --image=redis:alpine $do > non-root-pod.yml
vi non-root-pod.yml

spec:
  securityContext: 
    runAsUser: 1000
    fsGroup: 2000
  containers:
  - image: redis:alpine
    name: non-root-pod
```

We have deployed a new pod called np-test-1 and a service called np-test-service.
Incoming connections to this service are not working. Troubleshoot and fix it.
Create NetworkPolicy, by the name ingress-to-nptest that allows incoming connections to the service over port 80

Important: Don't delete any current objects deployed.

Important: Don't Alter Existing Objects!
NetworkPolicy: Applied to All sources (Incoming traffic from all pods)?
NetWorkPolicy: Correct Port?
NetWorkPolicy: Applied to correct Pod? 

Taint the worker node node01 to be Unschedulable. 
Once done, create a pod called dev-redis, image redis:alpine to ensure workloads are not scheduled to this worker node.
Finally, create a new pod called prod-redis and image redis:alpine with toleration to be scheduled on node01.

key:env_type, value:production, operator: Equal and effect:NoSchedule

Key = env_type
Value = production
Effect = NoSchedule
pod 'dev-redis' (no tolerations) is not scheduled on node01?
Create a pod 'prod-redis' to run on node01

```yaml
k taint node01 -h 
k taint node01 env_type=production:NoSchedule
k run dev-redis --image=redis:alpine
k run prod-redis --image=redis:alpine $do > prod-redis.yml 
vi prod-redis.yml
spec:
  nodeName: node01
  tolerations:
  - key: env_type
    value: production
    operator: "Equal"
    effect: "NoSchedule"
```

Create a pod called hr-pod in hr namespace belonging to the production environment and frontend tier .
image: redis:alpine
Use appropriate labels and create all the required objects if it does not exist in the system already.

hr-pod labeled with environment production?
hr-pod labeled with frontend tier? 

```
k create ns hr
k run hr-pod --image=redis:alpine -n hr -l tier=frontend,environment=production $do > hr-pod.yml
```

Create a cluster using [kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/) 
```bash
kubeadm init 
# In case you're provided with a config file 
kubeadm init --config=<name>.conf

# This will generate the join command that can be executed on the worker nodes
# Install network add-on
# https://v1-17.docs.kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network
k apply -f <network-addon>.yml

# On worker nodes
kubeadm join 

# Validate
k get nodes
```

Create a pod that runs the latest alpine image, it should be configured to sleep 3600 seconds and it should be created in the mynamespace namespace, ensure that the pod gets restarted automatically if it fails.

```bash
# 1- Create the Namespace
k create ns mynamespace $do > mynamespace.yml
k apply -f mynamespace.yml

k run alpine --image=alpine:latest --restart=OnFailure -n mynamespace $do > alpine.yml --command sleep 3600
k apply -f alpine.yml

# Verify
$ k get po -n mynamespace
NAME     READY   STATUS    RESTARTS   AGE
alpine   1/1     Running   0          31s
```

Configure a pod that runs 2 containers. The first container should create the file `/data/runfile.txt`. The second container should only start once this file has been created and it should run sleep 10000 as its task.

1- create a bash script that will check if the file exists and if it does then sleep command is executed
```bash
vi sleep-if-exists.sh
#!/bin/bash
if [ -f /data/runfile.txt ]
then
  sleep "10000"
fi
```

2- The bash script is stored in a configMap and will be used by the 2nd container 
```
k create cm sleep-if-exists --from-file=sleep-if-exists.sh
```

```yml
k run busybox --image=busybox $do > multi-container.yml --command touch /data/runfile.txt 

# Create a configMap to hold our bash script
vi multi-container.yml

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: busybox
  name: busybox
spec:
  volumes:
    # Shared volume that will be mounted in both containers
  - name: shared-v
    emptyDir: {}
    # Bash script is stored in this CM and will be used by the 2nd container
  - name: sleep-if-exists
    configMap:
      name: sleep-if-exists
  initContainers:
  - command:
    - touch
    - /data/runfile.txt
    image: busybox
    name: busybox
    volumeMounts:
    - name: shared-v
      mountPath: /data
  containers:
  - name: sleep
    image: busybox
    volumeMounts:
    - name: sleep-if-exists
      mountPath: /tmp
    - name: shared-v
      mountPath: /data
    command:
    - "/bin/sh"
    - "/tmp/sleep-if-exists.sh"
```

Create a Persistent Volume that uses local host storage. This PV should be accessible from all namespaces. Run a pod with the name `pv-pod` that uses this persistent volume from the `myvol` namespace.

```bash
k create ns myvol $do > myvol.yml
k apply -f myvol.yml
k explain pv # follow the link to the documentation and copy the example
vim pv.yml
```
pv.yml
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mypv
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /tmp
```

```bash
k apply -f pv.yml
# Create PVC 
k explain pvc # follow docs link
vi pvc.yml
```

```yml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mypvc
  namespace: myvol
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 5Gi
```

```bash
k apply -f pvc.yml
k run pv-pod --image=busybox -n myvol $do > pv-pod.yml --command sleep 3600
vim pv-pod.yml
```
```yml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pv-pod
  name: pv-pod
  namespace: myvol
spec:
  volumes:
  - name: devops-v
    persistentVolumeClaim:
      claimName: mypvc
  containers:
  - command:
    - sleep
    - "3600"
    image: busybox
    name: pv-pod
    volumeMounts:
    - name: devops-v
      mountPath: /devops
```
```bash
k apply -f pv-pod.yml
```

In the run-once namespace, run a pod with the name xxazz-pod using the alpine image and the command sleep 3600. Create the namespace if needed, ensure that the task in the pod runs once and after running once the pod stops.

```bash
k create ns run-once $do > run-once.yml
k apply -f run-once.yml
k create job xxazz-pod --image=alpine --namespace=run-once $do > xxazz-pod.yml -- sleep 3600
k apply -f xxazz-pod.yml
```

Create deployment that runs nginx based on 1.14 version. After creating it enable recording and perform a rolling upgrade to upgrade to the latest nginx version.
After successfully performing the upgrade undo the upgrade again.
```bash
k create deploy nginx --image=nginx:1.14 $do > nginx.yml
k apply -f nginx.yml
k set image deploy nginx nginx=nginx:latest --record
k rollout undo deployment nginx 
```

Find all kubernetes objects in all namespaces that have the label k8s-app set tp the value kube-dns
```bash
k get all -A -l k8s-app=kube-dns
```

Create a configMap that defines the variable myuser=mypassword.
Create a pod that runs alpine and uses this variable from the ConfigMap
```bash
k create cm myuser --from-literal=myuser=mypassword $do > myuser.yml
k apply -f myuser.yml
k run alpine --image=alpine $do > alpine.yml
k apply -f alpine.yml
k set env po/alpine --from=cm/myuser $do > alpine.yml
k delete po alpine --force --grace-period=0
k apply -f alpine.yml
```

Create a solution that runs multiple pods in parallel. The solution should start Nginx and ensure that it is started on every node in the cluster in a way that if a new node is added, an Nginx pod is automatically added to the node as well.
```
k create deploy nginx --image=nginx $do > nginx.yml
vi nginx.yml
```
```yml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: nginx
  name: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx
    spec:
      # Allow scheduling on master node
      tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/master
        operator: "Equal"
      containers:
      - image: nginx
        name: nginx
```

Mark node worker2 as unavailable and ensure all pods are moved away from the local node and started again somewhere else 
```
k drain kworker2.example.com --ignore-daemonsets --delete-local-data
```
After successfully executing this task make sure worker2 can be used again
```
k uncordon kworker2.example.com
```

Put worker2 in maintenance mode so that no new pods can be scheduled on it 
```
k cordon kworker2.example.com
```

After successfully executing this task undo it 
```
k uncordon kworker2.example.com
```

Create a backup of the etcd database. Write the backup to /var/exam/etcd-backup
```bash
mkdir -p /var/exam/etcd-backup
ETCDCTL_API=3 etcdctl snapshot save \ 
--cacert /etc/kubernetes/pki/etcd/ca.crt \ 
--cert /etc/kubernetes/pki/etcd/server.crt \ 
--key /etc/kubernetes/pki/etcd/server.key 
/var/exam/etcd-backup/etcd.db

$ ETCDCTL_API=3 etcdctl snapshot status --write-out="table" /var/exam/etcd-backup/etcd.db
+----------+----------+------------+------------+
|   HASH   | REVISION | TOTAL KEYS | TOTAL SIZE |
+----------+----------+------------+------------+
| b59c7550 |  1497728 |       1449 |     5.8 MB |
+----------+----------+------------+------------+
```

Start a pod that runs busybox image. use the name `busy33` for this pod. Expose this pod on a cluster IP address. Configure the pod and service such that DNS name resolution is possible, and use `nslookup` command to look up the names of both. write the output of DNS lookup command to /var/exam/dnsnames.txt
```bash
# DNS Doesn't work correctly on latest busybox so use image <= 1.28
k run busy33 --image=busybox:1.28 $do > busy33.yml --command sleep 3600
k apply -f busy33.yml
k expose pod busy33 --port=53 --target-port=53 --type=ClusterIP
k exec -it busy33 -- sh 

/ # nslookup busy33
Server:    10.96.0.10
Address 1: 10.96.0.10

Name:      busy33
Address 1: 10.244.2.177 busy33
```

Configure your node worker2 to auto start a pod that runs an Nginx webserver using the name auto-web
```bash
k run auto-web --image=nginx $do > nginx.yml
scp nginx.yml vagrant@kworker2.example.com:/etc/kubernetes/manifests/
```

Find the pod with the highest CPU load 
```
k top pod --sort-by=cpu -A | head -n 2
```

---



### Good to know:
- Creating custom resource definitions [crd]
