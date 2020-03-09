#!/bin/bash

# Shell provisioner script used for Kitchen testing

# Load variables from last_build.env
source /tmp/habitat/results/last_build.env || . /tmp/habitat/results/last_build.env

export HAB_LICENSE="accept-no-persist"
export HAB_ORIGIN="${pkg_origin}"

# Install Habitat on system
if [ ! -d /hab ]; then
  echo "Installing Habitat"
  curl -o /tmp/habinstall.sh https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh
  habv2install='bash /tmp/habinstall.sh -t x86_64-linux-kernel2'
  habinstall='bash /tmp/habinstall.sh'
  if [[ $(uname -r) =~ ^2 ]] ; then ${habv2install} ; else ${habinstall} ; fi
fi

# Create `hab` user and group if they do not exist
if getent passwd | grep -q "^hab:" ; then
  echo "Hab user exists, skipping user creation"
else
  useradd hab
fi

# Set license acceptance
echo 'HAB_LICENSE=accept' | sudo tee -a /etc/environment
hab license accept

# Load the Habitat supervisor as a service
hab pkg install collinmcneese/hab_sup_service
  # wait for the supervisor to finish loading before proceeding
  supcnt=0 ; until [ $supcnt -ge 10  ] ; do hab sup stat && break ; echo "Supervisor not up, waiting ... " ; supcnt=$[$supcnt+1] ; sleep 10 ;  done

# Install and load the locally built hart
hab pkg install /tmp/habitat/results/${pkg_artifact}
hab svc load ${pkg_origin}/${pkg_name}
