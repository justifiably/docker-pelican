# Pelican ready-to-go.
FROM justifiably/python3

ARG PELICAN_VERSION=4.2.0

ENV PUID=1001
ENV PGID=1001

# Install commonly used requirements
RUN apk --update --no-cache add libpng bash curl yaml gettext su-exec inotify-tools gettext && \
    apk --no-cache add --virtual build-dependencies python3-dev yaml-dev build-base \
    && pip3 install -U pip pelican==$PELICAN_VERSION Markdown pyyaml pygments feedparser feedgenerator typogrify awesome-slugify beautifulsoup4 python-gettext webassets \
    && apk del build-dependencies python3-dev yaml-dev build-base \
    && rm -r /root/.cache

RUN addgroup --gid "$PGID" pelican && \
    adduser --uid "$PUID" -S -G pelican pelican && \
    mkdir -p /srv/pelican/{output,content,config} && \
    chown -R pelican.pelican /srv/

ADD runpelican.sh /srv/pelican/config/
ADD pelicanconf.py /srv/pelican/config/

VOLUME ['/srv/pelican/config','/srv/pelican/content','/srv/pelican/output']

WORKDIR /srv/pelican/config
CMD ["su-exec", "pelican:users", "/srv/pelican/config/runpelican.sh"]
