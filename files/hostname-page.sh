#!/bin/sh
# Run by the official nginx image entrypoint (/docker-entrypoint.d/*.sh)
# before nginx starts: writes a home page showing the container hostname.
set -e

HOST="$(hostname)"

cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>nginx - ${HOST}</title>
  <style>
    body { font-family: sans-serif; max-width: 40em; margin: 4em auto; }
    code { background: #eee; padding: .2em .4em; border-radius: 4px; }
  </style>
</head>
<body>
  <h1>Welcome to nginx!</h1>
  <p>Container hostname: <code>${HOST}</code></p>
</body>
</html>
EOF
