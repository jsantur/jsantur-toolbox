# =====================================================================
# JSANTUR Genuine Center v1.6 (Optimizado)
# Utilidad de diagnóstico de solo lectura para licencias de Windows y Office
# Arquitectura modular, WPF/XAML, Fluent Design, UTF-8
# =====================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
 $OutputEncoding = [System.Text.Encoding]::UTF8

Add-Type -AssemblyName PresentationFramework

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    [System.Windows.MessageBox]::Show("JSANTUR Genuine Center requiere privilegios de Administrador para leer las licencias del sistema.`n`nPor favor, haga clic derecho sobre el archivo y seleccione 'Ejecutar como administrador'.", "Permisos insuficientes", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    exit
}

Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# =====================================================================
# MÓDULO XAML - Interfaz Gráfica (Fluent Design / Win11)
# =====================================================================
 $xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="JSANTUR Genuine Center" Height="720" Width="950" WindowStartupLocation="CenterScreen"
        Background="#F3F3F3" ResizeMode="CanResize" WindowStyle="None" AllowsTransparency="True"
        BorderThickness="1" BorderBrush="#E0E0E0">
    <Window.Resources>
        <Style x:Key="FluentCard" TargetType="Border">
            <Setter Property="Background" Value="White"/>
            <Setter Property="CornerRadius" Value="8"/>
            <Setter Property="Padding" Value="20"/>
            <Setter Property="Effect">
                <Setter.Value>
                    <DropShadowEffect BlurRadius="15" ShadowDepth="2" Opacity="0.15" Color="Gray"/>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="FluentButton" TargetType="Button">
            <Setter Property="Background" Value="#0078D4"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="15,8"/>
            <Setter Property="FontFamily" Value="Segoe UI Variable, Segoe UI"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#106EBE"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter TargetName="border" Property="Background" Value="#A0A0A0"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="FluentButtonSecondary" TargetType="Button" BasedOn="{StaticResource FluentButton}">
            <Setter Property="Background" Value="#E6E6E6"/>
            <Setter Property="Foreground" Value="#1A1A1A"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#D4D4D4"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter TargetName="border" Property="Background" Value="#F0F0F0"/>
                                <Setter Property="Foreground" Value="#B0B0B0"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="40"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="50"/>
        </Grid.RowDefinitions>

        <!-- Overlay de Carga con Progreso Real -->
        <Grid x:Name="LoadingOverlay" Grid.RowSpan="5" Visibility="Collapsed" Background="#C0FFFFFF" Panel.ZIndex="1000">
            <Border VerticalAlignment="Center" HorizontalAlignment="Center" Background="White" Padding="40,30" CornerRadius="8">
                <StackPanel>
                    <TextBlock x:Name="TxtProgressLabel" Text="Preparando análisis..." HorizontalAlignment="Center" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#333" Margin="0,0,0,15"/>
                    <Grid Width="250">
                        <ProgressBar x:Name="PgbLoading" Minimum="0" Maximum="100" Value="0" Height="10" Foreground="#0078D4" Background="#E6E6E6"/>
                        <TextBlock x:Name="TxtProgressPercent" Text="0%" HorizontalAlignment="Center" VerticalAlignment="Center" FontSize="9" FontWeight="Bold" Foreground="#1A1A1A"/>
                    </Grid>
                </StackPanel>
            </Border>
        </Grid>

        <Grid x:Name="HeaderGrid" Grid.Row="0" Background="Transparent">
            <TextBlock Text="JSANTUR Genuine Center" VerticalAlignment="Center" FontWeight="SemiBold" FontSize="12" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#5C5C5C"/>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                <Button x:Name="BtnClose" Content="✕" Width="40" Height="30" Background="Transparent" BorderThickness="0" FontWeight="Bold" Foreground="#5C5C5C" Cursor="Hand"/>
            </StackPanel>
        </Grid>

        <StackPanel Grid.Row="1" Margin="10,5,10,15">
            <TextBlock Text="Diagnóstico de Licencias" FontSize="28" FontWeight="Bold" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#1A1A1A"/>
            <TextBlock Text="Analiza el estado de activación de Windows y Microsoft Office." FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#717171" Margin="0,5,0,0"/>
        </StackPanel>

        <Grid Grid.Row="2" Margin="10,0,10,10">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="15"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <Border Style="{StaticResource FluentCard}" Grid.Column="0">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,15">
                        <TextBlock Text="🪟" FontSize="24" Margin="0,0,10,0"/>
                        <TextBlock Text="Windows" FontSize="20" FontWeight="SemiBold" FontFamily="Segoe UI Variable, Segoe UI" VerticalAlignment="Center"/>
                    </StackPanel>
                    <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                        <StackPanel x:Name="PnlWindows">
                            <TextBlock x:Name="TxtWinStatus" Text="Pendiente de análisis..." FontWeight="Bold" FontSize="14" Margin="0,0,0,10"/>
                            <StackPanel x:Name="DetailsWindows" Visibility="Collapsed">
                                <TextBlock x:Name="TxtWinEdition" Margin="0,2"/>
                                <TextBlock x:Name="TxtWinVersion" Margin="0,2"/>
                                <TextBlock x:Name="TxtWinBuild" Margin="0,2"/>
                                <TextBlock x:Name="TxtWinChannel" Margin="0,2"/>
                                <TextBlock x:Name="TxtWinKeyType" Margin="0,2"/>
                                <TextBlock x:Name="TxtWinPartialKey" Margin="0,2"/>
                                <TextBlock x:Name="TxtWinExpiration" Margin="0,2"/>
                                <TextBlock x:Name="TxtWinKMS" Margin="0,2"/>
                                <TextBlock x:Name="TxtWinActID" Margin="0,2" TextWrapping="Wrap" Foreground="#717171"/>
                            </StackPanel>
                        </StackPanel>
                    </ScrollViewer>
                </Grid>
            </Border>

            <Border Style="{StaticResource FluentCard}" Grid.Column="2">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,15">
                        <TextBlock Text="📦" FontSize="24" Margin="0,0,10,0"/>
                        <TextBlock Text="Microsoft Office" FontSize="20" FontWeight="SemiBold" FontFamily="Segoe UI Variable, Segoe UI" VerticalAlignment="Center"/>
                    </StackPanel>
                    <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                        <StackPanel x:Name="PnlOffice">
                            <TextBlock x:Name="TxtOffStatus" Text="Pendiente de análisis..." FontWeight="Bold" FontSize="14" Margin="0,0,0,10"/>
                            <StackPanel x:Name="DetailsOffice" Visibility="Collapsed">
                                <TextBlock x:Name="TxtOffProduct" Margin="0,2"/>
                                <TextBlock x:Name="TxtOffEdition" Margin="0,2"/>
                                <TextBlock x:Name="TxtOffVersion" Margin="0,2"/>
                                <TextBlock x:Name="TxtOffChannel" Margin="0,2"/>
                                <TextBlock x:Name="TxtOffLicenseType" Margin="0,2"/>
                                <TextBlock x:Name="TxtOffPartialKey" Margin="0,2"/>
                                <TextBlock x:Name="TxtOffExpiration" Margin="0,2"/>
                                <TextBlock x:Name="TxtOffKMS" Margin="0,2"/>
                                <TextBlock x:Name="TxtOffError" Margin="0,2" TextWrapping="Wrap" Foreground="#E81123" FontWeight="Bold"/>
                                <TextBlock x:Name="TxtOffPath" Margin="0,2" TextWrapping="Wrap" Foreground="#717171"/>
                            </StackPanel>
                        </StackPanel>
                    </ScrollViewer>
                </Grid>
            </Border>
        </Grid>

        <Border Grid.Row="3" Style="{StaticResource FluentCard}" Margin="10,5,10,15" Padding="15">
            <StackPanel>
                <TextBlock Text="🔍 Resumen del Diagnóstico" FontWeight="SemiBold" FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Margin="0,0,0,5"/>
                <TextBlock x:Name="TxtSummary" Text="Haz clic en 'Analizar' para generar el diagnóstico." FontSize="12" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#5C5C5C" TextWrapping="Wrap"/>
            </StackPanel>
        </Border>

        <StackPanel Grid.Row="4" Orientation="Horizontal" HorizontalAlignment="Right" Margin="10,0,10,10">
            <Button x:Name="BtnAnalyze" Content="✔ Analizar" Style="{StaticResource FluentButton}" Margin="0,0,10,0"/>
            <Button x:Name="BtnRefresh" Content="🔄 Actualizar" Style="{StaticResource FluentButtonSecondary}" Margin="0,0,10,0"/>
            <Button x:Name="BtnCopy" Content="📋 Copiar Diagnóstico" Style="{StaticResource FluentButtonSecondary}" Margin="0,0,10,0" IsEnabled="False"/>
            <Button x:Name="BtnExport" Content="💾 Exportar Informe" Style="{StaticResource FluentButtonSecondary}" IsEnabled="False"/>
        </StackPanel>
    </Grid>
