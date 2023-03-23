ostreecontainer --stateroot="fedora-coreos" --remote="fedora" --no-signature-verification --transport="repository" --url="ghcr.io/ublue-os/silverblue-main:38"

%post --logfile=/root/ks-post.log --erroronfail
%end
