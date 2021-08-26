RELEASE=`cat /etc/*-release`

osname=""

for name in 'CENTOS' 'UBUNTU' 'OpenSuse' 'DEBIAN' 'RED HAT'
do
        echo "${RELEASE}" | grep -i -q "${name}" && osname=`echo "$name"`
done

if [ "$osname" == "DEBIAN" ]; then
	echo "${osname}"
elif [ "$osname" == "CENTOS" ]; then
	echo "${osname}"
fi
