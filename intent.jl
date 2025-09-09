#Connectivity Intent between a node from domain 1 and a node from domain 3
conintent_neigh = MINDF.ConnectivityIntent(MINDF.GlobalNode(UUID(1), 4), MINDF.GlobalNode(UUID(3), 47), u"100.0Gbps")
intentuuid_neigh = MINDF.addintent!(ibnf1, conintent_neigh, MINDF.NetworkOperator())

#Compile the intent
MINDF.compileintent!(ibnf1, intentuuid_neigh, MINDF.KShorestPathFirstFitCompilation(5))

#Plot the intent
intentplot(ibnf1, intentid = intentuuid_neigh; multidomain=true, showstate = true, showintent = true)

#Check the low-level implementation of the intent
MINDF.getlogicallliorder(ibnf1, intentuuid_neigh; onlyinstalled=false)

#Plot the whole graph with the intent highlighted
ibnplot(ibnf1; multidomain=true, intentids = [intentuuid_neigh], shownodelabels = :local)

#Install the intent
MINDF.installintent!(ibnf1, intentuuid_neigh; verbose=true)


#Uninstall the intent
MINDF.uninstallintent!(ibnf1, intentuuid_neigh)

#Uncompile the intent
MINDF.uncompileintent!(ibnf1, intentuuid_neigh)
