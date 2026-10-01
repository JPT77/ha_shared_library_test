FROM ghcr.io/home-assistant/base:latest

ARG LIB_REPO="https://codeberg.org/JPT5/ha_shared_library_test.git"
ARG LIB_REF="main"

RUN apk add --no-cache python3 py3-pip git

RUN pip install --no-cache-dir --break-system-packages \
    "git+${LIB_REPO}@${LIB_REF}#subdirectory=shared/jpt_test_lib"

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
