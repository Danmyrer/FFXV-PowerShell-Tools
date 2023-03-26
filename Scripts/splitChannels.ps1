$files = Get-Location

$fileEnding = "_`$h.tga"
$splitChar = "_"
$albedoName = "ba"
$mmName = "mm"

$removeOriginal = $false

if ($null -eq (Get-Command "magick.exe" -ErrorAction SilentlyContinue))
{
    Write-Error "Magick can not be found. You can get it here: https://imagemagick.org"
    return
}

Get-ChildItem $files -Filter *.tga |
    ForEach-Object {
        if ($_.FullName.EndsWith($fileEnding) -and $_.Name -ne $fileEnding) {
            $tempName = $_.FullName.Substring(0, $_.FullName.Length - $fileEnding.Length)
            $lastIndexOfTemp = $tempName.LastIndexOf($splitChar)
            $texture = $tempName.Substring(0, $lastIndexOfTemp), $tempName.Substring($lastIndexOfTemp + 1, $tempName.Length - $lastIndexOfTemp - 1)

            if ($texture[1].Length -eq 1 -or $texture[1] -eq $albedoName -or $texture[1] -eq $mmName) {
                return # unique to Powershell: since we are using a ForEach-Object instead of a for-loop, 'return' has the same functionality as 'continue'
            }

            $tempFullName = $_.FullName
            Write-Output "Processing: $tempFullName"

            magick.exe convert $_.FullName -channel rgb -separate ($texture[0] + '#.tga')
            
            # rename _0 _1 to the respective texture name
            for ($i = 0; $i -lt $texture[1].ToCharArray().Length; $i++) {
                $char = $texture[1].ToCharArray()[$i]
                Move-Item ($texture[0] + '#-' + $i + '.tga') ($texture[0] + $splitChar + $char + $fileEnding)
            }

            if ($removeOriginal) {
                Remove-Item $_.FullName
            }
        }
    }