FROM quay.io/centos/centos:stream8 as centos

ENV LIBGUESTFS_BACKEND direct

RUN dnf update -y && \
    dnf install -y --setopt=install_weak_deps=False \
        libguestfs-devel

# Create tarball for the appliance. This fixed libguestfs appliance uses the root in qcow2 format as container runtime not always handle correctly sparse files.
RUN mkdir -p /usr/local/lib/guestfs/appliance && \
    cd /usr/local/lib/guestfs/appliance && \
    libguestfs-make-fixed-appliance --xz

FROM registry.access.redhat.com/ubi8/ubi-minimal

RUN mkdir -p /usr/lib64/guestfs
COPY --from=centos /usr/local/lib/guestfs/appliance/appliance-*.tar.xz /usr/lib64/guestfs
