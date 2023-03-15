Import-Module ConfluencePS   # AtlassianPS.Configuration is imported automatically

$serverData = @{
    # BaseURL of the server
    Uri = "https://nussbaum.atlassian.net/wiki"
    # Name with which you want to address this server
    ServerName = "NussbaumPS - wiki"
    # Type of the Atlassian product
    Type = "Confluence"
}
Set-AtlassianServerConfiguration @serverData

# display all spaces
Get-ConfluenceSpace

Get-ConfluenceSpace -Server "NussbaumPS - wiki"

# Automate documentation
# uses VM info -> Name, IP, Dept, Purpose
$CSV = Import-Csv .\testList.csv
ForEach ($VM in (Get-Content .\changes.txt)) {
    $Table = $CSV | Where Name -eq $VM | ConvertTo-ConfluenceTable | Out-String
    $Body = $Table | ConvertTo-ConfluenceStorageFormat
    
    If ($ID = (Get-ConfluencePage -Title "$($VM.Name)").ID) {
        # Current page found. Overwrite body.
        Set-ConfluencePage -PageID $ID -ParentID 123456 -Body $Body
    } Else {
        # Create a page
        New-ConfluencePage -Title "$($VM.Name)" -Body $Body -ParentID 123456
    }
}
