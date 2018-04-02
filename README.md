# RAPTURE
Shell script to install a [RAPTURE Masternode](https://our-rapture.com/) on a Linux server running Ubuntu 16.04. Use it on your own risk.
***

## Installation
```
wget -q https://raw.githubusercontent.com/zoldur/Agni/master/agni_install.sh
bash rapsetup.sh
```
***

## Desktop wallet setup  

After the MN is up and running, you need to configure the desktop wallet accordingly. Here are the steps:  
1. Open the RAPTURE Desktop Wallet.  
2. Go to RECEIVE and create a New Address: **MN1**  
3. Send **1000** RAP to **MN1**. You need to send all 1000 coins in one single transaction.
4. Wait for 15 confirmations.  
5. Go to **Help -> "Debug Window - Console"**  
6. Type the following command: **masternode outputs**  
7. Go to  **Tools -> "Open Masternode Configuration File"**
8. Add the following entry:
```
Alias Address Privkey TxHash TxIndex
```
* Alias: **MN1**
* Address: **VPS_IP**
* Privkey: **Masternode Private Key**
* TxHash: **First value from Step 6**
* TxIndex:  **Second value from Step 6**
9. Save and close the file.
10. Go to **Masternode Tab**. If you tab is not shown, please enable it from: **Settings - Options - Wallet - Show Masternodes Tab**
11. Click **Update status** to see your node. If it is not shown, close the wallet and start it again. Make sure the wallet is un
12. Select your MN and click **Start Alias** to start it.
13. Alternatively, open **Debug Console** and type:
```
masternode start-alias "MN1"
``` 
14. Login to your VPS and check your masternode status by running the following command:.
```
want-cli masternode status
```
***
***

## Usage:
```
rap_cli mnsync status
rap_cli masternode status  
rap_cli getinfo
```
Also, if you want to check/start/stop **RAPTURE**, run one of the following commands as **root**:

```
systemctl status RAP #To check if Agni service is running
systemctl start RAP #To start Agni service
systemctl stop RAP #To stop Agni service
systemctl is-enabled RAP #To check if Agni service is enabled on boot
```  
***

## Sentinel

Sentinel is installed in **/root/.rapturecore/sentinel** 
Sentinel log file is: **/root/.rapturecore/sentinel.log**
***

## Donations

Any donation is highly appreciated

**RAP**: 
