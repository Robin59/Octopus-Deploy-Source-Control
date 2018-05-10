Function Get-Octopus-Environements{
<#
	    .SYNOPSIS
           
                                    
	    .DESCRIPTION

		    See Synopsis

	    .PARAMETER 
            
            $OctopusURI -  Octopus URI
            $apikey - the Octopus API key

	    .EXAMPLE
    
            Octopus-Upload-Release -OctopusURI 'http://localhost' -apikey 'API-MOCK01API'
	
        .NOTES
            
            None
#>
    param
    (               
        [Parameter(Mandatory=$True)][String]$OctopusURI,
        [Parameter(Mandatory=$True)][String]$apikey
    )

    Begin{        
        Add-Type -Path "C:\Program Files\Octopus Deploy\Octopus\Octopus.Client.dll"
    }

    Process{          
        $header = @{ "X-Octopus-ApiKey" = $apikey } 
        $output = @{}

        $allEnvironments = ((Invoke-WebRequest $OctopusURI/api/environments/all -Method Get -Headers $header).content | ConvertFrom-Json )        

         Foreach ($environment in $allEnvironments) {
            $output.Add($environment.Id, $environment.Name)
         }
      
        $output        
    }
}

Function Get-Octopus-Machines{
    param
    (               
        [Parameter(Mandatory=$True)][String]$OctopusURI,
        [Parameter(Mandatory=$True)][String]$apikey
    )

    Begin{        
        Add-Type -Path "C:\Program Files\Octopus Deploy\Octopus\Octopus.Client.dll"
    }

    Process{          
        $header = @{ "X-Octopus-ApiKey" = $apikey } 
        $output = @{}

        $allMachines = ((Invoke-WebRequest $OctopusURI/api/machines/all -Method Get -Headers $header).content | ConvertFrom-Json )        

         Foreach ($machine in $allMachines) {
            $output.Add($machine.Id, $machine.Name)
         }
      
        $output        
    }
}

Function Get-Octopus-lifecycles{
<#
#>
    param
    (               
        [Parameter(Mandatory=$True)][String]$OctopusURI,
        [Parameter(Mandatory=$True)][String]$apikey
    )

    Begin{        
        Add-Type -Path "C:\Program Files\Octopus Deploy\Octopus\Octopus.Client.dll"
    }

    Process{          
        $header = @{ "X-Octopus-ApiKey" = $apikey } 
        $output = @{}

        $allLifecycles = ((Invoke-WebRequest $OctopusURI/api/lifecycles/all -Method Get -Headers $header).content | ConvertFrom-Json )        

         Foreach ($lifecycle in $allLifecycles) {
            $output.Add($lifecycle.Id, $lifecycle)
         }
      
        $output        
    }
}