#!/bin/bash 

#alle innputenesom bruker kan skrive inn
help=
storelse=
logfill=
katalog='.'
rek=

#So lenge inputten ikke er null, skal den utføre kommandoene som er skrivet inn av bruker
while [[ -n "$1" ]]; do 
    case "$1" in 
        -s | --str) shift; storelse="$1" 
        ;;
        -r | --rek) rek=1 
        ;;
        -l |--loggfil) shift; logfill="$1"
        ;;
        -h | --help)        
            echo "Bruk:  [-s storelse] [-l loggfil] [-r] [katalog]"

            echo "  -h: vis denne hjelp-meldingen"

            echo "  -s: storelse"

            echo "  -l: loggfil"

            echo "  -r: rek"
            
            exit 0
               
         ;;
        *) katalog="$1"  
        ;; 
    esac 
    shift 
done

#sjekker om innput ikkje er null
if [[ -n "$storelse" ]]; then 

    #find variabelen skal inneholde alle filene som er større enn størrelsen som brukeren skreiv inn sortert på reverse   awk print hennter ut fill nav istend for -rw-r--r-- 
    find=$(find "$katalog" -type f -size +"$storelse"c -exec ls -lh {} \; | awk '{print $9}' | sort -r | head -n 10)   
    echo "$find"

    #sjekker om loggfila har navn
    if [[ -n $logfill ]]; then 
        echo "$find" >> $logfill
    else 
        echo "$find" > "logfil.txt"
    fi

fi 


#sjekker om den er interaktiv. Om programmet starter med [-r] skal den bli interaktiv
if [[ -n "$rek" ]]; then 

    #find variabelen skal inneholde alle filene som er større enn størrelsen som brukeren skreiv inn sortert på reverse   awk print hennter ut fill nav istend for -rw-r--r-- 
    find=$(find "$katalog" -type f -size +"$storelse"c -exec ls -lh {} \; | awk '{print $9}' | sort -r | head -n 10)

    #for-loopen skal gå igjennom hver  fil i find variabelen. Og her skal brukeren gi sin innput på  hva som skal bli gjort. slettes, komprimeres eller ikkje røres.
    #etter å ha gitt ein kommando skal dette samtidigt bli loggført i en gitt log fill 
    for file in $find; do 
        echo "Hva vil du gjøre med $file? [S/K/I]"
        read answer
        echo "$find"
            if [[ $answer = "s"  || $answer = "S" ]]; then 
                rm -rf "$file"
                #if logfill is given then print to it otherwise create a file called logfil.txt and print to it
                if [[ -n $logfill ]]; then 
                    echo "$(date) Slettes $file "  >> $logfill
                else 
                     echo "$(date) Slettes $file " >> "logfil.txt"
                fi
            

            elif [[ $answer = "k"  || $answer = "K" ]]; then
                gzip "$file"
                        if [[ -n $logfill ]]; then 
                             echo "$(date) Komprimeres $file" >> "$logfill"
                        else 
                            echo "$(date) Komprimeres $file">> "logfil.txt"
                        fi 
                        
                gzip "$file"
                
            elif [[ $answer = "i" || $answer = "I" ]]; then 

                        if [[ -n $logfill ]]; then 
                            echo "$(date) Ikke røres. $file" >> $logfill
                        else 
                           echo "$(date) Ikke røres. $file" >> "logfil.txt"
                        fi

                continue 
            fi
    done
fi
#Slutt på bash skriptet




