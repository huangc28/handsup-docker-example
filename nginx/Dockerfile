FROM  nginx

LABEL maintainer="bryan@handsup.com"

# copy nginx configs to docker image
ADD fastcgi_params /etc/nginx/fastcgi_params
ADD nginx.conf /etc/nginx/nginx.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log

# reference https://github.com/centos/sig-cloud-instance-images/blob/centos-7/docker/dockerfile#l10
CMD ["/usr/sbin/nginx"]
