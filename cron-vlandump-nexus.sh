#!/bin/bash

##Crontab entry
# LANG="en_US.UTF-8"
# COLUMNS=240
# CISCOCMDPAD="/opt/ciscocmd"

# http_proxy=http://proxy.zzz.com:8080/
# https_proxy=http://proxy.zzz.com:8080/

# m h  dom mon dow   command
# Cisco-cmd commands
# */5 * * * * $CISCOCMDPAD/bin/cron-vlandump-nexus.sh >> $CISCOCMDPAD/log/cron-vlandump.log 2>&1

SCRIPT="vlandump-nexus"

PAD="/opt/ciscocmd/bin"
CONFIGPAD="/opt/ciscocmd/etc"
OUTROOTPAD="/var/www/html/vlan/nexus"

DATE=`/bin/date +'%F'`
TIME=`/bin/date +'%H:%M:%S'`
MONTH=`/bin/date +'%Y-%B'`
echo "Start cron-$SCRIPT($BASHPID) at $TIME on $DATE"

OUTFILE="$SCRIPT-$DATE-$TIME"
OUTPAD="$OUTROOTPAD/$MONTH/$DATE"
if [ ! -d $OUTPAD ]
then
    mkdir -p $OUTPAD
fi

echo "VLAN poortbezetting $SCRIPT om $TIME op $DATE" > "$OUTPAD/$OUTFILE.tmp"
echo >> "$OUTPAD/$OUTFILE.tmp"

#S-gebouw
#show interface status
#show interface trunk | be Allowed
#show port-channel summary | exclude NONE

OUTFILE="R-gebouw-$SCRIPT-$DATE-$TIME"
cat > "$OUTPAD/$OUTFILE.tmp" <<End-of-text
#################################
##         MER R-gebouw        ##
#################################"

End-of-text

$PAD/ciscocmd -f -t 10.20.1.1 -u xxx -p '1234' -r $CONFIGPAD/vlan-nexus-commands.txt >> "$OUTPAD/$OUTFILE.tmp"
echo " " >> "$OUTPAD/$OUTFILE.tmp"
sed -r 's/\^D//' "$OUTPAD/$OUTFILE.tmp" > "$OUTPAD/$OUTFILE.txt"

/usr/bin/txt2html --outfile "$OUTPAD/$OUTFILE.html" --preformat_trigger_lines 0 "$OUTPAD/$OUTFILE.txt"
/bin/rm "$OUTPAD/$OUTFILE.tmp" "$OUTPAD/$OUTFILE.txt"
/bin/cp "$OUTPAD/$OUTFILE.html" "$OUTROOTPAD/R-gebouw-$SCRIPT-laatste.html"

OUTFILE="S-gebouw-$SCRIPT-$DATE-$TIME"
cat > "$OUTPAD/$OUTFILE.tmp" <<End-of-text
#################################
##         MER S-gebouw        ##
#################################"

End-of-text

$PAD/ciscocmd -f -t 10.20.1.1 -u xxx -p '1234' -r $CONFIGPAD/vlan-nexus-commands.txt >> "$OUTPAD/$OUTFILE.tmp"
echo " " >> "$OUTPAD/$OUTFILE.tmp"
sed -r 's/\^D//' "$OUTPAD/$OUTFILE.tmp" > "$OUTPAD/$OUTFILE.txt"

/usr/bin/txt2html --outfile "$OUTPAD/$OUTFILE.html" --preformat_trigger_lines 0 "$OUTPAD/$OUTFILE.txt"
/bin/rm "$OUTPAD/$OUTFILE.tmp" "$OUTPAD/$OUTFILE.txt"
/bin/cp "$OUTPAD/$OUTFILE.html" "$OUTROOTPAD/S-gebouw-$SCRIPT-laatste.html"

DATE=`/bin/date +'%F'`
TIME=`/bin/date +'%H:%M:%S'`
echo "Exit cron-$SCRIPT($BASHPID) at $TIME on $DATE"
