param ( [string]$job )

#Por quest�es de compatibilidade esse arquivo precisa ser aberto em 
#codifica��o ISO 8859-1 (ANSI) e n�o UTF-8

if (! $job) {
    Add-Type -AssemblyName System.Windows.Forms


    $Form = New-Object system.Windows.Forms.Form
    $listJobs = New-Object system.windows.Forms.ListView
    $btn = New-Object system.windows.Forms.Button
    $imageListIcons = New-Object System.Windows.Forms.ImageList
    $labelConfigsPersonalizadas = New-Object System.Windows.Forms.Label
    $configsPersonalizadas = New-Object System.Windows.Forms.PropertyGrid
    $labelClasseSelecionada = New-Object System.Windows.Forms.Label
    
    if($PSVersionTable.PSVersion.Major -ge 3){
        $classDefinition = '
            using System;
            public class Configuracoes {
                public String skillsAprendiz { get; set; }
                public String skillsClasse1 { get; set; }
                public String skillsClasse2 { get; set; }
                public String skillsClasse1T { get; set; }
                public String skillsClasse2T { get; set; }
                public String skillsClasse3 { get; set; }
                public String statsPadrao { get; set; }
                public String statsPadraoTransclasse { get; set; }
                public String statsPadraoClasse3 { get; set; }
            }
        '
        Add-Type -Language CSharp  -TypeDefinition $classDefinition
        
        $configuracoes = New-Object Configuracoes
    } else {
        [System.Windows.Forms.MessageBox]::Show( "O powershell do seu sistema operacional � muito antigo. As configura��es personalizadas ser�o apenas leitura para visualiza��o", "Aviso" )
        $configuracoes = New-Object -TypeName PSObject -Prop @{ 
            skillsAprendiz = $null;
            skillsClasse1 = $null; 
            skillsClasse2 = $null;
            skillsClasse1T = $null;
            skillsClasse2T = $null;
            skillsClasse3 = $null;
            statsPadrao = $null;
            statsPadraoTransclasse = $null;
            statsPadraoClasse3 = $null;
        }
    }

}

function getVersao {
    $version = "versao_indefinida"
    try {
        $hash = (git rev-parse HEAD) | Out-String
        $hash = $hash.substring(0,7)
        $commitCounter = (git rev-list --count master) | Out-String 
        $commitCounter = $commitCounter -replace "\s+" 
        $version = $commitCounter + "." + $hash 
        
    }catch{
        [System.Windows.Forms.MessageBox]::Show( "Git n�o instalado, n�o vai ser exibida a vers�o", "Erro" )
    }
    return $version
}

function limparNomeDaClasse {
    Param($classe)
    return $classe.ToString().ToLower().Replace(" ","-").Replace("�","i").Replace("�","u").Replace("�","a").Replace("�","a").Replace("�","a")
}

function gerarMacro {
    param ($classe)
    $eventMacros =  "eventMacros.txt"
    #Remover o arquivo antigo
    if (Test-Path $eventMacros) {
      Remove-Item $eventMacros
    }
    $versao = getVersao
    $jobSimples = limparNomeDaClasse($classe)
    $automacroVersao = Get-Content -Encoding UTF8 versao.pm 
    $automacroVersao = $automacroVersao -replace "<versao>",$versao
    $automacroVersao | Out-File $eventMacros -Encoding UTF8 -append 
    Get-Content -Encoding UTF8 classes\$jobSimples\*.pm | Out-File $eventMacros -Encoding UTF8 -append
    Get-Content -Encoding UTF8 comum\*.pm | Out-File $eventMacros -Encoding UTF8 -append
}

function salvarBuild {
    param ($classe)
    $arquivo = "classes/$classe/config.pm"
    $config = $configsPersonalizadas.SelectedObject
    $tempFile = "classes/$classe/config.pm.tmp"
    foreach($line in Get-Content -Encoding UTF8 $arquivo) {
        if($line -match "^\s+\w+\s+=>\s+'.*"){
            $chave = $line -replace "\s+(\w+)\s+\=\>.*",'$1'
            $novoValor = $config."$chave"
            $line -replace "'.*'","'$novoValor'" | Out-File $tempFile -Encoding UTF8 -append
        } else {
            $line | Out-File $tempFile -Encoding UTF8 -append
        }
    }
    Remove-Item $arquivo
    Rename-Item -Path $tempFile -NewName "config.pm"

}

function acaoBotaoGerar {
    $classe = $listJobs.SelectedItems
    if ($classe.Count -eq 1) {
        $classeSelecionada = $classe[0].Text
        salvarBuild($classeSelecionada)
        gerarMacro($classeSelecionada)
        [System.Windows.Forms.MessageBox]::Show("eventMacros.txt para $classeSelecionada gerado com sucesso!" , "Ok")
        $Form.Dispose()
    } else{
        [System.Windows.Forms.MessageBox]::Show("Erro, nenhum item selecionado", "Selecione uma classe")
    }
}

