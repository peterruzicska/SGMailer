function Get-SGTokenUsageScript{
    <#
    .Synopsis
    Gets the code snippet to be pasted into scripts where emails will be sent from. Must use Install-SGToken first.

    .Description
    Gets the code snippet to be pasted into scripts where emails will be sent from. Must use Install-SGToken first.

    .Parameter CopyToClipboard
    If given, the code snippet will be copied to the clipboard.

    .Example
    Get-SGTokenUsageScript -CopyToClipboard

    #>
    param(
        [switch]$CopyToClipboard
        )
    $CodeSnippet = [Scriptblock]::Create('[SecureString]$SecureToken = [System.Environment]::GetEnvironmentVariable("SendGridToken","Machine") |ConvertTo-SecureString
$SendGridToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(($SecureToken)))')
    if($CopyToClipboard){$CodeSnippet |Set-Clipboard}
    else{return $CodeSnippet}
    }
function New-SGToken{
    <#
    .Synopsis
    Gets the SendGridToken via SendGrid REST API v3.

    .Description
    Gets the SendGridToken via SendGrid REST API v3.

    .Parameter AdminToken
    SendGrid token with at least api_keys.create, api_keys.delete, api_keys.read, api_keys.update, mail.send privilege.

    .Parameter APIKeyName
    SendGrid API key name. Give a recognizable name to the API key. Defaults to $env:COMPUTERNAME

    .Example
    New-SGToken -AdminToken "SG.CxHQIu86rtWZ9EoIyDAeXg.BS83T0fRegjl3oH076Pfc5hqx8hcK9PJePUsuqNFkEy4"

    .Example
    New-SGToken -APIKeyName "Johns PC" -AdminToken "SG.CxHQIu86rtWZ9EoIyDAeXg.BS83T0fRegjl3oH076Pfc5hqx8hcK9PJePUsuqNFkEy4"

    #>
    param(
        [Parameter(Mandatory,ValueFromPipeline)][String]$AdminToken,
        [String]$APIKeyName=$env:COMPUTERNAME
        )
    
    ## Adding REST parameters
    $Parameters=@{
        Method="POST"
        Uri="https://api.sendgrid.com/v3/api_keys"
        Headers=@{"authorization"="Bearer $AdminToken"}
        ContentType="application/json"
        Body=(@{
            "name" = $APIKeyName
            "scopes" = @("mail.send")
            }|ConvertTo-Json)
        }
    
    ## Sending REST request
    $ApiKey = (Invoke-RestMethod @Parameters).api_key
    return $ApiKey
    }
function Install-SGToken{
    <#
    .Synopsis
    Sets the SendGridToken environment variable.

    .Description
    Sets the Token parameter as encrypted to the SendGridToken environment variable.

    .Parameter Token
    SendGrid token. Should be able to have at least "send email" privilege.

    .Example

    Install-SGToken -Token "SG.CxHQIu86rtWZ9EoIyDAeXg.BS83T0fRegjl3oH076Pfc5hqx8hcK9PJePUsuqNFkEy4"

    #>
    param(
        [Parameter(Mandatory,ValueFromPipeline)][String]$Token
        )

    ##Determining active process elevation
    if(!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")){
        Write-Host "`r`n    Opening new elevated pwsh window to set environment variable machine-wide.`r`n    Press any key to continue...`r`n" -ForegroundColor Yellow
        $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") |out-null

        ##Scriptblock for converting Token to SecureString and setting as SendGridToken environment variable
        $SetENVVar = [Scriptblock]::Create("[System.Environment]::SetEnvironmentVariable('SendGridToken',([SecureString]('"+$Token+"' | ConvertTo-SecureString -AsPlainText -Force) |ConvertFrom-SecureString),'Machine')")

        ##Starting elevated process and executing the scriptblock
        Start-Process powershell.exe -Verb RunAs -ArgumentList "-command $SetENVVar"
        }
    else{
        ##Converting Token to SecureString and setting as SendGridToken environment variable
        [System.Environment]::SetEnvironmentVariable('SendGridToken',([SecureString]($Token | ConvertTo-SecureString -AsPlainText -Force) |ConvertFrom-SecureString),'Machine')
        }
    }


function Send-SGMail{
    <#
    .Synopsis
    Sends an email via SendGrid REST API v3.

    .Description
    Sends an email via SendGrid REST API v3.

    .Parameter From
    Sender email address.

    .Parameter To
    Recipient email address.

    .Parameter Subject
    Subject of the email.

    .Parameter NoHTML
    If set, email body will be sent as plaint text, not HTML.

    .Parameter SendGridToken
    Direct input of the SendGrid REST API v3 token.
    Default: use encrypted token from $env:SendGridToken (which can be installed using Install-SGToken)

    .Parameter Body
    Email body as string.

    .Example

    # Send an HTML email
    Send-SGMail -From john.doe@example.com -To jane.doe@example.com -Subject "Confession" -Body "<p><b>LOVE</b> <i>you!</i></p>"

    .Example

    # Send a plain text email
    Send-SGMail -From jane.doe@example.com -To john.doe@example.com -Subject "Re: Confession" -Body "Love you too!" -NoHTML

    #>

    param(
        [Parameter(Mandatory)][String]$From,
        [Parameter(Mandatory)][String]$To,
        [Parameter(Mandatory)][String]$Subject,
        [switch]$NoHTML,
        [string]$SendGridToken,
        [Parameter(Mandatory,ValueFromPipeline)][String]$Body
        )

    ## Setting content-type
    if(!$NoHTML){$Type="text/HTML"}else{$Type="text/plain"}

    ## Getting SendGridToken
    if(!$SendGridToken){
        if(!$env:SendGridToken){throw "SendGridToken missing. Give it directly using the -SendGridToken parameter or install it using the Install-SGToken command."}
        [SecureString]$SecureToken = [System.Environment]::GetEnvironmentVariable("SendGridToken","Machine") |ConvertTo-SecureString
        $SendGridToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(($SecureToken)))
        }

    ## Building data for JSON
    $SendGridBody = [pscustomObject]@{
        "personalizations"= @(
            @{"to"=@(@{"email"=$To})
            "subject"=$Subject})
        "content"=@(@{
            "type"=$Type
            "charset"="UTF-8"
            "value"=$Body})
        "from"= @{"email"=$From}
        }

    ## Adding REST parameters
    $Parameters=@{
        Method="POST"
        Uri="https://api.sendgrid.com/v3/mail/send"
        Headers=@{"authorization"="Bearer $SendGridToken"}
        ContentType="application/json"
        Body=($SendGridBody|ConvertTo-Json -Depth 4)
        }

    ## Sending REST request
    Invoke-RestMethod @Parameters
    }

Export-ModuleMember -Function Send-SGMail,Install-SGToken,New-SGToken,Get-SGTokenUsageScript

