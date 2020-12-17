apikey="$1"
vpcid="$2"
vpcurl="$3"
zone="$4"
mgmtip1="$5"
extip1="$6"
mgmtip2="$7"
extip2="$8"
ipaddress="$9"
ha1pwd="${10}"
ha2pwd="${11}"


# Install required packages

echo "Installing required packages ..."

systemctl stop --now apt-daily{,-upgrade}.{timer,service}

systemctl disable --now apt-daily{,-upgrade}.{timer,service}

systemctl kill --kill-who=all apt-daily{,-upgrade}.{timer,service}

# wait until `apt-get updated` has been killed
while ! (systemctl list-units --all apt-daily{,-upgrade}.{timer,service} | egrep -q '(dead|failed)')
do
  sleep 1;
done

sleep 60s;

sudo rm /var/lib/apt/lists/lock

sudo rm /var/cache/apt/archives/lock

sudo rm /var/lib/dpkg/lock

sudo rm /var/lib/dpkg/lock-frontend

echo "Removed lock files ..."

sleep 30s;

sudo apt-get update

sleep 30s;

apt-get install -y sshpass

sleep 30s;

echo "Installing python3-pip ..."

export DEBIAN_FRONTEND=noninteractive

apt-get install -y python3-pip

sleep 30s;

pip3 install --upgrade "ibm-vpc>=0.3.0"
 
pip3 install flask

sleep 30s;

echo "Clone ha fail over repository git"

git clone "https://github.com/MalarvizhiK/vnf-ha-cloud-failover-func.git"

sleep 30s;

cd vnf-ha-cloud-failover-func

python3 ha_initialize_json.py --apikey $apikey --vpcid  $vpcid --vpcurl $vpcurl --zone $zone --mgmtip1 $mgmtip1 --mgmtip2 $mgmtip2 --extip1 $extip1 --extip2 $extip2

py3loc=$(which python3)

echo "Install location of python3"

echo $py3loc

searchpy="whichpython3"

sed -i "s*$searchpy*$py3loc*" flask.service

sudo cp flask.service /lib/systemd/system/flask.service

systemctl daemon-reload

sudo systemctl enable --now flask

sudo service flask start

sudo service flask status

echo "Updating tgactive script ..."

sshpass -p $ha1pwd scp -o StrictHostKeyChecking=no /root/update_script.sh root@$mgmtip1:/config/failover/

sshpass -p $ha1pwd ssh -o StrictHostKeyChecking=no -l root $mgmtip1 "sh /config/failover/update_script.sh" $ipaddress

echo "$mgmtip1: Updated tgactive with url http://$ipaddress:3000/" 

sshpass -p $ha2pwd scp -o StrictHostKeyChecking=no /root/update_script.sh root@$mgmtip2:/config/failover/

sshpass -p $ha2pwd ssh -o StrictHostKeyChecking=no -l root $mgmtip2 "sh /config/failover/update_script.sh" $ipaddress

echo "$mgmtip2: Updated tgactive with url http://$ipaddress:3000/" 
