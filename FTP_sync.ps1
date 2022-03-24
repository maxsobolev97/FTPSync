
function FTPsync{
    try
    {
        Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"
 
        # Параметры подключения
        $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
            Protocol = [WinSCP.Protocol]::Ftp
            FtpMode  = [WinSCP.FtpMode]::Passive
            HostName = "ip.ip.ip.ip"
            UserName = "anonymous"
            Password = "anonymous"
            #PortNumber = "22221"
        }
 
        $session = New-Object WinSCP.Session
 
        try
        {
            # Открываем FTP сессию
            $session.Open($sessionOptions)
 
            # Синхроним с удаленной площадкой ЦБ
            $synchronizationResult = $session.SynchronizeDirectories([WinSCP.SynchronizationMode]::Local, "R:\", "/", $False)
            # Остановка по ошибке
            $synchronizationResult.Check()
 
            # Вывод результата
            foreach ($sync in $synchronizationResult.Downloads)
            {
                Write-Host "Upload of $($sync.Destination) succeeded"
            }
        }
        finally
        {
            # Завершаем сессию
            $session.Dispose()
        }
 
        exit 0
    }
    catch
    {
        Write-Host "Error: $($_.Exception.Message)"
        exit 1
    }

}

FTPsync