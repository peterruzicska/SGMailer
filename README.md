# SGMailer
SendGrid v3 REST API PowerShell module for sending automated emails via SendGrid.
# Usage
## Prerequisites
- SendGrid free tier environment at least.
- SendGrid API key with at least these scopes:
  - api\_keys.create
  - api\_keys.delete
  - api\_keys.read
  - api\_keys.update
  - send

## Setting up the environment, basic usage

Install-Module SGMailer

\<\<API key with API key creation privilege\>\> | New-SGToken | Install-SGToken

Send-SGMail -From john.doe@example.com -To jane.doe@example.com -Subject \"Confession\" -Body \"\<p\>\<b\>LOVE\</b\> \<i\>you!\</i\>\</p\>\"

# Exported functions

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
