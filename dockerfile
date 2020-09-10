Docker file

Enable IPv4 IP forwarding:

Check the current value:

/sbin/sysctl net.ipv4.conf.all.forwarding


Enable the setting:
/sbin/sysctl -w net.ipv4.conf.all.forwarding=1

#sysctl net.ipv4.ip_forward
net.ipv4.ip_forward = 1

Check the output of docker info:

docker info
To preserve this setting post-reboot, please refer to the /etc/sysctl.conf notes:

sysctl settings are defined through files in
/usr/lib/sysctl.d/, /run/sysctl.d/, and /etc/sysctl.d/.

Vendors settings live in /usr/lib/sysctl.d/.
To override a whole file, create a new file with the same in
/etc/sysctl.d/ and put new settings there. To override
only specific settings, add a file with a lexically later
name in /etc/sysctl.d/ and put new settings there.

For more information, see sysctl.conf(5) and sysctl.d(5).




New image:

httpd
htop
vim
index.html trong /var/www/html

/usr/sbin/httpd khi container image chay

--
#host
mkdir my image
vi index.html

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset=UTF-8">
<meta name="viewport" content=width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<title>Website Demo</title>
<head>
<body>
<h1>My IMAGE</h1>
<body>
<html>

--
Container 

docker run -it --name File centos:latest

yum update -y

yum install httpd httpd-tools -y

yum install vim -y

yum install epel-release -y 
yum install htop -y


--

#copy

docker cp /root/myimage/index.html f96bb9f9f30b:/var/www/html

#build image
docker commit f96bb9f9f30b myimage:v1

docker images

#rm container cu
docker rm -f f96bb9f9f30b

#tao container test, chay nen
docker run --rm -p 9898:80 myimage:v1 httpd -D FOREGROUND

#vao webrowser may host check

http://localhost:9898/index.html

---

Docker File:

# xây dựng image mới từ image centos:latest (CENTOS 7)
FROM centos:latest

# Cập nhật các gói và cài vào đó HTTPD, HTOP, VIM
RUN yum update -y
RUN yum install httpd httpd-tools -y
RUN yum install epel-release -y \
    && yum update -y \
    && yum install htop -y \
    && yum install vim -y

#Thiết lập thư mục hiện tại
WORKDIR /var/www/html
# Copy tất cả các file trong thư mục hiện tại (.)  vào WORKDIR
ADD . /var/www/html

#Thiết lập khi tạo container từ image sẽ mở cổng 80
# ở mạng mà container nối vào
EXPOSE 80

# Khi chạy container tự động chạy ngay httpd
ENTRYPOINT ["/usr/sbin/httpd"]

#chạy terminate
CMD ["-D", "FOREGROUND"]

----
FROM centos:latest

RUN yum update -y
RUN yum install httpd httpd-tools -y
RUN yum install vim -y
RUN yum install epel-release -y
RUn yum install htop -y

WORKDIR /var/www/html
ADD ./index.html /var/www/html

EXPOSE 80

ENTRYPOINT [ "httpd" ]
CMD [ "-D", "FOREGROUND" ]

---
#host
chattr -i /etc/resolv.conf
dns --> 8.8.8.8

--
#/root/myimage

#docker build -t name:version -f dockerfile /workdir
docker build -t mydockerfilecontainer:v1 -f dockerfile .

docker images -a

#xoa image rac
docker image prune
#WARNING! This will remove all dangling images.

#tao container test
docker run -it --name testdockerfile -p 9898:80 -h testdockerfile mydockerfilecontainer:v1

#vao Webrowser may host check:
http://localhost:9898/

#check layer
docker images -a

------ Docker file it layer


vi dockerfile2

--
FROM centos:latest

RUN yum update -y \
    && yum install httpd httpd-tools -y \
    && yum install epel-release -y \
    && yum update -y \
    && yum install htop -y \
    && yum install vim -y

ADD . /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]

--
docker build -t dockerf2:v1 -f dockerfile2 .

--
docker image prune
docker system prune
docker rmi (docker images -f “dangling=true” -q )
docker rmi $(docker images -a | grep "^<none>" | awk "{print $3}")
docker images -a | grep none | awk '{ print $3; }' | xargs docker rmi --force

--
docker images -a

docker run -it --name dockerf2test -p 9898:80 -h dockerf2test dockerf2:v1