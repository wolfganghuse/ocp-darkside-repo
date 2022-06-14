sudo cp cert/ca.crt /etc/pki/ca-trust/source/anchors/ca.crt
sudo update-ca-trust

mkdir ipi
echo '{"auths":{"ds-registry.dachlab.net:8443": {"auth": "'$(echo -n 'nutanix':'nutanix/4u' | base64 -w0 )'","email": "you@example.com"}}}' > ipi/ps.json

wget http://10.42.194.11/Users/Huse/ipi/kubectl
wget http://10.42.194.11/Users/Huse/ipi/oc
wget http://10.42.194.11//Users/Huse/ipi/ccoctl
wget http://10.42.194.11/Users/Huse/ipi/openshift-install
wget http://10.42.194.11/Users/Huse/openshift-tests

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

sudo install oc /usr/local/bin
sudo install ccoctl /usr/local/bin
sudo install openshift-install /usr/local/bin
sudo install openshift-tests /usr/local/bin

