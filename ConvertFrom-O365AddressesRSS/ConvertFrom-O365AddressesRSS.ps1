﻿Import-Module Boxstarter.Chocolatey
function ConvertFrom-O365AddressesRSS {
    <#
    .SYNOPSIS
    Download and convert to custom PowerShell object the RSS channel data about planned changes to Office 365 networks/hosts.
    
    .DESCRIPTION
    Function intended for converting to the custom PowerShell object the list of changes published by Microsoft as RSS items.
    
    More information on the Microsoft support page: "Office 365 URLs and IP address ranges", http://bit.ly/1LD8fYv
    
    .PARAMETER Path
    The xml file containing data like O365IPAddresses.xml downloaded manually. 
    If the the parameter is ommited the file O365IPAddresses.xml will be downloaded from the Microsoft site and saved with the name containing the date and time of download.
    
    .PARAMETER StartDate
    The Start parameter specifies the start date and time of the date range. RSS item publication information is returned from to, but not including, the specified date and time.
    
    .PARAMETER EndDate
    The End parameter specifies the end date and time of the date range. RSS item publication information is returned up to, but not including, the specified date and time.
    
    .INPUTS
    None. The xml data published as RSS channel under url https://support.office.com/en-us/o365ip/rss. 
    
    .OUTPUTS
    None. The custom PowerShell object what contains properties: OperationType, Title, PublicationDate, Guid, Description, DescriptionIsParsable, QuickDescription, Notes, SubChanges. The Subchanges property is array of objects (so can be expanded) to object what contains properties:  EffectiveDate, Required, ExpressRoute, Value.
    
    .EXAMPLE
    [PS] > ConvertFrom-O365AddressesRSS
    
    <Output partially omitted>
    
    OperationType         : Adding
    Title                 : Exchange Online
    PublicationDate       : 6/13/2016 3:06:43 PM
    Guid                  : 7ef9205d-fb30-43bf-9501-9fe8106dfa20
    Description           : Adding 1 New FQDNs; 1/[Effective 8/1/2016. Required: Exchange Online Protection. ExpressRoute:
                            No. 40mshrcstorageprod.blob.core.windows.net]. Notes: removing the wildcard for this endpoint.
    DescriptionIsParsable : True
    QuickDescription      : Adding 1 New FQDNs
    Notes                 : removing the wildcard for this endpoint.
    SubChanges            : {@{EffectiveDate=8/1/2016 12:00:00 AM; Required=Exchange Online Protection;
                            ExpressRoute=False; Value=40mshrcstorageprod.blob.core.windows.net}}

    OperationType         : Adding
    Title                 : Office Online
    PublicationDate       : 6/13/2016 3:06:45 PM
    Guid                  : 8ef9105d-fb30-43bf-9502-9fe7106efa20
    Description           : Adding 1 New IP_Sets; 1/[Effective 6/13/2016. Required: Office Online. ExpressRoute: Yes.
                            13.94.209.165]. Notes: Infrastructure change for a small component of Office Online, minimal
                            (if any) customer impact; additionally, this endpoint wonĂ˘â'¬â"˘t be available via
                            ExpressRoute until 8/1/2016.
    DescriptionIsParsable : True
    QuickDescription      : Adding 1 New IP_Sets
    Notes                 :
    SubChanges            : {@{EffectiveDate=6/13/2016 12:00:00 AM; Required=Office Online; ExpressRoute=True;
                            Value=13.94.209.165}}
    
    Automatically parsed RSS items, general view without expanding SubChanges
    
    
    .EXAMPLE
    
    [PS] > ConvertFrom-O365AddressesRSS -Path .\O365AddressesRSS.xml | get-member

       TypeName: Selected.System.String

    Name                  MemberType   Definition
    ----                  ----------   ----------
    Equals                Method       bool Equals(System.Object obj)
    GetHashCode           Method       int GetHashCode()
    GetType               Method       type GetType()
    ToString              Method       string ToString()
    Description           NoteProperty string Description=If 134.170.0.0/16 has already been added from the Office 365 l...
    DescriptionIsParsable NoteProperty bool DescriptionIsParsable=False
    Guid                  NoteProperty string Guid=fa204cfc-402a-4fe6-818e-f9105dfb303b
    Notes                 NoteProperty object Notes=null
    OperationType         NoteProperty object OperationType=null
    PublicationDate       NoteProperty datetime PublicationDate=7/15/2014 7:00:00 AM
    QuickDescription      NoteProperty object QuickDescription=null
    SubChanges            NoteProperty object SubChanges=null
    Title                 NoteProperty string Title=Office Online

    .EXAMPLE
    
    Output for the RSS item what is not parsable
    
    [PS] > ConvertFrom-O365AddressesRSS -Path .\O365AddressesRSS.xml | get-member

       TypeName: Selected.System.String

    Name                  MemberType   Definition
    ----                  ----------   ----------
    Equals                Method       bool Equals(System.Object obj)
    GetHashCode           Method       int GetHashCode()
    GetType               Method       type GetType()
    ToString              Method       string ToString()
    Description           NoteProperty string Description=Adding 1 New IP_Sets; 1/[Effective 7/1/2016. Required: Exchang...
    DescriptionIsParsable NoteProperty bool DescriptionIsParsable=True
    Guid                  NoteProperty string Guid=029fe710-7ef9-4205-8fb4-03afd6018ef8
    Notes                 NoteProperty string Notes=adding consolidated range.
    OperationType         NoteProperty string OperationType=Adding
    PublicationDate       NoteProperty datetime PublicationDate=6/1/2016 12:22:56 PM
    QuickDescription      NoteProperty string QuickDescription=Adding 1 New IP_Sets
    SubChanges            NoteProperty System.Collections.ArrayList SubChanges=
    Title                 NoteProperty string Title=Exchange Online Protection

    Output for the RSS item what is parsable
    
    .EXAMPLE
    
    [PS] > ConvertFrom-O365AddressesRSS | Select-Object -Property Guid,OperationType,PublicationDate,Title -ExpandProperty SubChanges
    
    <Output partially omitted>
    
    EffectiveDate   : 7/1/2016 12:00:00 AM
    Required        : Exchange Online Protection
    ExpressRoute    : True
    Value           : 216.32.180.0/23
    Guid            : 029fe710-7ef9-4205-8fb4-03afd6018ef8
    OperationType   : Adding
    PublicationDate : 6/1/2016 12:22:56 PM
    Title           : Exchange Online Protection

    EffectiveDate   : 8/1/2016 12:00:00 AM
    Required        : Office 365 Authentication and identity
    ExpressRoute    : True
    Value           : 2a01:111:2005:6::/64
    Guid            : 29fe7107-ef92-404c-bc40-3afd6018ef81
    OperationType   : Adding
    PublicationDate : 6/13/2016 3:06:37 PM
    Title           : Authentication and Identity

    EffectiveDate   : 8/1/2016 12:00:00 AM
    Required        : Exchange Online Protection
    ExpressRoute    : True
    Value           : 207.46.101.128/26
    Guid            : ef9205cf-b403-4afd-a018-fe8106dfa304
    OperationType   : Removing
    PublicationDate : 6/13/2016 3:06:39 PM
    Title           : Exchange Online Protection
    
    <Output partially omitted>
    
    Automatically parsed RSS items with details about planned changes.
    
    .EXAMPLE
    
    ConvertFrom-O365AddressesRSS | Select-Object -Property Guid -ExpandProperty SubChanges

    <Output partially omitted>

    EffectiveDate : 3/29/2016 12:00:00 AM
    Status        : Required
    SubService    : Exchange Online
    ExpressRoute  : False
    Protocol      : TCP
    Port          : 443
    Value         : 191.232.96.0/19
    Guid          : 4bfc5029-fe70-407e-b920-5cfb403afd60

    EffectiveDate : 2/29/2016 12:00:00 AM
    Status        : Optional
    SubService    : Microsoft Azure Active Directory (MFA)
    ExpressRoute  : False
    Protocol      : TCP
    Port          : 443
    Value         : secure.aadcdn.microsoftonline-p.com
    Guid          : 105dfb30-3bfd-4502-9fe7-107efa204cfc
    
    <Output partially omitted>
    
    .LINK
    https://github.com/it-praktyk/Convert-Office365NetworksData
    
    .LINK
    https://www.linkedin.com/in/sciesinskiwojciech
          
    .NOTES
    AUTHOR: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
    KEYWORDS: PowerShell, Exchange, Office 365, O365, XML, proxy, RSS
   
    VERSIONS HISTORY
    - 0.1.0 - 2016-06-17 - The first version published to GitHub
    - 0.1.1 - 2016-06-19 - A case when the parameter Path is used corrected, TODO updated
	- 0.1.2 - 2016-06-19 - Handling input file rewrote partially, help updated
    - 0.2.0 - 2016-06-21 - Support for Protocol,Port,Status means:Required/Optional added in SubChanges, help updated
    - 0.2.1 - 2016-06-21 - Parsing description to SubChanges corrected
    - 0.2.2 - 2016-06-21 - Parsing 'Updating' items added
    - 0.2.3 - 2016-06-21 - Description will be trimmed at the begining of processing, TODO updated
    - 0.3.0 - 2016-06-23 - Workarounds for inconsistent descriptions added, the parameters Start, End added to limit parse between dates
    - 0.4.0 - 2016-06-24 - Parsing notes only RSS items added, verbose corrected
    
    TODO
    - implement handling cases like 
      - guid: ef8105df-b303-4bfd-9029-fe7107efa204 - Notes only items
    - implement parameters DownloadRSSOnly, CleanFileAfterParsing
    - add support for downloading the file via proxy with authentication (?)
    - add parameter to custom naming downloaded file
    - direct output for CSV files (?)
    
        
    LICENSE
    Copyright (c) 2016 Wojciech Sciesinski
    This function is licensed under The MIT License (MIT)
    Full license text: https://opensource.org/licenses/MIT
   
#>
    
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $false)]
        [String]$Path = ".\O365AddressesRSS.xml",
        [Parameter(Mandatory = $false)]
        [DateTime]$Start,
        [Parameter(Mandatory = $false)]
        [DateTime]$End
        #,
        #[Parameter(Mandatory = $false)]
        #[Switch]$DownloadRSSOnly, #Can be handled to output to null
        #[Parameter(Mandatory = $false)]
        #[Switch]$CleanFileAfterParsing 
    )
    
    BEGIN {
        
        Import-Module DebugPx -Force -Verbose:$InternalVerbose
        
        [Bool]$InternalVerbose = $false
        
        If ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
            
            $ParameterVerbose = $true
            
        }
        Else {
            
            $ParameterVerbose = $false
            
        }
        
        Try {
            
            If (!(Test-Path -Path $Path -PathType Leaf)) {
                
                # If not provided file then download file from the internet
                
                [String]$UrlToDownload = "https://support.office.com/en-us/o365ip/rss"
                
                [String]$OutputFileName = ".\O365IPAddressesChanges-{0}.xml" -f (Get-Date -Format "yyyyMMdd-HHmmss")
                
                Invoke-WebRequest -uri $UrlToDownload -OutFile ".\$OutputFileName" -Verbose:$InternalVerbose
                
                [String]$MessageText = "The RSS {0} content downloaded and stored as a file {1}" -f $UrlToDownload, $OutputFileName
                
                [String]$FileToProcess = $OutputFileName
                
                Write-Verbose -Message $MessageText
                
            }
            Else {
                
                [String]$MessageText = "The file {0} found and will be processed" -f $Path
                
                Write-Verbose -Message $MessageText
                
                $FileToProcess = $Path
                
            }
            
            #Assigning RSS file content to variable
            [XML]$CurrentO365AddressesChanges = Get-Content -Path $FileToProcess
            
            $Results = New-Object System.Collections.ArrayList
            
        }
        Catch {
            
            Throw $error[0]
            
        }
        
    }
    
    PROCESS {
        
        $RSSItem = $CurrentO365AddressesChanges.rss.channel
        
        $RSSItemCount = $(($RSSItem.Item | Measure-Object).Count)
        
        [String]$MessageText = "{0} RSS items found in the xml file {1}" -f $RSSItemCount, $OutputFileName
        
        Write-Verbose -Message $MessageText
        
        $i = 1
        
        ForEach ($CurrentItem in $RSSItem.Item) {
            
            #This can be used to limit parse operation under development
            #if ($i -gt 197 -and $i -lt 203) {
            
            [datetime]$CurrentItemPubDate = $CurrentItem.pubDate
            
            #Check if the StartDate and EndDate parameters are populated
            If (-not ([String]::IsNullOrEmpty($Start)) -and -not ([String]::IsNullOrEmpty($End))) {
                
                If ($CurrentItemPubDate -le $Start -or $CurrentItemPubDate -ge $End) {
                    
                    #Skip current RSS item means loop iteration 
                    continue
                    
                }
                
            }
            Elseif ($Start) {
                
                If ($CurrentItemPubDate -le $Start) {
                    
                    #Skip current RSS item means loop iteration 
                    continue
                    
                }
                
            }
            elseif ($End) {
                
                If ($CurrentItemPubDate -ge $End) {
                    
                    #Skip current RSS item means loop iteration 
                    continue
                    
                }
                
            }
            
            
            #Prepoulating properties for the Result object
            
            $Result = "" | Select-Object -Property OperationType, Title, PublicationDate, Guid, Description, DescriptionIsParsable, QuickDescription, Notes, SubChanges
            
            $CurrentItemGuid = $CurrentItem.guid
            
            $DescriptionParsable = $false
            
            $CurrentItemDescription = $($($CurrentItem.Description).Replace("$([char][int]10)", " ")).Trim()
            
            If ($CurrentItemDescription.Substring(0, 5) -eq 'Note:' -or $CurrentItemDescription.Substring(0, 6) -eq 'Notes:') {
                
                $ParsedDescription = Parse-O365IPAddressChangesDescription -Description $CurrentItemDescription -Guid $CurrentItemGuid -InfoOnly -Verbose:$ParameterVerbose
                
            }
            Else {
                
                $ParsedDescription = Parse-O365IPAddressChangesDescription -Description $CurrentItemDescription -Guid $CurrentItemGuid -Verbose:$ParameterVerbose
                
            }
            
            $CurrentItemTitle = $($($CurrentItem.Title).trim()).Replace("$([char][int]10)", " ")
            
            $Result.Title = $CurrentItemTitle
            
            $Result.PublicationDate = $CurrentItemPubDate
            
            $Result.Guid = $CurrentItemGuid
            
            $Result.Description = $CurrentItemDescription
            
            If ($ParsedDescription.DescriptionIsParsable) {
                
                $Result.OperationType = $ParsedDescription.OperationType
                
                $Result.DescriptionIsParsable = $ParsedDescription.DescriptionIsParsable
                
                $Result.QuickDescription = $ParsedDescription.QuickChangeDescription
                
                $Result.Notes = $ParsedDescription.Notes
                
                $Result.SubChanges = $ParsedDescription.SubChanges
                
            }
            Else {
                
                $Result.DescriptionIsParsable = $ParsedDescription.DescriptionIsParsable
                
                $Result.SubChanges = $ParsedDescription.SubChanges
                
            }
            
            
            
            $Results.Add($Result) | Out-Null
            
        }
        
        $i++
        
        #}
        
    }
    
    END {
        
        #enter-debugger
        
        Return $Results
        
    }
    
}

