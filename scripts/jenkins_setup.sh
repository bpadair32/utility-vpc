#!/bin/bash

#Setup the extra volume where we are going to store Jenkins
vgchange -ay

DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then
   #Wait for the EBS device to be attached
   DEVICENAME=`echo "${DEVICE}" | awk -F '/' '{ print $3 }'`
   DEVICEEXISTS=''
   while [[ -z $DEVICEEXISTS ]]; do
      echo "Checking $DEVICENAME"
      DEVICEEXISTS=`lsblk | grep "$DEVICENAME" | wc -l`
      if [[ $DEVICEEXISTS != "1" ]]; then
         sleep 10
      fi
    done
    pvcreate ${DEVICE}
    vgcreate data ${DEVICE}
    lvcreate --name volume1 -l 100%FREE data
    mkfs.ext4 /dev/data/volume1
fi
mkdir -p /var/lib/jenkins
echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' >> /etc/fstab
mount /var/lib/jenkins

#Add the Jenkins repo
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update

#Install needed dependencies
apt-get install -y python3 openjdk-8-jre
update-java-alternatives --set java-1.8.0-openjdk-amd64

#Install Jenkins
apt-get install -y jenkins=${JENKINS_VERSION} unzip

#Install pip
wget -q https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py
rm -f get-pip.py

#Install the AWS CLI
pip install awscli

#Install Terraform
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

#Install Packer
cd /usr/local/bin
wget -q https://releases.hashicorp.com/packer/0.10.2/packer_0.10.2_linux_amd64.zip
unzip packer_0.10.2_linux_amd64.zip

#Finish up
apt-get clean
rm terraform_${TERAFORM_VERSION}_linux_amd64.zip
rm packer_0.10.2_linux_amd64.zip