# Define options
set val(chan)       Channel/WirelessChannel;# channel type
set val(prop)       Propagation/TwoRayGround;# radio-propagation model
set val(netif)      Phy/WirelessPhy ;# network interface type
set val(mac)        Mac/802_11 ;# MAC type
set val(ifq)        Queue/DropTail/PriQueue ;# interface queue type
set val(ll)         LL ;# link layer type
set val(ant)        Antenna/OmniAntenna ;# antenna model
set val(ifqlen)     50 ;# max packet in ifq
set val(nn)         400  ;# number of mobilenodes
set val(rp)         BFG ;# routing protocol
set val(x)          5000 ;# X dimension of topography
set val(y)          5000 ;# Y dimension of topography
set val(stop)       250 ;# time of simulation end
set val(grid)       20x20_400n.tcl
set val(nodedst)    190 ;#Node for which we calculate the gradient


Mac/802_11 set SlotTime_          0.000020        ;# 20us
Mac/802_11 set SIFS_              0.000010        ;# 10us
Mac/802_11 set PreambleLength_    144             ;# 144 bit
Mac/802_11 set PLCPHeaderLength_  48              ;# 48 bits
Mac/802_11 set PLCPDataRate_      1.0e6           ;# 1Mbps
Mac/802_11 set dataRate_          11.0e6          ;# 11Mbps
Mac/802_11 set basicRate_         1.0e6           ;# 1Mbps
Mac/802_11 set RTSThreshold_      3000            ;# Use RTS/CTS for packets larger 3000 bytes 


set ns              [new Simulator]
set tracefd         [open /dev/null w] ;#[open sim_epidemic.tr w]
set namtrace        [open /dev/null w] ;#[open sim_epidemic.nam w]

$ns use-newtrace
$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)


# set up topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
set god [create-god $val(nn)]

# Create nn mobilenodes [$val(nn)] and attach them to the channel.
set chan [new $val(chan)]
# configure the nodes
$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -channel $chan \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -topoInstance $topo \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace ON \
                -movementTrace ON 

for {set i 0} {$i < $val(nn) } { incr i } {
    set node($i) [$ns node]
    $node($i) random-motion 0    ;#Disable random-motion
}

# Provide initial location of mobilenodes
source $val(grid)

set god [God instance]

#Print hash functions identifiers for each node
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at 0.0 "[$node($i) agent 255] bfrepr"
}


#Tell protocol to start
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at 0.01 "[$node($i) agent 255] entersim"
}

# Define node initial position in nam
for {set i 0} {$i <$val(nn)} { incr i } {
  # 60 defines the node size for nam
  $ns initial_node_pos $node($i) 60
}


# Print Bloom Filters every 10 seconds
for {set t 0} {$t < $val(stop) } {incr t 10} {  
  for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $t "[$node($i) agent 255] bfstatus $val(nodedst)"    
  }  
}


#Tell nodes when to stop
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node($i) reset";
}


# ending nam and the simulation
$ns nam-end-wireless $val(stop)
$ns at $val(stop) "puts \"end simulation\" ; $ns halt"
$ns at $val(stop).00001 "stop"

proc stop {} {
   global ns tracefd namtrace
   puts "Cerrando archivos de trace"
   $ns flush-trace
   close $tracefd
   close $namtrace
}

$ns run

