function Edit-FalconSensorUpdatePolicy {
<#
.Synopsis
Modify Sensor Update policies
.Parameter Array
An array of Sensor Update policies to modify in a single request
.Parameter Id
Sensor Update policy identifier
.Parameter Name
Sensor Update policy name
.Parameter Settings
Hashtable of Sensor Update policy settings
.Parameter Description
Sensor Update policy description
.Role
sensor-update-policies:write
.Example
PS>Edit-FalconSensorUpdatePolicy -Id <id> -Settings @{ uninstall_protection = 'DISABLED' }

Modify Sensor Update policy <id> to disable 'uninstall_protection'.
#>
    [CmdletBinding(DefaultParameterSetName = '/policy/entities/sensor-update/v2:patch')]
    param(
        [Parameter(ParameterSetName = 'array', Mandatory = $true, Position = 1)]
        [ValidateScript({
            foreach ($Object in $_) {
                Confirm-Object -Object $Object -Required 'id'
            }
        })]
        [array] $Array,

        [Parameter(ParameterSetName = '/policy/entities/sensor-update/v2:patch', Mandatory = $true,
            ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidatePattern('^\w{32}$')]
        [string] $Id,

        [Parameter(ParameterSetName = '/policy/entities/sensor-update/v2:patch', Position = 2)]
        [string] $Name,

        [Parameter(ParameterSetName = '/policy/entities/sensor-update/v2:patch', Position = 3)]
        [object] $Settings,

        [Parameter(ParameterSetName = '/policy/entities/sensor-update/v2:patch', Position = 4)]
        [string] $Description
    )
    begin {
        $Fields = @{
            Array = 'resources'
        }
        $Param = @{
            Command  = $MyInvocation.MyCommand.Name
            Endpoint = '/policy/entities/sensor-update/v2:patch'
            Inputs   = Update-FieldName -Fields $Fields -Inputs $PSBoundParameters
            Format   = @{
                Body = @{
                    resources = @('name', 'id', 'description', 'settings')
                    root      = @('resources')
                }
            }
        }
    }
    process {
        Invoke-Falcon @Param
    }
}
function Get-FalconBuild {
<#
.Synopsis
Retrieve Falcon Sensor builds for assignment in Sensor Update Policies
.Parameter Platform
Operating System platform
.Role
sensor-update-policies:read
.Example
PS>Get-FalconBuild -Platform 'windows'

Return the available Falcon Sensor build values for Windows, which can be used for setting 'build' values in a
Sensor Update policy.
#>
    [CmdletBinding(DefaultParameterSetName = '/policy/combined/sensor-update-builds/v1:get')]
    param(
        [Parameter(ParameterSetName = '/policy/combined/sensor-update-builds/v1:get')]
        [ValidateSet('linux', 'mac', 'windows')]
        [string] $Platform
    )
    begin {
        $Param = @{
            Command  = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Inputs   = $PSBoundParameters
            Format   = @{
                Query = @('platform')
            }
        }
    }
    process {
        Invoke-Falcon @Param
    }
}
function Get-FalconSensorUpdatePolicy {
<#
.Synopsis
Search for Sensor Update policies
.Parameter Ids
Sensor Update policy identifier(s)
.Parameter Filter
Falcon Query Language expression to limit results
.Parameter Sort
Property and direction to sort results
.Parameter Limit
Maximum number of results per request
.Parameter Offset
Position to begin retrieving results
.Parameter Detailed
Retrieve detailed information
.Parameter All
Repeat requests until all available results are retrieved
.Parameter Total
Display total result count instead of results
.Role
sensor-update-policies:read
.Example
PS>Get-FalconSensorUpdatePolicy -Filter "name:!'platform_default'" -Detailed -All

Return detailed information about all Sensor Update policies not named 'platform_default'.
.Example
PS>Get-FalconSensorUpdatePolicy -Ids <id>, <id>

Return detailed information about Sensor Update policies <id> and <id>.
#>
    [CmdletBinding(DefaultParameterSetName = '/policy/queries/sensor-update/v1:get')]
    param(
        [Parameter(ParameterSetName = '/policy/entities/sensor-update/v2:get', Mandatory = $true, Position = 1)]
        [ValidatePattern('^\w{32}$')]
        [array] $Ids,

        [Parameter(ParameterSetName = '/policy/combined/sensor-update/v2:get', Position = 1)]
        [Parameter(ParameterSetName = '/policy/queries/sensor-update/v1:get', Position = 1)]
        [string] $Filter,

        [Parameter(ParameterSetName = '/policy/combined/sensor-update/v2:get', Position = 2)]
        [Parameter(ParameterSetName = '/policy/queries/sensor-update/v1:get', Position = 2)]
        [ValidateSet('created_by.asc', 'created_by.desc', 'created_timestamp.asc', 'created_timestamp.desc',
            'enabled.asc', 'enabled.desc', 'modified_by.asc', 'modified_by.desc', 'modified_timestamp.asc',
            'modified_timestamp.desc', 'name.asc', 'name.desc', 'platform_name.asc', 'platform_name.desc',
            'precedence.asc', 'precedence.desc')]
        [string] $Sort,

        [Parameter(ParameterSetName = '/policy/combined/sensor-update/v2:get', Position = 3)]
        [Parameter(ParameterSetName = '/policy/queries/sensor-update/v1:get', Position = 3)]
        [ValidateRange(1, 5000)]
        [int] $Limit,

        [Parameter(ParameterSetName = '/policy/combined/sensor-update/v2:get', Position = 4)]
        [Parameter(ParameterSetName = '/policy/queries/sensor-update/v1:get', Position = 4)]
        [int] $Offset,

        [Parameter(ParameterSetName = '/policy/combined/sensor-update/v2:get', Mandatory = $true)]
        [switch] $Detailed,

        [Parameter(ParameterSetName = '/policy/combined/sensor-update/v2:get')]
        [Parameter(ParameterSetName = '/policy/queries/sensor-update/v1:get')]
        [switch] $All,

        [Parameter(ParameterSetName = '/policy/queries/sensor-update/v1:get')]
        [switch] $Total
    )
    begin {
        $Param = @{
            Command  = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Inputs   = $PSBoundParameters
            Format   = @{
                Query = @('sort', 'ids', 'offset', 'filter', 'limit')
            }
        }
    }
    process {
        Invoke-Falcon @Param
    }
}
function Get-FalconSensorUpdatePolicyMember {
<#
.Synopsis
Search for members of Sensor Update policies
.Parameter Id
Sensor Update policy identifier
.Parameter Filter
Falcon Query Language expression to limit results
.Parameter Sort
Property and direction to sort results
.Parameter Limit
Maximum number of results per request
.Parameter Offset
Position to begin retrieving results
.Parameter Detailed
Retrieve detailed information
.Parameter All
Repeat requests until all available results are retrieved
.Parameter Total
Display total result count instead of results
.Role
sensor-update-policies:read
.Example
PS>Get-FalconSensorUpdatePolicyMember -Id <id> -All

Return all identifiers for hosts in the Sensor Update policy <id>.
#>
    [CmdletBinding(DefaultParameterSetName = '/policy/queries/sensor-update-members/v1:get')]
    param(
        [Parameter(ParameterSetName = '/policy/queries/sensor-update-members/v1:get',
            ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true, Position = 1)]
        [Parameter(ParameterSetName = '/policy/combined/sensor-update-members/v1:get',
            ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidatePattern('^\w{32}$')]
        [string] $Id,

        [Parameter(ParameterSetName = '/policy/queries/sensor-update-members/v1:get', Position = 2)]
        [Parameter(ParameterSetName = '/policy/combined/sensor-update-members/v1:get', Position = 2)]
        [string] $Filter,

        [Parameter(ParameterSetName = '/policy/queries/sensor-update-members/v1:get', Position = 3)]
        [Parameter(ParameterSetName = '/policy/combined/sensor-update-members/v1:get', Position = 3)]
        [string] $Sort,

        [Parameter(ParameterSetName = '/policy/queries/sensor-update-members/v1:get', Position = 4)]
        [Parameter(ParameterSetName = '/policy/combined/sensor-update-members/v1:get', Position = 4)]
        [ValidateRange(1, 5000)]
        [int] $Limit,

        [Parameter(ParameterSetName = '/policy/queries/sensor-update-members/v1:get', Position = 5)]
        [Parameter(ParameterSetName = '/policy/combined/sensor-update-members/v1:get', Position = 5)]
        [int] $Offset,

        [Parameter(ParameterSetName = '/policy/combined/sensor-update-members/v1:get', Mandatory = $true)]
        [switch] $Detailed,

        [Parameter(ParameterSetName = '/policy/combined/sensor-update-members/v1:get')]
        [Parameter(ParameterSetName = '/policy/queries/sensor-update-members/v1:get')]
        [switch] $All,

        [Parameter(ParameterSetName = '/policy/queries/sensor-update-members/v1:get')]
        [switch] $Total
    )
    begin {
        $Param = @{
            Command  = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Inputs   = $PSBoundParameters
            Format   = @{
                Query = @('sort', 'offset', 'filter', 'id', 'limit')
            }
        }
    }
    process {
        Invoke-Falcon @Param
    }
}
function Get-FalconUninstallToken {
<#
.Synopsis
Retrieve an uninstallation or maintenance token
.Parameter DeviceId
Host identifier
.Parameter AuditMessage
Audit log comment
.Role
sensor-update-policies:write
.Example
PS>Get-FalconUninstallToken -DeviceId <id>

Return the uninstallation token for host <id>.
.Example
PS>Get-FalconUninstallToken -DeviceId MAINTENANCE

Return the maintenance token that applies to any host within a given policy.
#>
    [CmdletBinding(DefaultParameterSetName = '/policy/combined/reveal-uninstall-token/v1:post')]
    param(
        [Parameter(ParameterSetName = '/policy/combined/reveal-uninstall-token/v1:post', Mandatory = $true,
            Position = 1)]
        [ValidatePattern('^(\w{32}|MAINTENANCE)$')]
        [string] $DeviceId,

        [Parameter(ParameterSetName = '/policy/combined/reveal-uninstall-token/v1:post', Position = 2)]
        [string] $AuditMessage
    )
    begin {
        $Fields = @{
            DeviceId     = 'device_id'
            AuditMessage = 'audit_message'
        }
        $Param = @{
            Command  = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Inputs   = Update-FieldName -Fields $Fields -Inputs $PSBoundParameters
            Format   = @{
                Body = @{
                    root = @('audit_message', 'device_id')
                }
            }
        }
    }
    process {
        Invoke-Falcon @Param
    }
}
function Invoke-FalconSensorUpdatePolicyAction {
<#
.Synopsis
Perform actions on Sensor Update policies
.Parameter Name
Action to perform
.Parameter Id
Sensor Update policy identifier
.Parameter GroupId
Host group identifier
.Role
sensor-update-policies:write
.Example
PS>Invoke-FalconSensorUpdatePolicyAction -Name add-host-group -Id <policy_id> -GroupId <group_id>

Add the Host Group <group_id> to Sensor Update policy <policy_id>.
.Example
PS>Invoke-FalconSensorUpdatePolicyAction -Name enable -Id <policy_id>

Enable Sensor Update policy <policy_id>.
#>
    [CmdletBinding(DefaultParameterSetName = '/policy/entities/sensor-update-actions/v1:post')]
    param(
        [Parameter(ParameterSetName = '/policy/entities/sensor-update-actions/v1:post', Mandatory = $true,
            Position = 1)]
        [ValidateSet('add-host-group', 'disable', 'enable', 'remove-host-group')]
        [string] $Name,

        [Parameter(ParameterSetName = '/policy/entities/sensor-update-actions/v1:post', Mandatory = $true,
            ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true, Position = 2)]
        [ValidatePattern('^\w{32}$')]
        [string] $Id,

        [Parameter(ParameterSetName = '/policy/entities/sensor-update-actions/v1:post', Position = 3)]
        [ValidatePattern('^\w{32}$')]
        [string] $GroupId
    )
    begin {
        $Fields = @{
            name = 'action_name'
        }
        $PSBoundParameters.Add('Ids', @( $PSBoundParameters.Id ))
        [void] $PSBoundParameters.Remove('Id')
        if ($PSBoundParameters.GroupId) {
            $PSBoundParameters.Add('action_parameters', @(
                @{
                    name  = 'group_id'
                    value = $PSBoundParameters.GroupId
                }
            ))
            [void] $PSBoundParameters.Remove('GroupId')
        }
        $Param = @{
            Command  = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Inputs   = Update-FieldName -Fields $Fields -Inputs $PSBoundParameters
            Format   = @{
                Query = @('action_name')
                Body  = @{
                    root = @('ids', 'action_parameters')
                }
            }
        }
    }
    process {
        Invoke-Falcon @Param
    }
}
function New-FalconSensorUpdatePolicy {
<#
.Synopsis
Create Sensor Update policies
.Parameter Array
An array of Sensor Update policies to create in a single request
.Parameter PlatformName
Operating System platform
.Parameter Name
Sensor Update policy name
.Parameter Settings
Hashtable of Sensor Update policy settings
.Parameter Description
Sensor Update policy description
.Role
sensor-update-policies:write
.Example
PS>$Settings = @{ build = <id>; uninstall_protection = 'ENABLED' }
PS>New-FalconSensorUpdatePolicy -PlatformName Windows -Name Example -Settings $Settings

Create Sensor Update policy 'Example' for Windows hosts, with the build version <id> and 'uninstall_protection'
enabled. 'Get-FalconBuild' can be used to find 'build' values.
#>
    [CmdletBinding(DefaultParameterSetName = '/policy/entities/sensor-update/v2:post')]
    param(
        [Parameter(ParameterSetName = 'array', Mandatory = $true, Position = 1)]
        [ValidateScript({
            foreach ($Item in $_) {
                foreach ($Property in @('platform_name', 'name')) {
                    if ($Item.PSObject.Properties.Name -contains $Property) {
                        $true
                    } else {
                        throw "'$Property' is required for each policy."
                    }
                }
            }
        })]
        [array] $Array,

        [Parameter(ParameterSetName = '/policy/entities/sensor-update/v2:post', Mandatory = $true, Position = 1)]
        [ValidateSet('Windows', 'Mac', 'Linux')]
        [string] $PlatformName,

        [Parameter(ParameterSetName = '/policy/entities/sensor-update/v2:post', Mandatory = $true, Position = 2)]
        [string] $Name,

        [Parameter(ParameterSetName = '/policy/entities/sensor-update/v2:post', Position = 3)]
        [object] $Settings,

        [Parameter(ParameterSetName = '/policy/entities/sensor-update/v2:post', Position = 4)]
        [string] $Description
    )
    begin {
        $Fields = @{
            Array        = 'resources'
            PlatformName = 'platform_name'
        }
        $Param = @{
            Command  = $MyInvocation.MyCommand.Name
            Endpoint = '/policy/entities/sensor-update/v2:post'
            Inputs   = Update-FieldName -Fields $Fields -Inputs $PSBoundParameters
            Format   = @{
                Body = @{
                    resources = @('description', 'platform_name', 'name', 'settings')
                    root =      @('resources')
                }
            }
        }
    }
    process {
        Invoke-Falcon @Param
    }
}
function Remove-FalconSensorUpdatePolicy {
<#
.Synopsis
Delete Sensor Update policies
.Parameter Ids
Sensor Update policy identifier(s)
.Role
sensor-update-policies:write
.Example
PS>Remove-FalconSensorUpdatePolicy -Ids <id>, <id>

Delete Sensor Update policies <id> and <id>.
#>
    [CmdletBinding(DefaultParameterSetName = '/policy/entities/sensor-update/v1:delete')]
    param(
        [Parameter(ParameterSetName = '/policy/entities/sensor-update/v1:delete', Mandatory = $true, Position = 1)]
        [ValidatePattern('^\w{32}$')]
        [array] $Ids
    )
    begin {
        $Param = @{
            Command  = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Inputs   = $PSBoundParameters
            Format   = @{
                Query = @('ids')
            }
        }
    }
    process {
        Invoke-Falcon @Param
    }
}
function Set-FalconSensorUpdatePrecedence {
<#
.Synopsis
Set Sensor Update policy precedence
.Description
All Sensor Update policy identifiers must be supplied in order (with the exception of the 'platform_default'
policy) to define policy precedence.
.Parameter PlatformName
Operating System platform
.Parameter Ids
All Sensor Update policy identifiers in desired precedence order
.Role
sensor-update-policies:write
.Example
PS>Set-FalconSensorUpdatePrecedence -PlatformName Windows -Ids <id_1>, <id_2>, <id_3>

Set the Sensor Update policy precedence for 'Windows' policies in order <id_1>, <id_2>, <id_3>. All policy
identifiers must be supplied.
#>
    [CmdletBinding(DefaultParameterSetName = '/policy/entities/sensor-update-precedence/v1:post')]
    param(
        [Parameter(ParameterSetName = '/policy/entities/sensor-update-precedence/v1:post', Mandatory = $true,
            Position = 1)]
        [ValidateSet('Windows', 'Mac', 'Linux')]
        [string] $PlatformName,

        [Parameter(ParameterSetName = '/policy/entities/sensor-update-precedence/v1:post', Mandatory = $true,
            Position = 2)]
        [ValidatePattern('^\w{32}$')]
        [array] $Ids
    )
    begin {
        $Fields = @{
            PlatformName = 'platform_name'
        }
        $Param = @{
            Command  = $MyInvocation.MyCommand.Name
            Endpoint = $PSCmdlet.ParameterSetName
            Inputs   = Update-FieldName -Fields $Fields -Inputs $PSBoundParameters
            Format   = @{
                Body = @{
                    root = @('platform_name', 'ids')
                }
            }
        }
    }
    process {
        Invoke-Falcon @Param
    }
}