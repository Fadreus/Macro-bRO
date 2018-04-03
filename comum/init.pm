automacro init {
    run-once 1
    priority -999 #pioridade altíssmia, sempre vai ser a primeira a executar
    exclusive 1
    BaseLevel > 0
    call {
        # Carregando Plugins necessários
        xConfConfiguratedOrNot() 
        BetterShopperConfiguratedOrNot()
        
        # Configurações de Ids de classe
        
        # Esse sub gera a hash %paramsClasses com as seguintes keys:
        # paramsClasses{idC1} 
        # paramsClasses{idC2} 
        # paramsClasses{idC1T}
        # paramsClasses{idC2T}
        # paramsClasses{idC3} 
        initParamsClasses()

        # Configurações Gerais de Build
        
        # Esse sub gera as hash %configsBuild e %mapa com as seguintes keys:
        # $configsBuild{skillsAprendiz}
        # $configsBuild{skillsClasse1}
        # $configsBuild{skillsClasse2}
        # $configsBuild{skillsClasse1T}
        # $configsBuild{skillsClasse2T}
        # $configsBuild{skillsClasse3}
        # $configsBuild{statsPadrao}
        configurarBuild()

        # Configurações Quests
        
        # Esse sub gera a hash %paramsQuestEden com as seguintes keys:
        # $paramsQuestEden{armaLevel26e40}
        # $paramsQuestEden{armaLevel60}
        initParamsQuestEden()
        
        # Esse sub gera a hash %paramsQuestClasse1 com as seguintes keys:
        # $paramsQuestClasse1{nomeClasse}
        # $paramsQuestClasse1{npc}
        # $paramsQuestClasse1{mapa}
        # $paramsQuestClasse1{precisaMover}
        # $paramsQuestClasse1{sequenciaConversa}
        # $paramsQuestClasse1{equipeIniciante}        
        initParamsQuestClasse1()
        
        # Esse sub gera a hash %paramsQuestClasse1T com as seguintes keys:
        # $paramsQuestClasse1T{nomeClasse}
        # $paramsQuestClasse1T{npc}
        # $paramsQuestClasse1T{mapa}
        # $paramsQuestClasse1T{sequenciaConversa}
        # $paramsQuestClasse1T{equipeIniciante}
        initParamsQuestClasse1T()
        
        # Esse sub gera a hash %paramsQuestClasse2T com a seguinte key:
        # $paramsQuestClasse2T{npc}
        initParamsQuestClasse2T()
        
        # Esse sub por enquanto nao gera nada, porque ainda não foi implementado
        initParamsQuestClasse3()

        # Esse sub gera a hash %paramsQuestClasseRenascer com a seguinte key:
        # $paramsQuestClasseRenascer{renascer}
        # $paramsQuestClasseRenascer{amigo}
        initParamsQuestClasseRenascer()
        
        # Esse sub configura os itens da quest de classe 2 (para não vender nem guardar)
        if ( pegarID() == $paramsClasses{idC1} ) call initParamsQuestClasse2

        if (&config(questc2_implementada) != true && pegarID() = $paramsQuestClasse1{idC1}) {
            [
            log =========================================================
            log   AVISO!
            log   ------
            log Este script para classe escolhida ainda está incompleto.
            log Portanto haverá um grande número de bugs e possivelmente
            log não fará a quest da classe 2.
            log Ao continuar você está ciente de que essa macro não fará
            log tudo por você.
            log ==========================================================
            ]
        }
        
    }
}

automacro atualizadorBuild {
    BaseLevel > 0
    priority -998 #sempre a segunda a executar
    timeout 300 #atualiza as variáveis a cada 5 minutos
    exclusive 1
    call atualizarBuild
}

macro atualizarBuild {

    #parte feita por vitorsilveiro
    $idClasseAtual = pegarID() #sub se encontra no arquivo utilidades.pm
    if (&config(skillsAddAuto) != 1) do conf skillsAddAuto 1
    if ($idClasseAtual == 0 || $idClasseAtual == $paramsClasses{idC1} || $idClasseAtual == $paramsClasses{idC2} || $idClasseAtual == $paramsClasses{idC2Alt} ) {
        if (&config(statsAddAuto_list) != $configsBuild{statsPadrao}) do conf statsAddAuto_list $configsBuild{statsPadrao}
    } else {
        if (&config(statsAddAuto_list) != $configsBuild{statsPadraoTransclasse}) do conf statsAddAuto_list $configsBuild{statsPadraoTransclasse}
    }
    if (&config(statsAddAuto) != 1) do conf statsAddAuto 1
    if (&config(statsAddAuto_dontUseBonus) != 1) do conf statsAddAuto_dontUseBonus 1
    
    #sub 'extrairMapasDeUp' pega o mapa de up e o saveMap correto dependendo do lvl atual
    # $mapa{lockMap}
    # $mapa{saveMap}
    extrairMapasDeUp("$.lvl")
    
    switch ($idClasseAtual) {
        case (~ 0, 161, 4001) { #Aprendiz / Aprendiz T.
            if (&config(skillsAddAuto_list) != $configsBuild{skillsAprendiz}) do conf skillsAddAuto_list $configsBuild{skillsAprendiz}
        }
        case (== $paramsClasses{idC1}) { #Classes 1
            if (&config(skillsAddAuto_list) != $configsBuild{skillsClasse1})  do conf skillsAddAuto_list $configsBuild{skillsClasse1}
        }
        case (~ $paramsClasses{idC2}, $paramsClasses{idC2Alt}) { #Classes 2
            if (&config(skillsAddAuto_list) != $configsBuild{skillsClasse2})  do conf skillsAddAuto_list $configsBuild{skillsClasse2}
        }
        case (== $paramsClasses{idC1T}) { #Classes 1T
            if (&config(skillsAddAuto_list) != $configsBuild{skillsClasse1T}) do conf skillsAddAuto_list $configsBuild{skillsClasse1T}
        }
        case (~ $paramsClasses{idC2T}, $paramsClasses{idC2TAlt} ) { #Classes 2T
            if (&config(skillsAddAuto_list) != $configsBuild{skillsClasse2T}) do conf skillsAddAuto_list $configsBuild{skillsClasse2T}
        }
        case (~ $paramsClasses{idC3}) { #Classes 3
            if (&config(skillsAddAuto_list) != $configsBuild{skillsClasse3})  do conf skillsAddAuto_list $configsBuild{skillsClasse3}
        }
        else {
            do eval Log::error "Nao foi possivel definir qual a sua classe.\n";
            do eval Log::error "Valor encontrado: $idClasseAtual\n";
        }
    }
}