</Window>
'@

# =====================================================================
# MÓDULO LÓGICA - Lectura de datos del sistema (OPTIMIZADO)
# =====================================================================

 $script:WinData = @{}
 $script:OffData = @{}

function Get-WindowsLicenseInfo {
    $script:WinData = @{}
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $script:WinData['Edition'] = $os.Caption
        $script:WinData['Version'] = $os.Version
        $script:WinData['Build'] = $os.BuildNumber

        # OPTIMIZACIÓN: Usar WQL para filtrar directamente en el motor WMI en lugar de PowerShell.
        # Esto reduce el tiempo de consulta drásticamente.
        $lic = Get-CimInstance -Query "SELECT * FROM SoftwareLicensingProduct WHERE Name LIKE '%Windows%' AND PartialProductKey IS NOT NULL"
        if (-not $lic) {
            $lic = Get-CimInstance -Query "SELECT * FROM SoftwareLicensingProduct WHERE Name LIKE '%Windows%'" | Select-Object -First 1
        }

        if (-not $lic) {
            $script:WinData['Status'] = "No se encontró licencia de Windows"
            $script:WinData['StatusCode'] = "Red"
            return
        }

        $script:WinData['PartialKey'] = if ($lic.PartialProductKey) { "*****$($lic.PartialProductKey)" } else { "No encontrada" }
        $script:WinData['ActID'] = if ($lic.ID) { $lic.ID } else { "N/A" }

        $status = $lic.LicenseStatus
        switch ($status) {
            1 { $script:WinData['Status'] = "Licenciado (Activado)"; $script:WinData['StatusCode'] = "Green" }
            2 { $script:WinData['Status'] = "Período de gracia OOB"; $script:WinData['StatusCode'] = "Yellow" }
            3 { $script:WinData['Status'] = "Período de gracia OOT"; $script:WinData['StatusCode'] = "Yellow" }
            4 { $script:WinData['Status'] = "Período de gracia no original"; $script:WinData['StatusCode'] = "Yellow" }
            5 { $script:WinData['Status'] = "Notificación (No activado)"; $script:WinData['StatusCode'] = "Red" }
            6 { $script:WinData['Status'] = "Período de gracia extendido"; $script:WinData['StatusCode'] = "Yellow" }
            default { $script:WinData['Status'] = "Desconocido / No activado"; $script:WinData['StatusCode'] = "Red" }
        }

        $desc = $lic.Description
        if ($desc -match "KMS_Client") {
            $script:WinData['Channel'] = "KMS_Client"
            $script:WinData['KeyType'] = "Activación mediante servidor KMS"
            $script:WinData['StatusCode'] = "Yellow"
        } elseif ($desc -match "MAK") {
            $script:WinData['Channel'] = "MAK"
            $script:WinData['KeyType'] = "Licencia por volumen legítima (MAK)"
        } elseif ($desc -match "OEM_DM") {
            $script:WinData['Channel'] = "OEM_DM"
            $script:WinData['KeyType'] = "Licencia OEM digital del fabricante"
        } elseif ($desc -match "OEM_COA") {
            $script:WinData['Channel'] = "OEM_COA"
            $script:WinData['KeyType'] = "Licencia OEM tradicional (COA)"
        } elseif ($desc -match "OEM") {
            $script:WinData['Channel'] = "OEM"
            $script:WinData['KeyType'] = "Licencia OEM"
        } elseif ($desc -match "RETAIL") {
            $script:WinData['Channel'] = "Retail"
            $script:WinData['KeyType'] = "Licencia comercial original (Retail)"
        } elseif ($desc -match "EVAL") {
            $script:WinData['Channel'] = "Evaluation"
            $script:WinData['KeyType'] = "Versión de evaluación"
            $script:WinData['StatusCode'] = "Yellow"
        } else {
            $script:WinData['Channel'] = "Desconocido"
            $script:WinData['KeyType'] = "Desconocido"
        }

        # OPTIMIZACIÓN: Leer la expiración directamente del objeto ya consultado ($lic)
        if ($lic.LicenseStatus -eq 1 -and $desc -notmatch "KMS_Client" -and $desc -notmatch "EVAL") {
            $script:WinData['Expiration'] = "Activación Permanente"
        } else {
            $exp = $lic.ExpirationDate
            if ($exp -and $exp -ne "0/1/1601 12:00:00 AM") {
                $script:WinData['Expiration'] = $exp.ToString("dd/MM/yyyy HH:mm:ss")
            } else {
                $script:WinData['Expiration'] = "No aplica o expirado"
            }
        }

        $svc = Get-CimInstance SoftwareLicensingService
        $script:WinData['KMS'] = if ($svc.KeyManagementServiceMachine) { "$($svc.KeyManagementServiceMachine):$($svc.KeyManagementServicePort)" } else { "No configurado" }

    } catch {
        $script:WinData['Status'] = "Error al leer WMI"
        $script:WinData['StatusCode'] = "Red"
    }
}

