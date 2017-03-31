################################################################################
## Authors:
##   Alex Ishkin [aleksandr.ishkin@thomsonreuters.com]
##   Dexter Pratt [depratt@ucsd.edu]
##   Frank Kramer [frank.kramer@med.uni-goettingen.de]
##   Florian Auer [florian.auer@med.uni-goettingen.de]
##
## History:
##   Split from ndex_networks on 25 January 2017 by Auer
##     
## Description:
##    Contains functions to search and retrieve networks
################################################################################


####################################################
## 
##   Simple network operations
##
####################################################

#' Get NetworkSummary by Network UUID
#' 
#' This function retrieves the summary of the network identified by the supplied network UUID string.
#' 
#' @param ndexcon object of class NDEXConnection link{ndex.connect}
#' @param networkId unique ID of the network
#' 
#' @return List of network metadata: ID, name, whether it is public, edge and node count; source and format of network
#' 
#' @section REST query:
#' GET: ndex.conf$api$network$summary$get
#' @note Compatible to NDEx server version 1.3 and 2.0
#' 
#' @examples 
#' ## Establish a server connection
#' ndexcon = ndex.connect()
#' ## Find a network and get its UUID
#' networks = ndex.find.networks(ndexcon,"p53")
#' networkId = networks[1,"externalId"]
#' ## Get the network summary
#' summary = ndex.network.get.summary(ndexcon, networkId)
#' @export
ndex.network.get.summary <- function(ndexcon, networkId){
    api = ndex.helper.getApi(ndexcon, 'network$summary$get')
    route <- ndex.helper.encodeParams(api$url, api$params, network=networkId)
    
    response = ndex_rest_GET(ndexcon, route)
    return(response)
}


#' Get complete network
#' 
#' Returns the specified network as CX. 
#' This is performed as a monolithic operation, so it is typically advisable for applications to first use the getNetworkSummary method to check the node and edge counts for a network before retrieving the network.
#' Uses getEdges (this procedure will return complete network with all elements)
#' Nodes use primary ID of the base term ('represents' element)
#' Edges use primary ID of the base term ('predicate', or 'p' element)
#' Mapping table for the nodes is retrieved ('alias' and 'related' terms) to facilitate conversions/data mapping
#' 
#' @param ndexcon object of class NDEXConnection link{ndex.connect}
#' @param networkId unique ID of the network
#' 
#' @return \code{\link{RCX}} object
#' 
#' @section REST query:
#' GET: ndex.conf$api$network$get
#' @note Compatible to NDEx server version 1.3 and 2.0
#' 
#' @examples 
#' ## Establish a server connection
#' ndexcon = ndex.connect()
#' ## Find a network and get its UUID
#' networks = ndex.find.networks(ndexcon,"p53")
#' networkId = networks[1,"externalId"]
#' ## Get the network data 
#' rcx = ndex.get.network(ndexcon, networkId) 
#' @export
ndex.get.network <- function(ndexcon, networkId){
    api = ndex.helper.getApi(ndexcon, 'network$get')
    route <- ndex.helper.encodeParams(api$url, api$params, network=networkId)
  
    response = ndex_rest_GET(ndexcon, route, raw=TRUE)
    rcx = rcx.fromJSON(response)
    return(rcx)
}


#' Create a Network at a server from RCX data
#' 
#' This method creates a new network on the NDEx server from the given RCX object
#' 
#' @param ndexcon object of class NDEXConnection link{ndex.connect}
#' @param rcx \code{\link{RCX}} object
#' 
#' @return UUID of the newly created network
#' @note Requires an authorized user! (ndex.connect with credentials)
#' 
#' @section REST query:
#' POST (multipart/form-data): ndex.conf$api$network$create$url
#' data: CXNetworkStream = data
#' @note Compatible to NDEx server version 1.3 and 2.0
#' 
#' @examples
#' ## Establish a server connection with credentials 
#' # ndexcon = ndex.connect('MyAccountName', 'MyPassword')
#' ## Find a network and get its UUID
#' # networks = ndex.find.networks(ndexcon,"p53")
#' # networkId = networks[1,"externalId"]
#' ## Get the network data 
#' # rcx = ndex.get.network(ndexcon, networkId) 
#' ## Do some changes to rcx..
#' ## and create a new network
#' # networkId = ndex.create.network(ndexcon, rcx)
#' NULL
#' @export
ndex.create.network <- function(ndexcon, rcx){
    api = ndex.helper.getApi(ndexcon, 'network$create')
    route <- ndex.helper.encodeParams(api$url, api$params)
  
    tmpFile = tempfile()
    writeLines(rcx.toJSON(rcx), tmpFile)
    data <- list(CXNetworkStream = httr::upload_file(tmpFile, type = 'application/json'))
    response = ndex_rest_POST(ndexcon, route, data, multipart=TRUE, raw=TRUE)
    ## response is the url of the network: "http://public.ndexbio.org/v2/network/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    ## only the uuid should be returned
    uuid = tail(unlist(strsplit(response, '/')), n=1)
    file.remove(tmpFile)
    return(uuid)
}


