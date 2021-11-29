#!/bin/bash
# Install .NET 5.0.0 SDK
# REFERENCE: https://docs.microsoft.com/en-gb/dotnet/core/install/linux-debian

#first add and trust Microsoft package signing key
wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

#install sdk
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-5.0
  
 #install runtime - not strictly necessary as it should be included in the sdk
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y aspnetcore-runtime-5.0