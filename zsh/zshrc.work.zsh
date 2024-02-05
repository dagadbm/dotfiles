alias gpt1='CURRENT_BRANCH=$(git symbolic-ref --short HEAD); git checkout testing && git reset origin/master --hard && git rebase $CURRENT_BRANCH && git push -f && git checkout - && unset CURRENT_BRANCH'
alias gpt2='CURRENT_BRANCH=$(git symbolic-ref --short HEAD); git checkout testing2 && git reset origin/master --hard && git rebase $CURRENT_BRANCH && git push -f && git checkout - && unset CURRENT_BRANCH'
alias gpt3='CURRENT_BRANCH=$(git symbolic-ref --short HEAD); git checkout testing3 && git reset origin/master --hard && git rebase $CURRENT_BRANCH && git push -f && git checkout - && unset CURRENT_BRANCH'
alias k='kubectl'
alias ks='switch'

alias ssh-cloud="python ~/work/ssh-datafold-cloud.py"
# https://www.notion.so/datafold/9314fc6a1eec4a8294468f6ee4eba553?v=f5e562e4e36341d9a3a26fe1deb367ac&pvs=4
alias pf='ssh -C -R 5027:127.0.0.1:5000 st'

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

# kubeswitch
echo 'source <(switcher init zsh)' >> ~/.zshrc
echo 'source <(compdef _switcher switch)' >> ~/.zshrc

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dagadbm/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dagadbm/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dagadbm/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dagadbm/google-cloud-sdk/completion.zsh.inc'; fi
source <(switcher init zsh)

source <(compdef _switcher switch)
