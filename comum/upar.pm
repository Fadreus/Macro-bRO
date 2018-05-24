automacro UpClasse {
    BaseLevel != 99
    ConfigKeyNot quest_eden em_curso
    ConfigKeyNot quest_eden terminando
    ConfigKeyNot naSequenciaDeSalvamento true
    ConfigKeyNot virarClasse2 true
    ConfigKeyNot virarClasse2T true
    ConfigKeyNot quest_skill true
    ConfigKeyNot esperarFazerQuest true
    ConfigKeyNot lockMap $mapa{lockMap}
    ConfigKey aeroplano1 none
    ConfigKey aeroplano2 none
    ConfigKey questRenascer_estagio none
    exclusive 1
    priority 20 #baixa prioridade
    timeout 30
    JobIDNot 0 #Ou o campo de treinamento fica louco
    JobIDNot 4023 #Baby Aprendiz
    call upar
}

automacro UpClasseEspecial {
    BaseLevel >= 99
    ConfigKeyNot naSequenciaDeSalvamento true
    ConfigKeyNot esperarFazerQuest true
    ConfigKeyNot lockMap $mapa{lockMap}
    ConfigKey aeroplano1 none
    ConfigKey aeroplano2 none
    exclusive 1
    priority 20 #baixa prioridade
    timeout 30
    JobID $parametrosClasses{idC3}, $parametrosClasses{idC3Alt}, $parametrosClasses{idBC3}, $parametrosClasses{idCB3Alt}
    call upar
}

macro upar {
    
    if (&config(lockMap) = $mapa{lockMap}) {
        [
        log ================================
        log =Tudo Configurado
        log =Continuarei upando em $mapa{lockMap}
        log ================================
        ]
        call voltarAtacar
        do conf -f o_que_estou_fazendo upando
        stop
    }
    
    #se chegar ate aqui é porque tem algo a ser configurado
    log vou upar em: $mapa{lockMap}
    
    #se chegar aqui significa que tem que ser mudado o lockMap e/ou o saveMap
    if (&config(saveMap) = $mapa{saveMap}) {
        [
        log =====================================
        log =Já estou salvo em $mapa{saveMap}
        log =Configurando lockMap 
        log =====================================
        ]
        do conf lockMap $mapa{lockMap}
        call voltarAtacar
        do conf -f o_que_estou_fazendo upando
    } else {
        log vou salvar em: $mapa{saveMap}
        call pararDeAtacar
        do conf lockMap none
        
        salvarOndeVouUpar(&config(saveMap), $mapa{saveMap})
        
    }
}

automacro estouLv99 {
    BaseLevel = 99
    ConfigKey questRenascer_estagio none
    exclusive 1
    timeout 120
    JobID $parametrosClasses{idC2}, $parametrosClasses{idC2Alt}, $parametrosClasses{idC2T}, $parametrosClasses{idC2TAlt}, $parametrosClasses{idBC2}, $parametrosClasses{idBC2Alt}
    call {
        log CHEGUEI NO LVL 99 FINALMENTE !!!!!!!
        log CARA ISSO LEVOU TEMPO PARA CAR**HO
    }
}

sub salvarOndeVouUpar {
    my $mapaOrigem = $_[0];
    my $mapaDestino = $_[1];

    my @rotas = (
        { de => 'hugel', para => 'rachel', usar => 'aeroplano_hugelPara "rachel"'},
        { de => 'hugel', para => 'veins', usar => 'aeroplano_hugelPara "rachel"'},
        { de => 'hugel', para => 'einbroch', usar => 'aeroplano_hugelPara "einbroch"'},
        { de => 'hugel', para => 'juno', usar => 'aeroplano_hugelPara "juno"'},
        { de => 'hugel', para => '*',  usar => 'aeroplano_hugelPara "izlude"'},
        { de => 'rachel', para => 'hugel', usar => 'aeroplano_rachelPara "rachel"'},
        { de => 'rachel', para => 'veins', usar => 'salvarNaCidade "veins"'},
        { de => 'rachel', para => 'einbroch', usar => 'aeroplano_rachelPara "einbroch"'},
        { de => 'rachel', para => 'juno', usar => 'aeroplano_rachelPara "juno"'},
        { de => 'rachel', para => '*',  usar => 'aeroplano_rachelPara "izlude"'},
        { de => 'veins', para => 'hugel', usar => 'aeroplano_rachelPara "rachel"'},
        { de => 'veins', para => 'rachel', usar => 'salvarNaCidade "rachel"'},
        { de => 'veins', para => 'einbroch', usar => 'aeroplano_rachelPara "einbroch"'},
        { de => 'veins', para => 'juno', usar => 'aeroplano_rachelPara "juno"'},
        { de => 'veins', para => '*',  usar => 'aeroplano_rachelPara "izlude"'},
        { de => '*', para => 'hugel',  usar => 'aeroplano_junoPara "hugel"'},
        { de => '*', para => 'rachel',  usar => 'aeroplano_junoPara "rachel"'},
        { de => '*', para => 'veins',  usar => 'aeroplano_junoPara "rachel"'},
        { de => '*', para => 'einbroch',  usar => 'aeroplano_junoPara "einbroch"'},
        { de => '*', para => '*',  usar => 'salvarNaCidade "{param}"'}
    );

    foreach my $rota (@{$rotas}) {
        if ($mapaOrigem eq $rota->{de}) {
            if ($mapaDestino eq $rota->{para}) {
                Commands::run("eventMacro $rota{$usar}");
                last;
            } else {
                if ($rota->{para} eq "*") {
                    Commands::run("eventMacro $rota{$usar}");
                    last;
                }
            }
        } else {
            if ($rota->{de} eq "*") {
                if ($mapaDestino = $rota->{para}) {
                    Commands::run("eventMacro $rota{$usar}");
                    last;
                } else {
                    if ($rota->{para} eq "*") {
                        Commands::run("eventMacro salvarNaCidade $salvarNaCidade");
                        last;
                    }
                }
            }
        }
    }
}

