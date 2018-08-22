# Deploy script runs nessecary terraform commands to tear down and stand up
# the slate-server and required resources
#
#   Variables and parameters:
#
#     [-f] | FORCE_ARG  | Force approve argument, varies dependong on TF version
#     [-t] | TARGET     | environment to which to deply the stack (prod, dev)
#     [-e] | ENABLE_EIP | boolean elastic_ip feature toggle
#     [-k] | KEY_NAME   | Name of key pair to attach to ec2 instance
#     [-b] | S3_BUCKET  | specifies name terraform backend s3 bucket
#     [-r] | REGION     | specifies region where desired s3 bucket resides
#
#          | DOC_REPO   | repository of swagger/openapi specs
#          | SLATE_REPO | Repository of slate project to host
#
# EPC Summer 2018 Intern - joshua.rodstein@elliemae.com
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #



FORCE_ARG="-force"
TARGET=""
ENABLE_EIP="false"
KEY_NAME="epc-api-doc-server-key-pair"
S3_BUCKET="epc-tf-remote-state"
REGION="us-east-2"
DOC_REPO=http://jrodstein:Jackalgod1@githubdev.dco.elmae/api-platform/partner-connect.git
SLATE_REPO=http://jrodstein:Jackalgod1@githubdev.dco.elmae/jrodstein/slate.git

while getopts f:t:e:k:b:r: option
do
  case "${option}"
    in
      t) TARGET=${OPTARG};;
      f) FORCE_ARG=${OPTARG};;
      e) ENABLE_EIP=${OPTARG};;
      k) KEY_NAME=${OPTARG};;
      b) S3_BUCKET=${OPTARG};;
      r) REGION=${OPTARG};;
  esac
done

# If local dev, will need to clean up working directory
if [ -e ./partner-connect ]
then
  rm -rf ./partner-connect
fi

if [ -e ./include/slate ]
then
  rm -rf ./include/slate
fi

if [ -e ./include/specs ]
then
  rm -rf ./include/specs
fi

# clone repositories into workspace
# ********** ISSUE: Unable to pass Jenkins GH creds to be included in git clone **************
# ***************** Currently passing user GH creds explicitly in repo URL *******************
git clone --single-branch -b swagger-spec $DOC_REPO
git clone $SLATE_REPO

# move cloned repositories into proper directory to be included with file provisioning
mv ./slate ./include
mkdir ./include/specs
mv ./partner-connect/* ./include/specs

# Retrieve ServiceUser private key for remote-exec provisioning
# and strip unnessecary chars
aws\
  --region=us-east-2\
  ssm get-parameter\
  --name ${KEY_NAME}\
  --with-decryption\
  --output text 2>&1\
  | sed 's/.*-----BEGIN/-----BEGIN/'\
  | sed 's/KEY-----.*/KEY-----/'\
  > private_key.pem

# initialize Terraform and remote backend config
terraform init\
  -backend-config="bucket=${S3_BUCKET}"\
  -backend-config="region=${REGION}"\
  -backend-config="key=slate-server-${TARGET}/terraform.tfstate"

terraform destroy\
  -var "env=${TARGET}"\
  -var "region=${REGION}"\
  -var "enable_eip=${ENABLE_EIP}"\
  ${FORCE_ARG}

terraform plan\
  -var "env=${TARGET}"\
  -var "enable_eip=${ENABLE_EIP}"

terraform apply\
  -var "env=${TARGET}"\
  -var "enable_eip=${ENABLE_EIP}"\


# Remove private_key from workspace as soon as build has finished
#rm ./private_key.pem
