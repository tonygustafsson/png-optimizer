########################################
# Created by Tony Gustafsson 2018-01-16
########################################

############### Settings ###############
$sourcePath = "C:\Users\Tony Gustafsson\Downloads\pngquant-windows\pngquant\";
$backupPath = "C:\Users\Tony Gustafsson\Downloads\pngquant-windows\PNGBackup\";
$pngGauntPath = "C:\Users\Tony Gustafsson\Downloads\pngquant-windows\pngquant\pngquant.exe";
$logPath = "C:\Users\Tony Gustafsson\Downloads\pngquant-windows\logs\";
$compressionSpeed = 11; #1-11, 1 slow and smaller, 11 is fast and larger
########################################

$images = Get-ChildItem -Path $sourcePath -Recurse -Filter "*.png";
$compressedFiles = 0;
$bytesSaved = 0;

foreach ($image in $images) {
	$copyToPath = $backupPath + ($image.Directory -Replace "^\w\:\\", "");
	$copyToFullPath = $copyToPath + "\" + $image;
	$sourceFileChanged = $image.LastWriteTime;
	$sourceFileSize = $image.Length;
		
	if (Test-Path $copyToFullPath) {
		# This file is already backed up, check file date to know if we should compress this image or not
		$backupFile = Get-ChildItem $copyToFullPath;
		$backupFileChanged = $backupFile.LastWriteTime;
		$backupFileSize = $backupFile.Length;
	
		if ($sourceFileChanged -eq $backupFileChanged) {
			Write-Host "Skipping $($image.FullName)";
			continue;
		}
	}
	
	if (!(Test-Path $copyToPath)) {
		# Create directory to copy to
		New-Item $copyToPath -Type "Directory" | Out-Null;
	}
	
	# Create a backup, also used to know if a file should be compressed.
	Write-Host "Compressing $($image.FullName)";
	"$(Get-Date -format s): Compressing $($image.FullName)" | Out-File "$logPath\pngOptimizer_$(Get-Date -format yyyy-MM-dd).txt" -Append;
	Copy-Item $image.FullName $copyToFullPath -Force;
	
	# Compress original image
	& $pngGauntPath --nofs --speed $compressionSpeed --ext=.png --force $image.FullName;
	
	# Do not change change time after pngGaunt
	$image.LastWriteTime = $sourceFileChanged;
	
	# Count saved bytes
	$bytesSaved += $sourceFileSize - $backupFileSize;
	$compressedFiles++;
}

Write-Host "Done. Compressed $compressedFiles files and saved $bytesSaved bytes.";
"$(Get-Date -format s): Done. Compressed $compressedFiles files and saved $bytesSaved bytes." | Out-File "$logPath\pngOptimizer_$(Get-Date -format yyyy-MM-dd).txt" -Append;
