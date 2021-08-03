function Get-FolderAPI {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Desktop', 'Documents', 'Downloads', 'Music', 'Pictures', 'Videos')]
        $Folder
    )
    $FoldersGUID = @{
        Desktop = 'B4BFCC3A-DB2C-424C-B029-7FE99A87C641';
        Documents = 'FDD39AD0-238F-46AF-ADB4-6C85480369C7';
        Downloads = '374DE290-123F-4565-9164-39C4925E467B';
        Music = '4BD8D571-6D19-48D3-BE97-422220080E43';
        Pictures = '33E28130-4E1E-4676-835A-98395C3BC3BB';
        Videos = '18989B1D-99B5-455B-841C-AB7C74E4DDFC'
    }
    $Signature = @'
        [DllImport("shell32.dll")]
        public extern static int SHGetKnownFolderPath(
            ref Guid folderId, 
            uint flags, 
            IntPtr token,
            [MarshalAs(UnmanagedType.LPWStr)] out string pszPath
        );
'@
    $Output = $null
    $Type = Add-Type -MemberDefinition $Signature -Name 'GetKnownFolders' -Namespace 'SHGetKnownFolderPath' -PassThru
    
    $Type::SHGetKnownFolderPath([ref]$FoldersGUID.$Folder, 0, 0, [ref]$Output) | Out-Null
    return $Output
}

function Set-FolderAPI {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Desktop', 'Documents', 'Downloads', 'Music', 'Pictures', 'Videos')]
        $Folder,
        [Parameter(Mandatory)]
        [string]$Path
    )
    $FoldersGUID = @{
        Desktop = 'B4BFCC3A-DB2C-424C-B029-7FE99A87C641';
        Documents = 'FDD39AD0-238F-46AF-ADB4-6C85480369C7';
        Downloads = '374DE290-123F-4565-9164-39C4925E467B';
        Music = '4BD8D571-6D19-48D3-BE97-422220080E43';
        Pictures = '33E28130-4E1E-4676-835A-98395C3BC3BB';
        Videos = '18989B1D-99B5-455B-841C-AB7C74E4DDFC'
    }
    $Signature = @'
        [DllImport("shell32.dll")]
        public extern static int SHSetKnownFolderPath(
            ref Guid folderId, 
            uint flags, 
            IntPtr token, 
            [MarshalAs(UnmanagedType.LPWStr)] string path
        );
'@
    $Type = Add-Type -MemberDefinition $Signature -Name 'SetKnownFolders' -Namespace 'SHSetKnownFolderPath' -PassThru

    $Type::SHSetKnownFolderPath([ref]$FoldersGUID.$Folder, 0, 0, $Path) | Out-Null
}