#
# 2022-01-24 Spindler (1 Bier und an Schluck)
#   the "aggregate" function for the properites not in the "group by clause"
#   is a "distinct String::Join"
#
param(
    [Parameter(Mandatory)][string]$inputfile,
    [Parameter(Mandatory)][string]$outputfile
)
Get-Content      $inputfile                                                                        |
Select-Object    -Skip 1                                                                           |
Where-Object     { $_ -ne [String]::Empty }                                                        |
ForEach-Object   { ([string]$_).TrimStart("`t") }                                                  |
ConvertFrom-Csv  -Delimiter "`t"                                                                   |
Group-Object     -Property Auftrag,ArbPlatz,Verursacher,Auftragsmenge,Mengeneinheit,Vorgang        |
ForEach-Object   {
    [PSCustomObject]@{
        Auftrag          = $_.Group[0].Auftrag
        ArbPlatz         = $_.Group[0].ArbPlatz
        Verursacher      = $_.Group[0].Verursacher
        Auftragsmenge    = $_.Group[0].Auftragsmenge
        Mengeneinheit    = $_.Group[0].Mengeneinheit
        Vorgang          = $_.Group[0].Vorgang
        Materialkurztext = [String]::Join(", ", ($_.Group.Materialkurztext | Sort-Object -Unique))
        BedTerm          = [String]::Join(", ", ($_.Group.BedTerm          | Sort-Object -Unique))
    }
}                                                                                                  |
ConvertTo-Csv    -Delimiter "`t" -NoTypeInformation                                                |
Out-File         -Encoding utf8 $outputfile
