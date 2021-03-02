#!/bin/bash
echo """
░█████╗░██╗░░░██╗████████╗░█████╗░███╗░░░███╗░█████╗░████████╗░█████╗░░█████╗░
██╔══██╗██║░░░██║╚══██╔══╝██╔══██╗████╗░████║██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗
███████║██║░░░██║░░░██║░░░██║░░██║██╔████╔██║███████║░░░██║░░░███████║███████║
██╔══██║██║░░░██║░░░██║░░░██║░░██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══██║██╔══██║
██║░░██║╚██████╔╝░░░██║░░░╚█████╔╝██║░╚═╝░██║██║░░██║░░░██║░░░██║░░██║██║░░██║
╚═╝░░╚═╝░╚═════╝░░░░╚═╝░░░░╚════╝░╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝
                                                                    BY- @anir0y
A Telegram Bot designed to send you WebEx Recored Meeting Links.
"""
#Check for new rec:
req=$(curl -s --location --request GET 'https://webexapis.com/v1/recordings?max=1' \
--header 'Authorization: Bearer {TOKEN}' | jq --raw-output .items[].id > update.db)

#setting up checks
flocal=$(head -n1 meetings.log)
rhost=$(cat update.db)
echo "LOCAL_LASTUPDATE: $flocal :: RemoteFETCH: $rhost"

#verify if new updates if yes, send it to telegram else re-run the script. #TODO: set a while True loop to execute this.
if [ "$rhost" = "$flocal" ]; then
    echo $(date)
    echo
    echo "Checking will run..."
    for i in `seq 10 -1 1` ; do echo -ne "\r$i " ; sleep 1 ; done #check every 10 sec
    clear
    bash run.sh
else
    echo "Update received!"
    echo "Parsing"
    #store iDs
    curl -s --location --request GET 'https://webexapis.com/v1/recordings?max=1' --header 'Authorization: Bearer {TOKEN}' | jq --raw-output .items[].id > meetings.log
    #create Temp
    curl -s --location --request GET 'https://webexapis.com/v1/recordings?max=1' --header 'Authorization: Bearer {TOKEN}' | jq > temp

    TOPIC=$(cat temp | jq '.items[].topic')
    DATE=$(cat temp | jq '.items[].createTime')
    DownloadURL=$(cat temp | jq '.items[].downloadUrl')
    PlaybackURL=$(cat temp | jq '.items[].playbackUrl')
    PASS=$(cat temp | jq '.items[].password')

    #Puting in a file
    echo "" >> filetosend.log
    echo "" >> filetosend.log
    echo "TOPIC: $TOPIC" >> filetosend.log
    echo "" >> filetosend.log
    echo "DATE: " $DATE >> filetosend.log
    echo "" >> filetosend.log
    echo "Download URL: $DownloadURL" >> filetosend.log
    echo "" >> filetosend.log
    echo "PlayBackURL: $PlaybackURL" >> filetosend.log
    echo "" >> filetosend.log
    echo "Password: $PASS" >> filetosend.log
    echo "" >> filetosend.log
    echo "" >> filetosend.log
    echo "sent via @anir0y_bot(AUTOMATA)" >> filetosend.log

#telegram Invoke
    sleep 1
    echo 'sending to Phone'
    USERID="{CHAT_ID}" 
    KEY="{API_KEY}" 
    TIMEOUT="10"
    URL="https://api.telegram.org/bot$KEY/sendMessage"
    DATE_EXEC="$(date "+%d %b %Y %H:%M")" #Collect date & time.
    TMPFILE='filetosend.log' #Create a temporary file to keep data in.
    LIST=$(cat $TMPFILE )
    TEXT="$DATE_EXEC +%0a+ Recording Details:+%0a+ $LIST"
    curl -s --max-time $TIMEOUT -d "chat_id=$USERID&disable_web_page_preview=1&text=$TEXT" $URL > /dev/null
    rm $TMPFILE #clean up after
    echo cleanup
    #cleanup
    rm temp 
    #relaunch
    bash run.sh
fi
