# CTOS7

Procedimentos para preparação do servidor ctos7 (OCI)
```
> CtOS 7

# timedatectl set-timezone America/Sao_Paulo
# sed -i s/^SELINUX=.*$/SELINUX=permissive/ /etc/selinux/config && setenforce 0
# systemctl stop firewalld && systemctl disable firewalld
# rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
# yum install -y epel-release https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
# yum update -y
# yum install -y python3 python3-pip python3-devel '@Development Tools' git libselinux-python3 htop
# pip3 install --upgrade pip && pip3 install --upgrade setuptools
# pip3 install setuptools_rust wheel && pip3 install ansible
# pip install boto && pip install boto3 (inventario AWS)
# export PATH=/usr/local/bin:$PATH && . /etc/profile (se necessário)
# ansible --version
# curl -sSL https://get.docker.com | sh
# pip3 install docker
# pip3 install docker-compose
# docker --version
# systemctl enable --now docker
# mkdir -p /tmp/git
# git clone -b 17.0.1 https://github.com/ansible/awx.git /tmp/git

# vi /tmp/git/installer/inventory
	awx_task_hostname=awx
  awx_web_hostname=awxweb
	postgres_data_dir="/var/lib/awx/.awx/pgdocker" #talvez selecionar uma pasta em outra partição
  host_port=80
  host_port_ssl=443
	docker_compose_dir="/var/lib/awx/.awx/awxcompose" #talvez selecionar uma pasta em outra partição

	pg_username=awx
	pg_password=awxpass
  pg_database=awx
  pg_port=5432

	admin_user=admin
  admin_password=password

	create_preload_data=True

	secret_key=awxsecret
	
	project_data_dir=/var/lib/awx/projects

# mkdir -p /var/lib/awx/projects/
# ansible-playbook -i /tmp/git/installer/inventory /tmp/git/installer/install.yml

# docker exec -it awx_task /bin/bash (se necessário)
	/usr/bin/awx-manage create_preload_data

# mkdir -p /var/lib/awx/projects/update_system
# vi /var/lib/awx/projects/update_system/main.yml

---

- name: Update/Upgrade Systems - Starting Deploy
  hosts: all
  tasks:
        - name: CentOS | Update System
          yum: name=* state=latest update_cache=yes
          when: ansible_distribution == "CentOS" or ansible_distribution == "RedHat"

        - name: Oracle Linux Server | Update System
          yum: name=* state=latest update_cache=yes
          when: ansible_distribution == "OracleLinux"

        - name: Debian | Update System
          apt: state=latest update_cache=yes
          when: ansible_distribution == "Debian" or ansible_distribution == "Ubuntu"

...

> Target

# useradd awx
# passwd awx
# echo "awx  ALL=(ALL)   	ALL" >> /etc/sudoers
```

### Pendências
|Ansible      |Descrição|
|-------------|-----------|
|`text`| text

