FROM nginx

COPY wrapper.sh /

COPY default.conf /etc/nginx/conf.d/
COPY html /usr/share/nginx/html

CMD ["./wrapper.sh"]
