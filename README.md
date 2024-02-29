# CryptoCrafter
The recent discovery of a method of DNP(DO NOT POWERWASH) allows us to modify cryptohome info in stateful. We will create a cryptohome setup app in rma shims, allowing us to finally unenroll without exploiting CRSwifty.

## StateSploit
StateSploit is the method of DNP which uses DDR(disable_dev_request).  
Here is the original [PoC](poc.sh) of statesploit shared in firmware smasher.

## CryptoCrafter setup

It will use source code from chromium to replicate a version of cryptohome that works in a shim and doesn't touch device settings. We can enforce this through a chroot.
## [CryptoSmite](cryptosmite.md)

Access the CryptoSmite exploit [here](cryptosmite.md)
## Tools and exploits contained in this repo

1. [CryptoSmite](cryptosmite.md) (Cryptohome exploits allowing for full command execution and take over of the system in verified)  
2. Cros_debug setter (which failed)  
3. verity_bypass_poc.sh (Reco image modding, currently wip)  
4. crafter: Crypto Crafter  
Again, please don't leak anything from this repo. If you want something to be shared, please ask for permission, and then publish it only if you have permission.
## Story of how I found this exploit
I was actually testing another exploit (private) and then I ran a battery cutoff. Except when I did this, I ran in a bigger problem, my computer won't actually turn on. When it does, it is stuck in a boot loop. Enabled developer mode, just in case it was an operating system issue, except now I was stuck in the fake devmode and I couldn't exit. When using recovery mode, no recovery image would bring this chromebook back to life, because its in devmode blocked mode. Except I forgot about dev_disable_request in vboot, and now this project exists to exploit this.