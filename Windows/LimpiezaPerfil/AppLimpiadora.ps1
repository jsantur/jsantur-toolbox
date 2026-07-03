# =============================================================================
# JSANTUR TOOLBOX - LIMPIEZA DE PERFIL (DISEÑO SPLIT-SCREEN)
# =============================================================================

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# -----------------------------------------------------------------------------
# FUNCIÓN: NOTIFICACIÓN TIPO SMS (BalloonTip)
# -----------------------------------------------------------------------------
function Show-Notification {
    param([string]$Titulo, [string]$Mensaje)
    try {
        $icon = [System.Drawing.SystemIcons]::Information
        $iconStream = New-Object System.IO.MemoryStream
        $icon.Save($iconStream)
        $iconStream.Position = 0
        $bitmapIcon = New-Object System.Drawing.Icon($iconStream)
        $notify = New-Object System.Windows.Forms.NotifyIcon
        $notify.Icon = $bitmapIcon
        $notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
        $notify.BalloonTipTitle = $Titulo
        $notify.BalloonTipText = $Mensaje
        $notify.Visible = $true
        $notify.ShowBalloonTip(4000)
        $timerCleanup = New-Object System.Windows.Forms.Timer
        $timerCleanup.Interval = 5000
        $timerCleanup.Add_Tick({ $notify.Dispose(); $timerCleanup.Stop(); $timerCleanup.Dispose() })
        $timerCleanup.Start()
    } catch {}
}

