# =============================================================================
# APLICACIÓN DE LIMPIEZA DE PERFIL - NOTIFICACIONES INFALIBLES Y SIN CIERRE
# =============================================================================

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# -----------------------------------------------------------------------------
# FUNCIÓN: ENVIAR NOTIFICACIÓN TIPO SMS (BalloonTip Infalible)
# -----------------------------------------------------------------------------
function Show-Notification {
    param(
        [string]$Titulo,
        [string]$Mensaje
    )
    try {
        # Extraer el icono de información de Windows a la memoria para usarlo
        $icon = [System.Drawing.SystemIcons]::Information
        $iconStream = New-Object System.IO.MemoryStream
        $icon.Save($iconStream)
        $iconStream.Position = 0
        $bitmapIcon = New-Object System.Drawing.Icon($iconStream)

        # Crear el componente de notificación
        $notify = New-Object System.Windows.Forms.NotifyIcon
        $notify.Icon = $bitmapIcon
        $notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
        $notify.BalloonTipTitle = $Titulo
        $notify.BalloonTipText = $Mensaje
        $notify.Visible = $true

        # Mostrar la burbuja por 4 segundos
        $notify.ShowBalloonTip(4000)

        # Programar la limpieza del icono de la barra de tareas después de 5 segundos
        $timerCleanup = New-Object System.Windows.Forms.Timer
        $timerCleanup.Interval = 5000
        $timerCleanup.Add_Tick({
            $notify.Dispose()
            $timerCleanup.Stop()
            $timerCleanup.Dispose()
        })
        $timerCleanup.Start()
    } catch {
        # Si falla el globo, no hace nada para no interrumpir la app
    }
}

