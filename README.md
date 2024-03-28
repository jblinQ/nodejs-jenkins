
## Dockerize node.js app 
docker build . -t express-demo    

docker run -it -p 127.0.0.1:3002:3000 express-demo  

docker tag express-demo jblinq05/express-demo:latest  
docker push jblinq05/express-demo:latest  

## Launch k8s (minikube)
minikube start --driver=docker --container-runtime=docker --network-plugin=cni --cni=calico   
k create deployment node-app --image jblinq05/express-demo:latest --replicas 2  
k expose deployment node-app --port 5000 --target-port 3000 --type NodePort  

## Launch Jenkins
cd jenkins  
docker compose up -d --build  
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword  

-- Destroy jenkins  
docker compose down -v

## Launch Jenkins
cd jenkins  
docker compose up -d --build  
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword  

-- Destroy jenkins  
docker compose down -v

## Extra
minikube start --driver=docker --container-runtime=docker --network-plugin=cni --cni=calico  
minikube node add --worker  
alias k=kubectl  
k get nodes -owide  

k get po --all-namespaces   
k get po --all-namespaces -owide  

k get services  
k describe svc &name of pod
k get endpoints &name of pod
k describe endpoints &name of pod


k create namespace prod  
k create namespace dev  
k get namespace  
k config get-contexts  

k run node-app --image jblinq05/node-app  
k get po  
k delete po node-app  

k run node-app --image jblinq05/node-app --dry-run=client -oyaml  
k apply -f app.yml  

minikube delete --all

