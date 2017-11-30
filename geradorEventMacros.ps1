﻿Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object system.Windows.Forms.Form
$Form.Text = "Form"
$Form.TopMost = $true
$Form.Width = 400
$Form.Height = 100

$cbxJobs = New-Object system.windows.Forms.ComboBox
$cbxJobs.Width = 300
$cbxJobs.location = new-object system.drawing.point(10,20)
$cbxJobs.Items.Add("Arcano")
$cbxJobs.Items.Add("Arcebispo")
$cbxJobs.Items.Add("Bioquímico")
$cbxJobs.Items.Add("Cavaleiro Rúnico")
$cbxJobs.Items.Add("Feiticeiro")
$cbxJobs.Items.Add("Guardião Real")
$cbxJobs.Items.Add("Mecânico")
$cbxJobs.Items.Add("Musa")
$cbxJobs.Items.Add("Renegado")
$cbxJobs.Items.Add("Sentinela")
$cbxJobs.Items.Add("Sicário")
$cbxJobs.Items.Add("Shura")
$cbxJobs.Items.Add("Trovadore")
$Form.controls.Add($cbxJobs)

$btn = New-Object system.windows.Forms.Button
$btn.Text = "Gerar"
$btn.Width = 60
$btn.location = new-object system.drawing.point(310,20)
$Form.controls.Add($btn)

$btn.Add_click({
    $job = $cbxJobs.SelectedItem
    if($job){
        del eventMacros.txt
        Get-Content comum\*.pm | Out-File eventMacros.txt -Encoding UTF8 -append
        $jobSimples = $job.ToString().ToLower().Replace(" ","-").Replace("í","i").Replace("ú","u").Replace("â","a").Replace("ã","a").Replace("á","a")
        Get-Content classes\$jobSimples\*.pm | Out-File eventMacros.txt -Encoding UTF8 -append
        [System.Windows.Forms.MessageBox]::Show("eventMacros.txt para "+$job+" gerado com sucesso!" , "Ok")
        $Form.Dispose()
    }else{
        [System.Windows.Forms.MessageBox]::Show("Selecione uma classe" , "Erro")
    }
})

[void]$Form.ShowDialog()
$Form.Dispose()