# -----------------------------------------------------------------------------
# DISEÑO DE LA INTERFAZ GRÁFICA (XAML)
# -----------------------------------------------------------------------------
[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="🧹 JSANTUR ✨" Height="520" Width="460"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        WindowStartupLocation="CenterScreen" ResizeMode="NoResize">
    
    <Border Background="White" CornerRadius="12" Margin="15">
        <Border.Effect>
            <DropShadowEffect BlurRadius="30" ShadowDepth="0" Opacity="0.25" Color="#000000"/>
        </Border.Effect>
        
        <Grid Margin="35,30,35,35">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>

            <Grid Grid.Row="0" Margin="0,0,0,20">
                <TextBlock Text="🧹 JSANTUR ✨" FontSize="18" FontWeight="SemiBold" 
                           FontFamily="Segoe UI Variable, Segoe UI" Foreground="#1a1a1a" VerticalAlignment="Center"/>
                <Button x:Name="BtnCerrar" Content="✕" HorizontalAlignment="Right" 
                        VerticalAlignment="Center" Width="28" Height="28" 
                        FontSize="12" FontWeight="Bold" Foreground="#888888" 
                        Background="Transparent" BorderThickness="0" Cursor="Hand"/>
            </Grid>

            <Grid Grid.Row="1">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <TextBlock Grid.Row="0" TextWrapping="Wrap" Margin="0,0,0,20" 
                           FontSize="13" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#666666"
                           Text="Esta utilidad moverá a la Papelera de reciclaje el contenido de las carpetas seleccionadas de su perfil de usuario."/>
                
                <StackPanel Grid.Row="1" Margin="0,0,0,20">
                    <TextBlock Text="✓  Documentos" FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#333333" Margin="0,6"/>
                    <TextBlock Text="✓  Descargas" FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#333333" Margin="0,6"/>
                    <TextBlock Text="✓  Imágenes" FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#333333" Margin="0,6"/>
                    <TextBlock Text="✓  Música" FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#333333" Margin="0,6"/>
                    <TextBlock Text="✓  Videos" FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#333333" Margin="0,6"/>
                    <TextBlock Text="✓  Escritorio (Solo archivos de usuario, sin accesos directos)" FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#333333" Margin="0,6"/>
                </StackPanel>

                <Button x:Name="BtnIniciar" Grid.Row="3" Height="45" FontSize="15" 
                        FontFamily="Segoe UI Variable, Segoe UI" FontWeight="SemiBold"
                        Content="Iniciar limpieza" Background="#2C2C2C" Foreground="White"
                        BorderThickness="0" Cursor="Hand" Margin="0,10,0,0">
                    <Button.Style>
                        <Style TargetType="Button">
                            <Setter Property="Template">
                                <Setter.Value>
                                    <ControlTemplate TargetType="Button">
                                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="8" Padding="10">
                                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                        </Border>
                                        <ControlTemplate.Triggers>
                                            <Trigger Property="IsMouseOver" Value="True">
                                                <Setter TargetName="border" Property="Background" Value="#444444"/>
                                            </Trigger>
                                        </ControlTemplate.Triggers>
                                    </ControlTemplate>
                                </Setter.Value>
                            </Setter>
                        </Style>
                    </Button.Style>
                </Button>

                <Grid x:Name="PanelProgreso" Grid.Row="3" Visibility="Collapsed" Margin="0,10,0,0">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>
                    <TextBlock x:Name="TxtEstado" Text="Preparando..." FontSize="13" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#555555" Margin="0,0,0,10"/>
                    <ProgressBar x:Name="BarraProgreso" Grid.Row="1" Height="6" Minimum="0" Maximum="100" Margin="0,0,0,10">
                        <ProgressBar.Style>
                            <Style TargetType="ProgressBar">
                                <Setter Property="Template">
                                    <Setter.Value>
                                        <ControlTemplate TargetType="ProgressBar">
                                            <Border Background="#F0F0F0" CornerRadius="3">
                                                <Border x:Name="PART_Indicator" Background="#2C2C2C" CornerRadius="3" HorizontalAlignment="Left"/>
                                            </Border>
                                        </ControlTemplate>
                                    </Setter.Value>
                                </Setter>
                            </Style>
                        </ProgressBar.Style>
                    </ProgressBar>
                    <TextBlock x:Name="TxtPorcentaje" Grid.Row="2" Text="0%" FontSize="12" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#999999" HorizontalAlignment="Right"/>
                </Grid>

                <Grid x:Name="PanelExito" Grid.Row="3" Visibility="Collapsed" Margin="0,10,0,0">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>
                    
                    <StackPanel Grid.Row="0" Orientation="Horizontal" Margin="0,0,0,15">
                        <TextBlock Text="✓ " FontSize="18" Foreground="#34C759" FontWeight="Bold" VerticalAlignment="Center"/>
                        <TextBlock Text="La limpieza ha finalizado correctamente." FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#1a1a1a" VerticalAlignment="Center"/>
                    </StackPanel>
                    
                    <TextBlock Grid.Row="1" Text="¿Desea vaciar ahora la Papelera de reciclaje?" FontSize="13" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#555555" Margin="0,0,0,15"/>
                    
                    <StackPanel Grid.Row="2" Orientation="Horizontal" HorizontalAlignment="Center">
                        <Button x:Name="BtnVaciarSi" Content="Sí" Width="100" Height="38" Margin="0,0,10,0" FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Background="#2C2C2C" Foreground="White" BorderThickness="0" Cursor="Hand">
                            <Button.Style>
                                <Style TargetType="Button"><Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button"><Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="8"><ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/></Border><ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="border" Property="Background" Value="#444444"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter></Style>
                            </Button.Style>
                        </Button>
                        <Button x:Name="BtnVaciarNo" Content="No" Width="100" Height="38" FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Background="#F0F0F0" Foreground="#333333" BorderThickness="0" Cursor="Hand">
                            <Button.Style>
                                <Style TargetType="Button"><Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button"><Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="8"><ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/></Border><ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="border" Property="Background" Value="#E0E0E0"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter></Style>
                            </Button.Style>
                        </Button>
                    </StackPanel>
                </Grid>

            </Grid>
        </Grid>
    </Border>
</Window>
"@

# -----------------------------------------------------------------------------
# CARGAR INTERFAZ
# -----------------------------------------------------------------------------
 $Reader = New-Object System.Xml.XmlNodeReader $XAML
 $Ventana = [System.Windows.Markup.XamlReader]::Load($Reader)

 $BtnCerrar = $Ventana.FindName("BtnCerrar")
 $BtnIniciar = $Ventana.FindName("BtnIniciar")
 $PanelProgreso = $Ventana.FindName("PanelProgreso")
 $PanelExito = $Ventana.FindName("PanelExito")
 $BarraProgreso = $Ventana.FindName("BarraProgreso")
 $TxtEstado = $Ventana.FindName("TxtEstado")
 $TxtPorcentaje = $Ventana.FindName("TxtPorcentaje")
 $BtnVaciarSi = $Ventana.FindName("BtnVaciarSi")
 $BtnVaciarNo = $Ventana.FindName("BtnVaciarNo")

# --- CONTROLES DE CIERRE ---
# 1. Cerrar con el botón X
 $BtnCerrar.Add_Click({ $Ventana.Close() })

# 2. Cerrar con la tecla Escape (ESC)
 $Ventana.Add_PreviewKeyDown({
    if ($_.Key -eq 'Escape') {
        $Ventana.Close()
    }
})

# -----------------------------------------------------------------------------
# VARIABLES COMPARTIDAS
# -----------------------------------------------------------------------------
 $syncHash = [hashtable]::Synchronized(@{})
 $syncHash.Progress = 0
 $syncHash.Status = "Preparando..."
 $syncHash.Done = $false

# -----------------------------------------------------------------------------
# CÓDIGO DE LIMPIEZA (HILO SEPARADO)
# -----------------------------------------------------------------------------
 $CleanScriptBlock = {
    param($syncHash)
    
    $Carpetas = @("Documents", "Downloads", "Pictures", "Music", "Videos", "Desktop")
    $TotalCarpetas = $Carpetas.Count
    
    function Send-ToRecycleBin {
        param([string]$FilePath)
        try {
            $shell = New-Object -ComObject Shell.Application
            $recycleBin = $shell.NameSpace(0x0a)
            $parentDir = $shell.NameSpace((Split-Path $FilePath))
            $fileName = Split-Path $FilePath -Leaf
            $item = $parentDir.ParseName($fileName)
            if ($null -ne $item) { $recycleBin.MoveHere($item) }
        } catch { }
    }

    for ($i = 0; $i -lt $TotalCarpetas; $i++) {
        $carpeta = $Carpetas[$i]
        $ruta = Join-Path $env:USERPROFILE $carpeta
        
        $nombreMostrar = switch ($carpeta) {
            "Documents" { "Documentos" }
            "Downloads" { "Descargas" }
            "Pictures"  { "Imágenes" }
            "Music"     { "Música" }
            "Videos"    { "Videos" }
            "Desktop"   { "Escritorio" }
        }

        $syncHash.Status = "Procesando $nombreMostrar..."

        if (Test-Path $ruta) {
            $items = @(Get-ChildItem -Path $ruta -Force)
            $totalItems = $items.Count
            $currentItem = 0

            foreach ($archivo in $items) {
                if ($carpeta -eq "Desktop") {
                    $esLnk = $archivo.Extension.ToLower() -eq ".lnk"
                    $esSistema = ($archivo.Attributes -band [System.IO.FileAttributes]::Hidden) -or ($archivo.Attributes -band [System.IO.FileAttributes]::System)
                    if (-not $esLnk -and -not $esSistema) {
                        Send-ToRecycleBin -FilePath $archivo.FullName
                    }
                } else {
                    Send-ToRecycleBin -FilePath $archivo.FullName
                }
                
                $currentItem++
                if ($totalItems -gt 0) {
                    $progresoParcial = ($currentItem / $totalItems) / $TotalCarpetas
                    $progresoBase = $i / $TotalCarpetas
                    $syncHash.Progress = [math]::Floor(($progresoBase + $progresoParcial) * 100)
                }
            }
        }
    }
    
    $syncHash.Progress = 100
    Start-Sleep -Milliseconds 200
    $syncHash.Done = $true
}

# -----------------------------------------------------------------------------
# TEMPORIZADOR DE LA INTERFAZ
# -----------------------------------------------------------------------------
 $TimerUI = New-Object System.Windows.Threading.DispatcherTimer
 $TimerUI.Interval = [TimeSpan]::FromMilliseconds(100)

 $TimerUI.Add_Tick({
    $TxtEstado.Text = $syncHash.Status
    $BarraProgreso.Value = $syncHash.Progress
    $TxtPorcentaje.Text = "$($syncHash.Progress) %"
    
    if ($syncHash.Done) {
        $TimerUI.Stop()
        $PanelProgreso.Visibility = "Collapsed"
        $PanelExito.Visibility = "Visible"
    }
})

# -----------------------------------------------------------------------------
# FUNCIÓN PARA REINICIAR INTERFAZ (Volver al menú principal)
# -----------------------------------------------------------------------------
function Reset-UI {
    $PanelExito.Visibility = "Collapsed"
    $BtnIniciar.Visibility = "Visible"
    $BarraProgreso.Value = 0
    $TxtPorcentaje.Text = "0 %"
    $TxtEstado.Text = "Preparando..."
}

# -----------------------------------------------------------------------------
# EVENTOS DE BOTONES
# -----------------------------------------------------------------------------
 $BtnIniciar.Add_Click({
    $BtnIniciar.Visibility = "Collapsed"
    $PanelProgreso.Visibility = "Visible"
    $syncHash.Progress = 0
    $syncHash.Done = $false
    
    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.Open()
    $powershell = [powershell]::Create().AddScript($CleanScriptBlock).AddArgument($syncHash)
    $powershell.Runspace = $runspace
    $powershell.BeginInvoke() | Out-Null
    $TimerUI.Start()
})

# SI PULSA "SÍ" -> Notifica, vacía papelera, y VUELVE al menú
 $BtnVaciarSi.Add_Click({
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Show-Notification -Titulo "🧹 JSANTUR ✨" -Mensaje "La papelera de reciclaje se ha vaciado correctamente."
    Reset-UI
})

# SI PULSA "NO" -> Notifica, no hace nada, y VUELVE al menú
 $BtnVaciarNo.Add_Click({
    Show-Notification -Titulo "🧹 JSANTUR ✨" -Mensaje "Los archivos se mantienen seguros en la papelera de reciclaje."
    Reset-UI
})

# -----------------------------------------------------------------------------
# INICIAR APLICACIÓN
# -----------------------------------------------------------------------------
 $Ventana.ShowDialog() | Out-Null