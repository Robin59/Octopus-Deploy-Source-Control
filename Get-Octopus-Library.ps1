Function Get-Octopus-Library{
<#
	    .SYNOPSIS
            This function put all the content of the Octopus library in a folder and in a human-readable format. 
            The goal is to be able to do version control of Octopus projects.
                                    
	    .DESCRIPTION

		    See Synopsis

	    .PARAMETER 
            
            $Destination - Folder that will contain the files created 
            $OctopusURI -  Octopus URI
            $apikey - the Octopus API key

	    .EXAMPLE
    
            Octopus-Upload-Release -OctopusURI 'http://localhost' -$Destination "C:\Users\rgiraudon\Document\Octopus_Version_Control" -apikey 'API-MOCK01API'
	
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
        if(-Not (test-path $Destination\Library)){   
            New-Item -Path $Destination -Name Library -ItemType directory
        }
        if(-Not (test-path $Destination\Library\ScriptModule)){   
            New-Item -Path $Destination\Library -Name ScriptModule -ItemType directory
        }
    }

    Process{          
        $header = @{ "X-Octopus-ApiKey" = $apikey } 
    
        $allprojects = (Invoke-WebRequest $OctopusURI/api/libraryvariablesets/all -Method Get -Headers $header).content | ConvertFrom-Json 

        Foreach ($Project in $allprojects){
    
            if($Project.ContentType -eq "ScriptModule"){     
                $URI = $OctopusURI+$Project.Links.Variables      
                $Var = (Invoke-WebRequest $URI -Method Get -Headers $header).content | ConvertFrom-Json 
                $Var.Variables.Value > ("$Destination\Library\ScriptModule\"+$Project.Name+".ps1")
            }    
        }

    }
}