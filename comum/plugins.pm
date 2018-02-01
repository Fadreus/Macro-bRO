### Instalação e configuração do xconf
sub xConfConfiguratedOrNot {
    use File::Copy;
    
    my ($estaAtualizado, $estaNaPasta, $estaNoSys);
    my $path_xconf_na_pasta_plugins = "plugins/xConf/xConf.pl";
    my $path_xconf_na_pasta_needsreview = "plugins/needs-review/xconf/trunk/xconf.pl";
    
    unlink "plugins/xConf.pl" if -e "plugins/xConf.pl";
    
    if (-e $path_xconf_na_pasta_plugins) {
        $estaNaPasta = 1;
        $estaAtualizado = 1
    } else {
        error "Seu openkore está desatualizado, atualize-o.\n";
        error "Devido a isso o plugin xConf poderá não funcionar corretamente\n.";
        $estaNaPasta = 0;
        $estaAtualizado = 0;
    }
    
    my $controlfile = Settings::getControlFilename('sys.txt');
    open(FILE, '<:encoding(UTF-8)', $controlfile);
    my @lines = <FILE>;
    close(FILE);
    chomp @lines;
    foreach my $line (@lines) {
        next if $line =~ /^$/ || $line =~ /^#/;
        if ($line =~ /xconf/ ) {
            $estaNoSys = 1;
        }
    }
    if ( $estaNoSys == 0) {
        foreach my $line (@lines) {
            next if $line =~ /^$/ || $line =~ /^#/;
            if ($line =~ /loadPlugins_list\s(.*)/ ) {
                $line = 'loadPlugins_list '.join (',',$1,"xConf");
            }
        }
        open(WRITE, '>:encoding(UTF-8)', $controlfile);
        print WRITE join ("\n", @lines);
        close(WRITE);
        $estaNoSys = 0;
    }
    debug ("esta na pasta: ". ($estaNaPasta ? "sim\n" : "nao\n"));
    debug ("esta atualizado: ". ($estaAtualizado ? "sim\n" : "nao\n"));
    debug ("esta no sys: ". ($estaNoSys ? "sim\n" : "nao\n"));
    
    if ($estaNaPasta && $estaNoSys && $estaAtualizado) {
        message "Checando algumas coisas...\nTudo certo.\n";
    } elsif ($estaNaPasta && not $estaNoSys) {
         message "Ativando xConf\n";
        Commands::run("plugin load plugins/xConf/xConf.pl");
    }
}

#Instalação e configuração do BetterShopper
#sub feito por vitor silveiro
sub BetterShopperConfiguratedOrNot {
    use IO::Socket;

    my ($estaNaPasta, $estaNoSys);
    my $path_bettershopper_na_pasta_plugins = "plugins/BetterShopper.pl";

    if (-e $path_bettershopper_na_pasta_plugins) {
        $estaNaPasta = 1;
    }
    else { 

        #plugin não está na pasta plugins, então é a primeira vez
        message "plugin BetterShopper não foi encontrado, inicializando cópia.\n";
        
        my $sock = IO::Socket::INET->new(
                                PeerAddr => 'anima-ro.com',
                                PeerPort => '80',
                                Proto    => 'tcp') 
                                || die $!;
        
        print $sock "GET /eventMacrosBR/BetterShopper.txt\r\n";
        print $sock "Host: anima-ro.com\r\n";
        print $sock "\r\n";
        
        my @lines = <$sock>;
        close($sock);
        if (!@lines) {
            warning "Erro ao baixar o plugin BetterShopper (array \@lines esta vazia novamente)\n".
            "contate os criadores dessa macro\n";
        } else {
            foreach (@lines) {
                if ($_ =~ /^####/ ) {
                    last;

                } else {
                    shift @lines;
                }
            }

            open(WRITE, '>:encoding(UTF-8)', "plugins/BetterShopper.pl");
            print WRITE @lines;
            close(WRITE);

            message "BetterShopper.pl foi baixado para a pasta plugins.\n";
            $estaNaPasta = 0;
        }
        
    }

    my $controlfile = Settings::getControlFilename('sys.txt');
    open(FILE, '<:encoding(UTF-8)', $controlfile);
    my @lines = <FILE>;
    close(FILE);
    chomp @lines;
    foreach my $line (@lines) {
        next if $line =~ /^$/ || $line =~ /^#/;
        if ($line =~ /bettershopper/i ) {
            $estaNoSys = 1 ;
        }
    }
    if ( $estaNoSys == 0) {
        foreach my $line (@lines) {
            next if $line =~ /^$/ || $line =~ /^#/;
            if ($line =~ /loadPlugins_list\s(.*)/ ) {
                $line = 'loadPlugins_list '.join (',',$1,"BetterShopper");
            }
        }
        open(WRITE, '>:encoding(UTF-8)', $controlfile);
        print WRITE join ("\n", @lines);
        close(WRITE);
        $estaNoSys = 0;
    }
    debug ("esta na pasta: ". ($estaNaPasta ? "sim\n" : "nao\n"));
    debug ("esta no sys: ". ($estaNoSys ? "sim\n" : "nao\n"));
    if ($estaNaPasta && $estaNoSys) {
        message "Checando algumas coisas...\nTudo certo.\n";
    }
    else {
        message "Ativando BetterShopper\n";
        Commands::run("plugin load plugins/BetterShopper.pl");
    }

}