function Get-OfficeLicenseInfo {
    $script:OffData = @{}
    $osppPaths = @(
        "${env:ProgramFiles}\Microsoft Office\Office16\OSPP.VBS",
        "${env:ProgramFiles(x86)}\Microsoft Office\Office16\OSPP.VBS",
        "${env:ProgramFiles}\Microsoft Office\root\Office16\OSPP.VBS",
        "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\OSPP.VBS",
        "${env:ProgramFiles}\Microsoft Office\Office15\OSPP.VBS",
        "${env:ProgramFiles(x86)}\Microsoft Office\Office15\OSPP.VBS",
        "${env:ProgramFiles}\Microsoft Office\root\Office15\OSPP.VBS",
        "${env:ProgramFiles(x86)}\Microsoft Office\root\Office15\OSPP.VBS"
    )

    $ospp = $osppPaths | Where-Object { Test-Path $_ } | Select-Object -First 1

    if (-not $ospp) {
        $script:OffData['Status'] = "No detectado"
        $script:OffData['StatusCode'] = "Red"
        $script:OffData['Product'] = "Microsoft Office no está instalado"
        return
    }

    $script:OffData['Path'] = (Split-Path $ospp)
    $output = cscript.exe //nologo $ospp /dstatus 2>&1 | Out-String
    
    $licName = ""; $licDesc = ""; $licStatus = ""; $partialKey = ""; $errDesc = ""; $kmsMachine = ""; $expiration = ""

    $lines = $output -split "`r`n"
    foreach ($line in $lines) {
        if ([string]::IsNullOrWhiteSpace($licName) -and $line -match "^LICENSE NAME:\s+(.+)") { $licName = $matches[1].Trim() }
        elseif ([string]::IsNullOrWhiteSpace($licDesc) -and $line -match "^LICENSE DESCRIPTION:\s+(.+)") { $licDesc = $matches[1].Trim() }
        elseif ([string]::IsNullOrWhiteSpace($licStatus) -and $line -match "^LICENSE STATUS:\s+(.+)") { $licStatus = $matches[1].Trim() }
        elseif ([string]::IsNullOrWhiteSpace($partialKey) -and $line -match "^Last 5 characters of installed product key:\s+(.+)") { $partialKey = $matches[1].Trim() }
        elseif ([string]::IsNullOrWhiteSpace($errDesc) -and $line -match "^ERROR DESCRIPTION:\s+(.+)") { $errDesc = $matches[1].Trim() }
        elseif ([string]::IsNullOrWhiteSpace($kmsMachine) -and $line -match "^KMS machine name:\s+(.+)") { $kmsMachine = $matches[1].Trim() }
        elseif ([string]::IsNullOrWhiteSpace($expiration) -and $line -match "^REMAINING GRACE:\s+(.+)") { $expiration = $matches[1].Trim() }
    }

    $script:OffData['Product'] = if(-not [string]::IsNullOrWhiteSpace($licName)) { $licName } else { "Desconocido" }
    $script:OffData['PartialKey'] = if(-not [string]::IsNullOrWhiteSpace($partialKey)) { "*****$partialKey" } else { "No encontrada" }
    $script:OffData['Error'] = if(-not [string]::IsNullOrWhiteSpace($errDesc)) { $errDesc } else { "" }
    
    if (-not [string]::IsNullOrWhiteSpace($licDesc) -and $licDesc -match "Office\s+(\d+),\s+(.+)") {
        $script:OffData['Version'] = "Office $($matches[1])"
        $channelStr = $matches[2].Trim()
        
        if ($channelStr -match "RETAIL") {
            $script:OffData['Channel'] = "Retail"
            $script:OffData['LicenseType'] = "Licencia comercial original (Retail)"
            $script:OffData['StatusCode'] = "Green"
        } elseif ($channelStr -match "VOLUME_KMS") {
            $script:OffData['Channel'] = "KMS_Client"
            $script:OffData['LicenseType'] = "Activación mediante servidor KMS"
            $script:OffData['StatusCode'] = "Yellow"
        } elseif ($channelStr -match "VOLUME_MAK") {
            $script:OffData['Channel'] = "MAK"
            $script:OffData['LicenseType'] = "Licencia por volumen legítima (MAK)"
            $script:OffData['StatusCode'] = "Green"
        } else {
            $script:OffData['Channel'] = $channelStr
            $script:OffData['LicenseType'] = $channelStr
            $script:OffData['StatusCode'] = "Yellow"
        }
    } else {
        $script:OffData['Version'] = "Desconocida"
        $script:OffData['Channel'] = "Desconocido"
        $script:OffData['LicenseType'] = "Desconocido"
    }

    if (-not [string]::IsNullOrWhiteSpace($licName) -and $licName -match "ProPlus") {
        $script:OffData['Edition'] = "Professional Plus"
    } elseif (-not [string]::IsNullOrWhiteSpace($licName) -and $licName -match "Standard") {
        $script:OffData['Edition'] = "Standard"
    } else {
        $script:OffData['Edition'] = "Otra Edición"
    }

    if (-not [string]::IsNullOrWhiteSpace($licStatus)) {
        if ($licStatus -match "---LICENCED---") {
            $script:OffData['Status'] = "Activado"
            if($script:OffData['Channel'] -ne "KMS_Client") { $script:OffData['StatusCode'] = "Green" }
        } elseif ($licStatus -match "---NOTIFICATIONS---") {
            $script:OffData['Status'] = "Notificaciones (Sin activar / Expirado)"
            $script:OffData['StatusCode'] = "Red"
        } elseif ($licStatus -match "---OOB_GRACE---") {
            $script:OffData['Status'] = "Período de gracia"
            $script:OffData['StatusCode'] = "Yellow"
        } else {
            $script:OffData['Status'] = "Desconocido"
            $script:OffData['StatusCode'] = "Red"
        }
    } else {
        $script:OffData['Status'] = "Desconocido"
        $script:OffData['StatusCode'] = "Red"
    }

    $script:OffData['KMS'] = if (-not [string]::IsNullOrWhiteSpace($kmsMachine)) { $kmsMachine } else { "No configurado" }
    $script:OffData['Expiration'] = if (-not [string]::IsNullOrWhiteSpace($expiration)) { $expiration } else { "Permanente / No aplica" }
}

