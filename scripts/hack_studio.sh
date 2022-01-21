#!/bin/bash


#change this to reflect whatever vlan you want this in
vlan=2003
#this will put this prefix before all your vms
prefix=s22-it4510


#probably don't change anything down here

declare -A toclone
#this is a list of images that I want to clone when I run the command and how much ram each should be given

toclone=( ["s22-linux-desktop"]="1024" ["pfsense"]="512" ["kali"]="2048" ["metasploitable"]="512" )


function usage(){
  echo "./hack_studio.sh"
}

function clone(){
for m in "${!toclone[@]}"
do
ram=${toclone[$m]}
echo "Going to create $m - with ram: $ram"
citv clonevm $m $prefix-$m $ram $vlan
done
}

function delete() {

  read -p "Deleting these vms. Are you sure?(y/N)" choice
  if [ "$choice" = "y" ]
   then
	for m in "${!toclone[@]}"
	do
	citv removevm $prefix-$m 
	done
  else
    exit 1
  fi
}

function turnoff() {
	for m in "${!toclone[@]}"
	do
	citv powerdownvm $prefix-$m 
	done
}

function turnon() {
	for m in "${!toclone[@]}"
	do
	citv bootvm $prefix-$m c
	done
}

#generate a possible ssh command
function genssh() {
 echo "Maybe this ssh command will work? It takes a few seconds to run. If it says NONE, your machine isn't running"
 cmd="ssh $USER@ssh.cs.dixie.edu "
 /qemu/bin/citv showvm | grep $prefix | 
 (
 while read -r m;
 do
   port=$(echo "$m" | awk '{ print $4 }')
   p=$(echo "$port" | awk -F: '{ print $2 }')
   add=" -L $p:$port "
   cmd="$cmd$add"
 done
 echo $cmd
 )
 

}



read -r -p "What would you like to do? 
clone (c) 
delete (d) 
poweroff (p)
poweron (o)
ssh (s)
" selection

if [ "$selection" = "c" ]
then
  clone
elif [ "$selection" = "d" ]
then
  delete
elif [ "$selection" = "p" ]
then
  turnoff
elif [ "$selection" = "o" ]
then
  turnon
elif [ "$selection" = "s" ]
then
  genssh
else
  echo "Invalid selection"
  exit 1
fi
