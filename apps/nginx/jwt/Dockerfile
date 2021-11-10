ARG VERSION=1.20.1

FROM public.ecr.aws/htec/nginx:${VERSION}
COPY --chown=nginx:nginx conf/ /etc/nginx/

STOPSIGNAL SIGTERM

USER nginx

EXPOSE 8080
ENTRYPOINT ["nginx", "-g", "daemon off;"]