# =====================================================================
# MÓDULO INTERFAZ - Lógica visual y eventos
# =====================================================================

try {
    $window = [Windows.Markup.XamlReader]::Parse($xaml)

    $HeaderGrid = $window.FindName("HeaderGrid")
    $HeaderGrid.Add_MouseLeftButtonDown({ $window.DragMove() })
    $window.FindName("BtnClose").Add_Click({ $window.Close() })

    $window.Add_KeyDown({
        if ($_.Key -eq 'Escape') { $window.Close() }
    })

    function Get-StatusEmoji($Code) {
        switch ($Code) {
            "Green"  { return "🟢" }
            "Yellow" { return "🟡" }
            "Red"    { return "🔴" }
        }
    }

    function Set-Progress {
        param ([int]$Percent, [string]$Label)
        $window.FindName("PgbLoading").Value = $Percent
        $window.FindName("TxtProgressPercent").Text = "$Percent%"
        $window.FindName("TxtProgressLabel").Text = $Label
        [System.Windows.Threading.Dispatcher]::CurrentDispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Background)
    }

    function Update-UI {
        $window.FindName("LoadingOverlay").Visibility = "Visible"
        $window.FindName("PgbLoading").Value = 0
        $window.FindName("TxtProgressPercent").Text = "0%"
        
        try {
            Set-Progress -Percent 20 -Label "Consultando base de datos WMI..."

            Set-Progress -Percent 40 -Label "Analizando licencia de Windows..."
            Get-WindowsLicenseInfo

            Set-Progress -Percent 70 -Label "Analizando licencia de Microsoft Office..."
            Get-OfficeLicenseInfo

            Set-Progress -Percent 90 -Label "Procesando resultados..."

            # Actualizar UI Windows
            $emojiWin = Get-StatusEmoji $script:WinData['StatusCode']
            $window.FindName("TxtWinStatus").Text = "$emojiWin $($script:WinData['Status'])"
            $window.FindName("TxtWinStatus").Foreground = switch ($script:WinData['StatusCode']) { "Green" {"#10893E"} "Yellow" {"#FFB900"} "Red" {"#E81123"} }
            
            if ($script:WinData.Count -gt 2) {
                $window.FindName("DetailsWindows").Visibility = "Visible"
                $window.FindName("TxtWinEdition").Text = "Edición: $($script:WinData['Edition'])"
                $window.FindName("TxtWinVersion").Text = "Versión: $($script:WinData['Version'])"
                $window.FindName("TxtWinBuild").Text = "Build: $($script:WinData['Build'])"
                $window.FindName("TxtWinChannel").Text = "Canal: $($script:WinData['Channel'])"
                $window.FindName("TxtWinKeyType").Text = "Tipo: $($script:WinData['KeyType'])"
                $window.FindName("TxtWinPartialKey").Text = "Clave Parcial: $($script:WinData['PartialKey'])"
                $window.FindName("TxtWinExpiration").Text = "Expiración: $($script:WinData['Expiration'])"
                $window.FindName("TxtWinKMS").Text = "Servidor KMS: $($script:WinData['KMS'])"
                $window.FindName("TxtWinActID").Text = "ID Activación: $($script:WinData['ActID'])"
            }

            # Actualizar UI Office
            $emojiOff = Get-StatusEmoji $script:OffData['StatusCode']
            $window.FindName("TxtOffStatus").Text = "$emojiOff $($script:OffData['Status'])"
            $window.FindName("TxtOffStatus").Foreground = switch ($script:OffData['StatusCode']) { "Green" {"#10893E"} "Yellow" {"#FFB900"} "Red" {"#E81123"} }
            
            if ($script:OffData['Product'] -like "*no está instalado*") {
                $window.FindName("TxtOffStatus").Text = "🔴 No detectado"
                $window.FindName("DetailsOffice").Visibility = "Collapsed"
            } else {
                $window.FindName("DetailsOffice").Visibility = "Visible"
                $window.FindName("TxtOffProduct").Text = "Producto: $($script:OffData['Product'])"
                $window.FindName("TxtOffEdition").Text = "Edición: $($script:OffData['Edition'])"
                $window.FindName("TxtOffVersion").Text = "Versión: $($script:OffData['Version'])"
                $window.FindName("TxtOffChannel").Text = "Canal: $($script:OffData['Channel'])"
                $window.FindName("TxtOffLicenseType").Text = "Tipo: $($script:OffData['LicenseType'])"
                $window.FindName("TxtOffPartialKey").Text = "Clave Parcial: $($script:OffData['PartialKey'])"
                $window.FindName("TxtOffExpiration").Text = "Expiración: $($script:OffData['Expiration'])"
                $window.FindName("TxtOffKMS").Text = "Servidor KMS: $($script:OffData['KMS'])"
                $window.FindName("TxtOffPath").Text = "Ruta: $($script:OffData['Path'])"
                
                if ($script:OffData['Error'] -ne "") {
                    $window.FindName("TxtOffError").Text = "⚠ Error: $($script:OffData['Error'])"
                    $window.FindName("TxtOffError").Visibility = "Visible"
                } else {
                    $window.FindName("TxtOffError").Visibility = "Collapsed"
                }
            }

            # Generar Resumen
            $summary = ""
            if ($script:WinData['StatusCode'] -eq "Green") { $summary += "✔ Windows activado correctamente (Canal: $($script:WinData['Channel'])).`n" }
            elseif ($script:WinData['StatusCode'] -eq "Yellow") { $summary += "⚠ Windows con activación temporal / KMS / Evaluación. Canal: $($script:WinData['Channel']).`n" }
            else { $summary += "🔴 Windows NO está activado.`n" }

            if ($script:OffData['StatusCode'] -eq "Green") { $summary += "✔ Office activado correctamente (Canal: $($script:OffData['Channel'])).`n" }
            elseif ($script:OffData['StatusCode'] -eq "Yellow") { $summary += "⚠ Office con activación temporal / KMS. Canal: $($script:OffData['Channel']).`n" }
            elseif ($script:OffData['StatusCode'] -eq "Red" -and $script:OffData['Product'] -notlike "*no está instalado*") { $summary += "🔴 Office detectado pero SIN LICENCIA / Expirado.`n" }

            $window.FindName("TxtSummary").Text = $summary

            # Habilitar botones
            $window.FindName("BtnCopy").IsEnabled = $true
            $window.FindName("BtnExport").IsEnabled = $true

            Set-Progress -Percent 100 -Label "Análisis completado"
            Start-Sleep -Milliseconds 300

        } catch {
            [System.Windows.MessageBox]::Show("Error durante el análisis:`n`n$($_.Exception.Message)", "JSANTUR Genuine Center", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
        } finally {
            $window.FindName("LoadingOverlay").Visibility = "Collapsed"
        }
    }

    $window.FindName("BtnAnalyze").Add_Click({ Update-UI })
    $window.FindName("BtnRefresh").Add_Click({ Update-UI })

    $window.FindName("BtnCopy").Add_Click({
        $diagText = "=== JSANTUR GENUINE CENTER - DIAGNÓSTICO ===`nFecha: $(Get-Date)`n`n"
        $diagText += "--- WINDOWS ---`n"
        foreach ($key in $script:WinData.Keys) { $diagText += "${key}: $($script:WinData[$key])`n" }
        $diagText += "`n--- MICROSOFT OFFICE ---`n"
        foreach ($key in $script:OffData.Keys) { $diagText += "${key}: $($script:OffData[$key])`n" }
        $diagText += "`n--- RESUMEN ---`n$($window.FindName("TxtSummary").Text)"
        
        [System.Windows.Forms.Clipboard]::SetText($diagText)
        [System.Windows.MessageBox]::Show("Diagnóstico copiado al portapapeles.", "JSANTUR Genuine Center", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    })

    $window.FindName("BtnExport").Add_Click({
        $diagText = "=== JSANTUR GENUINE CENTER - DIAGNÓSTICO ===`nFecha: $(Get-Date)`n`n"
        $diagText += "--- WINDOWS ---`n"
        foreach ($key in $script:WinData.Keys) { $diagText += "${key}: $($script:WinData[$key])`n" }
        $diagText += "`n--- MICROSOFT OFFICE ---`n"
        foreach ($key in $script:OffData.Keys) { $diagText += "${key}: $($script:OffData[$key])`n" }
        $diagText += "`n--- RESUMEN ---`n$($window.FindName("TxtSummary").Text)"

        $html = @"
<!DOCTYPE html>
<html lang='es'>
<head>
<meta charset='UTF-8'>
<style>
    body { font-family: 'Segoe UI', sans-serif; background: #F3F3F3; padding: 40px; }
    .card { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-bottom: 20px; }
    h1 { color: #1A1A1A; } h2 { color: #0078D4; border-bottom: 1px solid #E6E6E6; padding-bottom: 10px; }
    p { margin: 4px 0; color: #333; }
    .summary { background: #E6F4FF; border-left: 4px solid #0078D4; padding: 15px; border-radius: 4px; }
</style>
</head>
<body>
    <h1>JSANTUR Genuine Center - Informe</h1>
    <div class='card'><h2>🪟 Windows</h2>
"@
        foreach ($key in $script:WinData.Keys) { $html += "<p><strong>${key}:</strong> $($script:WinData[$key])</p>" }
        $html += "</div><div class='card'><h2>📦 Microsoft Office</h2>"
        foreach ($key in $script:OffData.Keys) { $html += "<p><strong>${key}:</strong> $($script:OffData[$key])</p>" }
        $html += "</div><div class='summary'><h2>🔍 Resumen</h2><p>$($window.FindName("TxtSummary").Text -replace "`n", "<br>")</p></div></body></html>"

        $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
        $saveDialog.Filter = "Archivo HTML (*.html)|*.html|Archivo de Texto (*.txt)|*.txt"
        $saveDialog.FileName = "JSANTUR_GenuineCenter_Report"
        if ($saveDialog.ShowDialog() -eq "OK") {
            if ($saveDialog.FileName -like "*.txt") {
                [System.IO.File]::WriteAllText($saveDialog.FileName, $diagText, [System.Text.Encoding]::UTF8)
            } else {
                [System.IO.File]::WriteAllText($saveDialog.FileName, $html, [System.Text.Encoding]::UTF8)
            }
            [System.Windows.MessageBox]::Show("Informe exportado exitosamente.", "JSANTUR Genuine Center", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        }
    })

    $window.ShowDialog() | Out-Null

} catch {
    [System.Windows.MessageBox]::Show("Ocurrió un error crítico al cargar la aplicación:`n`n$($_.Exception.Message)", "JSANTUR Genuine Center", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
}