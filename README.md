# SGMailer
SendGrid v3 REST API PowerShell module for sending automated emails via SendGrid.
# Usage
## Prerequisites
- SendGrid basic tier environment at least.
- SendGrid API key with at least these scopes:
  - api\_keys.create
  - api\_keys.delete
  - api\_keys.read
  - api\_keys.update
  - mail.send
## Setting up the environment
```powershell
Install-Module SGMailer
"API key with API key creation privilege" | New-SGToken | Install-SGToken
```
After Install-Token, a new PS session is needed!
## Basic usage
```powershell
Send-SGMail -From john.doe@example.com -To jane.doe@example.com -Subject "Confession" -Body "<p><b>LOVE</b> <i>you!</i></p>"
```
# Exported functions
  - [Send-SGMail](#send-sgmail)
  - [Install-SGToken](#install-sgtoken)
  - [New-SGToken](#new-sgtoken)
  - [ConvertTo-SGEncryptedToken](#convertto-sgencryptedtoken)
  - [ConvertFrom-SGEncryptedToken](#convertfrom-sgencryptedtoken)
## Send-SGMail
### NAME
Send-SGMail
### SYNOPSIS
Sends an email via SendGrid REST API v3.
### SYNTAX
Send-SGEmail [-From] \<String\> [-To] \<String\> [-Subject] \<String\> [-NoHTML] [[-SendGridToken] \<String\>] [-Body] \<String\> [\<CommonParameters\>]
### DESCRIPTION
Sends an email via SendGrid REST API v3.
### PARAMETERS
#### -From \<String\>
Sender email address.
#### -To \<String\>
Recipient email address.
#### -Subject \<String\>
Subject of the email.
#### -NoHTML [\<SwitchParameter\>]
If set, email body will be sent as plaint text, not HTML.
#### -SendGridToken \<String\>
Direct input of the SendGrid REST API v3 token.
Default: use encrypted token from $env:SendGridToken (which can be installed using Install-SGToken)
#### -Body \<String\>
Email body as string.
#### \<CommonParameters\>
This cmdlet supports the common parameters: Verbose, Debug,
 ErrorAction, ErrorVariable, WarningAction, WarningVariable,
 OutBuffer, PipelineVariable, and OutVariable. For more information, see
 about\_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).
### -------------------------- EXAMPLE 1 --------------------------
PS \> # Send an HTML email
Send-SGEmail -From john.doe@example.com -To jane.doe@example.com -Subject \"Confession\" -Body \"\<p\>\<b\>LOVE\</b\> \<i\>you!\</i\>\</p\>\"
### -------------------------- EXAMPLE 2 --------------------------
PS \> # Send a plain text email
Send-SGEmail -From jane.doe@example.com -To john.doe@example.com -Subject \"Re: Confession\" -Body \"Love you too!\" -NoHTML
## Install-SGToken
### NAME
Install-SGToken
### SYNOPSIS
Sets the SendGridToken environment variable.
### SYNTAX
Install-SGToken [-Token] \<String\> [\<CommonParameters\>]
### DESCRIPTION
Sets the Token parameter as encrypted to the SendGridToken environment variable.
### PARAMETERS
#### -Token \<String\>
SendGrid token. Should be able to have at least api\_keys.create, api\_keys.delete, api\_keys.read, api\_keys.update, mail.send privilege.
#### \<CommonParameters\>
This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable. For more information, see about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).
### -------------------------- EXAMPLE 1 --------------------------
PS \> Install-SGToken -Token \"SG.asdfASDF1234.....\"
## New-SGToken
### NAME
New-SGToken
### SYNOPSIS
Gets the SendGridToken via SendGrid REST API v3.
### SYNTAX
New-SGToken [-AdminToken] \<String\> [[-APIKeyName] \<String\>] [\<CommonParameters\>]
### DESCRIPTION
Gets the SendGridToken via SendGrid REST API v3.
### PARAMETERS
#### -AdminToken \<String\>
SendGrid token with at least api\_keys.create, api\_keys.delete, api\_keys.read, api\_keys.update, mail.send privilege.
#### -APIKeyName \<String\>
SendGrid API key name. Give a recognizable name to the API key. Defaults to $env:COMPUTERNAME
#### \<CommonParameters\>
This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable. For more information, see about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).
### -------------------------- EXAMPLE 1 --------------------------
PS > New-SGToken -AdminToken \"SG.asdfASDF1234.....\"
### -------------------------- EXAMPLE 2 --------------------------
PS > New-SGToken -APIKeyName \"Johns PC\" -AdminToken \"SG.asdfASDF1234.....\"
## ConvertTo-SGEncryptedToken
### NAME
ConvertTo-SGEncryptedToken
### SYNOPSIS
Encrypts token with machine key for later use.
### SYNTAX
ConvertTo-SGEncryptedToken [-Token] <String> [<CommonParameters>]
### DESCRIPTION
Encrypts token with machine key for later use.
### PARAMETERS
#### -Token <String>
Token to be encrypted.
#### <CommonParameters>
This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable. For more information, see about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).
### -------------------------- EXAMPLE 1 --------------------------
PS > ConvertTo-SGEncryptedToken -Token "SG.asdfASDF1234....."
## ConvertFrom-SGEncryptedToken
### NAME
ConvertFrom-SGEncryptedToken
### SYNOPSIS
Decrypts token with machine key.
### SYNTAX
ConvertFrom-SGEncryptedToken [-Token] <String> [<CommonParameters>]
### DESCRIPTION
Decrypts token with machine key.
### PARAMETERS
#### -Token <String>
Token to be decrypted.
#### <CommonParameters>
This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable. For more information, see about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).
### -------------------------- EXAMPLE 1 --------------------------
PS > ConvertFrom-SGEncryptedToken -Token "SG.asdfASDF1234....."