FROM ghcr.io/cgwalters/fedora-silverblue:37
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc
RUN rm -f /usr/share/flatpak/fedora-flathub.filter

COPY ublue-firstboot /usr/bin

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
