# Homebrew interface built on Qt for Raspberry Pi

## Compile using instructions
https://github.com/TyrantUT/RaspberryPi64CrossCompile

## Qt to RPI Pin mapping
Pin mappings exist within rpicomms.h

## Web Socket
All telemtry data is sent through a Web Socket to an external web server, see details in 
https://github.com/TyrantUT/brewberryWeb_Docker

Modify the QT_WEB_URL #define in main.cpp to include your public IP

![](https://maketechsecure.com/wp-content/uploads/2023/02/image.png)
![](https://maketechsecure.com/wp-content/uploads/2023/02/image-8.png)
![](https://maketechsecure.com/wp-content/uploads/2023/02/image-9.png)