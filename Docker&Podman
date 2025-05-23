# To run single container, use 
docker run -d --name <continer-name> -p 80:80 <image-name>
podman run -d --name <continer-name> -p 80:80 <image-name>

# To run multiple containers, use a compose.yml file and then run 
docker-compose up
podman-compose up

compose.yml
-----------
version: '3'
services:
  web:
    image: nginx
    ports:
      - "80:80"
  redis:
    image: redis                                  
-----------

# Podman doesnot have a native equivalent to Docker Swarm.
# Docker Swarm is for orchaestrating multi-node container clusters.
docker swarm init
docker servive create

# Docker Compose is a tool used to run multi-conatiner applications on a single machine. Uses docker-compose.yml.
docker-compose up
# Docker Swarm is a container orchaestration tool to manage cluster of nodes.
docker swarm init
docker swarm join
# Dokcer Stack is a tool used to deploy and manage multi-service applications on a docker swarm cluster using a compose file.
docker stack deploy -c docker-compose.yml mystack

# Docker Swarm and Docker Stack go hand in hand. To use Docker Stack, Docker Swarm need to be setup first.
# Docker Swarm provides cluster and orchaestration capability. Docker Stack provides a deployment interface for multi-service apps on a Swarm cluster using docker-compose. yml file
| Component    | Role                                    | Analogy (Kubernetes)        |
| ------------ | --------------------------------------- | --------------------------- |
| Docker Swarm | The orchestrator (cluster engine)       | Kubernetes control plane    |
| Docker Stack | The deployer (uses Compose file)        | `kubectl apply -f app.yaml` |
| Compose file | App definition (services, volumes, etc) | Kubernetes YAML manifest    |
								
