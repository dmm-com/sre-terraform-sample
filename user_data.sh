#!/bin/bash

if [ ! -f /usr/local/bin/jq ]; then
  curl -o /usr/local/bin/jq -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
  chmod +x /usr/local/bin/jq
fi

SETENV_SHELL="/etc/profile.d/setenv.sh"

INSTANCE_ID=$(curl 169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl 169.254.169.254/latest/meta-data/placement/region)
ZONE=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone)

SSM_PARAMETER_STORE=$(aws ssm get-parameters-by-path --region ${REGION} --path "/sample" --with-decryption)

# Output environment initialize scripts.
cat > "${SETENV_SHELL}" <<EOF
#
# [$(date '+%Y-%m-%dT%H:%M:%S+09:00' -d '9 hour')] Initialized scripts.
#
export INSTANCE_ID=${INSTANCE_ID}
export REGION=${REGION}
export ZONE=${ZONE}
export PATH=$PATH:/usr/local/go/bin
EOF

for PARAMS in $(echo ${SSM_PARAMETER_STORE} | /usr/local/bin/jq -r '.Parameters[] | .Name + "=" + .Value'); do
  echo "export ${PARAMS##*/}"
done >> "${SETENV_SHELL}"

chmod +x "$SETENV_SHELL"
source "$SETENV_SHELL"

if [ ! -f /usr/local/go/bin/go ]; then
  wget https://dl.google.com/go/go1.15.15.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go1.15.15.linux-amd64.tar.gz
  rm ./go1.15.15.linux-amd64.tar.gz
fi

### github token必須
git clone https://oauth:$GITHUB_TOKEN@github.com/dmm-com/sample-go-server && cd sample-go-server 
go build -tags timetzdata -a -installsuffix cgo -o sample-go-server .
nohup ./sample-go-server &