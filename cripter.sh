#!/bin/bash
########################################################################
# by PINPEREPETTE (the Pirate) #
########################################################################
# This program is free software; you can redistribute it and/or modify #
# it under the terms of the GNU General Public License as published by #
# the Free Software Foundation; either version 2 of the License, or #
# (at your option) any later version. #
# #
# This program is distributed in the hope that it will be useful, #
# but WITHOUT ANY WARRANTY; without even the implied warranty of #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the #
# GNU General Public License for more details. #
# #
# You should have received a copy of the GNU General Public License #
# along with this program; if not, write to the Free Software #
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, #
# MA 02110-1301, USA. #
############################# DISCALIMER ###############################
# Usage of this software for probing/attacking targets without prior #
# mutual consent, is illegal. It's the end user's responsability to #
# obey alla applicable local laws. Developers assume no liability and #
# are not responible for any missue or damage caused by thi program #
########################################################################
prog="Cripter"
txr=$(tput setaf 1)
sxb=$(tput setab 4)
cxl=$(tput sgr0)
txg=$(tput setab 3)
gxo=$(tput bold)
clear
#Per fargli "digerire" input e output
digerisci() {
echo " Input file: $filein"
openssl dgst -md5 $1
echo " Output file: $fileout"
openssl dgst -md5 $2
}
#Il menu (se non l'avete capito è gravissimo XD) #MUOIO
menu() {
echo "${txr}
                  (
            ( )\ ) ) ( ( (
       )\ ( (()/( ( /( )\))( )\ )
   ((((_)( )\ /(_)) )(_))((_)()\(()/(
   )\ _ )\ ((_) (_)) ((_) (()((_)/(_))
 (_)_\(_)| __|/ __| | _ ) | __| (_) /
  / _ \  | _| \__ \  / /  |__ \ / _ \ 
 /_/ \_\ |___||___/ /___| |___/ \___/
${cxl}"
}
# Aiuto o.O
help() {
echo "###################################################"
echo " Script che codifica e decodifica i file [AES-256] "
echo " -e, --encrypt cripta il file"
echo " -d, --decrypt decripta il file"
echo " -i, --input input file da scrivere"
echo " -o, --output output file da leggere"
echo "###################################################"
}

## Setto a no di default i parametri "getopt"
encrypt="no"
decrypt="no"
filein="no"
fileout="no"

while [ $# -gt 0 ]; do
case $1 in
-e|--encrypt) encrypt="yes" ;;
-d|--decrypt) decrypt="yes" ;;
########### opzionali #############
-i|--input) filein="$2" ; shift;;
-o|--output) fileout="$2" ; shift;;
(--) shift; break;;
(-*) echo "$0: errore - opzione non riconosciuta - COCCODIO $1" 1>&2; exit 1;;
(*) break;;
esac
shift
done
## Fine GetOpt

## Processo di cancellazione sicura sia su Linux che su mac (fare le cose uguali MAI CoccoDio)
function sdelete() {
if [ $(uname -s) == 'Darwin' ]; then
srm $1
elif [ $(uname -s) == 'Linux' ]; then
shred -u $1
fi
}

## funzione x decriptare
function decrypt() {
filein="$1"
fileout="$2"
if [ "$filein" = "no" ]; then
echo -n "Se non mi dai un file crittografato, cosa decripto CoccoDio!!! damme uno da decriptare : "
read filein
fi

if [ -r "$filein" ]; then
if [ "$fileout" = "no" ]; then
fileout="$filein.decrypted"
fi
openssl enc -d -aes256 -in $filein -out $fileout
digerisci $filein $fileout
exit 0;
else
echo "il file '$filein' non è leggibile o non esiste BioParco !!! "
exit 1;
fi
}

## funzione x criptare
function encrypt() {
filein="$1"
fileout="$2"
if [ "$filein" = "no" ]; then
echo -n "Se non mi dai un file da criptare, cosa cripto CoccoDio!!! damme uno da criptare : "
read filein
fi

if [ -r "$filein" ]; then
if [ "$fileout" = "no" ]; then
fileout="$filein.aes256"
fi
if [ -f "$fileout" ]; then
echo "Il file di Output esiste già, , la crittografia sovrascriverà questo file."
echo -n "Vuoi criptare il file comunque ??? [Y/n]: "
read choice
if [ "$choice" = "Y" ] || [ "$choice" = "y" ] || [ "$choice" = "" ]; then
openssl enc -aes256 -in $filein -out $fileout
digerisci $filein $fileout
sdelete $filein
exit 0;
else
exit 2;
fi
else
openssl enc -aes256 -in $filein -out $fileout
digerisci $filein $fileout
sdelete $filein
exit 0;
fi
else
echo "Il file di input '$filein' non esiste o non è leggibile.. COCCODIO !!! "
exit 1;
fi
}

if [ "$encrypt" = "yes" ] && [ "$decrypt" = "no" ]; then
encrypt $filein $fileout
elif [ "$decrypt" = "yes" ] && [ "$encrypt" = "no" ]; then
decrypt $filein $fileout
else
clear
menu
help
fi
