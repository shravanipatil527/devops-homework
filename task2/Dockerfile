# Base image is nginx:stable
FROM nginx:stable

USER root

RUN apt-get update && apt-get install -y --no-install-recommends curl

#Define our static files location volume
VOLUME /opt/html:/usr/share/nginx/html
VOLUME /opt/html/nginx.conf:/etc/nginx/nginx.conf
VOLUME /opt/html/default.conf:/etc/nginx/conf.d/default.conf

# Add a new user "john" with user id 8877
RUN useradd -u 8877 john

# Set file permissions for john user
RUN touch /var/run/nginx.pid && \
  chown -R john:john /var/run/nginx.pid && \
  chown -R john:john /var/cache/nginx


# Change to non-root privilege
USER john

# Expose ports
EXPOSE 80
