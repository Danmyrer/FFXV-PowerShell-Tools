# FFXV Powershell Tools
# created by Henri Henr
# 

$files = Get-Location

$fileEnding = "_`$h.tga"
$splitChar = "_"
$albedoName = "b"
$alphaName = "a"

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

            if ($texture[1] -ne $albedoName) {
                return
            }

            $albedoFile = $_.FullName

            $alphaFileName = $texture[0] + "_" + $alphaName + $fileEnding
            if (-Not (Test-Path $alphaFileName)) {
                Write-Debug "Alpha-File can not be found, continuing..."
                return
            }

            $tempFullName = $_.FullName
            Write-Output "Processing: $tempFullName"

            $alphaFile = Get-Item $alphaFileName

            $albedoSize = magick.exe identify -ping -format '%wx%h\!' $albedoFile

            # resize and fix the alpha file
            $alphaFileFixedName = $alphaFile.DirectoryName + '\\' +  $alphaFile.BaseName + ".fixed.tga"
            magick.exe $alphaFile -resize $albedoSize -colorspace gray -alpha off -monochrome $alphaFileFixedName
            $alphaFileFixed = Get-Item $alphaFileFixedName

            # combine alpha and albedo
            $combinedFileName = $texture[0] + '_' + $albedoName + $alphaName + $fileEnding
            magick.exe convert $albedoFile $alphaFileFixed -compose copy-opacity -composite $combinedFileName

            # remove temp files
            Remove-Item $alphaFileFixed

            # remove original files
            if ($removeOriginal) {
                Remove-Item $albedoFile
                Remove-Item $alphaFile
            }
        }
    }