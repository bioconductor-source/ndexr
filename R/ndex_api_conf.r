################################################################################
## Authors:
##   Florian Auer [florian.auer@med.uni-goettingen.de]
##
## History:
##   Created on 28 November 2016 by Auer
##   Switched to automatic generation from yml file on 02 Februar 2017 by Auer
## 	
## Description:
##   Contains API configuration for connecting to NDEx servers
################################################################################


#' NDEx server api configuration
#' 
#' This nested list contains the url and methods for accessing the NDEx server via its REST full api
#' It contains specifications for NDEx server api version 1.3 and 2.0
#' If possible, the version 2.0 should be used
#' 
#' @return Nested list resembling the NDEx server REST API structure
#' @export
ndex.api.conf = list(
	Version_2.0=list(
		version="2.0",
		defaults=list(
			description="Default parameters",
			start=0,
			size=100,
			connection=list(
				description="URL of the NDEx server",
				host="www.ndexbio.org",
				api="/v2"
			)
		),
		replaceables=list(
			description="Tabs used within urls to be replaced with content",
			uuid="#UUID#",
			network="#NETWORKID#",
			aspect="#ASPECT#",
			start="#START#",
			size="#SIZE#",
			permission="#PERMISSION#",
			key="#KEY#",
			value="#VALUE#",
			type="#TYPE#"
		),
		url=list(
			serverStatus=list(
				description="Get Server Status",
				url="/admin/status",
				method="GET"
			),
			user=list(
				authenticate=list(
					description="Authenticate a User",
					url="/user?valid: true",
					method="GET"
				)
			),
			network=list(
				create=list(
					description="Create a CX Network",
					url="/network",
					method="POST"
				),
				update=list(
					description="Update a Network",
					url="/network/#NETWORKID#",
					method="PUT"
				),
				delete=list(
					description="Delete a Network",
					url="/network/#NETWORKID#",
					method="DELETE"
				),
				get=list(
					description="Get Complete Network in CX format",
					url="/network/#NETWORKID#",
					method="GET"
				),
				summary=list(
					get=list(
						description="Get Network Summary",
						url="/network/#NETWORKID#/summary",
						method="GET"
					)
				),
				sample=list(
					set=list(
						description="Get Network Summary",
						url="/network/#NETWORKID#/sample",
						method="PUT"
					),
					get=list(
						description="Set Network Sample",
						url="/network/#NETWORKID#/sample",
						method="GET"
					)
				),
				aspect=list(
					getMetaData=list(
						description="Get Network CX Metadata Collection",
						url="/network/#NETWORKID#/aspect",
						method="GET"
					),
					getMetaDataByName=list(
						description="Get Network Aspect Metadata",
						url="/network/#NETWORKID#/aspect/#ASPECT#/metadata",
						method="GET"
					),
					get=list(
						description="Get a Network Aspect As CX",
						url="/network/#NETWORKID#/aspect/#ASPECT#",
						method="GET",
						params=list(
							size="#SIZE#"
						)
					),
					update=list(
						description="Update an Aspect of a Network",
						url="/network/#NETWORKID#/aspect/#ASPECT#",
						method="PUT"
					)
				),
				permission=list(
					get=list(
						description="Get All Permissions on a Network",
						url="/network/#NETWORKID#/permission",
						method="GET",
						params=list(
							type="#TYPE#",
							permission="#PERMISSION#",
							start="#START#",
							size="#SIZE#"
						)
					),
					update=list(
						description="Update Network Permission",
						url="/network/#NETWORKID#/permission",
						method="PUT",
						params=list(
							userid="#UUID#",
							groupid="#UUID#",
							permission="#PERMISSION#"
						)
					),
					delete=list(
						description="Delete Network Permission",
						url="/network/#NETWORKID#/permission",
						method="DELETE",
						params=list(
							userid="#UUID#",
							groupid="#UUID#"
						)
					)
				),
				profile=list(
					update=list(
						description="Update Network Profile",
						url="/network/#NETWORKID#/profile",
						method="PUT"
					)
				),
				systemproperties=list(
					set=list(
						description="Set Network System Properties",
						url="/network/#NETWORKID#/systemproperty",
						method="PUT"
					)
				),
				properties=list(
					set=list(
						description="Set Network Properties",
						url="/network/#NETWORKID#/properties",
						method="PUT"
					)
				),
				provenance=list(
					set=list(
						description="Set Network Provenance",
						url="/network/#NETWORKID#/provenance",
						method="PUT"
					),
					get=list(
						description="Get Network Provenance",
						url="/network/#NETWORKID#/provenance",
						method="GET"
					)
				)
			),
			search=list(
				user=list(
					description="Search users",
					url="/search/user",
					method="POST",
					params=list(
						start="#START#",
						size="#SIZE#"
					)
				),
				group=list(
					description="Search groups",
					url="/search/group",
					method="POST",
					params=list(
						start="#START#",
						size="#SIZE#"
					)
				),
				network=list(
					search=list(
						description="Search network",
						url="/search/network",
						method="POST",
						params=list(
							start="#START#",
							size="#SIZE#"
						)
					),
					neighborhood=list(
						description="Query Network As CX",
						url="/search/network/#NETWORKID#/query",
						method="POST",
						params=list(
							size="#SIZE#"
						)
					)
				)
			)
		)
	),
	Version_1.3=list(
		version="1.3",
		defaults=list(
			description="Default parameters",
			start=0,
			size=100,
			connection=list(
				description="URL of the NDEx server",
				host="www.ndexbio.org",
				api="/rest"
			)
		),
		replaceables=list(
			description="Tabs used within urls to be replaced with content",
			uuid="#UUID#",
			network="#NETWORKID#",
			aspect="#ASPECT#",
			start="#START#",
			size="#SIZE#",
			permission="#PERMISSION#",
			key="#KEY#",
			value="#VALUE#",
			type="#TYPE#"
		),
		url=list(
			serverStatus=list(
				description="Get Server Status",
				url="/admin/status",
				method="GET"
			),
			user=list(
				authenticate=list(
					description="Authenticate a User",
					url="/user/authenticate",
					method="GET"
				)
			),
			network=list(
				create=list(
					description="Create a CX Network",
					url="/network/asCX",
					method="POST"
				),
				update=list(
					description="Update a Network",
					url="/network/asCX/#NETWORKID#",
					method="PUT"
				),
				delete=list(
					description="Delete a Network",
					url="/network/#NETWORKID#",
					method="DELETE"
				),
				get=list(
					description="Get Complete Network in CX format",
					url="/network/#NETWORKID#/asCX",
					method="GET"
				),
				summary=list(
					get=list(
						description="Get Network Summary",
						url="/network/#NETWORKID#/summary",
						method="GET"
					)
				),
				aspect=list(
					getMetaData=list(
						description="Get Network CX Metadata Collection",
						url="/network/#NETWORKID#/metadata",
						method="GET"
					),
					get=list(
						description="Get a Network Aspect As CX",
						url="/network/#NETWORKID#/aspect/#ASPECT#/#SIZE#",
						method="GET",
						params=list(
							size="#SIZE#"
						)
					)
				),
				permission=list(
					get=list(
						description="Get All Permissions on a Network",
						url="/network/#NETWORKID#/user/#PERMISSION#/#START#/#SIZE#",
						method="GET",
						params=list(
							permission="#PERMISSION#",
							start="#START#",
							size="#SIZE#"
						)
					),
					update=list(
						description="Update Network Permission",
						url="/network/#NETWORKID#/member",
						method="PUT",
						params=list(
							userid="#UUID#",
							groupid="#UUID#",
							permission="#PERMISSION#"
						)
					),
					delete=list(
						description="Delete Network Permission",
						url="/network/#NETWORKID#/member/#UUID#",
						method="DELETE",
						params=list(
							userid="#UUID#",
							groupid="#UUID#"
						)
					)
				),
				systemproperties=list(
					set=list(
						description="Set Network System Properties",
						url="/network/#NETWORKID#/setFlag/#KEY#=#VALUE#",
						method="PUT"
					)
				),
				properties=list(
					set=list(
						description="Set Network Properties",
						url="/network/#NETWORKID#/properties",
						method="PUT"
					)
				),
				provenance=list(
					set=list(
						description="Set Network Provenance",
						url="/network/#NETWORKID#/provenance",
						method="PUT"
					),
					get=list(
						description="Get Network Provenance",
						url="/network/#NETWORKID#/provenance",
						method="GET"
					)
				)
			),
			search=list(
				user=list(
					description="Search users",
					url="/user/search/#START#/#SIZE#",
					method="POST",
					params=list(
						start="#START#",
						size="#SIZE#"
					)
				),
				group=list(
					description="Search groups",
					url="/group/search/#START#/#SIZE#",
					method="POST",
					params=list(
						start="#START#",
						size="#SIZE#"
					)
				),
				network=list(
					search=list(
						description="Search network",
						url="/network/textsearch/#START#/#SIZE#",
						method="POST",
						params=list(
							start="#START#",
							size="#SIZE#"
						)
					),
					neighborhood=list(
						description="Query Network As CX",
						url="/network/#NETWORKID#/asCX/query",
						method="POST",
						params=list(
							size="#SIZE#"
						)
					)
				)
			)
		)
	)
)
