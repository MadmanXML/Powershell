Function ConvertTo-HashArray
{
    <#
    .SYNOPSIS
    Convert an array of objects to a hash table based on a single property of the array. 
    
    .DESCRIPTION
    Convert an array of objects to a hash table based on a single property of the array.
    
    .PARAMETER InputObject
    An array of objects to convert to a hash table array.

    .PARAMETER PivotProperty
    The property to use as the key value in the resulting hash.

    .EXAMPLE
    <Placeholder>

    Description
    -----------
    <Placeholder>
    
    .NOTES

    #> 
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        [PSObject[]]
        $InputObject,
        
        [Parameter(Mandatory=$true)]
        [string]$PivotProperty
    )

    BEGIN
    {
        #init array to dump all objects into
        $allObjects = @()
        $Results = @{}
    }
    PROCESS
    {
        #if we're taking from pipeline and get more than one object, this will build up an array
        $allObjects += $inputObject
    }

    END
    {
        ForEach ($object in $allObjects)
        {
            if ($object[0].PSObject.Properties.Match($PivotProperty).Count) 
            {
                $Results[$object.$PivotProperty] = $object
            }
        }
        $Results
    }
}