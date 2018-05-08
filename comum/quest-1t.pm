automacro questClasse1T_virandoClasse1T_bugada {
    JobLevel = 10
    JobID 161 #aprendiz T.
    InMapRegex /^(?!new_\d-\d)$/
    SkillLevel NV_BASIC != 9
    exclusive 1
    call {
        $pontos = $.SkillLevelLastLevel
        log As Habilidades básicas nao foram distribuídas!!!
        log A skill ta lvl $.SkillLevelLastLevel
        log Mudando isso
        while ($pontos < 9 ) {
            do skills add NV_BASIC
            $pontos++
        }
    }
}
automacro questClasse1T_irAteNpc {
    NotInMap $parametrosQuestClasse1T{mapa}
    JobID 161,4001 #Aprendiz
    JobLevel 10
    SkillLevel NV_BASIC = 9
    exclusive 1
    call {
        do conf lockMap none
        call pararDeAtacar
        do conf -f virandoClasse1T true
        do conf -f o_que_estou_fazendo virandoClasse1Trans
        log cidade: $parametrosQuestClasse1T
        do move $parametrosQuestClasse1T{mapa} $parametrosQuestClasse1T{npc} &rand(1,5)
    }
}

automacro questClasse1T_virandoClasse1T {
    InMap $parametrosQuestClasse1T{mapa}
    JobID 161,4001 #Aprendiz
    JobLevel 10
    SkillLevel NV_BASIC = 9
    exclusive 1
    call {
        # $parametrosQuestClasse1T{mapa} tem como valor o mapa em vc vira classe 1
        # $parametrosQuestClasse1T{npc} contem as coordenadas do npc
        # $parametrosQuestClasse1T{sequenciaConversa} tem como valor a sequencia de conversação correta
        # $parametrosQuestClasse1T{equipeIniciante} tem como valor a id da arma que vc recebe quando vira classe 1
        do conf -f virandoClasse1T true
        do conf -f o_que_estou_fazendo virandoClasse1Trans
        log mapa: "$parametrosQuestClasse1T{mapa}"
        log npc:  "$parametrosQuestClasse1T{npc}"
        log sequenciaConversa: "$parametrosQuestClasse1T{sequenciaConversa}"
        log equip: "$parametrosQuestClasse1T{equipeIniciante}"
        #repetindo o comando de se mover só por desencargo de consciencia
        do move $parametrosQuestClasse1T{mapa} $parametrosQuestClasse1T{npc} &rand(1,5)
        if (a$parametrosQuestClasse1T{sequenciaConversa} = a) {
            log iniciando conversa sem sequencia
            do talknpc $parametrosQuestClasse1T{npc}
        } else {
            log conversa tem sequencia, usando ela
            do talknpc $parametrosQuestClasse1T{npc} $parametrosQuestClasse1T{sequenciaConversa}
        }
    }
}

automacro questClasse1T_jaSouClasse1T {
    JobID $parametrosClasses{idC1T}
    ConfigKey virandoClasse1T true
    exclusive 1
    call {
        call atualizarBuild
        do iconf 2393 0 0 0 #Tunica de Iniciante
        do iconf $parametrosQuestClasse1T{equipeIniciante} 0 0 0
        $check = GetIndexAndEquipped("armor", 2393) #Tunica de Iniciante
        if ($check != -1) do eq $check
        $check = GetIndexAndEquipped("rightHand", "$parametrosQuestClasse1T{equipeIniciante}")
        if ($check != -1) do eq $check
        do conf virandoClasse1T none
        
        do conf -f o_que_estou_fazendo acabeiDeVirarClasse1T
    }
}

