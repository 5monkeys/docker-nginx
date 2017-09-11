FROM nginx:latest

RUN apt-get --yes update && \
    apt-get --yes install openssl

COPY nginx.conf /etc/nginx/
COPY default.conf /etc/nginx/conf.d/
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