#' Update an Entire Network as CX
#' 
#' This method updates/replaces a existing network on the NDEx server with new content from the given RCX object.
#' The UUID can either be specified manually or it will be extracted from the RCX object (i.e. from rcx$ndexStatus$externalId).
#' 
#' @param ndexcon object of class NDEXConnection link{ndex.connect}
#' @param rcx \code{\link{RCX}} object
#' @param networkId (optional); unique ID of the network
#' 
#' @return UUID of the updated network
#' @note Requires an authorized user! (ndex.connect with credentials)
#' 
#' @section REST query:
#' PUT (multipart/form-data): ndex.conf$api$network$update$url
#' data: CXNetworkStream = data
#' @note Compatible to NDEx server version 1.3 and 2.0
#' 
#' @examples 
#' ## Establish a server connections with credentials 
#' # ndexcon = ndex.connect('MyAccountName', 'MyPassword')
#' ## Find one of your networks and get its UUID
#' # networks = ndex.find.networks(ndexcon, accountName='MyAccountName')
#' # networkId = networks[1,"externalId"]
#' ## Get the network data 
#' # rcx = ndex.get.network(ndexcon, networkId) 
#' ## Do some changes to rcx..
#' ## and update the network
#' # networkId = ndex.update.network(ndexcon, rcx, networkId)
#' # networkId = ndex.update.network(ndexcon, rcx) ## same as previous
#' NULL
#' @export
ndex.update.network <- function(ndexcon, rcx, networkId){
    if(missing(networkId)){
        if(is.null(rcx$ndexStatus)|| is.null(rcx$ndexStatus$externalId)) {
            stop("ndex.update.network: no network id specified, whether as parameter nor in rcx$ndexStatus$externalId")
        }
        networkId = rcx$ndexStatus$externalId
    }
        
    api = ndex.helper.getApi(ndexcon, 'network$update')
    route <- ndex.helper.encodeParams(api$url, api$params, network=networkId)
    
    tmpFile = tempfile()
    writeLines(rcx.toJSON(rcx), tmpFile)
    data <- list(CXNetworkStream = httr::upload_file(tmpFile, type = 'application/json'))
    response = ndex_rest_PUT(ndexcon, route, data, multipart=TRUE, raw=TRUE)
    file.remove(tmpFile)
    return(networkId)
}


#' Delete a network
#' 
#' @param ndexcon object of class NDEXConnection link{ndex.connect}
#' @param networkId unique ID of the network
#' 
#' @return NULL on success; Error else
#' @note Requires an authorized user! (ndex.connect with credentials)
#' 
#' @section REST query:
#' DELETE: ndex.conf$api$network$delete
#' @note Compatible to NDEx server version 1.3 and 2.0
#' 
#' @examples 
#' ## Establish a server connections with credentials 
#' # ndexcon = ndex.connect('MyAccountName', 'MyPassword')
#' ## Find a network and get its UUID
#' # networks = ndex.find.networks(ndexcon,"p53")
#' # networkId = networks[1,"externalId"] 
#' ## Delete the network
#' # ndex.delete.network(ndexcon, networkId)
#' NULL
#' @export
ndex.delete.network <- function(ndexcon, networkId){
    api = ndex.helper.getApi(ndexcon, 'network$delete')
    route <- ndex.helper.encodeParams(api$url, api$params, network=networkId)
    response = ndex_rest_DELETE(ndexcon, route, raw=TRUE)
    return(NULL)
}