# Distroless NGINX docker image
> Important: If you need to update nginx.conf file, please pay attention on file configuration 
> and extend non-privileged file given in the example below

## Overview
Nginx docker image is built on top of `base-debian12` distroless image. The main nginx process is configured to run 
as user `nginx`, hence nginx is not accessible on port 80 but 8080 instead. 

## Usage 

### Local testing

Image built using `container-ops.sh` script has `local/REPONAME/nginx` tag, yet image is available locally only if you run 
build as `LOCAL_TEST=true make nginx`.
```
docker run -it --rm -p 8080:8080 local/REPONAME/nginx:1.25.3
```

### From ECR

```
docker run -it --rm -p 8080:8080 public.ecr.aws/htec/nginx:1.25.3
```

Open your browser on http://localhost:8080/

### Example

Take a look in `../cyberchef` directory to see distroless nginx utilization in practice.

#### 2) Non-privileged nginx config file

```
worker_processes  auto;                                                       
                                                                              
error_log  /var/log/nginx/error.log notice;                                   
pid        /tmp/nginx.pid;                                                    
                                                                              
events {                                                                      
    worker_connections  1024;                                                 
}
                                                         
http {                                                                        
    proxy_temp_path /tmp/proxy_temp;                                          
    client_body_temp_path /tmp/client_temp;                                   
    fastcgi_temp_path /tmp/fastcgi_temp;                                      
    uwsgi_temp_path /tmp/uwsgi_temp;                                          
    scgi_temp_path /tmp/scgi_temp;                                            
                                                                              
    include       /etc/nginx/mime.types;                                      
    default_type  application/octet-stream;                                   
                                                                              
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" ' 
                      '$status $body_bytes_sent "$http_referer" '             
                      '"$http_user_agent" "$http_x_forwarded_for"';           
                                                                              
    access_log  /var/log/nginx/access.log  main;                              
                                                                              
    sendfile        on;                                                       
    #tcp_nopush     on;                                                       
                                                                              
    keepalive_timeout  65;                                                    
                                                                                  
    #gzip  on;                                                                
    include /etc/nginx/conf.d/*.conf;                                            
}
```

default.conf file

```

server {
    listen       8080;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

}



```

### Credits
https://github.com/kyos0109/nginx-distroless