function acaoCarregarConfiguracoes {
    $classe = $listJobs.SelectedItems
    if ($classe.Count -eq 1) {
        $classeSelecionada = $classe[0].Text
        Write-Host "Classe selecionada: $classeSelecionada"

        $labelClasseSelecionada.Text = "Classe selecionada: $classeSelecionada"
        $c = limparNomeDaClasse($classe[0].Text)
        $arquivo = "classes/$c/config.pm"
        Write-Host "Abrindo arquivo: $arquivo"
        foreach($line in Get-Content -Encoding UTF8 $arquivo) {

            if($line -match "^\s+\w+\s+=>\s+'.*"){
                Write-Host "Linha de configura��o: $line"
                $chave = $line -replace "\s+(\w+)\s+\=\>.*",'$1'
                $valor = $line -replace ".*'(.*)'.*",'$1'
                
                $configuracoes."$chave" = $valor
                                
            }
           
        }
        $configsPersonalizadas.SelectedObject = $configuracoes

    } else {
        $labelClasseSelecionada.Text = "Classe selecionada: "
        
    }
}


function desenharJanela {
    $versao = getVersao
    $Form.Text = "Gerador eventMacros.txt vers�o: " + $versao
    $Form.TopMost = $true
    $Form.Width = 800
    $Form.Height = 600


    $listJobs.Width = 760
    $listJobs.Height = 130
    $listJobs.location = New-Object system.drawing.point(10,20)
    $Form.controls.Add($listJobs)
    $listJobs.View = "LargeIcon"
    $listJobs.LargeImageList = $imageListIcons
    $listJobs.MultiSelect = 0
    $listJobs.Add_click({ acaoCarregarConfiguracoes })

    $labelClasseSelecionada.Width = 400
    $labelClasseSelecionada.Text = "Classe selecionada: "
    $labelClasseSelecionada.Location = New-Object system.drawing.point(10,160)
    $Form.controls.Add($labelClasseSelecionada)

    $labelConfigsPersonalizadas.Text = "Configura��es Personalizadas"
    $labelConfigsPersonalizadas.Width = 400
    $labelConfigsPersonalizadas.location = New-Object system.drawing.point(10,195)
    $Form.controls.Add($labelConfigsPersonalizadas)

    $configsPersonalizadas.Width = 760
    $configsPersonalizadas.Height = 300
    $configsPersonalizadas.location = New-Object system.drawing.point(10,220)
    $configsPersonalizadas.SelectedObject = $configuracoes
    $Form.controls.Add($configsPersonalizadas)

    
    $btn.Text = "Gerar"
    $btn.Width = 60
    $btn.location = New-Object system.drawing.point(710,520)
    $Form.controls.Add($btn)
    $Form.AcceptButton = $btn

    $btn.Add_click({ acaoBotaoGerar })
}

function carregarValores {
    
    $classes = "Cavaleiro R�nico", "Guardi�o Real", "Arcano", "Feiticeiro", "Sentinela", "Trovador", "Musa", "Mec�nico", "Bioqu�mico", "Sic�rio", "Renegado", "Arcebispo", "Shura", "Mestre Taekwon", "Espiritualista", "Kagerou", "Oboro", "Justiceiro", "Superaprendiz"

    For ($i=0; $i -lt $classes.Count; $i++) {
        $listItemClasse = New-Object System.Windows.Forms.ListViewItem
        $classe = limparNomeDaClasse($classes[$i])
        $imageListIcons.Images.Add([System.Drawing.Image]::FromFile("gerador-images/$classe.png"))
        $listItemClasse.ImageIndex = $i
        $listItemClasse.Text = $classes[$i]
        
        $listJobs.Items.Add($listItemClasse)
    } 
}

function mostrarJanela {
    [void]$Form.ShowDialog()
}

function encerrarAplicacao {
    $Form.Dispose()
}

function updater {
    if(getVersao -ne "versao_indefinida") {
        git fetch
        $versao_atual = (git rev-list --count origin/master) | Out-String
        $versao_local = (git rev-list --count master) | Out-String
        if($versao_atual -ne $versao_local) {
            $confirmacao = [System.Windows.Forms.MessageBox]::Show( "Nova vers�o dispon�vel. Gostaria de atualizar sua vers�o?", "Vers�o desatualizada", [Windows.Forms.MessageBoxButtons]::YesNo )
            if ($confirmacao -eq "YES"){
                git stash save
                git pull --rebase
                git stash pop
            }
        }
    }
}

if(! $job){
    updater
    desenharJanela
    carregarValores
    mostrarJanela
    encerrarAplicacao
}else{
    gerarMacro($job)
}