Function Parse-O365IPAddressChangesDescription {
    
    [cmdletbinding()]
    param (
        
        [parameter(Mandatory = $true)]
        [String]$Description,
        [parameter(Mandatory = $true)]
        [String]$Guid,
        [parameter(Mandatory = $false)]
        [switch]$InfoOnly
        
    )
    
    begin {
        
        $DescriptionIsParsable = $false
        
    }
    
    Process {
        
        #Import-Module DebugPx -Force
        
        
        #Try {
        
        If ($InfoOnly.IsPresent) {
            
            $SubResult = "" | Select-Object -Property EffectiveDate, Status, SubService, ExpressRoute, Protocol, Port, Value
            
            $SubResults = New-Object System.Collections.ArrayList
            
            $QuickDescription = 'Information - read description'
            
            $SubResult.Value = 'N/A'
            
            #Add Value to allow expand 'SubChanges' field
            $SubResults.Add($SubResult) | Out-Null
            
            $DescriptionIsParsable = $true
            
            $QuickDescriptionPart0 = 'InfoONly'
            
            Remove-Variable -Name SubResult | Out-Null
            
            
        }
        
        #Workaround for guid: afd6018e-f810-45df-b303-bfd5029fe710 - colon except semicolon used to separate the first block
        #Replace the first colon
        Else {
            If ($Description.IndexOf(';') -eq -1) {
                
                $CommaIndex = $Description.IndexOf(',')
                
                $Description = "{0};{1}" -f $Description.Substring(0, ($CommaIndex - 1)), $($Description.Substring($CommaIndex + 1, $($Description.Length - $CommaIndex) - 1))
                
            }
            
            $DescriptionSplittedParts = $Description.Split(';')
            
            #Workaround for gudi: e6018ef9-105d-4fb3-83bf-d5029fe7106e 
            #Join parts if was splitted due to a semicolon in the last field (probably in 'Notes')
            if ($Description.IndexOf(';') -ne $Description.LastIndexOf(';')) {
                
                #Enter-
                
                $DescriptionSplittedParts[1] = "{0}; {1}" -f $DescriptionSplittedParts[1], $DescriptionSplittedParts[2]
                
            }
            
            $DescriptionSplittedPartsCount = ($DescriptionSplittedParts | Measure-Object).Count
            
            #Replace end of the line chars
            $QuickDescription = $($DescriptionSplittedParts[0]).Replace("$([char][int]10)", " ")
            
            $QuickDescriptionPart0 = $($QuickDescription.Split(' '))[0]
            
            [String]$MessageText = "QuickDescription separated from the Description field: {0}" -f $QuickDescription
            
            Write-Verbose -Message $MessageText
            
            If (@("Adding", "Removing", "Updating") -contains $QuickDescriptionPart0) {
                
                [String]$MessageText = "Recognized operations in the RSS item {0} is {1} - means Adding or Removing. Description will be parsed to extract SubChanges." -f $Guid, $QuickDescriptionPart0
                
                Write-Verbose -Message $MessageText
                
                $Operations = $($($($($Description.Split(';'))[1]).trim()).Replace("$([char][int]10)", " ")).Split(',')
                
                $OperationsCount = ($Operations | Measure-Object).Count
                
                For ($i = 0; $i -lt $OperationsCount; $i++) {
                    
                    $CurrentOperation = $($Operations[$i]).Trim()
                    
                    [String]$MessageText = "Parsing subchange: {0}" -f $CurrentOperation
                    
                    Write-Verbose -Message $MessageText
                    
                    If ($i -eq $OperationsCount - 1 -and $CurrentOperation -match 'Notes:') {
                        
                        #Try find Notes
                        
                        $RawNotes = $CurrentOperation.Split(']')[1]
                        
                        $Notes = $RawNotes.Substring(9, $RawNotes.length - 9)
                        
                    }
                    
                    $OpenBracket = $CurrentOperation.IndexOf('[')
                    
                    $CloseBracket = $CurrentOperation.IndexOf(']')
                    
                    If ($OpenBracket -eq -1 -or $CloseBracket -eq -1) {
                        
                        Break
                        
                    }
                    Else {
                        
                        $SubResult = "" | Select-Object -Property EffectiveDate, Status, SubService, ExpressRoute, Protocol, Port, Value
                        
                        $SubResults = New-Object System.Collections.ArrayList
                        
                        #Clean data from data outside brackets
                        $CurrentOperation = $CurrentOperation.Substring($OpenBracket + 1, ($CloseBracket - $OpenBracket) - 1)
                        
                        #Split data to fields
                        $CurrentOperationSplited = $CurrentOperation.Split('.')
                        
                        [DateTime]$EffectiveDate = Get-Date -Date $($($CurrentOperationSplited[0]).Trim()).Replace('Effective ', '') -Format 'M/d/yyyy'
                        
                        If ($CurrentOperationSplited[1] -match 'Required') {
                            
                            $Status = 'Required'
                            
                            $SubService = $($($CurrentOperationSplited[1]).Trim()).Replace('Required: ', '')
                            
                        }
                        elseif ($CurrentOperationSplited[1] -match 'Optional') {
                            
                            $Status = 'Optional'
                            
                            $SubService = $($($CurrentOperationSplited[1]).Trim()).Replace('Optional: ', '')
                            
                        }
                        
                        If ($(($CurrentOperationSplited[2]).Trim()).Replace('ExpressRoute: ', '') -eq 'Yes') {
                            
                            $ExpressRoute = $true
                            
                        }
                        Else {
                            
                            $ExpressRoute = $false
                            
                        }
                        
                        If ($CurrentOperationSplited[3] -match 'TCP' -and $CurrentOperationSplited[3] -match 'UDP') {
                            
                            $Protocol = 'TCP,UDP'
                            
                            
                        }
                        
                        ElseIf ($CurrentOperationSplited[3] -match 'TCP') {
                            
                            $Protocol = 'TCP'
                            
                            $Port = $($($CurrentOperationSplited[3]).Trim()).Replace('Port: TCP ', '')
                            
                        }
                        
                        
                        ElseIf ($CurrentOperationSplited[3] -match 'UDP') {
                            
                            $Protocol = 'UDP'
                            
                            $Port = $($($CurrentOperationSplited[3]).Trim()).Replace('Port: UDP ', '')
                            
                        }
                        
                        $LastSpaceIndex = $CurrentOperation.LastIndexOf(' ')
                        
                        $Value = $($CurrentOperation.Substring($LastSpaceIndex + 1, $($CurrentOperation.length - $LastSpaceIndex) - 1)).Trim()
                        
                        $SubResult.EffectiveDate = $EffectiveDate
                        
                        $SubResult.Status = $Status
                        
                        $SubResult.SubService = $SubService
                        
                        $SubResult.ExpressRoute = $ExpressRoute
                        
                        $SubResult.Protocol = $Protocol
                        
                        $SubResult.Port = $Port
                        
                        $SubResult.Value = $Value
                        
                        $DescriptionIsParsable = $true
                        
                        $SubResults.Add($SubResult) | Out-Null
                        
                        If ($DescriptionIsParsable) {
                            
                            [String]$MessageText = "Subchange {0} from RSS item {1} parsed successfully to: {2}" -f $i, $Guid, $SubResult
                            
                        }
                        Else {
                            
                            [String]$MessageText = "Subchange {0} from RSS item {1} not parsed successfully" -f $i, $Guid
                            
                        }
                        
                        Write-Verbose -Message $MessageText
                        
                        Remove-Variable -Name SubResult | Out-Null
                        
                    }
                    
                }
                
            }
            
            
            
        <#
    }
    
    Catch {
    
        $SubResult.Value = 'N/A'
    
        #Add Value to allow expand 'SubChanges' field
        $SubResults.Add($SubResult) | Out-Null
        
        $DescriptionIsParsable = $false
    
        Remove-Variable -Name SubResult | Out-Null
        
    }
    
    Finally {
        
        If ($DescriptionIsParsable) {
            
            [String]$MessageText = "All subchanges from RSS item {0} have parsed successfully." -f $Guid
            
        }
        Else {
            
            [String]$MessageText = "Subchange {0} from RSS item {1} haven't parsed successfully." -f $i, $Guid
            
        }
        
        Write-Verbose -Message $MessageText
        
    }
    
        #>
            
        }
    }
    
    
    
    End {
        
        $Result = New-Object -TypeName System.Management.Automation.PSObject
        
        $Result | Add-Member -MemberType NoteProperty -Name DescriptionIsParsable -Value $DescriptionIsParsable
        
        $Result | Add-Member -MemberType NoteProperty -Name QuickChangeDescription -Value $QuickDescription
        
        $Result | Add-Member -MemberType NoteProperty -Name OperationType -Value $QuickDescriptionPart0
        
        $Result | Add-Member -MemberType NoteProperty -Name Notes -Value $Notes
        
        $Result | Add-Member -MemberType NoteProperty -Name SubChanges -Value $SubResults
        
        Return $Result
        
    }
    
}