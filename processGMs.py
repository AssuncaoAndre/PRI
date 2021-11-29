import sys
import requests
import json

def isGM(title_string):
    if "GM" in title_string:
        return True
    return False

def parsePlayer(player):

    return player[8:-3]

gms_list = []

gm_file = open("gms.txt", "a")

with open(sys.argv[1], "r") as file:
    
    

    buffer_offset = 0

    file.readline()

    while True:
        
        white = file.readline()

        if len(white)==0:
                break

        black = file.readline()
        buffer1 = file.readline()

        if "LichessURL" in buffer1:
            continue
        elif "BlackTitle" in buffer1:
            if(isGM(buffer1)):
                
                if parsePlayer(black) not in gms_list:
                    
                    gms_list.append(parsePlayer(black))
                buffer_offset = 1 
            file.readline()   
        elif "WhiteTitle" in buffer1:
            if(isGM(buffer1)):
                if parsePlayer(white) not in gms_list:
                    
                    gms_list.append(parsePlayer(white))
                
            buffer2 = file.readline()
            
            if "LichessURL" in buffer2:
                continue
            else:
                if(isGM(buffer2)):
                    if parsePlayer(black) not in gms_list:
                        
                        gms_list.append(parsePlayer(black))
                file.readline()



for gm in gms_list:
    r =requests.get('https://lichess.org/api/user/' + gm)

    data = json.loads(r.text)

    if 'profile' in data:
        
        profile = data['profile']

        if 'firstName' in profile and 'lastName' in profile:
            
            gm_file.write(gm + ":" + profile['firstName'] + " " + profile['lastName'] + "\n")
            
        
        

   

    
