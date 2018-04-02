# RAPTURE
Shell script to install a [RAPTURE Masternode](https://our-rapture.com/) on a Linux server running Ubuntu 16.04. Use it on your own risk.
***

## Installation
```
wget -q https://github.com/smai2018/RAPTURE-masternode-autoinstall/blob/master/rapture-setup.sh
bash rapture-setup.sh
```
***

## Desktop wallet setup  

The first step involves sending exactly 1,000 Rapture to a new wallet address. You’ll want to have a small
amount above 1,000 Rapture to cover the transaction fee, so you’ll need to have a starting balance of at least,
say 1,001.00 Rapture. First, we’ll create a new wallet address to hold the 1,000 collateral. This will also be the
address that the masternode rewards are sent to.

1.  Open the RAPTURE Desktop Wallet
2.  Go to "RECEIVE"
3.  Label: **MN1**
4.  Amount: **1000**
5.  Copy address and Close and Exit this dialog
6.  Go to **SEND**
7.  "Pay To": Strg+V or right mouse "Paste"
8.  IMPORTANT: Don't check any checkbox!
9.  Send with **Send** and confirm with **Yes**
10. Wait for 15 confirmations
11. Go to **Settings-> Options-> Wallet-> Show Masternodes Tab** 
    Click Ok to apply the setting and then close and re-open your local wallet. After re-opening, you should see the
    Masternodes tab which will display the full list of masternodes on the network, as well as masternodes
    associated with your local wallet (My Masternodes is probably empty because we haven’t added one yet).
12. Go to **Help -> "Debug Window - Console"**
13. Type the following command: **masternode outputs** 
14. Type the following command: **masternode genkey**
    *This two outputs are your own secret. Tell nobody this numbers!*
15. Go to  **Tools -> "Open Masternode Configuration File"**
16. Add the following entry:
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
14. Login to your VPS and check your masternode status by running the following command:
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
If you want to check/start/stop **RAPTURE**, run one of the following commands as **root**:

```
systemctl status RAP #To check if RAPTURE service is running
systemctl start RAP #To start RAPTURE service
systemctl stop RAP #To stop RAPTURE service
systemctl is-enabled RAP #To check if RAPTURE service is enabled on boot
```  
***

## Sentinel

Sentinel is installed in **/root/.rapturecore/sentinel** 
Sentinel log file is: **/root/.rapturecore/sentinel.log**
***

## Donations

Any donation is highly appreciated

**RAP**: RT3p6q5xG8vCcfCNjQERGZfgRRcoWqU6LW 
