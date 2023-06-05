#!/bin/bash
scripts_dir=/opt/easy-linux
set -e
# Version: 0.0.3
source ${scripts_dir}/.envrc

install_func() {
        packages=("psutil" "defusedxml" "ujson" "batinfo" "bernhard" "bottle" "cassandra-driver" "chevron" "couchdb" "docker" "elasticsearch" "graphitesender" "hddtemp" "influxdb" "influxdb-client" "kafka-python" "netifaces" "py3nvml" "pika" "podman" "potsdb" "prometheus_client" "py-cpuinfo" "pygal" "pymdstat" "pymongo" "pysnmp" "pySMART.smartx" "pyzmq" "requests" "sparklines" "statsd" "wifi" "zeroconf")
        for package in "${packages[@]}"; do
                        printf "Installing ${package[@]}\\n"
                        pip3 install "${package[@]}"
        done
        pip install --user 'glances[all]'
         glances_install=1
         sudo sed -i "s/glances_install=.*/glances_install=$glances_install/g" "$scripts_dir/.envrc"
         sudo glances
}

main() {
        # Main script logic
clear
source ${scripts_dir}/support/support-Banner_func.sh
sudo apt install -y python2-dev wireless-tools
printf "${CY} Do you want the full install or Docker install?\\n${NC}  "
read -n 1 -r -p "[F]ull or [D]ocker? [F/d] " fullord
fullord=${fullord:-F}
if "$fullord" =~ ^[fF]$; then
install_func
elif "$fullord" =~ ^[dD]$; then
${scripts_dir}/install/menu-containerized.sh
else
    printf "${RED}  Invalid selection.  Choices are F or D.\\n"
fi
}

main
