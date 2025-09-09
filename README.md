# Demo of Distributed MINDFul.jl with TFS controller inside LXD virtual machines

Include `initialize.jl` and instatiate the different IBN-Frameworks by calling the corresponding function depending on wether to use TFS or not

Both functions expect the configuration file in TOML format. TFS also expects the IP address of the LXD-VM

Each one will return the corresponing `ibnf`

An example of the operation and ploting of a connectivity intent is provided in `intent.jl`