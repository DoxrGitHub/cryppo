# CryptoSmite
## Files to download
Download [stateful.tar.xz](https://drive.google.com/file/d/1WBn8iZtzGyNUITmwccJY-w7bjDTzHTyx/view?usp=sharing) and [st.tar.xz](https://drive.google.com/file/d/1YlgNDslOIrOAQJuQ-AoL0FuE7Xve71Co/view?usp=sharing)  
I promise it will be in a better storage medium soon but right now its in google drive.
## Instructions
(TODO: Automate these instructions)
### Setup
1. Build a [sh1mmer](https://osu.bio/builder) shim.
2. Run cryptosmite_host.sh on the shim using the files specified above. Rename st.tar.xz to cryptsetup.tar.xz and follow the usage instructions in host. 
### Main instructions
1. Boot into rma shim
2. Select bash shell
3. Run cryptosmite.sh in shim
4. In the new bash shell with a mount, extract stateful into the /mnt/stateful
5. Exit the shell to unmount
6. The system will reboot unenrolled. DO NOT LOGIN TO THE JEFFPLAYS ACCOUNT, ITS CRYPTOHOME IS PURPOSELY LEFT CORRUPTED.
7. Instead add a person with your own email. Now you have an unenrolled device.
8. Open chrome://policy and press reload. It should remove fwmp. (lmk if it doesn't this hasn't been tested yet)
9. Congrats your device is completely unenrolled. You should enable devmode
