
sub configurarBuild {
    my %configsBuild = (
        skillsAprendiz => 'NV_BASIC 9',
        skillsClasse1 => 'MG_LIGHTNINGBOLT 5, MG_FIREBOLT 7, MG_COLDBOLT 7,MG_SRECOVERY 10, MG_FIREBOLT 10, MG_COLDBOLT 10, MG_STONECURSE 1, MG_FROSTDIVER 10,MG_SOULSTRIKE 3',
        skillsClasse2 => '',
        skillsClasse1T => 'MG_LIGHTNINGBOLT 5, MG_FIREBOLT 7, MG_COLDBOLT 7,MG_SRECOVERY 10, MG_FIREBOLT 10, MG_COLDBOLT 10, MG_STONECURSE 1, MG_FROSTDIVER 10,MG_SOULSTRIKE 3',
        skillsClasse2T => '',
        skillsClasse3 => '',
        statsPadrao => '70 int, 50 dex, 20 vit, 90 int, 65 vit, 99 int, 70 dex',
        statsPadraoTransclasse => '70 int, 50 dex, 20 vit, 90 int, 65 vit, 99 int, 70 dex',
        statsPadraoClasse3 => ''
    );
    my $eventMacro = $eventMacro::Data::eventMacro;
    $eventMacro->set_full_hash('configsBuild', \%configsBuild);
}


sub extrairMapasDeUp {
    my ($lvl) = @_;
    my $variaveisDeUp;
    
    #########################################################################
    #AQUI É DEFINIDO OS MAPAS QUE CADA CLASSE IRÁ UPAR, DE MODO 
    #QUE SEJA EXTREMAMENTE FÁCIL DE ALTERAR A SEU GOSTO
    ########################################################################

    $variaveisDeUp = 
    [
        {lvlMin => 1 , lvlMax => 11, lockMap => 'gef_fild04',  saveMap => 'geffen'},
        {lvlMin => 12, lvlMax => 25, lockMap => 'pay_fild08',  saveMap => 'payon'},
        {lvlMin => 26, lvlMax => 40, lockMap => 'pay_dun00',   saveMap => 'payon'},
        {lvlMin => 41, lvlMax => 45, lockMap => 'moc_fild03',  saveMap => 'payon'},
        {lvlMin => 46, lvlMax => 60, lockMap => 'cmd_fild01',  saveMap => 'comodo'},
        {lvlMin => 60, lvlMax => 70, lockMap => 'moc_fild17',  saveMap => 'morocc'},
        {lvlMin => 71, lvlMax => 79, lockMap => 'yuno_fild09', saveMap => 'aldebaran'},
        {lvlMin => 80, lvlMax => 98, lockMap => 'ein_fild09',  saveMap => 'einbroch'}
    ];
    
    
    foreach my $configs (@{$variaveisDeUp}) {
        #mensagem para debug
        #warning "lvl min: " . $configs->{lvlMin}.' '. "lvl max: " . $configs->{lvlMax}."\n";
        if ($configs->{lvlMin} <= $lvl && $lvl <= $configs->{lvlMax}) {  #checa em qual "grupo" (de lvlMin e lvlMax) seu nivel se encaixa
            my %hash = (lockMap => $configs->{lockMap}, saveMap => $configs->{saveMap});
            my $eventMacro = $eventMacro::Data::eventMacro;
               $eventMacro->set_full_hash('mapa', \%hash);
        }    
    }
}

sub inicializarParametrosQuestClasseRenascer {
    my %parametrosQuestClasseRenascer = (
        renascer => 'nao',
        amigo => '',
        #observação sobre o ponto de encontro:
        #só poderá ser as coordenadas, não coloque nome de cidade aqui, senão é treta
        #a cidade sempre será obrigatoriamente em juno, já que o reborn se passa por lá
        #altere a coordenada a seu prazer, fique a vontade
        pontoDeEncontro => '146 116'
    );
    my $eventMacro = $eventMacro::Data::eventMacro;
    $eventMacro->set_full_hash('parametrosQuestClasseRenascer', \%parametrosQuestClasseRenascer);
}

