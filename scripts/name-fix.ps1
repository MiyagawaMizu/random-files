# Directory path (cần thay đổi theo thư mục của bạn)
$directoryPath = "C:\Your\Directory\Path"

# Function to generate a random suffix
function Get-RandomSuffix {
    $chars = "abcdefghijklmnopqrstuvwxyz0123456789"
    $suffix = ""
    for ($i = 0; $i -lt 5; $i++) {
        $suffix += $chars | Get-Random
    }
    return "-" + $suffix
}

# Get all files in the specified directory
$files = Get-ChildItem -Path $directoryPath -File

foreach ($file in $files) {
    # Remove spaces, parentheses, and special characters (except hyphen and dot for file extension)
    $newName = ($file.Name -replace '[\s\(\)\[\]\{\}~!@#$%^&+=`]', '')

    # If the filename already exists, add a random suffix
    while (Test-Path -Path (Join-Path -Path $directoryPath -ChildPath $newName)) {
        $nameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($newName)
        $extension = $file.Extension
        $newName = $nameWithoutExtension + (Get-RandomSuffix) + $extension
    }

    # Rename the file
    $newPath = Join-Path -Path $directoryPath -ChildPath $newName
    Rename-Item -Path $file.FullName -NewName $newName
    Write-Host "Renamed '$($file.Name)' to '$newName'"
}
