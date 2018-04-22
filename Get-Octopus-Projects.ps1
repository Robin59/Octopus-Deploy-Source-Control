Function Get-Octopus-Projects{
<#
	    .SYNOPSIS
         
	    .DESCRIPTION

		    See Synopsis

	    .PARAMETER 
            
            $Destination - Folder that will contain the files created 
            $OctopusURI -  Octopus URI
            $apikey - the Octopus API key

	    .EXAMPLE
    
            Get-Octopus-Projects -OctopusURI 'http://localhost' -$Destination "C:\Users\rgiraudon\Document\Octopus_Version_Control" -apikey 'API-MOCK01API'
	
        .NOTES
            
            None
#>
    param
    (        
        [Parameter(Mandatory=$True)][String]$Destination,
        [Parameter(Mandatory=$True)][String]$OctopusURI,
        [Parameter(Mandatory=$True)][String]$apikey
    )

    Begin{        
        Add-Type -Path "C:\Program Files\Octopus Deploy\Octopus\Octopus.Client.dll"

        #Create structure
        if(-Not (test-path $Destination\Projects)){   
            New-Item -Path $Destination -Name Projects -ItemType directory
        }               
    }

    Process{          
        $header = @{ "X-Octopus-ApiKey" = $apikey } 

        $allProjectGroups = (Invoke-WebRequest $OctopusURI/api/projectgroups/all -Method Get -Headers $header).content | ConvertFrom-Json  

        foreach ($projectGroup in $allProjectGroups){
            $projectGroupPath = [string]::Concat($Destination, "\Projects\", $projectGroup.Name)
            
            if(-Not (test-path $projectGroupPath)){   
                New-Item -Path $Destination\Projects -Name $projectGroup.Name -ItemType directory
            }
            $uri = [string]::Concat($OctopusURI,"/api/projectgroups/",  $projectGroup.ID, "/projects")
            $projects = (Invoke-WebRequest $uri -Method Get -Headers $header).content | ConvertFrom-Json
           
            foreach($project in  $projects.Items){
                $projectPath = [string]::Concat($projectGroupPath, "\", $project.Name)
                if(-Not (test-path $projectPath)){  
                    New-Item -Path $projectGroupPath -Name $project.Name -ItemType directory 
                }
                # Write-Output $project
            }
        }

    }

}