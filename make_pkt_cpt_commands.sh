#!/bin/sh

#Check if the script was run with empty argument
if [ "$1" == "" ]
  then
        echo "Please pass the name of a VM from command 'net-stats -l' and run the command again."
        echo "For example, a VM shown as nsx-t-manager3.eth0 should be provided as nsx-t-manager3.eth0"
        exit 0
fi

#This variable is used to check for the presence of the VM the user provides
INITIAL_VM_PORT_ID=`net-stats -l | grep $1`

#Check if the VM name even exists on this ESXi host
if [ "$INITIAL_VM_PORT_ID"  == "" ]
  then
        echo "There is no VM by the name of $1 on this ESXi host. Please double check the name."
        exit 0
  else
        #Script starts to run here!
        echo ""
        echo "Argument passed to script: $1"
        VM_NAME=${1::-5}
        echo "$VM_NAME"

        #declaring variables
        #Get the port id from the net stats command
        VM_PORT_ID=`net-stats -l | grep $1 | cut -d " " -f0  `

        #Get the world id from esxcli command and pass it to a variable
        VM_WORLD_ID=`esxcli vm process list | grep -A 1 $VM_NAME | grep "World ID:" | cut -c 14-`

        echo ""
        echo "Find the VM PNIC, PortID and World ID below:"
        VM_PNIC=`esxcli network vm port list -w $VM_WORLD_ID | grep -A 8 $VM_PORT_ID | grep "Team Uplink" |  cut -c 17-`
        echo "This VM's PNIC is: $VM_PNIC"
        echo "VM Port ID is: $VM_PORT_ID"
        echo "VM World ID is: $VM_WORLD_ID"



        echo ""
        echo "Packet capture commands that can be used for this VM:"
        echo ""
        echo "pktcap-uw --switchport $VM_PORT_ID --capture VnicTx,VnicRx -o - | tcpdump-uw -enr -"
        echo "pktcap-uw --switchport $VM_PORT_ID --capture PortInput,PortOutput -o - | tcpdump-uw -enr -"
        echo "pktcap-uw --uplink $VM_PNIC --capture UplinkSndKernel,UplinkRcvKernel -o - | tcpdump-uw -enr -"

        echo ""

        echo "You might choose to packet capture to a file later. Here are the possible locations you can save the file:"
        ls -l /vmfs/volumes
fi
echo ""
echo "The script has completed"
