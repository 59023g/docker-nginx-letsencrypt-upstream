#!/bin/bash
# special thanks to https://github.com/diresi
set -e

BASEDIR=${BASEDIR:-/etc/letsencrypt}
LIVEDIR=${LIVEDIR:-${BASEDIR}/live}

CERTBOT="/usr/bin/certbot --text --webroot -w /var/lib/certbot/"
SYMLINK=/etc/nginx/ssl/latest

function fail ()
{
    (>&2 echo $@)
    exit 1
}

function log ()
{
    [ ${VERBOSE} -eq 0 ] || echo $@
}
################################################################################
# http://stackoverflow.com/a/7948533/203515
# NOTE: This requires GNU getopt.  On Mac OS X and FreeBSD, you have to install this
# separately; see below.
TEMP=`getopt -o vCLR: --long verbose,nocert,nolink,noreload \
             -n 'certbot.sh' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

VERBOSE=0
CERT=1
LINK=1
RELOAD=1
while true; do
  case "$1" in
    -v | --verbose ) VERBOSE=1; shift ;;
    -C | --nocert ) CERT=0; shift ;;
    -L | --nolink ) LINK=0; shift ;;
    -R | --noreload ) RELOAD=0; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done
# done with option parsing
#################################################################################

# not verbose? hush certbot
[ ${VERBOSE} -eq 0 ] && CERTBOT="${CERTBOT} -q"

function install_link ()
{
    LATEST=$(ls -td1 ${LIVEDIR}/* | head -n1)
    log "Using live directory: ${LATEST}"
    rm -f ${SYMLINK}
    ln -sf ${LATEST} ${SYMLINK}
}

function certbot_init ()
{
    [ -n "${EMAIL}" ] || fail "EMAIL environment variable missing"
    [ -n "${DOMAINS}" ] || fail "DOMAINS environment variable missing"
    # expand ${DOMAINS} and replace whitespace with commas, certbot accepts
    # comma-separated lists of domains or multiple -d parameters
    DOMAINS=$(eval echo $DOMAINS | sed -e "s| \+|,|g")

    log "Requesting initial certificate for ${DOMAINS}"
    ${CERTBOT} certonly ${TOS} --email ${EMAIL} -d ${DOMAINS}
}

function certbot_renew ()
{
    log "Renewing existing certificate"
    ${CERTBOT} renew
}
function certbot ()
{
    [ -d ${LIVEDIR} ] && certbot_renew || certbot_init
}

function reload_nginx ()
{
    log "Reloading nginx"
    nginx -s reload
}

[ ${CERT} -eq 0 ] || certbot
[ ${LINK} -eq 0 ] || install_link
[ ${RELOAD} -eq 0 ] || reload_nginx
