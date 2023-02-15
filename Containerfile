ARG FEDORA_MAJOR_VERSION=37

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

LABEL org.opencontainers.image.created=2022-06-27T00:00:00Z
LABEL org.opencontainers.image.description="The description goes in here."
LABEL io.artifacthub.package.readme-url=https://github.com/ublue-os/base/blob/main/README.md
LABEL io.artifacthub.package.logo-url="https://avatars.githubusercontent.com/u/120078124?s=200&v=4"

COPY etc /etc

RUN wget https://copr.fedorainfracloud.org/coprs/ublue-os/vanilla-first-setup/repo/fedora-$(rpm -E %fedora)/ublue-os-vanilla-first-setup-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ublue-os-vanilla-first-setup.repo && \
    rpm-ostree override remove firefox firefox-langpacks && \
    rpm-ostree install vanilla-first-setup distrobox gnome-tweaks vte291-gtk4-devel && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer
    
# Cleanup
RUN sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-vanilla-first-setup.repo && \
    rpm-ostree cleanup -m && \
    rm -rf \
        /tmp/* \
        /var/* && \
    ostree container commit
