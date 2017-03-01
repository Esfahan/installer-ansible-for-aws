#!/bin/bash
PY_VER=$1
VENV_NAME=$2

if [ ! -e '~/.bash_profile' ]; then
  source ~/.bash_profile
fi

install_dependencies() {
  sudo yum -y install git
  sudo yum -y groupinstall "Development Tools"
  sudo yum -y install readline-devel zlib-devel bzip2-devel sqlite-devel openssl-devel libXext.x86_64 libSM.x86_64 libXrender.x86_64 gcc libffi-devel python-devel
}

pyenv_install() {
  # skip installation when pyenv is already installed.
  if [ `pyenv --version > /dev/null 2>&1; echo $?` == 0 ]; then
    echo '[INFO] pyenv_install() : .pyenv is already installed.(skipping...)'
    return
  fi
  # pyenv
  git clone https://github.com/yyuu/pyenv.git ~/.pyenv;
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile;
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile;
  echo 'eval "$(pyenv init -)"' >> ~/.bash_profile;

  # virtualenv
  git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv;
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile;

  source ~/.bash_profile;
}

python_install() {
  PY_VER=$1
  if [ -z "${PY_VER}" ]; then
    echo '[ERROR] python_install() : specify version of python.'
    exit 1
  fi

  if [ `pyenv versions | grep -w "${PY_VER}" > /dev/null 2>&1; echo $?` == 0 ]; then
    echo "[INFO] python_install() : python ${PY_VER} is already installed.(skipping...)"
  else
    pyenv install ${PY_VER}
  fi
}

ansible_install() {
  PY_VER=$1
  VENV_NAME=$2
  if [ -z "${PY_VER}" ]; then
    echo '[ERROR] ansible_install() : specify version of python.'
    exit 1
  fi
  if [ -z "${VENV_NAME}" ]; then
    echo '[ERROR] ansible_install() : specify VENV_NAME for virtualenv.'
    exit 1
  fi

  pyenv virtualenv ${PY_VER} ${VENV_NAME}
  pyenv local ${PY_VER}/envs/${VENV_NAME}
  pip install --upgrade pip
  pip install ansible
}

# dependencies for aws module on ansible
pip_install() {
  pip install awscli
  pip install boto
  pip install boto3
  pip install botocore
  pip install configparser
}

install_dependencies
pyenv_install
python_install $PY_VER
ansible_install $PY_VER $VENV_NAME
pip_install

echo ''
echo '###############################################'
echo '# You have to do followings after installation'
echo '###############################################'
echo 'source ~/.bash_profile'
echo 'mv ~/installer-ansible-for-aws/.python-version {working directory}/'
echo ''
echo '# If you use modules of aws on ansible, do followings'
echo 'aws configure'
echo 'export AWS_ACCESS_KEY_ID=xxxxxxxx'
echo 'export AWS_SECRET_ACCESS_KEY=xxxxxxxx'
