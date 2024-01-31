FROM bitnami/ghost:latest

USER root

COPY post_ghost_config.sh /
RUN mkdir -p /.npm \
    && chmod -R g+rwX,o+rw /.npm \
    && chmod +x /post_ghost_config.sh \
    && cp /opt/bitnami/scripts/ghost/entrypoint.sh /tmp/entrypoint.sh \
    && sed '/info "\*\* Ghost setup finished! \*\*"/ a . /post_ghost_config.sh' /tmp/entrypoint.sh > /opt/bitnami/scripts/ghost/entrypoint.sh
ENV AWS_ACCESS_KEY_ID="AWS_ACCESS_KEY_ID" \
    AWS_ACCESS_SECRET_KEY="AWS_ACCESS_SECRET_KEY" \
    AWS_REGION="AWS_REGION" \
    AWS_BUCKET="AWS_BUCKET"

## Revert to the original non-root user
USER 1001

RUN cd /bitnami/ghost \
    && npm i --silent ghost-storage-adapter-s3 \
    && mkdir -p /opt/bitnami/ghost/content/adapters/storage/s3 \
    && cp -r ./node_modules/ghost-storage-adapter-s3/* /opt/bitnami/ghost/content/adapters/storage/s3/
