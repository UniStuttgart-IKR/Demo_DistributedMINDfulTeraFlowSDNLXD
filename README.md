# Demo of Distributed MINDFul.jl with TFS controllers inside LXD virtual machines

Include `initialize.jl` and instatiate the different IBN-Frameworks by calling the corresponding function depending on wether to use TFS or not

Both functions expect the configuration file in TOML format. TFS also expects the IP address of the LXD-VM

Each one will return the corresponing `ibnf`

An example of the operation and ploting of a connectivity intent is provided in `intent.jl`

### How to generate RSA keys if needed
`openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -pkeyopt rsa_keygen_pubexp:3 -out rsa_priv1.pem`
`openssl pkey -in rsa_priv1.pem -out rsa_pub1.pem -pubout`