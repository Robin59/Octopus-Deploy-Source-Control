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
        if(-Not (test-path $Destination\Library\VariableSets)){   
            New-Item -Path $Destination\Library -Name VariableSets -ItemType directory
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

            }elseif($Project.ContentType -eq "Variables"){
                
                $VariablesOutput = New-Object System.Collections.ArrayList
                $URI = $OctopusURI+$Project.Links.Variables      
                $Variables =  (Invoke-WebRequest $URI -Method Get -Headers $header).content | ConvertFrom-Json                
                                
                Foreach ($Variable in $Variables.variables){   
                
                    $Var = New-Object psobject
                    
                    add-Member -InputObject $Var –MemberType NoteProperty –Name Name –Value $Variable.Name 
                    add-Member -InputObject $Var –MemberType NoteProperty –Name Value –Value $Variable.Value
                    
                    if($Variable.Scope.Environment.Length -ge 1){ 
                        $Var | add-Member –MemberType NoteProperty –Name Environment –Value $Variable.Scope.Environment
                    }
                    if($Variable.Scope.Machine.Length -ge 1){ 
                        $Var | add-Member –MemberType NoteProperty –Name Machine –Value $Variable.Scope.Machine
                    }
                    if($Variable.Scope.Role.Length -ge 1){
                        $Var | add-Member –MemberType NoteProperty –Name Roles –Value $Variable.Scope.Role
                    }                    
                                                        
                    $VariablesOutput.Add($Var) | Out-Null
                }
                 $VariablesOutput | ConvertTo-Json > ("$Destination\Library\VariableSets\"+$Project.Name+".json")
            }
        }

    }
}