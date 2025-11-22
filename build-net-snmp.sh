#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
TARGET="$2"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <arch>"
    echo "Ex:"
    echo " $0 5.7.2 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$TARGET" ]; then
    usage
fi

mkdir -p $EPICS_PACKAGE_TOP/net-snmp/$VER
cd $EPICS_PACKAGE_TOP/net-snmp/$VER

# Check if tarball exists
if [ ! -f net-snmp-$VER.tar.gz ]; then
    wget "https://sourceforge.net/projects/net-snmp/files/net-snmp/$VER/net-snmp-$VER.tar.gz/download" -O net-snmp-$VER.tar.gz
fi

# Check if source dir exists
if [ ! -d net-snmp-$VER ]; then
    echo "Extracting tarball..."
    tar -xf "net-snmp-$VER.tar.gz"
fi

mkdir -p build/$TARGET
cd build/$TARGET

../../net-snmp-$VER/configure --prefix="$PWD/../../$TARGET" \
    --enable-shared --enable-static --with-default-snmp-version=3 --with-sys-contact=root@localhost \
    --with-sys-location=Unknown --with-logfile=/var/log/snmpd.log --with-persistent-directory=/var/lib/net-snmp \
    --enable-ipv6 --enable-ucd-snmp-compatibility --with-openssl=internal --with-pic \
    --disable-embedded-perl --enable-as-needed --without-perl-modules \
    --enable-mfd-rewrites \
    --enable-local-smux '--with-mib-modules=host agentx smux ucd-snmp/diskio tcp-mib udp-mib mibII/mta_sendmail ip-mib/ipv4InterfaceTable ip-mib/ipv6InterfaceTable ip-mib/ipAddressPrefixTable/ipAddressPrefixTable ip-mib/ipDefaultRouterTable/ipDefaultRouterTable ip-mib/ipv6ScopeZoneIndexTable ip-mib/ipIfStatsTable sctp-mib rmon-mib etherlike-mib ucd-snmp/lmsensorsMib'

# Make all and install must be in separate steps because autotools sucks.
make 
make install
