# automata
A WebEX API to telegram Bot

### why?
As a trainer, I use WebEx for hosting the meeting and record all meetings that are stored over Cloud. Now the Problem is sharing those recorded videos with the students. The only way is, login to WebEx website and get the link & Password from there and share with students. Now, my problem is these recordings takes around 30-90 mintues for rendering and availble for download. mostly because of this wait time I miss or forget that I have to share. So, I came up this solution that I've using for last few months. this uses WebEx API to fetch the recordings and uses telegram Bot to share over telegram Group. 


#### Make sure you have JQ installed if not [download](https://stedolan.github.io/jq/)

# API requires
* WebEx API : bareer Token.
* Telegram Chat ID
* Telegram Bot KEY (@botfather)

# where to put those?
simple replace {TOKEN} with token e.g: 

 ``` bash 
 barer: {TOKEN} #old 
 barer: token:strings #new
 ```
 
 # TODO:
 - [ ] config a while True Loop
 - [ ] config auto trigger with github actions
 
 # done 
 - [x] WebEx API / access token / bareer 
 - [x] telegram Chat ID set to group
 - [x] Auto trigger emails (code note updloaded here)
 - [x] push to github 

# liked it?
>> thanks :) 

# Contribution
Contributions are welcome. send a PR!!
