FROM ghcr.io/cgwalters/fedora-silverblue:37
# See https://pagure.io/releng/issue/11047 for final location

LABEL org.opencontainers.image.created='2022-06-27T00:00:00Z' \
      org.opencontainers.image.description="The description goes in here." \
      io.artifacthub.package.readme-url="https://github.com/ublue-os/base/blob/main/README.md" \
      io.artifacthub.package.logo-url='https://avatars.githubusercontent.com/u/120078124?s=200&v=4'

COPY etc /etc

RUN rpm-ostree override remove firefox firefox-langpacks && \
    rpm-ostree install distrobox gnome-tweaks vte291-gtk4-devel && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    rpm-ostree cleanup -m && \
    ostree container commit

# VanillaOS first-setup
COPY --from=ghcr.io/adamisrael/vanilla-first-setup:latest /first-setup/vanilla-first-setup.tar.gz /tmp/vanilla-first-setup.tar.gz
RUN tar xf /tmp/vanilla-first-setup.tar.gz --strip-component=1 -C / && \
    chmod +x /usr/bin/vanilla-first-setup && \
    ostree container commit
