/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

#define N_PREFS 1024
#define PORT_WIDTH 32
#define N_PORTS 128
#define N_PATHS 128
#define N_SW_ID 8
#define N_HOPS 128

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;
typedef bit<20> label_t;

const bit<16> TYPE_IPV4 = 0x0800;
const bit<16> TYPE_PATH_HOPS = 0x45;

header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}
header ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<2>    ecn;
    bit<6>    dscp;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}

header pathHops_t{
    bit<32> numHop; //counts the current hop position (switch by switch)
    bit<48> pkt_timestamp; //the instant of time the packet ingressed the depot switch
    bit<32> path_id; //same as "meta.indexPath"
    bit<8> is_alt; //is alternative path? (0 = NO; 1 = YES)
    bit<8> has_visited_depot; //whether it is the first time visiting the depot switch: (0 = NO; 1 = YES)
    bit<32> num_times_curr_switch_primary; // 31 switches + 1 filler (ease indexation). last switch ID is the leftmost bit (the most significant one). 
    bit<32> num_times_curr_switch_alternative; // 31 switches + 1 filler ... Current limitation: As each switch ID is represent by a switch bit. Each switch may be traversed twice (state 0 and state 1) in each path
}

struct metadata {
    bit<1> linkState; //link state (UP = 0, DOWN = 1)
    bit<32> indexPath; //used for both "primaryNH" and "alternativeNH" registers
    bit<32> depotPort; //universal (for now)
    bit<32> nextHop; //next hop of the current path
    bit<32> lenPrimaryPathSize; //length of the provided primary path (by the control plane)
    bit<32> lenAlternativePathSize; //length of the provided alternative path (by the control plane)
}
struct headers {
    ethernet_t                      ethernet;
    ipv4_t                          ipv4;
    pathHops_t                      pathHops;
}
