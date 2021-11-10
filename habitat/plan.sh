pkg_name=haproxy
pkg_origin=collinmcneese
pkg_maintainer="Collin McNeese <cmcneese@chef.io>"
pkg_version=2.4.8 # Bump version to match version of haproxy to use and reference in pkg_source
# From upstream core/haproxy
pkg_license=('GPL-2.0' 'LGPL-2.1')
pkg_source="https://www.haproxy.org/download/2.4/src/haproxy-${pkg_version}.tar.gz"
pkg_upstream_url="https://www.haproxy.org/"
pkg_shasum=e3e4c1ad293bc25e8d8790cc5e45133213dda008bfd0228bf3077259b32ebaa5

pkg_svc_user=root
pkg_svc_group=root

pkg_exports=(
  [port]=frontend.port
  [status-port]=status.port
)
pkg_exposes=(port status-port)
pkg_deps=(
  core/zlib
  core/pcre
  core/openssl
)
pkg_build_deps=(
  core/coreutils
  core/gcc
  core/pcre
  core/make
  core/openssl
  core/zlib
  core/diffutils
)
pkg_bin_dirs=(bin)

do_build() {
  make \
    USE_PCRE=1 \
    USE_PCRE_JIT=1 \
    TARGET=linux-glibc \
    USE_OPENSSL=1 \
    USE_ZLIB=1 \
    USE_GETADDRINFO=1 \
    ADDINC="${CFLAGS}" \
    ADDLIB="${LDFLAGS}"
}

do_install() {
  mkdir -p "${pkg_prefix}"/bin
  cp haproxy "${pkg_prefix}"/bin
}
