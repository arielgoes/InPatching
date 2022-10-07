#!/usr/bin/env python3
import argparse
import sys
import socket
import random
import struct

from scapy.all import sendp, get_if_list, get_if_hwaddr, bind_layers
from scapy.all import Packet
from scapy.all import Ether, IP, UDP, TCP
from scapy.fields import *
from time import sleep


# path_id == 0 <-> path 0 (first path). Each path has a primary NH and alternative NH
#BitField("name", default_value, size)
class PathHops(Packet):
    fields_desc = [IntField("numHop", 0),
                   BitField("pkt_timestamp", 0, 48),
                   IntField("path_id", 0),
                   BitField("which_alt_switch", 0, 32), #tells at which switch ID the depot will try to deviate from the primary path at a single hop. NOTE: value zero is reserved for primary path - i.e., no deviation at any hop.
                   ByteField("has_visited_depot", 0), #00000000 (0) OR 11111111 (1). I'm using 8 bits because P4 does not accept headers which are not multiple of 8
                   BitField("num_times_curr_switch_primary", 0, 64), # 31 switches + 1 filler (ease indexation). last switch ID is the leftmost bit (the most significant one)
                   BitField("num_times_curr_switch_alternative", 0, 64)] # 31 switches + 1 filler (ease indexation). last switch ID is the leftmost bit (the most significant one)
bind_layers(IP, PathHops, proto=0x45)


def main():
    #addr = "10.1.1.2" # l3 - 1 host
    #addr = "10.1.2.2" # l3 - 2 hosts
    addr = "10.0.1.2" # mixed - 2 hosts
    #addr = "10.0.1.1" # mixed - 1 host
    iface = "h1-eth1"

    print("sending on interface %s to %s" % (iface, str(addr)))

    #for _ in range(1): #number of random packets
    #while True:
    pkt = Ether(src=get_if_hwaddr(iface), dst='ff:ff:ff:ff:ff:ff') / IP(dst=addr, proto=0x45) / PathHops(path_id=1)
    sendp(pkt, iface=iface, verbose=False)
    #sleep(0.5)

if __name__ == '__main__':
    main()