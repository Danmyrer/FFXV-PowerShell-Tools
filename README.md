# FFXV PowerShell Tools

A collection of useful PowerShell-Scripts for Final Fantasy XV - Windows

## Requirements

- [ImageMagick](https://imagemagick.org/)
- [PowerShell](https://github.com/PowerShell/PowerShell)

## Scripts

|Name|Description|
|---|---|
|`splitChannels.ps1`| Splits combined textures ( i.e `*_mro_$h.tga` / Metalness / Roughness / Occlusion ) into their own files ( → `*_m_$h.tga` / `*_r_$h.tga` ... )|
|`combineAlbedoAlpha.ps1`| Combines matching albedo and alpha textures ( `*_b_$h.tga` / `*_a_$h.tga` ) into a single file ( → `*_ba_$h.tga` )

## Usage

- Place .ps1 script inside the texture directory
- Inside .ps1 : Change `$removeOriginal = true` if you don't want to remove original files
- Execute from within the directory

## Guides

A complete guide about FFXV Textures and Materials - by [Impatient-Traveler](https://steamcommunity.com/id/Impatient-Traveler) - can be found [on Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=1455536027).
