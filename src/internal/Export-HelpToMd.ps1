function Export-HelpToMd {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [PSCustomObject]
        $HelpInfo
    )

    begin {
        function GetText {
            param ([string]$text, [string]$default)

            $text = $text.Trim()
            if ([string]::IsNullOrEmpty($text)) {
                if ([string]::IsNullOrEmpty($default)) {
                    $default = 'No description'
                }
                return $default
            }
            return $text
        }

        function GetName ([PSCustomObject]$help) {
            $lines = @()
            $lines += '# {0}' -f $help.Name
            $lines += [System.Environment]::NewLine
            return $lines
        }

        function GetDescription {
            param ($description, [string]$noDesc)

            $description = $description.Description.Text | Out-String
            $line = '{0}' -f (GetText $description $noDesc)

            return $line
        }

        function GetParameterSet ([PSCustomObject]$help) {
            $lines = @()
            $setNum = 1

            $lines += '## Parameters'

            foreach ($set in $help.syntax.syntaxItem) {
                $lines += [System.Environment]::NewLine
                $lines += '### Parameter Set {0}' -f $setNum
                $lines += [System.Environment]::NewLine

                foreach ($param in $set.Parameter) {
                    $paramStringParts = @()

                    $paramStringParts += '- `[{0}]`' -f (GetText $param.parameterValue 'switch')

                    $paramStringParts += '**{0}**' -f $param.Name

                    $paramStringParts += '_{0}_. ' -f (GetDescription -description $param -noDesc 'Parameter help description')

                    $attributes = @()
                    if ($param.required -eq 'true') { $attributes += 'Mandatory' }
                    if ($param.pipelineInput -like '*ByValue*') { $attributes += 'ValueFromPipeline' }

                    $paramStringParts += $attributes -join ', '

                    $lines += $paramStringParts -join ' '
                }

                $setNum++
            }

            return $lines
        }

        function GetExample ([PSCustomObject]$help) {
            $lines = @()
            $exNum = 1

            $lines += [System.Environment]::NewLine
            $lines += '## Examples'

            foreach ($exampleList in $help.examples.example) {
                foreach ($example in $exampleList) {
                    $lines += [System.Environment]::NewLine
                    $lines += '### Example {0}' -f $exNum
                    $lines += [System.Environment]::NewLine

                    $lines += $example.remarks.Text.Where({ ![string]::IsNullOrEmpty($_) })
                    $lines += [System.Environment]::NewLine

                    $lines += '```powershell'
                    $lines += $example.code.Trim("`t")
                    $lines += '```'

                }
                $exNum++
            }

            return $lines
        }

        function GetLink ([PSCustomObject]$help, $Commands) {
            if ($help.relatedLinks.count -gt 0) {
                $lines = @()

                $lines += [System.Environment]::NewLine
                $lines += '## Links'
                $lines += [System.Environment]::NewLine

                foreach ($link in $help.relatedLinks) {

                    foreach ($text in $link.navigationLink.linkText) {

                        if ($text -match '\w{3,}-\w{3,}') {
                            $uri = $text
                            $lines += '- [{0}]({0}.md)' -f $uri
                        }

                    }
                    foreach ($uri in $link.navigationLink.uri) {
                        if (![string]::IsNullOrEmpty($uri)) {
                            $lines += '- [{0}]({0})' -f $uri
                        }
                    }
                }

                return $lines
            }
        }
    }

    process {

        GetName $HelpInfo
        GetDescription $HelpInfo $HelpInfo.Synopsis
        GetParameterSet $HelpInfo
        GetExample $HelpInfo
        GetLink $HelpInfo
    }

    end {

    }
}
