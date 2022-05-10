#!/bin/bash
# shell script to setup reverse proxy server using Nginx in Rocky linux

# Update system
sudo yum update -y

#install Nginx webserver
sudo yum install nginx -y

# start Nginx service
sudo systemctl start nginx

# configure Nginx start to Boot
sudo systemctl enable nginx

#add firewall rule to allow http trafic
sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --zone=public --permanent --add-service=https
sudo firewall-cmd --reload


# create new configuration file
cd /etc/nginx/
sudo mv nginx.conf nginx.conf.old
sudo touch nginx.conf

#configuration
sudo bash -c 'cat <<EOT >> /etc/nginx/nginx.conf
events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;

        location / {
            proxy_pass http://192.168.116.144:8080/;
            } # end location
        } # end server
    } # end http
EOT'

# test nginx configuration
sudo /usr/sbin/nginx -t

# restart nginx service
sudo systemctl restart nginx

echo "Completed"
