# Q SASE POC TIPs

1. Mesh_natenabler.sh
It modifies the connector to do Hi-NAT over peer mesh source IPs, in the same way as clients.
You can get the list of the networks from here:

![p81](https://github.com/moralesaugusto/qsase/assets/16660407/130fd01a-2ac4-4334-adfa-f5c33717a9e6)


Example of how running the script. Connector ip is: 192.168.1.15 and peer networks (not agent): 192.168.5.0/24

admin@connectornothlake:~$ curl https://raw.githubusercontent.com/moralesaugusto/qsase/main/mesh_natenabler.sh --output mesh_natenabler.sh

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2604  100  2604    0     0  33818      0 --:--:-- --:--:-- --:--:-- 34263

admin@connectornothlake:~$ chmod +x mesh_natenabler.sh 

admin@connectornothlake:~$ sudo ./mesh_natenabler.sh 

[sudo] password for admin: 

****************************************************\n
v0.1 AMorales
This scripts helps to modify default connector behavior for site-2-site (mesh networking scenarios). It allows to enable Hide NAT for the remote locations\n

Take into consideration that default behavior for Agents is base on Hide NAT, but not for mesh. So this script enables that feature.  \n

****************************************************\n
\n 1. Please introduce the connector routed IP address: 192.168.1.15

\n 2. Enter one or more networks (e.g., 10.12.0.0/16 192.168.0.0/24): 192.168.5.0/24

\n 3. IPTABLES rule added successfully!!!

\n 4. Do you want to save the iptables configuration permanently? (y/n): n

---- NAH! Iptables configuration not saved permanently.

2. To enable CHKP to community over QSASE network do not forget to create a rule similar to below:
3. 
   ![fw](https://github.com/moralesaugusto/qsase/assets/16660407/8f1f65c6-53b9-46ef-9b8c-4332815aee5a)
