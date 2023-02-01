FROM quay.io/centos/centos:stream8

ENV LIBGUESTFS_BACKEND direct

RUN dnf update -y && \
    dnf install -y --setopt=install_weak_deps=False \
        libguestfs-devel \
        qemu-img

# Create tarball for the appliance. This fixed libguestfs appliance uses the root in qcow2 format as container runtime not always handle correctly sparse files.
RUN mkdir -p /usr/lib64/guestfs/appliance && \
    libguestfs-make-fixed-appliance /usr/lib64/guestfs/appliance && \
    cd /usr/lib64/guestfs/appliance && \
    qemu-img convert -c -O qcow2 root root.qcow2 && \
    mv root.qcow2 root