# -----------------------------------------------------------------------------
# DISEÑO DE INTERFAZ GRÁFICA (XAML SPLIT-SCREEN)
# -----------------------------------------------------------------------------
[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="🧹 JSANTUR ✨" Height="560" Width="880"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        WindowStartupLocation="CenterScreen" ResizeMode="NoResize">
    
    <!-- Borde principal externo (Sombra y esquinas redondeadas globales) -->
    <Border Background="White" CornerRadius="12" Margin="10">
        <Border.Effect>
            <DropShadowEffect BlurRadius="30" ShadowDepth="0" Opacity="0.2" Color="#000000"/>
        </Border.Effect>
        
        <Grid>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="300"/> <!-- Panel Izquierdo Fijo -->
                <ColumnDefinition Width="*"/>    <!-- Panel Derecho Dinámico -->
            </Grid.ColumnDefinitions>

            <!-- ================================================================== -->
            <!-- PANEL IZQUIERDO: BRANDING Y HUB (JSANTUR TOOLBOX)                  -->
            <!-- ================================================================== -->
            <Border Grid.Column="0" Background="#F8F9FA" CornerRadius="12,0,0,12" Padding="35,40,35,40">
                <Grid VerticalAlignment="Center">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>

                    <!-- Títulos -->
                    <TextBlock Grid.Row="0" Text="JSANTUR" FontSize="30" FontWeight="Bold" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#1a1a1a"/>
                    <TextBlock Grid.Row="1" Text="TOOLBOX" FontSize="30" FontWeight="Light" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#555555" Margin="0,-5,0,25"/>
                    
                    <!-- Descripción -->
                    <TextBlock Grid.Row="2" Text="Scripts y herramientas de automatización para Windows." FontSize="13" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#666666" TextWrapping="Wrap" Margin="0,0,0,30"/>

                    <!-- Tags/Chips de tecnología -->
                    <WrapPanel Grid.Row="3" VerticalAlignment="Top">
                        <Border Background="#E9ECEF" CornerRadius="12" Padding="10,5" Margin="0,0,8,8">
                            <TextBlock Text="PowerShell" FontSize="12" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#495057" FontWeight="Medium"/>
                        </Border>
                        <Border Background="#E9ECEF" CornerRadius="12" Padding="10,5" Margin="0,0,8,8">
                            <TextBlock Text="WPF + XAML" FontSize="12" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#495057" FontWeight="Medium"/>
                        </Border>
                        <Border Background="#E9ECEF" CornerRadius="12" Padding="10,5" Margin="0,0,8,8">
                            <TextBlock Text="Batch" FontSize="12" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#495057" FontWeight="Medium"/>
                        </Border>
                    </WrapPanel>

                    <!-- Eslogan inferior -->
                    <TextBlock Grid.Row="4" Text="Automatiza. Optimiza. Simplifica." FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#343a40" FontWeight="SemiBold" Margin="0,20,0,0"/>
                </Grid>
            </Border>

            <!-- Línea divisoria sutil -->
            <Border Grid.Column="0" HorizontalAlignment="Right" Width="1" Background="#E0E0E0" Margin="0,20,0,20"/>

            <!-- ================================================================== -->
            <!-- PANEL DERECHO: HERRAMIENTA LIMPIEZA DE PERFIL                     -->
            <!-- ================================================================== -->
            <Grid Grid.Column="1" Margin="35,30,35,30">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/> <!-- Título Herramienta -->
                    <RowDefinition Height="Auto"/> <!-- Checkboxes -->
                    <RowDefinition Height="*"/>    <!-- Espaciador -->
                    <RowDefinition Height="Auto"/> <!-- Botón / Progreso / Éxito -->
                    <RowDefinition Height="Auto"/> <!-- Footer de características -->
                </Grid.RowDefinitions>

                <!-- Cabecera de la herramienta y botón cerrar global -->
                <Grid Grid.Row="0" Margin="0,0,0,20">
                    <StackPanel>
                        <TextBlock Text="Limpieza de Perfil de Usuario" FontSize="20" FontWeight="SemiBold" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#1a1a1a"/>
                        <TextBlock Text="Selecciona las ubicaciones y limpia tu sistema de forma segura." FontSize="13" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#888888" Margin="0,5,0,0"/>
                    </StackPanel>
                    <Button x:Name="BtnCerrar" Content="✕" HorizontalAlignment="Right" VerticalAlignment="Top" 
                            Width="28" Height="28" FontSize="12" FontWeight="Bold" Foreground="#888888" 
                            Background="Transparent" BorderThickness="0" Cursor="Hand"/>
                </Grid>

                <!-- Lista de Checkboxes (Estilo moderno) -->
                <StackPanel Grid.Row="1" Margin="0,0,0,10">
                    <CheckBox x:Name="ChkEscritorio" Content="Escritorio" IsChecked="True" Margin="0,8"/>
                    <CheckBox x:Name="ChkDescargas" Content="Descargas" IsChecked="True" Margin="0,8"/>
                    <CheckBox x:Name="ChkDocumentos" Content="Documentos" IsChecked="True" Margin="0,8"/>
                    <CheckBox x:Name="ChkImagenes" Content="Imágenes" IsChecked="True" Margin="0,8"/>
                    <CheckBox x:Name="ChkMusica" Content="Música" IsChecked="True" Margin="0,8"/>
                    <CheckBox x:Name="ChkVideos" Content="Videos" IsChecked="True" Margin="0,8"/>
                </StackPanel>

                <!-- BOTÓN INICIAR -->
                <Button x:Name="BtnIniciar" Grid.Row="3" Height="45" FontSize="15" 
                        FontFamily="Segoe UI Variable, Segoe UI" FontWeight="SemiBold"
                        Content="Iniciar limpieza" Background="#2C2C2C" Foreground="White"
                        BorderThickness="0" Cursor="Hand" Margin="0,15,0,0">
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

                <!-- PANEL DE PROGRESO (Oculto inicialmente) -->
                <Grid x:Name="PanelProgreso" Grid.Row="3" Visibility="Collapsed" Margin="0,15,0,0">
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

                <!-- PANEL DE ÉXITO (Oculto inicialmente) -->
                <Grid x:Name="PanelExito" Grid.Row="3" Visibility="Collapsed" Margin="0,15,0,0">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>
                    <StackPanel Grid.Row="0" Orientation="Horizontal" Margin="0,0,0,10">
                        <TextBlock Text="✓ " FontSize="18" Foreground="#34C759" FontWeight="Bold" VerticalAlignment="Center"/>
                        <TextBlock Text="Limpieza finalizada correctamente." FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#1a1a1a" VerticalAlignment="Center"/>
                    </StackPanel>
                    <TextBlock Grid.Row="1" Text="¿Desea vaciar ahora la Papelera de reciclaje?" FontSize="13" FontFamily="Segoe UI Variable, Segoe UI" Foreground="#555555" Margin="0,0,0,15"/>
                    <StackPanel Grid.Row="2" Orientation="Horizontal" HorizontalAlignment="Left">
                        <Button x:Name="BtnVaciarSi" Content="Sí" Width="100" Height="38" Margin="0,0,10,0" FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Background="#2C2C2C" Foreground="White" BorderThickness="0" Cursor="Hand">
                            <Button.Style><Style TargetType="Button"><Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button"><Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="8"><ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/></Border><ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="border" Property="Background" Value="#444444"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter></Style></Button.Style>
                        </Button>
                        <Button x:Name="BtnVaciarNo" Content="No" Width="100" Height="38" FontSize="14" FontFamily="Segoe UI Variable, Segoe UI" Background="#F0F0F0" Foreground="#333333" BorderThickness="0" Cursor="Hand">
                            <Button.Style><Style TargetType="Button"><Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button"><Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="8"><ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/></Border><ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="border" Property="Background" Value="#E0E0E0"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter></Style></Button.Style>
                        </Button>
                    </StackPanel>
                </Grid>

                <!-- Footer de características -->
                <WrapPanel Grid.Row="4" Margin="0,20,0,0" Orientation="Horizontal">
                    <TextBlock Text="🛡️ Seguro" FontSize="11" Foreground="#999" FontFamily="Segoe UI Variable, Segoe UI" Margin="0,0,15,0"/>
                    <TextBlock Text="⚡ Rápido" FontSize="11" Foreground="#999" FontFamily="Segoe UI Variable, Segoe UI" Margin="0,0,15,0"/>
                    <TextBlock Text="🔄 Recuperable" FontSize="11" Foreground="#999" FontFamily="Segoe UI Variable, Segoe UI"/>
                </WrapPanel>

            </Grid>
        </Grid>
    </Border>
    
    <!-- ESTILO GLOBAL PARA LOS CHECKBOXES MODERNOS -->
    <Window.Resources>
        <Style TargetType="CheckBox">
            <Setter Property="FontFamily" Value="Segoe UI Variable, Segoe UI"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="Foreground" Value="#333333"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="CheckBox">
                        <Grid Margin="0,2">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="20"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <Border x:Name="CheckBorder" Width="18" Height="18" CornerRadius="4" Background="#F0F0F0" BorderThickness="1.5" BorderBrush="#CCCCCC" VerticalAlignment="Center"/>
                            <Path x:Name="CheckMark" Data="M 3 8 L 7 12 L 15 4" Stroke="White" StrokeThickness="2" StrokeLineJoin="Round" Visibility="Collapsed" VerticalAlignment="Center" HorizontalAlignment="Center" Margin="1,0,0,0"/>
                            <ContentPresenter Grid.Column="1" Content="{TemplateBinding Content}" VerticalAlignment="Center" Margin="12,0,0,0"/>
                        </Grid>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsChecked" Value="True">
                                <Setter TargetName="CheckBorder" Property="Background" Value="#2C2C2C"/>
                                <Setter TargetName="CheckBorder" Property="BorderBrush" Value="#2C2C2C"/>
                                <Setter TargetName="CheckMark" Property="Visibility" Value="Visible"/>
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="CheckBorder" Property="BorderBrush" Value="#999999"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
</Window>
"@

# -----------------------------------------------------------------------------
# CARGAR INTERFAZ
# -----------------------------------------------------------------------------
 $Reader = New-Object System.Xml.XmlNodeReader $XAML
 $Ventana = [System.Windows.Markup.XamlReader]::Load($Reader)

# Controles de Cierre
 $BtnCerrar = $Ventana.FindName("BtnCerrar")
 $BtnCerrar.Add_Click({ $Ventana.Close() })
 $Ventana.Add_PreviewKeyDown({ if ($_.Key -eq 'Escape') { $Ventana.Close() } })

# Controles Principales
 $BtnIniciar = $Ventana.FindName("BtnIniciar")
 $PanelProgreso = $Ventana.FindName("PanelProgreso")
 $PanelExito = $Ventana.FindName("PanelExito")
 $BarraProgreso = $Ventana.FindName("BarraProgreso")
 $TxtEstado = $Ventana.FindName("TxtEstado")
 $TxtPorcentaje = $Ventana.FindName("TxtPorcentaje")
 $BtnVaciarSi = $Ventana.FindName("BtnVaciarSi")
 $BtnVaciarNo = $Ventana.FindName("BtnVaciarNo")

# Checkboxes
 $ChkEscritorio = $Ventana.FindName("ChkEscritorio")
 $ChkDescargas = $Ventana.FindName("ChkDescargas")
 $ChkDocumentos = $Ventana.FindName("ChkDocumentos")
 $ChkImagenes = $Ventana.FindName("ChkImagenes")
 $ChkMusica = $Ventana.FindName("ChkMusica")
 $ChkVideos = $Ventana.FindName("ChkVideos")

# -----------------------------------------------------------------------------
# VARIABLES COMPARTIDAS
# -----------------------------------------------------------------------------
 $syncHash = [hashtable]::Synchronized(@{})
 $syncHash.Progress = 0
 $syncHash.Status = "Preparando..."
 $syncHash.Done = $false

# -----------------------------------------------------------------------------
# CÓDIGO DE LIMPIEZA (HILO SEPARADO - AHORA RESPETA LOS CHECKBOXES)
# -----------------------------------------------------------------------------
 $CleanScriptBlock = {
    param($syncHash)
    
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

    # Construir la lista de carpetas basándose en lo que el usuario marcó
    $CarpetasSeleccionadas = @()
    if ($syncHash.ChkEscritorio) { $CarpetasSeleccionadas += @("Desktop", "Escritorio") }
    if ($syncHash.ChkDescargas) { $CarpetasSeleccionadas += @("Downloads", "Descargas") }
    if ($syncHash.ChkDocumentos) { $CarpetasSeleccionadas += @("Documents", "Documentos") }
    if ($syncHash.ChkImagenes) { $CarpetasSeleccionadas += @("Pictures", "Imágenes") }
    if ($syncHash.ChkMusica) { $CarpetasSeleccionadas += @("Music", "Música") }
    if ($syncHash.ChkVideos) { $CarpetasSeleccionadas += @("Videos", "Videos") }

    $TotalCarpetas = $CarpetasSeleccionadas.Count / 2

    for ($i = 0; $i -lt $TotalCarpetas; $i++) {
        $indiceReal = $i * 2
        $carpeta = $CarpetasSeleccionadas[$indiceReal]
        $nombreMostrar = $CarpetasSeleccionadas[$indiceReal + 1]
        $ruta = Join-Path $env:USERPROFILE $carpeta
        
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
# FUNCIONES DE INTERFAZ
# -----------------------------------------------------------------------------
function Reset-UI {
    $PanelExito.Visibility = "Collapsed"
    $BtnIniciar.Visibility = "Visible"
    $BarraProgreso.Value = 0
    $TxtPorcentaje.Text = "0 %"
    $TxtEstado.Text = "Preparando..."
}

 $BtnIniciar.Add_Click({
    $BtnIniciar.Visibility = "Collapsed"
    $PanelProgreso.Visibility = "Visible"
    $syncHash.Progress = 0
    $syncHash.Done = $false
    
    # Pasar el estado de los checkboxes al hilo de fondo
    $syncHash.ChkEscritorio = $ChkEscritorio.IsChecked
    $syncHash.ChkDescargas = $ChkDescargas.IsChecked
    $syncHash.ChkDocumentos = $ChkDocumentos.IsChecked
    $syncHash.ChkImagenes = $ChkImagenes.IsChecked
    $syncHash.ChkMusica = $ChkMusica.IsChecked
    $syncHash.ChkVideos = $ChkVideos.IsChecked

    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.Open()
    $powershell = [powershell]::Create().AddScript($CleanScriptBlock).AddArgument($syncHash)
    $powershell.Runspace = $runspace
    $powershell.BeginInvoke() | Out-Null
    $TimerUI.Start()
})

 $BtnVaciarSi.Add_Click({
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Show-Notification -Titulo "🧹 JSANTUR ✨" -Mensaje "La papelera de reciclaje se ha vaciado correctamente."
    Reset-UI
})

 $BtnVaciarNo.Add_Click({
    Show-Notification -Titulo "🧹 JSANTUR ✨" -Mensaje "Los archivos se mantienen seguros en la papelera de reciclaje."
    Reset-UI
})

# -----------------------------------------------------------------------------
# INICIAR APLICACIÓN
# -----------------------------------------------------------------------------
 $Ventana.ShowDialog() | Out-Null