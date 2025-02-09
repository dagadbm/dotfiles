alias gpt1='CURRENT_BRANCH=$(git symbolic-ref --short HEAD); git checkout testing && git reset origin/master --hard && git rebase $CURRENT_BRANCH && git push -f && git checkout - && unset CURRENT_BRANCH'
alias gpt2='CURRENT_BRANCH=$(git symbolic-ref --short HEAD); git checkout testing2 && git reset origin/master --hard && git rebase $CURRENT_BRANCH && git push -f && git checkout - && unset CURRENT_BRANCH'
alias gpt3='CURRENT_BRANCH=$(git symbolic-ref --short HEAD); git checkout testing3 && git reset origin/master --hard && git rebase $CURRENT_BRANCH && git push -f && git checkout - && unset CURRENT_BRANCH'
alias k='kubectl'
alias ks='switch'

alias ssh-cloud="python ~/work/ssh-datafold-cloud.py"
# https://www.notion.so/datafold/9314fc6a1eec4a8294468f6ee4eba553?v=f5e562e4e36341d9a3a26fe1deb367ac&pvs=4
# alias pf='ssh -C -R 5027:127.0.0.1:5000 st'
alias pf='ssh -C -R 5027:127.0.0.1:5000 st'
alias phoenix='kubectl --context saas port-forward phoenix-0 -n phoenix 6006:6006'

# using phone
# aws_mfa () {
#   ACCOUNT=${1:-710753145501}
#   MFA_DEVICE=${2:-david}
#   echo "AWS MFA Token: "
#   read mfa
#   RESPONSE=$(aws sts get-session-token --profile mfa --serial-number arn:aws:iam::"$ACCOUNT":mfa/"$MFA_DEVICE" --token-code $mfa)
#   aws configure set --profile default aws_access_key_id $(echo $RESPONSE | jq -r .Credentials.AccessKeyId)
#   aws configure set --profile default aws_secret_access_key $(echo $RESPONSE | jq -r .Credentials.SecretAccessKey)
#   aws configure set --profile default aws_session_token $(echo $RESPONSE | jq -r .Credentials.SessionToken)
# }

# using one password
aws_mfa() {
  ACCOUNT=${1:-710753145501}
  MFA_DEVICE=${2:-one_password}
  ONE_PASSWORD_AWS_ITEM=${3:-AWS Login}
  mfa=$(op item get $ONE_PASSWORD_AWS_ITEM --otp --vault private)
  RESPONSE=$(aws sts get-session-token --profile mfa --serial-number arn:aws:iam::"$ACCOUNT":mfa/"$MFA_DEVICE" --token-code $mfa)
  aws configure set --profile default aws_access_key_id $(echo $RESPONSE | jq -r .Credentials.AccessKeyId)
  aws configure set --profile default aws_secret_access_key $(echo $RESPONSE | jq -r .Credentials.SecretAccessKey)
  aws configure set --profile default aws_session_token $(echo $RESPONSE | jq -r .Credentials.SessionToken)
}

# aws ssm to connect to k8s
# used once to setup ssh keys in the k8s-proxy server
aws_ssm_session () {
  INSTANCE_TAG=${1:-"k8s-proxy"}
  PROFILE=${2:-default}
  INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values='$INSTANCE_TAG'" --profile "$PROFILE" --output json | jq -r '.[][].Instances[].InstanceId')
  echo $INSTANCE_ID
  aws ssm start-session --target "$INSTANCE_ID" --profile "$PROFILE"
}
alias k8s-proxy="ssh -D 1080 -q i-06f1d7d6f04c9b45b"

# kubeswitch
source <(switcher init zsh)
source <(switch completion zsh)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dagadbm/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dagadbm/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dagadbm/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dagadbm/google-cloud-sdk/completion.zsh.inc'; fi

# this is for the datafold repo to work correctly
export PKG_CONFIG_PATH="/opt/homebrew/opt/icu4c/lib/pkgconfig"

portal-setup () {
  export PORTAL_USER=$(op item get 'Portal Credentials' --fields username) && export PORTAL_PASS=$(op item get 'Portal Credentials' --fields password --reveal) && export DD_API_KEY=$(op item get 'DD_API_KEY' --fields password --reveal) && export DD_APP_KEY=$(op item get 'DD_APP_KEY' --fields password --reveal)
}
