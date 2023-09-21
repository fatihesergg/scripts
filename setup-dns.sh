#!/bin/bash


printmessage(){
    default='\033[0m'
    bgreen='\033[1;32m'
    echo -e "$bgreen$1$default"
}

install_program(){

    printmessage "installing dnscrpt-proxy.."
    sudo pacman -S dnscrypt-proxy dnsmasq --noconfirm > /dev/null  2>&1

}

configure(){
    
    printmessage  "Change listen adress port to  53000"
    listen_addresses="listen_addresses = ['127.0.0.1:53000', '[::1]:53000']"
    sed -i "s/^listen_addresses =.*/$listen_addresses/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml

    printmessage "Configure dnsmasq"
    sed -i "s/^#no-resolv.*/no-resolv/g" /etc/dnsmasq.conf
    sed -i "s/^#listen-address=.*/listen-address=::1,127.0.0.1/g" /etc/dnsmasq.conf
    echo "server=::1#53000" >> /etc/dnsmasq.conf
    echo "server=127.0.0.1#53000" >> /etc/dnsmasq.conf
    sed -i "s/^# server_names = .*/server_names = ['nextdns','quad9-doh-ip4-port443-nofilter-pri','adguard-dns-doh']/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
    sed -i "s/^cache =.*/cache = false/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
    sed -i "s/block_ipv6 =.*/block_ipv6 = true/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
    echo -e "nameserver ::1\nnameserver 127.0.0.1" > /etc/resolv.conf
}

enable_service(){
    sudo systemctl enable  dnscrypt-proxy.service
    sudo systemctl enable  dnsmasq.service
}

install_program

configure

printmessage "Enable Service.."

enable_service

printmessage "Done !"
