function Get-MailboxCalendarDelegates {
    <#
    .SYNOPSIS
    Retrieves a list of mailbox rules which forward or redirect email elsewhere.
    .DESCRIPTION
    Retrieves a list of mailbox rules which forward or redirect email elsewhere.
    .PARAMETER MailboxName
    One mailbox name in string format.
    .PARAMETER MailboxName
    Array of mailbox names in string format.    
    .PARAMETER MailboxObject
    One or more mailbox objects.
    .LINK
    http://www.the-little-things.net
    .NOTES
    Last edit   :   10/10/2014
    Version     :   1.0.0 10/10/2014
    Author      :   Zachary Loeber

    .EXAMPLE
    Get-MailboxCalendarDelegates -MailboxName "Test User1" -Verbose

    Description
    -----------
    TBD
    #>
    [CmdLetBinding(DefaultParameterSetName='AsString')]
    param(
        [Parameter(ParameterSetName='AsStringArray', Mandatory=$True, ValueFromPipeline=$True, Position=0, HelpMessage="Enter an Exchange mailbox name")]
        [string[]]$MailboxNames,
        [Parameter(ParameterSetName='AsString', Mandatory=$True, ValueFromPipeline=$True, Position=0, HelpMessage="Enter an Exchange mailbox name")]
        [string]$MailboxName,
        [Parameter(ParameterSetName='AsMailbox', Mandatory=$True, ValueFromPipeline=$True, Position=0, HelpMessage="Enter an Exchange mailbox name")]
        [Microsoft.Exchange.Data.Directory.Management.Mailbox[]]$MailboxObject
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Begin"
        $Mailboxes = @()
    }
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'AsStringArray' {
                try {
                    $Mailboxes = @($MailboxNames | Foreach {Get-Mailbox $_ -erroraction Stop})
                }
                catch {
                    Write-Warning = "$($MyInvocation.MyCommand): $_.Exception.Message"
                }
            }
            'AsString' {
                try { 
                    $Mailboxes = @(Get-Mailbox $MailboxName -erroraction Stop)
                }
                catch {
                    Write-Warning = "$($MyInvocation.MyCommand): $_.Exception.Message"
                }
            }
            'AsMailbox' {
               $Mailboxes = @($MailboxObject)
            }
        }

        Foreach ($Mailbox in $Mailboxes)
        {
            Write-Verbose "$($MyInvocation.MyCommand): Processing Mailbox $($Mailbox.Name)"
            $PossibleDelegates = @(Get-CalendarProcessing $Mailbox| Where {($_.resourcedelegates)}) 
            $PossibleDelegates | Foreach {
                $delegates = @()
                Foreach ($delegate in $_.resourcedelegates)
                {
                    $delegates += $delegate.Name
                }
                New-Object psobject -Property @{
                    'Mailbox' = $Mailbox.Name
                    'Delegates' = $delegates
                }
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): End"
    }
}