# docker run --rm -v $(pwd)/bin:/output caddy:2.2.1-builder sh -c "caddy-builder github.com/caddy-dns/cloudflare github.com/greenpau/caddy-auth-jwt github.com/greenpau/caddy-auth-portal && cp /usr/bin/caddy /output/"

export GOOS=linux
export GOARCH=amd64

xcaddy build --with github.com/caddy-dns/cloudflare --output bin/caddy
xcaddy build --with github.com/caddy-dns/cloudflare --with github.com/greenpau/caddy-auth-jwt --with github.com/greenpau/caddy-auth-portal --output bin/caddy-auth
