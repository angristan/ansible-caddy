docker run --rm -v `pwd`/bin:/output caddy:2.0.0-builder sh -c "caddy-builder github.com/caddy-dns/cloudflare && cp /usr/bin/caddy /output/"
