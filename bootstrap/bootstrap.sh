# SELinux

echo "#################################################################################"
echo "# Environment Values "
echo "#################################################################################"

if command -v apt-get >/dev/null; then
  echo "apt-get is used here"
  #apt -d 1 -y install policycoreutils-python
	apt -y update
	apt -y install curl
elif command -v yum >/dev/null; then
  echo "yum is used here"
  yum -d 1 -y install policycoreutils-python
else
  echo "I have no Idea what im doing here"
	apk add curl
fi

#curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --bind-address 0.0.0.0

# audit-log-maxage=30 # days
# audit-log-maxsize=100 # megabytes
#--log /home/vagrant/k3s.log # default: /var/log/message

#curl -sfL https://get.k3s.io | sh -s - \
#curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v0.9.1 sh -

#curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v0.9.1 sh - 
mkdir /var/log/kubernetes

#_ip=`gcloud compute instances list --format='get(networkInterfaces[0].accessConfigs[0].natIP)'`

echo "#################################################################################"
echo "# Check docker installation"
echo "#################################################################################"
if command -v docker > /dev/null; then
  echo 'found'
else
  sleep 10
fi

echo "#################################################################################"
echo "# Install k3d"
echo "#################################################################################"
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | sh
k3d cluster create hoge-cluster
exit 0

curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v0.9.1 sh -s - \
--no-deploy traefik \
--write-kubeconfig-mode 600 \
--data-dir=/app/var/lib/rancher/k3s \
--bind-address=0.0.0.0 \
--kube-apiserver-arg=audit-log-path=/var/log/k3saudit/audit.log \
--kube-apiserver-arg=audit-log-maxage=30 \
--kube-apiserver-arg=audit-log-maxbackup=10 \
--kube-apiserver-arg=audit-log-maxsize=100 \
--kube-apiserver-arg=log-dir=/var/log/kubernetes/ \
--kube-apiserver-arg=log-file=/var/log/kubernetes/kube-apiserver.log \
--kube-apiserver-arg=logtostderr=false \
--kube-scheduler-arg=log-dir=/var/log/kubernetes/ \
--kube-scheduler-arg=log-file=/var/log/kubernetes/kube-scheduler.log \
--kube-scheduler-arg=logtostderr=false \
--kube-controller-arg=log-dir=/var/log/kubernetes/ \
--kube-controller-arg=log-file=/var/log/kubernetes/kube-controller-manager.log \
--kube-controller-arg=logtostderr=false

#--kube-apiserver-arg=enable-admission-plugins=PodSecurityPolicy
#--kube-apiserver-arg=audit-policy-file=/vagrant/k8s-yamls/audit-policy.yaml \
#--kube-apiserver-arg=bind-address=0.0.0.0 \
#--kube-apiserver-arg=insecure-port=0 \
#--kube-apiserver-arg=profiling=false \
#--kube-apiserver-arg=kubelet-https=true \
#--kube-apiserver-arg=enable-admission-plugins=NamespaceLifecycle \
#--kube-apiserver-arg=audit-log-path=/var/log/apiserver/audit.log \
#--kube-apiserver-arg=audit-log-maxage=30 \
#--kube-apiserver-arg=audit-log-maxbackup=10 \
#--kube-apiserver-arg=audit-log-maxsize=100 \
#--kube-apiserver-arg=service-account-lookup=true \
#--kube-apiserver-arg=enable-admission-plugins=ServiceAccount,NodeRestriction \
#--kube-apiserver-arg=tls-min-version=VersionTLS12 \
#--kube-apiserver-arg=feature-gates=AllAlpha=false \
#--kube-scheduler-arg=profiling=false \
#--kube-scheduler-arg=address=127.0.0.1 \
#--kube-controller-arg=terminated-pod-gc-threshold=100 \
#--kube-controller-arg=profiling=false \
#--kube-controller-arg=use-service-account-credentials=true \
#--kube-controller-arg=feature-gates=RotateKubeletServerCertificate=true \
#--kube-controller-arg=address=127.0.0.1 \
#--kubelet-arg=address=127.0.0.1 \
#--kubelet-arg=anonymous-auth=false \
#--kubelet-arg=protect-kernel-defaults=true \
#--kubelet-arg=make-iptables-util-chains=true \
#--kubelet-arg=event-qps=0 \
#--kubelet-arg=feature-gates=RotateKubeletServerCertificate=true
#--no-deploy=traefik \
#--node-ip=127.0.0.1 \
#--kube-apiserver-arg=tls-cipher-suites="TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384" \
#--kubelet-arg=tls-cipher-suites="TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA34"

exit 0

mkdir ~/.kube
sudo cp -p /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo cp -p /etc/rancher/k3s/k3s.yaml /tmp/kubeconfig
sudo chmod 766 /tmp/kubeconfig
sudo chown vagrant:vagrant ~/.kube/config

export KUBECONFIG=~/.kube/config
echo "export KUBECONFIG=~/.kube/config" >> /home/vagrant/.bashrc

echo "istio"
curl -L -s -S https://istio.io/downloadIstio | sh -
sudo cp -p istio-*/bin/istioctl /usr/local/bin/

kubectl get pod 
kubectl get node

echo "#################################################################################"
echo "# Install Helm"
echo "#################################################################################"
wget https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz
tar xzf helm-v2.16.1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

sleep 10

helm init --service-account=tiller --upgrade

#wget https://get.helm.sh/helm-v3.0.2-linux-amd64.tar.gz
#curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
#chmod 700 get_helm.sh
#./get_helm.sh

echo "#################################################################################"
echo "# install Brigade"
echo "#################################################################################"
wget -O brig https://github.com/brigadecore/brigade/releases/download/v1.2.1/brig-linux-amd64
chmod +x brig
sudo mv brig /usr/local/bin/

kubectl create namespace brigade
helm repo add brigade https://brigadecore.github.io/charts
helm install -n brigade brigade/brigade --set rbac.enabled=true
#helm install -n brigade brigade/brigade --namespace brigade --set rbac.enabled=true



