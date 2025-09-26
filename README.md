# Demo of Distributed MINDFul.jl with TFS controllers inside LXD virtual machines

Include `initialize.jl` and instatiate the different IBN-Frameworks by calling the corresponding function depending on wether to use TFS or not

Both functions expect the configuration file in TOML format. TFS also expects the IP address of the LXD-VM

Each one will return the corresponing `ibnf`

An example of the operation and ploting of a connectivity intent is provided in `intent.jl`

### How to generate RSA keys if needed
`openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -pkeyopt rsa_keygen_pubexp:3 -out rsa_priv1.pem`
`openssl pkey -in rsa_priv1.pem -out rsa_pub1.pem -pubout`

### How to proceed with the demo

#### Install incus
1. install incus on your machine. Follow official guide.
2. create a dummy VM (e.g. Ubuntu) and loginto this VM and check there is internet (e.g. `ping 8.8.8.8`)
3. Clone MINDFulTeraFlowSDN.jl repo
4. Run with sudo the script "MINDFulTeraFlowSDN.jl/deploy-tfs/tfs-incus-distributed/tfs-lxd.sh"
5. If successful rerun the script by passing a different name for the VM, e.g., `sudo VM_NAME="tfs-vm-2" bash ./tfs-lxd.sh`
6. The two scripts must have created 2 incus instances. Check with `sudo incus list`. Output should be similar to:
+----------+---------+-----------------------------+-----------------------------------------------+-----------------+-----------+
|   NAME   |  STATE  |            IPV4             |                     IPV6                      |      TYPE       | SNAPSHOTS |
+----------+---------+-----------------------------+-----------------------------------------------+-----------------+-----------+
| tfs-vm   | RUNNING | 172.17.0.1 (docker0)        | fd42:c744:55:6f42:216:3eff:fe1a:9ebd (enp5s0) | VIRTUAL-MACHINE | 0         |
|          |         | 10.1.105.64 (vxlan.calico)  |                                               |                 |           |
|          |         | 10.0.100.49 (enp5s0)        |                                               |                 |           |
+----------+---------+-----------------------------+-----------------------------------------------+-----------------+-----------+
| tfs-vm-2 | RUNNING | 172.17.0.1 (docker0)        | fd42:c744:55:6f42:216:3eff:fe24:126 (enp5s0)  | VIRTUAL-MACHINE | 0         |
|          |         | 10.1.178.128 (vxlan.calico) |                                               |                 |           |
|          |         | 10.0.100.156 (enp5s0)       |                                               |                 |           |
+----------+---------+-----------------------------+-----------------------------------------------+-----------------+-----------+
7. Check the webui works, by copy/pasting the vxlan.calico address of every VM in the browser and appending "/webui". e.g. "http://10.0.100.49/webui"

#### Start MINDFul

1. Clone repo and instantiate.
2. Open 3 julia kernels in the demo environment
3. In the first terminal 
4. In the first terminal give the commands
```julia
julia> include("initialize.jl")

julia> ibnf1 = initializewithTFS("data/config1.toml", "10.0.100.49") # address of vxlan.calico "tfs-vm"
```
5. In the next terminal give the commands
```julia
julia> include("initialize.jl")

julia> ibnf3 = initializewithTFS("data/config3.toml", "10.0.100.156") # address of vx.calico "tfs-vm-2"
```
6. In the third terminal, instantiate with a dummy SDN controller:
```julia
julia> include("initialize.jl")

julia> ibnf2 = initializewithoutTFS("data/config2.toml")
```

The first time will take a while to initialize.

#### Demo in action
1. Open the two webui of the Teraflow controllers and select the default Ctx/Topo.
Now you are inside the view of the SDN controller.
2. Go to the "tfs-vm" on the Devices on the "Device Router-Node-4" on "/interfaces/interface/eth61". The enabled field should be set to `false`
3. Go to the "tfs-vm-2" on the Devices on the "Device Router-Node-47" on "/interfaces/interface/eth61". The enabled field should be set to `false`
4. Run one-by-one all commands from "intent.jl" for the `ibnf1`, i.e. "tfs-vm".
5. All commands should be successful. After the `installintent!` command, return to steps 2. and 3. and check that the field has gone to `true`.

You can search in TeraFlow for all the other devices configured by looking at the `intentplot` to find which devices are impacted.\
You can experiment with restarting the incus images and MINDFul to confirm that everything is rigidly in place.
