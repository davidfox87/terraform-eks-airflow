kind create cluster --name airflow-cluster --config kind-cluster.yaml 
kubectl cluster-info --context kind-airflow-cluster
kubectl get nodes -o wide

deploy airflow

1. create namespace
    kubectl create namespace airflow
2. list namespaces
    kubectl get ns
3. fetch airflow via helm and get the latest version of the airflow chart
    helm repo add apache-airflow https://airflow.apache.org
    helm repo update
    helm search repo airflow

4. deploy
    helm install airflow apache-airflow/airflow --namespace airflow --debug --timeout 10m0s
    helm ls -n airflow
5. get all the pods deployed by airflow
     kubectl get po -n airflow

6. Check the logs of one of the pods
    kubectl logs airflow-scheduler-5c648c489d-2xvlr -n airflow -c scheduler

7. Take a look at the UI by setting up a port forward to the UI
    kubectl port-forward svc/airflow-webserver 8080:8080 -n airflow

# customizing our instance of airflow by modifying values.yaml
1. helm show values apache-airflow/airflow > values.yaml
2. create ConfigMap in variables.yaml
```
    apiVersion: v1
kind: ConfigMap
metadata:
  namespace: airflow
  name: airflow-variables
data:
  AIRFLOW_VAR_MY_S3_BUCKET: "my_s3_name"
  ```

3. values.yaml add 
```
extraEnvFrom: |
  - configMapRef:
    name: 'airflow-variables'
```

4. Upload ConifgMap to cluster
```
kubectl apply -f variables.yaml
```

5. helm upgrade --install airflow apache-airflow/airflow -n airflow -f values.yaml --debug
6. helm ls -n airflow

# verify that the ConfigMap was successful
1. kubectl get po -n airflow
2. kubectl exec --stdin --tty airflow-webserver-67ddff448c-h2kkg -n airflow -- /bin/bash
3. python
4. from airflow.models import Variable
5. Variable.get("my_s3_bucket")



# fetch dags from private github repo
1. ssh-keygen -t rsa -f rsa -b 4096 -m PEM
2. go to github repo -> settings -> deploy-keys -> add new 
3. paste in rsa.pub SSH public key
4. Configure gitsync section in values.yaml
5. Store the github ssh private key as a secret
6. create the secret
```
kubectl create secret generic airflow-ssh-git-secret \
    --from-file=gitSsKey=/home/david/terraform-eks-airflow/local/.ssh/rsa \
    -n airflow
kubectl get secrets -n airflow
```

If that doesn't work, then do kubectl apply -f ssh-git-secret.yaml

7. Upgrade with new config
```
helm upgrade --install airflow apache-airflow/airflow -n airflow -f values.yaml --debug
```

8.  kubectl get po -n airflow -o wide

9. If some issue causes error and crashloopbackoff, probably an issue with the private SSH key. Check
   the logs of the container 
   ```
   kubectl logs airflow-scheduler-8f5d64678-lr2h9 -c git-sync-init  -n airflow
   ```

# delete local Kind cluster
```
kind delete cluster --name airflow-cluster
```