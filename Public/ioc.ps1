function Edit-FalconIoc {
<#
.Synopsis
Update custom indicators
.Parameter Id
Custom indicator identifier
.Parameter Action
Action to take when a host observes the custom indicator
.Parameter Platforms
Platform that the custom indicator applies to
.Parameter Source
The source where this custom indicator originated
.Parameter Severity
Severity level to apply to the custom indicator
.Parameter Description
Descriptive label for the custom indicator
.Parameter Filename
A common filename, or a filename in your environment (applies to hashes only)
.Parameter Tags
List of tags to apply to the custom indicator
.Parameter HostGroups
One or more Host Group identifiers to assign the custom indicator
.Parameter AppliedGlobally
Globally assign the custom indicator instead of assigning to specific Host Groups
.Parameter Expiration
The date on which the custom indicator will become inactive. When an indicator expires, its action is set
to 'no_action' but it remains in your list of custom indicators.
.Parameter Comment
Audit log comment
.Parameter RetroDetects
Generate retroactive detections for hosts that have observed the custom indicator
.Parameter IgnoreWarnings
Ignore warnings and modify all custom indicators
.Role
ioc:write
.Example
PS>Edit-FalconIoc -Id <id> -Action prevent -Severity high

Change custom indicator <id> and set 'action' to 'prevent' and 'severity' to 'high'.
#>
    [CmdletBinding(DefaultParameterSetName = '/iocs/entities/indicators/v1:patch')]
    param(
        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Mandatory = $true,
            ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidatePattern('^\w{64}$')]
        [string] $Id,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Position = 2)]
        [ValidateSet('no_action', 'allow', 'prevent_no_ui', 'detect', 'prevent')]
        [string] $Action,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Position = 3)]
        [ValidateSet('linux', 'mac', 'windows')]
        [array] $Platforms,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Position = 4)]
        [ValidateRange(1,256)]
        [string] $Source,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Position = 5)]
        [ValidateSet('informational', 'low', 'medium', 'high', 'critical')]
        [string] $Severity,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Position = 6)]
        [string] $Description,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Position = 7)]
        [string] $Filename,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Position = 8)]
        [array] $Tags,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Position = 9)]
        [ValidatePattern('^\w{32}$')]
        [array] $HostGroups,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Position = 10)]
        [boolean] $AppliedGlobally,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Position = 11)]
        [ValidatePattern('^(\d{4}-\d{2}-\d{2}|\d{4}-\d{2}-\d{2}T\d{2}:\d{2}\d{2}Z)$')]
        [string] $Expiration,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Position = 12)]
        [string] $Comment,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Position = 13)]
        [boolean] $Retrodetects,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:patch', Position = 14)]
        [boolean] $IgnoreWarnings
    )
    begin {
        $Fields = @{
            AppliedGlobally = 'applied_globally'
            Filename        = 'metadata.filename'
            HostGroups      = 'host_groups'
            IgnoreWarnings  = 'ignore_warnings'
        }
        $Param = @{
            Command  = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Inputs   = Update-FieldName -Fields $Fields -Inputs $PSBoundParameters
            Format   = @{
                Query = @('retrodetects', 'ignore_warnings')
                Body  = @{
                    root       = @('comment')
                    indicators = @('id', 'tags', 'applied_globally', 'expiration', 'description',
                        'metadata.filename', 'source', 'host_groups', 'severity', 'action', 'platforms')
                }
            }
        }
    }
    process {
        if (!$PSBoundParameters.HostGroups -and !$PSBoundParameters.AppliedGlobally) {
            throw "'HostGroups' or 'AppliedGlobally' must be provided."
        }
        Invoke-Falcon @Param
    }
}
function Get-FalconIoc {
<#
.Synopsis
Search for custom indicators
.Parameter Ids
One or more custom indicator identifiers
.Parameter Filter
Falcon Query Language expression to limit results
.Parameter Sort
Property and direction to sort results
.Parameter Limit
Maximum number of results per request
.Parameter Offset
Position to begin retrieving results
.Parameter After
Pagination token to retrieve the next set of results
.Parameter Detailed
Retrieve detailed information
.Parameter All
Repeat requests until all available results are retrieved
.Parameter Total
Display total result count instead of results
.Role
ioc:read
.Example
PS>Get-FalconIoc -Filter "type:'sha256'"

List the first set of identifiers for 'sha256' custom indicators.
.Example
PS>Get-FalconIoc -Filter "type:'domain'+value:'example.com'" -Detailed

List detailed information about the 'domain' custom indicator with the value 'example.com'.
#>
    [CmdletBinding(DefaultParameterSetName = '/iocs/queries/indicators/v1:get')]
    param(
        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:get', Mandatory = $true, Position = 1)]
        [ValidatePattern('^\w{64}$')]
        [array] $Ids,

        [Parameter(ParameterSetName = '/iocs/queries/indicators/v1:get', Position = 1)]
        [Parameter(ParameterSetName = '/iocs/combined/indicator/v1:get', Position = 1)]
        [string] $Filter,

        [Parameter(ParameterSetName = '/iocs/queries/indicators/v1:get', Position = 2)]
        [Parameter(ParameterSetName = '/iocs/combined/indicator/v1:get', Position = 2)]
        [ValidateSet('action', 'applied_globally', 'metadata.av_hits', 'metadata.company_name.raw', 'created_by',
            'created_on', 'expiration', 'expired', 'metadata.filename.raw', 'modified_by', 'modified_on',
            'metadata.original_filename.raw', 'metadata.product_name.raw', 'metadata.product_version',
            'severity_number', 'source', 'type', 'value')]
        [string] $Sort,

        [Parameter(ParameterSetName = '/iocs/queries/indicators/v1:get', Position = 3)]
        [Parameter(ParameterSetName = '/iocs/combined/indicator/v1:get', Position = 3)]
        [ValidateRange(1,2000)]
        [int] $Limit,

        [Parameter(ParameterSetName = '/iocs/queries/indicators/v1:get', Position = 4)]
        [Parameter(ParameterSetName = '/iocs/combined/indicator/v1:get', Position = 4)]
        [int] $Offset,

        [Parameter(ParameterSetName = '/iocs/queries/indicators/v1:get', Position = 5)]
        [Parameter(ParameterSetName = '/iocs/combined/indicator/v1:get', Position = 5)]
        [string] $After,

        [Parameter(ParameterSetName = '/iocs/combined/indicator/v1:get', Mandatory = $true)]
        [switch] $Detailed,

        [Parameter(ParameterSetName = '/iocs/queries/indicators/v1:get')]
        [Parameter(ParameterSetName = '/iocs/combined/indicator/v1:get')]
        [switch] $All,

        [Parameter(ParameterSetName = '/iocs/queries/indicators/v1:get')]
        [switch] $Total
    )
    begin {
        $Param = @{
            Command  = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Inputs   = $PSBoundParameters
            Format   = @{
                Query = @('ids', 'filter', 'offset', 'limit', 'sort', 'after')
            }
        }
    }
    process {
        Invoke-Falcon @Param
    }
}
function New-FalconIoc {
<#
.Synopsis
Create custom indicators
.Parameter Array
An array of custom indicators to create in a single request
.Parameter Type
Custom indicator type
.Parameter Value
String representation of the custom indicator
.Parameter Action
Action to take when a host observes the custom indicator
.Parameter Platforms
Platform that the custom indicator applies to
.Parameter Source
The source where this custom indicator originated
.Parameter Severity
Severity level to apply to the custom indicator
.Parameter Description
Descriptive label for the custom indicator
.Parameter Filename
A common filename, or a filename in your environment (applies to hashes only)
.Parameter Tags
List of tags to apply to the custom indicator
.Parameter HostGroups
One or more Host Group identifiers to assign the custom indicator
.Parameter AppliedGlobally
Globally assign the custom indicator instead of assigning to specific Host Groups
.Parameter Expiration
The date on which the custom indicator will become inactive. When an indicator expires, its action is set
to 'no_action' but it remains in your list of custom indicators.
.Parameter Comment
Audit log comment
.Parameter RetroDetects
Generate retroactive detections for hosts that have observed the custom indicator
.Parameter IgnoreWarnings
Ignore warnings and create all custom indicators
.Role
ioc:write
.Example
PS>$IOCs = @(@{ type = 'domain'; value = 'example.com'; platforms = @('windows'); action = 'detect';
    severity = 'low'; applied_globally = $true}, @{ type = 'ipv4'; value = '93.184.216.34'; platforms = @(
    'windows','mac','linux'); action = 'detect'; severity = 'low'; host_groups = @('<id>', '<id>')})
PS>New-FalconIoc -Array $IOCs

Create a 'domain' and 'ipv4' custom indicator for 'example.com' and its related IP address in a single request.
.Example
PS>New-FalconIoc -Type domain -Value example.com -Platforms windows -Action detect -Severity low
    -AppliedGlobally $true

Create the 'domain' custom indicator for 'example.com' and set it to generate detections of 'low' severity
for all Windows hosts.
#>
    [CmdletBinding(DefaultParameterSetName = '/iocs/entities/indicators/v1:post')]
    param(
        [Parameter(ParameterSetName = 'array', Mandatory = $true, Position = 1)]
        [ValidateScript({
            $Patterns = @{
                expiration  = '^(\d{4}-\d{2}-\d{2}|\d{4}-\d{2}-\d{2}T\d{2}:\d{2}\d{2}Z)$'
                host_groups = '^\w{32}$'
            }
            foreach ($Object in $_) {
                Confirm-Object -Object $Object -Required @('type', 'value', 'action', 'platforms')
                $Param = @{
                    Object    = $Object
                    Command   = 'New-FalconIoc'
                    Endpoint  = '/iocs/entities/indicators/v1:post'
                    Parameter = @('action', 'platforms', 'severity', 'type')
                }
                Confirm-Value @Param
                foreach ($Pair in $Patterns.GetEnumerator()) {
                    if ($Object.($Pair.Key) -and ($Object.($Pair.Key) -notmatch $Pair.Value)) {
                        $ObjectString = ConvertTo-Json -InputObject $Object -Compress
                        throw "'$($Object.($Pair.Key))' is not a valid '$($Pair.Key)' value. $ObjectString"
                    }
                } # TODO: Create 'Confirm-Pattern' function for 'ValidatePattern'
            }
        })]
        [array] $Array,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Mandatory = $true, Position = 1)]
        [ValidateSet('domain', 'ipv4', 'ipv6', 'md5', 'sha256')]
        [string] $Type,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Mandatory = $true, Position = 2)]
        [string] $Value,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Mandatory = $true, Position = 3)]
        [ValidateSet('no_action', 'allow', 'prevent_no_ui', 'detect', 'prevent')]
        [string] $Action,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Mandatory = $true, Position = 4)]
        [ValidateSet('linux', 'mac', 'windows')]
        [array] $Platforms,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Position = 5)]
        [ValidateRange(1,256)]
        [string] $Source,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Position = 6)]
        [ValidateSet('informational', 'low', 'medium', 'high', 'critical')]
        [string] $Severity,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Position = 7)]
        [string] $Description,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Position = 8)]
        [string] $Filename,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Position = 9)]
        [array] $Tags,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Position = 10)]
        [ValidatePattern('^\w{32}$')]
        [array] $HostGroups,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Position = 11)]
        [boolean] $AppliedGlobally,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Position = 12)]
        [ValidatePattern('^(\d{4}-\d{2}-\d{2}|\d{4}-\d{2}-\d{2}T\d{2}:\d{2}\d{2}Z)$')]
        [string] $Expiration,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Position = 13)]
        [Parameter(ParameterSetName = 'array', Position = 2)]
        [string] $Comment,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Position = 14)]
        [Parameter(ParameterSetName = 'array', Position = 3)]
        [boolean] $Retrodetects,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:post', Position = 15)]
        [Parameter(ParameterSetName = 'array', Position = 4)]
        [boolean] $IgnoreWarnings
    )
    begin {
        $Fields = @{
            AppliedGlobally = 'applied_globally'
            Array           = 'indicators'
            Filename        = 'metadata.filename'
            HostGroups      = 'host_groups'
            IgnoreWarnings  = 'ignore_warnings'
        }
        $Param = @{
            Command  = $MyInvocation.MyCommand.Name
            Endpoint = '/iocs/entities/indicators/v1:post'
            Inputs   = Update-FieldName -Fields $Fields -Inputs $PSBoundParameters
            Format   = @{
                Query = @('retrodetects', 'ignore_warnings')
                Body  = @{
                    root       = @('comment', 'indicators')
                    indicators = @('tags', 'applied_globally', 'expiration', 'description', 'value',
                        'metadata.filename', 'type', 'source', 'host_groups', 'severity', 'action', 'platforms')
                }
            }
        }
    }
    process {
        Invoke-Falcon @Param
    }
}
function Remove-FalconIoc {
<#
.Synopsis
Remove custom indicators
.Parameter Ids
One or more custom indicator identifiers
.Parameter Filter
Falcon Query Language expression to find custom indicators for removal (takes precedence over 'Ids')
.Parameter Comment
Audit log comment
.Role
ioc:write
.Example
PS>Remove-FalconIoc -Ids <id>, <id>

Delete custom indicators <id> and <id>.
.Example
PS>Remove-FalconIoc -Filter "type:'domain'+value:'example.com'"

Delete custom indicators matching 'type: domain' and 'value: example.com'.
#>
    [CmdletBinding(DefaultParameterSetName = '/iocs/entities/indicators/v1:delete')]
    param(
        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:delete', Position = 1)]
        [ValidatePattern('^\w{64}$')]
        [array] $Ids,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:delete', Position = 2)]
        [string] $Filter,

        [Parameter(ParameterSetName = '/iocs/entities/indicators/v1:delete', Position = 3)]
        [string] $Comment
    )
    begin {
        $Param = @{
            Command  = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Inputs   = $PSBoundParameters
            Format    = @{
                Query = @('ids', 'filter', 'comment')
            }
        }
    }
    process {
        if ($PSBoundParameters.Filter -or $PSBoundParameters.Ids) {
            Invoke-Falcon @Param
        } else {
            throw "'Filter' or 'Ids' must be provided."
        }
    }
}