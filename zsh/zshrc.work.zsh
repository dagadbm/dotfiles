alias gpt1='CURRENT_BRANCH=$(git symbolic-ref --short HEAD); git checkout testing && git reset origin/master --hard && git rebase $CURRENT_BRANCH && git push -f && git checkout - && unset CURRENT_BRANCH'
alias gpt2='CURRENT_BRANCH=$(git symbolic-ref --short HEAD); git checkout testing2 && git reset origin/master --hard && git rebase $CURRENT_BRANCH && git push -f && git checkout - && unset CURRENT_BRANCH'

source /Users/dagadbm/.docker/init-zsh.sh || true # Added by Docker Desktop
alias ssh-cloud="python ~/work/ssh-datafold-cloud.py"

aws_mfa () {
  ACCOUNT=${2:-710753145501}
  MFA_DEVICE=${1:-david}
  echo "AWS MFA Token: "
  read mfa
  RESPONSE=$(aws sts get-session-token --profile mfa --serial-number arn:aws:iam::"$ACCOUNT":mfa/"$MFA_DEVICE" --token-code $mfa)
  aws configure set --profile default aws_access_key_id $(echo $RESPONSE | jq -r .Credentials.AccessKeyId)
  aws configure set --profile default aws_secret_access_key $(echo $RESPONSE | jq -r .Credentials.SecretAccessKey)
  aws configure set --profile default aws_session_token $(echo $RESPONSE | jq -r .Credentials.SessionToken)
}

aws_one_password () {
  ACCOUNT=${2:-710753145501}
  MFA_DEVICE=${3:-one_password}
  ONE_PASSWORD_AWS_ITEM=${3:-My AWS Login}
  mfa=$(op item get $ONE_PASSWORD_AWS_ITEM --otp --vault private)
  RESPONSE=$(aws sts get-session-token --profile mfa --serial-number arn:aws:iam::"$ACCOUNT":mfa/"$MFA_DEVICE" --token-code $mfa)
  aws configure set --profile default aws_access_key_id $(echo $RESPONSE | jq -r .Credentials.AccessKeyId)
  aws configure set --profile default aws_secret_access_key $(echo $RESPONSE | jq -r .Credentials.SecretAccessKey)
  aws configure set --profile default aws_session_token $(echo $RESPONSE | jq -r .Credentials.SessionToken)
}
