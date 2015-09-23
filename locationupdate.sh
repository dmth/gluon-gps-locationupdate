# Configure GPS
stty -F /dev/ttyUSB0 raw 4800 cs8 clocal -parenb crtscts -cstopb;
# Use GPS  as Stream
exec 4</dev/ttyUSB0;
while true
do
    read this_line;
    nc=`echo $this_line | cut -d',' -f 1`;
    if [ "$nc" = '$GPRMC' ];
    then                           
        valid=`echo $this_line | cut -d',' -f 3`;
        if [ "$valid" = "A" ];
        then
            #First: Retrieve coordinate
            lat=`echo $this_line | cut -d',' -f 4`;
            lon=`echo $this_line | cut -d',' -f 6`;

            # Second: Determine if coordinate is oriented North/South or East/West
            latdir=`echo $this_line | cut -d',' -f 5`;
            londir=`echo $this_line | cut -d',' -f 7`;

            # Split DEGREES from coordinate
            latdeg="$(echo ${lat:0:2} | sed 's/^0*//')";
            londeg="$(echo ${lon:0:3} | sed 's/^0*//')";

            # Split MINUTES.SECONDS from coordinate
            latmin=`echo ${lat:2}`;
            lonmin=`echo ${lon:3}`;

            #Convert from Degree-Minutes to Decimal-Minutes
            latdec=$(awk -v l="$latmin" 'BEGIN {printf "%f", l/60}' | sed 's/^0*//')
            londec=$(awk -v l="$lonmin" 'BEGIN {printf "%f", l/60}' | sed 's/^0*//')

            #Use negative notation instead of North/South or East/West
            if [ $latdir = 'S' ];
            then
                latdeg="-"$latdeg;
            fi
            if [ $londir = 'W' ];
            then
                londeg="-"$londeg;
            fi
            echo "Position is valid Lat/Lon: "$latdeg$latdec   $londeg$londec;
            
            # Write to config
            uci set gluon-node-info.@location[0].share_location=1;
            uci set gluon-node-info.@location[0].latitude=$latdeg$latdec;
            uci set gluon-node-info.@location[0].longitude=$londeg$londec;
            # uci commit gluon-node-info; See Phip's comment below why this should not be done here.
            break;
        else
            echo "Position is Invalid..." $valid;
            break;
        fi
    fi
done <&4;
exit 0;
