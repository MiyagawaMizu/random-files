# Lấy đường dẫn của thư mục hiện tại
$directoryPath = Get-Location

# Hàm để tạo hậu tố ngẫu nhiên
function Get-RandomSuffix {
    $chars = "abcdefghijklmnopqrstuvwxyz0123456789"
    $suffix = ""
    for ($i = 0; $i -lt 5; $i++) {
        $suffix += $chars | Get-Random
    }
    return "-" + $suffix
}

# Lấy tất cả các file trong thư mục hiện tại
$files = Get-ChildItem -Path $directoryPath -File

foreach ($file in $files) {
    # Loại bỏ khoảng trắng, dấu ngoặc và ký tự đặc biệt (trừ dấu '-' và '.' cho phần mở rộng)
    $newName = ($file.Name -replace '[\s\(\)\[\]\{\}~!@#$%^&+=`]', '')

    # Nếu tên file mới đã tồn tại, thêm hậu tố ngẫu nhiên để tránh trùng lặp
    while (Test-Path -Path (Join-Path -Path $directoryPath -ChildPath $newName)) {
        $nameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($newName)
        $extension = $file.Extension
        $newName = $nameWithoutExtension + (Get-RandomSuffix) + $extension
    }

    # Đổi tên file
    $newPath = Join-Path -Path $directoryPath -ChildPath $newName
    Rename-Item -Path $file.FullName -NewName $newName
    Write-Host "Renamed '$($file.Name)' to '$newName'"
}
