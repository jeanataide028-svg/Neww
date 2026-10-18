-- AutoTyper PT / EN / ES (painel parecido com o do vídeo)
-- Palavra sugerida + botão ESCREVER + velocidade Lento/Rápido em ms
-- Suggested word + WRITE button + Slow/Fast speed in ms
-- Palabra sugerida + botón ESCRIBIR + velocidad Lento/Rápido en ms

local sucesso, erro = pcall(function()
    local Players = game:GetService("Players")
    local jogador = Players.LocalPlayer
    local playerGui = jogador:WaitForChild("PlayerGui")
    local okVIM, VIM = pcall(function() return game:GetService("VirtualInputManager") end)
    local UIS = game:GetService("UserInputService")
    local GuiService = game:GetService("GuiService")

    ---------------------------------------------------------------- config
    local config = {
        idioma = "pt",     -- pt / en / es
        atrasoMs = 80,     -- milissegundos por letra
        enter = true,      -- aperta Enter depois da palavra (mude para false se não precisar)
        letra = "A",       -- letra inicial da rodada
        auto = true,       -- true = tenta detectar a letra sozinho
        trocaAuto = true,  -- true = se acabarem as palavras de um idioma, usa os outros
        pularPrimeira = true, -- true = não digita a 1ª letra (o jogo já preenche a letra da rodada)
        priorizarFinais = true,       -- true = prefere palavras que terminam em letras difíceis
        finaisDificeis = "KYXZWH",    -- poucas palavras começam com elas, então o próximo jogador sofre
        maxPrefixo = 3,               -- máximo de letras iniciais que o jogo pode dar (1, 2 ou 3)
        restaurarTeclado = true,      -- depois de digitar, dá um toque no painel para o teclado do jogo voltar
        nivelVocab = 4,               -- 1 comum | 2 grande | 3 +plurais | 4 ultra (tudo). Muda no botão VOCAB
        faisca = true,                -- true = prioriza palavras com 10+ letras (pet Fogos de Artifício)
        faiscaMin = 10,               -- quantas letras contam como "palavra longa" para a faísca
        festaAuto = false,            -- botão FESTA: quando armado, digita prefixos sozinho quando o jogo pedir
        festaPalavras = { "prefixo" },-- textos (minúsculos, sem acento) que mostram que o jogo está pedindo prefixo
        festaTextoMax = 80,           -- ignora textos longos (descrição de pet, dicas)
        festaEspera = 0.5,            -- espera antes de digitar, depois que o jogo pede o prefixo (segundos)
        festaMax = 10,                -- prefixos por Festa
        festaTimeout = 300,           -- desarma sozinho se o jogo não pedir prefixo por esse tempo (segundos)
    }
    local PASSO_MS, MIN_MS, MAX_MS = 10, 10, 500
    local ALFABETO = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    ---------------------------------------------------------------- palavras
    -- Pacotes de palavras: texto separado por espaço, já sem acento (o jogo ignora acentos).
    -- comuns = dia a dia | extras = vocabulário grande | plurais = formas derivadas | ultra = palavras raras e verbais
    local pacotes = {
        pt = {
            comuns = [[
                abacaxi abelha abismo abissal abraco abrigo acolito acordo acucar adaga adeus
                agosto agulha ajuda alarme alcatraz alegria alfabeto alface algodao alianca
                almoco altura aluno amanha amarelo ambicao ambiente amigo amizade amor anel
                animal anjo antena antigo aparelho apito aprender aquario aranha areia armadura
                armario arroz arte arvore assunto astro atlas atleta atriz audaz aula aurora
                avenida aventura aviao azeite azul azulejo baba bacia bagagem baile bairro
                balanca balao balde baleia banana banco banda bandeira banheiro banho barba
                barco barulho basquete bastao batalha bateria beijo beleza berco biblioteca
                bicho bicicleta bigode bilhete biscoito blusa boca bola bolo bolsa bombeiro
                bondade boneca bonito borax borboleta borracha botao braco branco brasa bravura
                brilho brinquedo brisa bronze bruxa bumbo buraco cabana cabeca cabelo cabide
                cachorro cadeira cafe caixa calca calendario calix calor cama camelo caminho
                camisa campeao campo cancao caneta cansaco cantor capa capaz capital caracol
                carinho carro carta cartaz casa casaco castelo cavalo caverna cebola cenoura
                centro cerebro cerveja chave chefe chegada cheiro chuva cicatriz cidade cigarra
                cinema cinto circo climax cobra coelho cofre coisa colar colecao colega colher
                cometa comida computador conceito concha conversa copo coracao coragem corda
                coroa corpo correio corrida cortex costa cowboy cozinha crianca cristal
                crocodilo cruz cultura curva dado danca dedo defesa degrau delta dente desafio
                desenho deserto destino diamante diario dicionario dieta dificil dinheiro
                dinossauro direito disco distancia doce documento domingo dono dor dragao drama
                ducha duelo duque duro duvida eclipse edificio eficaz elastico elefante
                eletricidade elevador emocao empresa encontro energia enfermeiro enigma entrada
                envelope epoca equipe erro escada escola escova escrita escudo esfera esmeralda
                espaco espada especial espelho esperanca esporte esposa esquerda estacao estadio
                estante estatua estomago estrada estrela estudo eterno europa exame exemplo
                exercito fabrica faca face fada familia fantasma farinha farol fazenda febre
                feijao feira felicidade feliz fenix feroz ferro festa fevereiro fiel figura
                filho filme final fio flauta flecha flor floresta fluxo fogao fogo folha fome
                fonte forca forma formiga foto fralda frances frango frase freio frente frio
                fronteira fruta fuga fugaz fumaca funcao fundo funk furacao futebol futuro gado
                gaiola gaivota galaxia galinha galo ganho garagem garfo garoto garrafa gato
                gaveta gelado geleia gelo gemeo general genio gente geografia gesto gigante
                girafa globo golfinho golpe goma gorila gosto graca grama grande grao gravata
                grito grupo guarda guerra guerreiro guia guitarra habito harmonia harpa
                helicoptero helix heranca heroi hino historia hobby hockey hoje homem honra hora
                horario horizonte hortela hospital hotel humano humor idade ideia idioma igreja
                ilha ilusao imagem imperador imperio impressora incendio indio infancia infinito
                inseto instrumento inteligente inverno irmao isca jacare janeiro janela jangada
                jantar jardim jarra jato jaula jipe joelho jogador jogo joia jornal jovem juiz
                julho junho junto justica juventude karaoke karate ketchup kimono kiwi koala
                labio labirinto laco lado ladrao lago lagoa lagrima lama lampada lanca lanche
                lanterna lapis laranja lareira largo lata latex leao leite leitor lembranca
                lenco lendario lenha lente leopardo letra levar libelula liberdade limao limite
                limpeza lingua linha lista livro lixo lobo local logo loja lona longe loteria
                louca lua lugar luva luz maca macaco machado madeira madrugada mae magico magro
                maio mala malha mamao manha manteiga mapa maquiagem mar maratona margem marido
                marinheiro martelo mascara massa mata matematica matiz matriz medalha mel melao
                memoria menino mensagem mente mercado mesa metal meteoro metro microfone migalha
                milho minuto miolo misterio moeda monstro montanha morango morcego mordaz mosca
                motor muleta mulher mundo muralha museu musica nabo nadador namorado nariz natal
                natureza nave navio neblina negocio nervo neve ninho ninja nivel noite nome
                norte nota noticia novela novembro numero nuvem oasis objeto obra oceano
                ocidente oculos oficina oleo olho ombro onca onda onibus onix ontem opcao orelha
                organizacao orgulho orquestra osso otimo ouro outono ouvido ovelha ovo oxigenio
                pacote padaria pai paisagem palacio palavra palco paleta palhaco palito panela
                pano pantera papel parede parque parte passado passaro passeio pasta pastel
                patio pato paz peca pedra peixe pele pena pente pepino pequeno perdiz perfume
                pergaminho perigo perna pertinaz pesadelo pescador pessoa piano picole pijama
                pilha pimenta pincel pinguim pintor pirata piscina pista planeta planta plastico
                plateia poco poder poema poesia policia polvo pomba ponte porco porta portal
                portao posto pote praca praia prato prazer presente primavera princesa prisma
                problema professor pulseira punho punk pupila quadra quadro qualidade quarto
                quase queda queijo quente quilo quimera quimica quintal quitanda rabo radar
                radio rainha raio raiva raiz ramo rapaz raposa rascunho rato razao realidade
                receita recife rede redondo refeicao reflexo reino relampago relax relogio
                remedio remo repouso resposta restaurante reta reuniao revista rio riqueza riso
                ritmo robo rocha rock roda rodovia rolo rosa rosto roupa rua rubi rugby ruido
                ruina sabado sabao sabor saco safira sagaz saida sala salada salto salvador
                samurai sanduiche sangue sapato sapo saudade saude segredo segunda seguro selva
                semana semente sereia serpente serra sertao sexta show sinal sino sitio sobrinho
                sofa sol soldado solo sombra sonho sopa sorriso sorvete spray suco sul sussurro
                tabela tabua taca talento talvez tambor tampa tapete tarde tartaruga taxa teatro
                tecido teclado telefone televisao tempestade templo tempo tenaz tenda tenis
                terca terra terremoto tesoura tesouro teto tigre tijolo time tinta tio tira
                tomate torax torneio torre tosse trabalho trem trigo trilha trono trovador
                trovao truque tubarao tulipa tunel turma turquesa ultimo umbigo uniao unicornio
                uniforme universo ursinho urso urubu usina utensilio uva vaca vaga vagao vale
                valor vampiro vapor varal varinha vaso vassoura vela veleiro velho veloz veludo
                vento verao verdade verde vermelho verniz versao vestido vez viagem vidro vila
                vinho violao violeta visita vista vitoria vitrine viuva vivaz vizinho voar
                volante volta voraz vovo voz vulcao waffle whisky xadrez xadrezes xadrezista
                xale xales xama xamanismo xampu xampus xango xara xarope xaropes xavante xaveco
                xaxado xaxim xelim xenofobia xenofobico xenon xenonio xeque xeques xerem xereta
                xeretar xerife xerifes xerocar xerocopia xerox xexeu xicara xicaras xifoide
                xifopago xiita xilema xilindro xilofone xilofones xilofonista xilografia
                xilogravura xingamento xingar xinxim xis xisto xix xixi xodo xucro yakisoba yoga
                zangao zebra zelador zero ziper zona zoologico zumbi
            ]],
            extras = [[
                abacate abobora abracar abutre acabar acalmar acampamento acampar aceitar
                acender acertar acidente acordar acostumar acreditar acrobata adesivo adivinhar
                adjetivo admirar adolescente adorar adulto advogado aeroporto agencia agenda
                agradecer agricultor aguia ajudar alavanca albergue alcancar alcance aldeia
                alecrim alegrar alfaiate alfinete alicate alimento alivio almocar almofada altar
                alugar amar amargo amarrar ameixa amendoa amendoim ametista ancora andaime andar
                anedota anfibio anotar anzol apagador apagar aparecer apartamento apelido
                apertar apetite aplaudir aplauso apontar apostila aprendiz apresentar aproveitar
                aquecedor arbusto argila argola aroma arquiteto arquivo arrumar artesanato
                artista asfalto aspirador assalto assento assinatura assistir assustar
                astronauta atacar atencao atirar atracao atravessar auditorio autor avalanche
                aveia avental avisar aviso azedo azeitona bacalhau bacteria bagunca baixar bala
                balancar balcao bambu bandeja bandido banqueiro baralho barata barbeiro barraca
                barreira barril batata batedeira bater batom beber bebida beijar beliche bengala
                berinjela besouro bexiga bezerro bico bife bilhar binoculo biologia biombo
                biquini bisavo bisneto bloco bobo bochecha bode boia bolha bomba bombom bondoso
                borda bosque bota bravo briga brigadeiro brigar brilhante brilhar brincar broche
                bronca broto bruma bule buscar bussola caber cabideiro cabine cabo cacador cacau
                cachecol cacho cacto caderno cafeteira caiaque cair caixote cajado calar calcada
                calcado calcanhar caldeira caldo calmaria caloria camaleao camarao cambalhota
                camera caminhar camiseta campainha campeonato canal canario canela canhao
                canivete canoa cantar cantina canudo capacete capela capim capitao capricho
                capsula caramelo caravana carbono cardapio cardume carga cargo carimbo carnaval
                carneiro carpinteiro carrapato carregar carrinho carroca carruagem cartao
                cartola casal casamento casar casca cascata casulo catalogo catapulta catedral
                categoria caule causa cautela cavaleiro cavar cavidade cedro cegonha ceia cela
                celebridade celeiro celula cemiterio cenario centavo centopeia ceramica cerca
                cereal cereja cerimonia certeza cesta cetro chacara chafariz chale chaleira
                chama chamada chamar chamine champanhe chantagem chao chapeu charada charme
                charrete charuto chegar cheirar cheque chiclete chifre chinelo chocalho choque
                chorar chover churrasco chuteira ciclista ciclone cidadao ciencia cigano cilio
                cimento cinza cinzeiro circuito circulo cirurgiao cisne clareira claridade
                classe classico clima clinica clipe clube cobertor cobertura cobica cobrir
                codigo cogumelo colcha colchao colete colheita colina colmeia colonia coluna
                combate combustivel comecar comedia comer comercio comissao compasso competicao
                composicao compota compra comprar comprimento comunidade concerto concreto
                condor conduta conduzir confianca confusao conhaque conhecer conjunto conquista
                conquistar consciencia conseguir conselho constelacao construir construtor
                consulta contador contar conteudo continuar contrato controle convidar convite
                copiar coqueiro coral corcel cordao cordeiro cordilheira corneta coro corredor
                corrente correr cortar cortesia cortina coruja costela costume costurar cotovelo
                couve covarde coveiro cracha cranio creme crepusculo crescer crescimento criar
                crina crise criterio cronica crosta cruzar cruzeiro cubo cuidado cuidador cuidar
                culpa cume cumprir cupim curar curativo curiosidade curriculo curso cursor custo
                dama dancar decidir dedal defeito defender deficiencia deitar deixar delegado
                deleite delicia demonio denuncia dependencia deposito derramar desabafo
                descansar descanso descer descoberta desconto desejar desejo desenhar desenhista
                desfile desmaio despedir despensa despertador despertar destaque destruir
                detergente detetive deus devedor devolver diabo diagrama dialeto dialogo
                diferenca dificuldade digestao dignidade dilema diploma direcao diretor dirigir
                dirigivel discurso discussao discutir disfarce disputa distrito diversao divida
                dividir divisao dizer doacao dobradica dobrar dobro documentario doenca domino
                dormir doutor drogaria duelista duna duplicata duvidar ecologia economia edicao
                editor educacao educar efeito egoista eixo eleicao eleitor elenco eletrodo
                elogiar elogio embalagem embarcacao embarcar emblema embriao emenda emprego
                emprestar emprestimo enchente encher enciclopedia encontrar endereco enfeite
                enfermaria enfrentar enganar engenheiro engrenagem enredo ensaio ensinar ensino
                entardecer entender entrar entregar entrevista enviar enxada enxame enxofre
                epidemia episodio equador equilibrio equipamento erosao errar erva ervilha
                escalada escama escandalo escanteio escapamento escolher esconder escoteiro
                escrever escritor escritorio escultor escuridao escutar esgoto esmalte esmola
                esofago espaguete espanto esperar espetaculo espeto espiga espinho espiral
                esponja esquecer esqueleto esquilo esquina estaca estaleiro estampa estande
                estatura estepe esterco estilingue estojo estrangeiro estrategia estrutura
                estudante estudar estufa etiqueta evento evidencia evitar excecao excursao
                exercicio exibicao exilio existencia expedicao experiencia explicar explosao
                exposicao expressao extintor extrato fabricar fachada faisao faixa falar falcao
                falesia falha falsidade faltar fama fanfarra fantoche farao farda farmacia
                faroeste farpa fartura fatia fato favela favo fazendeiro fazer fechadura fechar
                feitico feitor feixe feriado ferida ferradura ferramenta ferrovia fertil ferver
                fervura festival fibra ficar ficcao fidelidade figurino filhote filial filosofo
                filtro fingir firmar fiscal fita fivela flamingo flanela flautim florista fluido
                fofoca foguete foice folclore folego folheto fonema forja formatura formula
                formulario fortaleza fortuna fossil fotografo fracasso fragata fragil fragrancia
                fratura fregues freira frescor frigideira fritada frota frustracao fruteira
                fugir fuligem funcionar funcionario fundacao fundador funil furar furgao furo
                fusao fusivel gabinete gaita galeria galpao gangorra ganhar ganso garca
                garimpeiro garoa gasolina gastar gastronomia gatilho gaucho gaviao gazela geada
                gelatina geleira gema genero gengibre genro geracao gerente gestante gibi
                ginasio ginasta girassol glaciar gloria glossario gnomo gole gongo gordura
                gorjeta gostar governador governar governo gozo grade gradil grafico grafite
                gralha grampo granizo granja gritar grosseiro gruta guarani guardar guerreira
                guiar guincho guirlanda guizo habitante halito hangar haste hectare helice
                hemisferio hera herbivoro herdar herdeiro hesitacao hidrante hiena hipopotamo
                hipotese historico holofote homenagem honestidade horda horta hospede hostil
                humildade humorista iate iceberg icone identidade ideologia ignicao igualdade
                ilustrador imaginar imitacao imperatriz impulso incenso inclinacao industria
                inferno infiel influencia informacao ingrediente iniciativa inimigo inocente
                inquerito inseticida inspetor instante instituto insulto integral intencao
                interesse interruptor intervalo intestino intriga inundacao invasao inventar
                inventor investigador iogurte irmandade irrigacao isqueiro itinerario jabuti
                jaca jaguar jangadeiro janta jardineiro jasmim jazida jeito jiboia jogar jubileu
                judeu jujuba jumento juncao juntar jurado jurar juri juro laboratorio lacaio
                lacre lagarta lagarto laguna laje lamento lamparina lampiao lancamento lanceiro
                lancha lapela laranjeira larva lasanha lava lavanderia lavar lavoura lazer leal
                lebre legado legenda legiao legume leilao leitura lembrar leme lenda lentilha
                leoa leque lesma letreiro levantar lhama liberal libertar libra licenca
                lideranca ligacao ligar lima limbo limiar limonada limpar linguado linguagem
                linguica linhagem linho liquidacao liquido lirio litoral lixeira lobisomem locao
                logica lombo longitude lotus louro lousa lucro lugarejo lunar luneta lupa lustre
                lutador lutar luxo machucar maestro magia magistrado magnata maionese maleta
                malicia mamadeira mamifero mancha mandar mandioca mangueira manicure manivela
                mansao manto manual manuscrito maquete marcar marcha marfim margarida marmelada
                marmota marreco marrom marsupial massagem mastigar mastro matadouro matilha
                matricula maturidade mausoleu mecanico medicamento medico medida medir medo
                medusa meia melancia melodia melro membrana menestrel menta mentir mentira
                mercador mercearia merecer mergulhador mergulhar meridiano mesada mesquita
                mestre metade metodo mexilhao microbio migrante milagre milenio milionario
                mimica minerio ministro minoria miragem miseria missa mistura misturar mito
                mochila moda modelo moedor moinho moleque molho monarca monitor monja monologo
                monopolio monumento moradia morar morder mordomo morro mortalha mosaico mostarda
                mosteiro mostrar motim motocicleta motorista movimento mudar muralista murmurio
                musculo mutirao nacao nadar nafta narciso narrador nascente nascer nata natacao
                navalha navegador navegar necessitar nectarina negar neto neuronio neutro
                nevasca nicho nobre nodoa nogueira nomade nomear notar notario novato novico
                novilho obedecer obediencia obelisco observar obstaculo ocorrencia octogono
                ocupar odisseia oferenda oficial oitava olaria olfato olhar olimpiada oliveira
                ondulacao opaco opera operario opiniao oportunidade oratorio orfanato origami
                orvalho ostra ourico ourives outeiro ouvinte ouvir ovacao oxidacao padeiro
                pagamento pagar pagode paineira painel paiol pajem paladar palanque palestra
                paleto palha palhoca palmeira palmito palpebra pampa panfleto pantano pantufa
                papagaio papelaria papiro parafuso paraiso parar parasita parceiro pardal
                parecer parente parlamento parteira partir passar passear pasto pastor patente
                patinete patrao patrimonio patrulha pavao pavilhao pecado pecuaria pedagio pedal
                pedestal pedir pedreiro pegada pegar peito peixaria pelucia pendulo peneira
                penhasco penicilina pensamento pensar pepita percevejo perder perdoar perguntar
                permitir perola persiana personagem perspectiva peru pesar pescar pesquisa
                pessego pestana petisco petroleiro piada picada picadeiro pilastra pilotagem
                pinca pinheiro pintar pintassilgo piolho pioneiro piramide pirueta pisar pivo
                pizzaria placa plagio planalto planicie plantao plantar plataforma plebeu
                plenario plumagem pneu pocilga poeira poeta polegar polenta polo pomada pomar
                pombal ponteiro pontifice porao porcelana porteiro portico portuario pouso
                povoado praga prateleira pratica preceito precipicio predio prefeito prejuizo
                preludio premiacao prender preocupar preparar presidente pressa prestigio
                previsao primo principio prioridade procissao procurador procurar produtor
                produzir profecia profeta profundidade programa progresso projetil projetor
                prole promessa prometer pronome propaganda propina proposta prosa proteger
                protesto protetor provar provedor proverbio provincia prudencia psicologo
                publicidade pudim pulga pulmao pulo pulpito punhal pureza puxar quadril quaresma
                quartel quebrar queimar querer quermesse quibe quietude quilometro quimono
                quinhao quiosque quitute quociente rabanete rabino raca radiador rajada ralador
                rale ramal rampa rancho ranco rapina raposo raquete rasgar rastro ratoeira
                reacao realizar reator rebanho rebelde recado recanto receber recepcao
                reciclagem reclamacao recompensa recordar recorde recreio recruta recusar
                redacao refletir reforcar reforma refugio regador regar regata regiao regime
                registro regra regulamento reinado relato relevo religiao reliquia remador
                remendo remorso renda rendicao renome reparo repertorio repolho reportagem
                represa reprise republica reputacao requinte resgate resistencia respiracao
                resumo retalho retrato reves revolta rezador rezar riacho ribeirao rifa
                rinoceronte rival rodar rodizio roedor rolha roma romaria romeiro rosario rosca
                rotina roubar roubo roxo rubrica rumor saber sabia sabonete sabotagem sacerdote
                sacola sacrificio sacudir safari saga sagacidade sair saliva salmao salsicha
                saltimbanco salvar samba sancao sandalia sapateiro sapatilha saque sarampo
                sarcofago sardinha sargento satelite satira satisfazer saudacao sebo secador
                secar secretaria seculo seda sedimento seguidor seguir seguranca seiva selecao
                selo senado senhora sensacao sentar sentenca sentido sentinela sentir separacao
                separar sepulcro sequoia seriedade seringa sermao serpentina serrote servidao
                servir sessao setor severidade sifao sigilo silaba silencio silhueta silo
                simbolo simpatia sindicato sinfonia singular sintoma sirene sistema soberano
                sobrado sobremesa sociedade socorro soldador solenidade solidao soltar soltura
                solucao sombrinha sonata soneca sonhador sonhar sono soprano soprar sorrir
                sorteio sotao suavidade subida subir submarino suburbio sucata sucesso sucuri
                sueter sujar sujeira sulco sultao sumario supermercado suplemento suportar
                suporte surgir surpresa susto sutia tabaco taberna tabuleiro tacho talha talo
                tamanho tamarindo tamborim tangerina tanque tapar tapecaria tapioca taquara
                tarantula tarifa tatica tatu taverna tecelao tecnologia teimosia tela telescopio
                telhado temor temporada tenente tensao tentaculo tentar teoria terminal terminar
                termometro termostato terno ternura terraco territorio tesoureiro testa
                testemunha textura tiara tigela timao tinteiro tintura tipico tirano tirar tita
                titulo toalete tocar toco toldo tolerancia tomada tomar tonalidade tonel topazio
                topo toque torcedor torcer tornar torneira tornozelo torpedo torrada torrente
                torresmo totem touca toupeira touro trabalhador trabalhar traducao trafego
                tragedia traicao trailer trajeto tranca transporte trapaca trapezio trator
                travessia trazer tregua treinador treinar tremer treno trepadeira tributo trico
                trincheira trindade tripulacao triunfo trocar trombeta tronco tropa tropeco
                trouxa trufa truta tucano tufao tumba tumulto turbante turbina turismo turista
                tutor ubere uisque ultimato umidade unanimidade uncao unha unidade urbanismo
                urgencia urna usar usuario utopia vacina vagabundo vaidade valente valentia
                validade valsa vandalismo vanguarda vantagem varanda varejista variedade
                varredor vassalo vegetacao veiculo vencer venda vendaval vender veneno
                ventilador ventre verbo verdura vereador vergonha verme verruga vertigem vespa
                vestiario vestigio vestir vetor vexame viaduto viajar vibracao vice vicio vida
                vidraca vigia vigor vilao vilarejo vime vinagre vinheta violoncelo virada virgem
                virtude virus visao visconde viseira vitral viveiro vivencia viver vizinhanca
                vocabulario voltar volume voluntario vontade votacao votar vulgar zagueiro
                zeloso zenite zigoto zinco zodiaco zombaria zumbido
            ]],
            plurais = [[
                abacates abacaxis abelhas abismos abissais aboboras abracos abrigos abutres
                acampamentos acidentes acolitos acordos acrobatas acucares adagas adesivos
                adjetivos adolescentes adultos advogados aeroportos agencias agendas agostos
                agricultores aguias agulhas ajudas alarmes alavancas albergues alcances
                alcatrazes aldeias alecrins alegrias alfabetos alfaces alfaiates alfinetes
                aliancas alicates alimentos alivios almocos almofadas altares alturas alunos
                amanhas amarelos amargos ambientes ameixas amendoas amendoins ametistas amigos
                amizades amores ancoras andaimes anedotas aneis anfibios animais anjos antenas
                antigos anzois apagadores aparelhos apartamentos apelidos apetites apitos
                aplausos apostilas aprendizes aquarios aquecedores aranhas arbustos areias
                argilas argolas armaduras armarios aromas arquitetos arquivos arrozes artes
                artesanatos artistas arvores asfaltos aspiradores assaltos assentos assinaturas
                assuntos astronautas astros atletas atrizes audazes auditorios aulas auroras
                autores avalanches aveias avenidas aventais aventuras avisos azedos azeites
                azeitonas azuis azulejos babas bacalhaus bacias bacterias bagagens baguncas
                bailes bairros balancas balas baldes baleias bambus bananas bancos bandas
                bandeiras bandejas bandidos banheiros banhos banqueiros baralhos baratas barbas
                barbeiros barcos barracas barreiras barulhos basquetes batalhas batatas
                batedeiras baterias batons bebidas beijos belezas beliches bengalas bercos
                berinjelas besouros bexigas bezerros bibliotecas bichos bicicletas bicos bifes
                bigodes bilhares bilhetes binoculos biologias biombos biquinis bisavos biscoitos
                bisnetos blocos blusas bobos bocas bochechas bodes boias bolas bolhas bolos
                bolsas bombas bombeiros bombons bondades bondosos bonecas bonitos borboletas
                bordas borrachas bosques botas bracos brancos brasas bravos bravuras brigadeiros
                brigas brilhantes brilhos brinquedos brisas broches broncas bronzes brotos
                brumas bruxas bules bumbos buracos bussolas cabanas cabecas cabelos cabideiros
                cabides cabines cabos cacadores cacaus cachecois cachorros cachos cactos
                cadeiras cadernos cafes cafeteiras caiaques caixas caixotes cajados calcadas
                calcados calcanhares calcas caldeiras caldos calendarios calmarias calores
                calorias camas cambalhotas camelos cameras caminhos camisas camisetas campainhas
                campeonatos campos canais canarios canelas canetas canivetes canoas cansacos
                cantinas cantores canudos capacetes capas capazes capelas capins capitais
                caprichos capsulas caracois caramelos caravanas carbonos cardapios cardumes
                cargas cargos carimbos carinhos carnavais carneiros carpinteiros carrapatos
                carrinhos carrocas carros carruagens cartas cartazes cartolas casacos casais
                casamentos casas cascas cascatas castelos casulos catalogos catapultas catedrais
                categorias caules causas cautelas cavaleiros cavalos cavernas cavidades cebolas
                cedros cegonhas ceias celas celebridades celeiros celulas cemiterios cenarios
                cenouras centavos centopeias centros ceramicas cercas cereais cerebros cerejas
                cerimonias certezas cervejas cestas cetros chacaras chafarizes chaleiras chales
                chamadas chamas chamines champanhes chantagens chapeus charadas charmes
                charretes charutos chaves chefes chegadas cheiros cheques chicletes chifres
                chinelos chocalhos choques churrascos chuteiras chuvas cicatrizes ciclistas
                ciclones cidades ciencias ciganos cigarras cilios cimentos cinemas cintos cinzas
                cinzeiros circos circuitos circulos cisnes clareiras claridades classes
                classicos climas clinicas clipes clubes cobertores coberturas cobicas cobras
                codigos coelhos cofres cogumelos coisas colchas colegas coletes colheitas
                colinas colmeias colonias colunas combates combustiveis comedias comercios
                cometas comidas compassos compotas compras comprimentos computadores comunidades
                conceitos concertos conchas concretos condores condutas confiancas conhaques
                conjuntos conquistas consciencias conselhos construtores consultas contadores
                conteudos contratos controles conversas convites copos coqueiros coragens corais
                corceis cordas cordeiros cordilheiras cornetas coroas coros corpos corredores
                correios correntes corridas cortesias cortinas corujas costas costelas costumes
                cotovelos couves covardes coveiros cozinhas crachas cranios cremes crepusculos
                crescimentos criancas crinas crises cristais criterios crocodilos cronicas
                crostas cruzeiros cruzes cubos cuidadores cuidados culpas culturas cumes cupins
                curativos curiosidades curriculos cursores cursos curvas custos dados damas
                dancas dedais dedos defeitos defesas deficiencias degraus delegados deleites
                delicias deltas demonios dentes denuncias dependencias depositos desabafos
                desafios descansos descobertas descontos desejos desenhistas desenhos desertos
                desfiles desmaios despensas destaques destinos detergentes detetives devedores
                diabos diagramas dialetos dialogos diamantes diarios dicionarios dietas
                diferencas dificuldades dignidades dilemas dinheiros dinossauros diplomas
                direitos diretores dirigiveis discos discursos disfarces disputas distancias
                distritos dividas dobradicas dobros doces documentos doencas domingos dominos
                donos dores doutores dramas drogarias duchas duelistas duelos dunas duplicatas
                duques duros duvidas eclipses ecologias economias edificios editores efeitos
                eficazes egoistas eixos elasticos elefantes eleitores elencos eletrodos
                elevadores elogios embalagens emblemas emendas empregos empresas emprestimos
                enchentes encontros enderecos energias enfeites enfermarias enfermeiros
                engenheiros engrenagens enigmas enredos ensaios ensinos entardeceres entradas
                entrevistas envelopes enxadas enxames enxofres epidemias episodios epocas
                equadores equilibrios equipamentos equipes erros ervas ervilhas escadas
                escaladas escamas escandalos escanteios escapamentos escolas escoteiros escovas
                escritas escritores escritorios escudos escultores esferas esgotos esmaltes
                esmeraldas esmolas esofagos espacos espadas espaguetes espantos especiais
                espelhos esperancas espetaculos espetos espigas espinhos espirais esponjas
                esportes esposas esqueletos esquerdas esquilos esquinas estacas estadios
                estaleiros estampas estandes estantes estatuas estaturas estepes estercos
                estilingues estojos estomagos estradas estrangeiros estrategias estrelas
                estruturas estudantes estudos estufas eternos etiquetas europas eventos
                evidencias exames exemplos exercicios exercitos exilios existencias experiencias
                extintores extratos fabricas facas faces fachadas fadas faixas falesias falhas
                falsidades famas familias fanfarras fantasmas fantoches fardas farinhas
                farmacias faroestes farois farpas farturas fatias fatos favelas favos fazendas
                fazendeiros febres fechaduras feiras feiticos feitores feixes felicidades
                felizes feriados feridas ferozes ferraduras ferramentas ferros ferrovias
                fervuras festas festivais fevereiros fibras fidelidades fieis figuras figurinos
                filhos filhotes filiais filmes filosofos filtros finais fiscais fitas fivelas
                flamingos flanelas flautas flautins flechas flores florestas floristas fluidos
                fluxos fofocas fogos foguetes foices folclores folegos folhas folhetos fomes
                fonemas fontes forcas forjas formas formaturas formigas formularios formulas
                fortalezas fortunas fotografos fotos fracassos fragatas fragrancias fraldas
                frangos frases fraturas freios freiras frentes frescores frigideiras frios
                fritadas fronteiras frotas frutas fruteiras fugas fugazes fuligens fumacas
                funcionarios fundadores fundos furos fusiveis futebois futuros gabinetes gados
                gaiolas gaitas gaivotas galaxias galerias galinhas galos gangorras ganhos gansos
                garagens garcas garfos garimpeiros garoas garotos garrafas gasolinas
                gastronomias gatilhos gatos gauchos gavetas gazelas geadas gelados gelatinas
                geleias geleiras gelos gemas gemeos generais generos gengibres genios genros
                gentes geografias gerentes gestantes gestos gibis gigantes ginasios ginastas
                girafas girassois glaciares globos glorias glossarios gnomos goles golfinhos
                golpes gomas gongos gorduras gorilas gorjetas gostos governadores governos gozos
                gracas grades graficos grafites gralhas gramas grampos grandes granizos granjas
                gravatas gritos grosseiros grupos grutas guaranis guardas guerras guerreiras
                guerreiros guias guinchos guirlandas guitarras guizos habitantes habitos halitos
                hangares harmonias harpas hastes hectares helices helicopteros hemisferios
                herancas heras herbivoros herdeiros herois hidrantes hienas hinos hipopotamos
                hipoteses historias historicos hojes holofotes homenagens homens honestidades
                honras horarios horas hordas horizontes hortas hortelas hospedes hospitais
                hoteis humanos humildades humores humoristas iates icones idades ideias
                identidades ideologias idiomas igrejas igualdades ilhas ilustradores imagens
                imperadores imperatrizes imperios impressoras impulsos incendios incensos indios
                industrias infancias infernos infieis infinitos influencias ingredientes
                iniciativas inimigos inocentes inqueritos inseticidas insetos inspetores
                instantes institutos instrumentos insultos integrais inteligentes interesses
                intervalos intestinos intrigas inventores invernos iogurtes irmandades iscas
                isqueiros itinerarios jabutis jacares jacas jaguares janeiros janelas jangadas
                jangadeiros jantares jantas jardineiros jardins jarras jasmins jatos jaulas
                jazidas jeitos jiboias jipes joelhos jogadores jogos joias jornais jovens
                jubileus judeus juizes jujubas julhos jumentos junhos juntos jurados juris juros
                justicas juventudes karaokes karates kimonos kiwis koalas labios labirintos
                laboratorios lacaios lacos lacres lados lagartas lagartos lagoas lagos lagrimas
                lagunas lajes lamas lamentos lampadas lamparinas lancamentos lancas lanceiros
                lanchas lanches lanternas lapelas laranjas laranjeiras lareiras largos larvas
                lasanhas latas lavanderias lavas lavouras lazeres leais lebres legados legendas
                legumes leites leitores leituras lembrancas lemes lencos lendarios lendas lenhas
                lentes lentilhas leoas leopardos leques lesmas letras letreiros lhamas libelulas
                liberais liberdades libras licencas liderancas limas limbos limiares limites
                limonadas limpezas linguados linguagens linguas linguicas linhagens linhas
                linhos liquidos lirios listas litorais livros lixeiras lixos lobisomens lobos
                locais logicas logos lojas lombos lonas longes longitudes loterias loucas louros
                lousas lucros lugarejos lugares lunares lunetas lupas lustres lutadores luvas
                luxos luzes macacos macas machados madeiras madrugadas maestros magias magicos
                magistrados magnatas magros maioneses maios malas maletas malhas malicias
                mamadeiras mamiferos manchas mandiocas mangueiras manhas manicures manivelas
                manteigas mantos manuais manuscritos mapas maquetes maquiagens maratonas marchas
                mares marfins margaridas margens maridos marinheiros marmeladas marmotas
                marrecos marrons marsupiais martelos mascaras massagens massas mastros
                matadouros matas matematicas matilhas matizes matriculas matrizes maturidades
                mausoleus mecanicos medalhas medicamentos medicos medidas medos medusas meias
                melancias melodias melros membranas memorias menestreis meninos mensagens mentas
                mentes mentiras mercadores mercados mercearias meridianos mesadas mesas
                mesquitas mestres metades metais meteoros metodos metros microbios microfones
                migalhas migrantes milagres milenios milhos milionarios mimicas minerios
                ministros minorias minutos miolos miragens miserias missas misterios misturas
                mitos mochilas modas modelos moedas moedores moinhos moleques molhos monarcas
                monitores monjas monologos monopolios monstros montanhas monumentos moradias
                morangos morcegos mordazes mordomos morros mortalhas mosaicos moscas mostardas
                mosteiros motins motocicletas motores motoristas movimentos muletas mulheres
                mundos muralhas muralistas murmurios musculos museus musicas nabos nadadores
                naftas namorados narcisos narizes narradores nascentes natais natas naturezas
                navalhas navegadores naves navios neblinas nectarinas negocios nervos netos
                neuronios neutros nevascas neves nichos ninhos ninjas niveis nobres nodoas
                nogueiras noites nomades nomes nortes notarios notas noticias novatos novelas
                novembros novicos novilhos numeros nuvens obediencias obeliscos objetos obras
                obstaculos oceanos ocidentes ocorrencias octogonos odisseias oferendas oficiais
                oficinas oitavas olarias oleos olfatos olhos olimpiadas oliveiras ombros oncas
                ondas ontens opacos operarios operas oratorios orelhas orfanatos orgulhos
                origamis orquestras orvalhos ossos ostras otimos ouricos ouros outeiros outonos
                ouvidos ouvintes ovelhas oxigenios pacotes padarias padeiros pagamentos pagodes
                paineiras paineis paiois paisagens pajens palacios paladares palanques palavras
                palcos palestras paletas paletos palhacos palhas palhocas palitos palmeiras
                palmitos palpebras pampas panelas panfletos panos pantanos panteras pantufas
                papagaios papeis papelarias papiros parafusos paraisos parasitas parceiros
                pardais paredes parentes parlamentos parques parteiras partes passados passaros
                passeios pastas pasteis pastores pastos patentes patinetes patios patos
                patrimonios patrulhas pazes pecados pecas pecuarias pedagios pedais pedestais
                pedras pedreiros pegadas peitos peixarias peixes peles pelucias penas pendulos
                peneiras penhascos penicilinas pensamentos pentes pepinos pepitas pequenos
                percevejos perdizes perfumes pergaminhos perigos pernas perolas persianas
                personagens perspectivas pertinazes perus pesadelos pescadores pesquisas
                pessegos pessoas pestanas petiscos petroleiros piadas pianos picadas picadeiros
                picoles pijamas pilastras pilhas pilotagens pimentas pincas pinceis pinguins
                pinheiros pintassilgos pintores piolhos pioneiros piramides piratas piruetas
                piscinas pistas pivos pizzarias placas plagios planaltos planetas planicies
                plantas plasticos plataformas plateias plebeus plenarios plumagens pneus
                pocilgas pocos poderes poeiras poemas poesias poetas polegares polentas policias
                polos polvos pomadas pomares pombais pombas ponteiros pontes pontifices
                porcelanas porcos portais portas porteiros porticos portuarios postos potes
                pousos povoados pracas pragas praias prateleiras praticas pratos prazeres
                preceitos precipicios predios prefeitos prejuizos preludios presentes
                presidentes pressas prestigios primaveras primos princesas principios
                prioridades prismas problemas procuradores produtores profecias professores
                profetas programas progressos projetores proles promessas pronomes propagandas
                propinas propostas prosas protestos protetores provedores proverbios provincias
                prudencias psicologos publicidades pudins pulgas pulos pulpitos pulseiras
                punhais punhos pupilas purezas quadras quadros qualidades quaresmas quarteis
                quartos quases quedas queijos quentes quermesses quibes quietudes quilometros
                quilos quimeras quimicas quimonos quintais quiosques quitandas quitutes
                quocientes rabanetes rabinos rabos racas radares radiadores radios rainhas raios
                raivas raizes rajadas raladores rales ramais ramos rampas ranchos rancos rapazes
                rapinas raposas raposos raquetes rascunhos rastros ratoeiras ratos realidades
                reatores rebanhos rebeldes recados recantos receitas reciclagens recifes
                recompensas recordes recreios recrutas redes redondos reflexos reformas refugios
                regadores regatas regimes registros regras regulamentos reinados reinos
                relampagos relatos relevos reliquias relogios remadores remedios remendos
                remorsos remos rendas renomes reparos repertorios repolhos reportagens repousos
                represas reprises republicas requintes resgates resistencias respostas
                restaurantes resumos retalhos retas retratos revistas revoltas rezadores riachos
                rifas rinocerontes riquezas risos ritmos rivais robos rochas rodas rodizios
                rodovias roedores rolhas rolos romarias romas romeiros rosarios rosas roscas
                rostos rotinas roubos roupas roxos rubis rubricas ruidos ruinas rumores sabados
                sabias sabonetes sabores sabotagens sacerdotes sacolas sacos sacrificios safaris
                safiras sagacidades sagas sagazes saidas saladas salas salivas salsichas
                saltimbancos saltos salvadores sambas samurais sandalias sanduiches sangues
                sapateiros sapatilhas sapatos sapos saques sarampos sarcofagos sardinhas
                sargentos satelites satiras saudades saudes sebos secadores secretarias seculos
                sedas sedimentos segredos seguidores segundas segurancas seguros seivas selos
                selvas semanas sementes senados senhoras sentencas sentidos sentinelas sepulcros
                sequoias sereias seriedades seringas serpentes serpentinas serras serrotes
                setores severidades sextas sigilos silabas silencios silhuetas silos simbolos
                simpatias sinais sindicatos sinfonias singulares sinos sintomas sirenes sistemas
                sitios soberanos sobrados sobremesas sobrinhos sociedades socorros sofas
                soldadores soldados solenidades solos solturas sombras sombrinhas sonatas
                sonecas sonhadores sonhos sonos sopas sopranos sorrisos sorteios sorvetes
                suavidades subidas submarinos suburbios sucatas sucessos sucos sucuris sueteres
                sujeiras sulcos sumarios suplementos suportes surpresas sussurros sustos sutias
                tabacos tabelas tabernas tabuas tabuleiros tacas tachos talentos talhas talos
                talvezes tamanhos tamarindos tambores tamborins tampas tangerinas tanques
                tapecarias tapetes tapiocas taquaras tarantulas tardes tarifas tartarugas
                taticas tatus tavernas taxas teatros tecidos teclados tecnologias teimosias
                telas telefones telescopios telhados temores tempestades templos temporadas
                tempos tenazes tendas tenentes tentaculos teorias tercas terminais termometros
                termostatos ternos ternuras terracos terras terremotos territorios tesouras
                tesoureiros tesouros testas testemunhas tetos texturas tiaras tigelas tigres
                tijolos times tintas tinteiros tinturas tipicos tiranos tiras titas titulos
                toaletes tocos toldos tolerancias tomadas tomates tonalidades toneis topazios
                topos toques torcedores torneios torneiras tornozelos torpedos torradas
                torrentes torres torresmos tosses totens toucas toupeiras touros trabalhos
                trafegos tragedias traileres trajetos trancas transportes trapacas trapezios
                tratores travessias treguas treinadores trenos trens trepadeiras tributos tricos
                trigos trilhas trincheiras trindades triunfos trombetas troncos tronos tropas
                tropecos trouxas trovadores trufas truques trutas tucanos tulipas tumbas
                tumultos tuneis turbantes turbinas turismos turistas turmas turquesas tutores
                uberes uisques ultimatos ultimos umbigos umidades unanimidades unhas unicornios
                unidades uniformes universos urbanismos urgencias urnas ursinhos ursos urubus
                usinas usuarios utensilios utopias vacas vacinas vagabundos vagas vaidades
                valentes valentias vales validades valores valsas vampiros vandalismos
                vanguardas vantagens vapores varais varandas varejistas variedades varinhas
                varredores vasos vassalos vassouras veiculos velas veleiros velhos velozes
                veludos vendas vendavais venenos ventiladores ventos ventres verbos verdades
                verdes verduras vereadores vergonhas vermelhos vermes vernizes verrugas
                vertigens vespas vestiarios vestidos vestigios vetores vexames vezes viadutos
                viagens vices vicios vidas vidracas vidros vigias vigores vilarejos vilas vimes
                vinagres vinhetas vinhos violetas violoncelos viradas virgens virtudes viscondes
                viseiras visitas vistas vitorias vitrais vitrines viuvas vivazes viveiros
                vivencias vizinhancas vizinhos vocabularios volantes voltas volumes voluntarios
                vontades vorazes vovos vozes vulgares waffles xadrezistas xamanismos xamas
                xangos xaras xavantes xavecos xaxados xaxins xelins xenofobias xenofobicos
                xenonios xerens xeretares xeretas xerocares xerocopias xexeus xifoides xifopagos
                xiitas xilemas xilindros xilofonistas xilografias xilogravuras xingamentos
                xingares xinxins xistos xixis xodos xucros yakisobas yogas zagueiros zebras
                zeladores zelosos zenites zeros zigotos zincos ziperes zodiacos zombarias zonas
                zoologicos zumbidos zumbis
            ]],
            ultra = [[
                abafado abandonado abencoado abracado abracando abusivo acabado acabando
                acalmado acalmando acampado acampando acendendo acendido acertado acertando
                acessivel acolhedor aconchegante acordado acordando acostumado acostumando
                acreditado acreditando adivinhado adivinhando admirado admirando adorado
                adorando afiado afortunado agitado agradavel agradecendo agradecido agressivo
                ajudado ajudando alcancado alcancando alegrado alegrando alegre almocado
                almocando alto alugado alugando amarrado amarrando amavel ameacador amplo andado
                andando anotado anotando ansioso apagado apagando apaixonado aparecendo
                aparecido apertado apertando aplaudido aplaudindo apontado apontando aprendendo
                aprendido apresentado apresentando apressado aproveitado aproveitando arriscado
                arrogante arrumado arrumando artificial assistido assistindo assustado
                assustando atacado atacando atento atirado atirando atravessado atravessando
                atual audacioso autentico avarento avisado avisando baixado baixando balancado
                balancando barato barulhento batendo batido bebendo bebido beijado beijando belo
                brigado brigando brilhado brilhando brincado brincando bruto burro buscado
                buscando cabendo cabido calado calando caminhado caminhando cansado cantado
                cantando caprichoso careca carinhoso caro carregado carregando casado casando
                cauteloso cavado cavando cego celebre certo chamado chamando chato chegado
                chegando cheio cheirado cheirando chorado chorando chovendo chovido cinzento
                claro colado colando colhendo colhido comecado comecando comendo comico comido
                complexo comprado comprando comprido comum conduzido conduzindo confuso
                conhecendo conhecido conquistado conquistando conseguido conseguindo construido
                construindo contado contando contente continuado continuando convidado
                convidando copiado copiando corajoso correndo corrido cortado cortando cortes
                costurado costurando crescendo crescido criado criando cruel cruzado cruzando
                cuidadoso cuidando cumprido cumprindo curado curando curioso curto dancado
                dancando decidido decidindo defendendo defendido deitado deitando deixado
                deixando delicado denso derramado derramando desastrado descansado descansando
                descendo descido desejado desejando desenhado desenhando desonesto despedido
                despedindo despertado despertando destruido destruindo devolvendo devolvido
                diferente dirigido dirigindo discutido discutindo distante divertido dividido
                dividindo dobrado dobrando doente dolorido dormido dormindo duvidado duvidando
                educado educando elegante elogiado elogiando embarcado embarcando emocionante
                emprestado emprestando enchendo enchido encontrado encontrando enfrentado
                enfrentando enganado enganando enorme ensinado ensinando entendendo entendido
                entrado entrando enviado enviando errado errando escolhendo escolhido escondendo
                escondido escuro escutado escutando esforcado esperado esperando esperto espesso
                esquecendo esquecido esquisito estranho estudado estudando evidente evitado
                evitando exato excelente exotico explicado explicando extenso fabricado
                fabricando facil falado falando falso faltado faltando familiar famoso
                fantastico fechado fechando fervendo fervido ficado ficando fingido fingindo
                fino firmado firmando firme flexivel fofo forte fraco franco fugido fugindo
                funcionado funcionando furado furando furioso generoso gentil glorioso gordo
                gostado gostando governado governando grato gritado gritando grosso guardado
                guardando guiado guiando guloso habilidoso herdado herdando honesto horrivel
                humido ignorante igual imaginado imaginando imenso imovel imponente importante
                impossivel incrivel inesperado infantil interessante inventado inventando
                invisivel jogado jogando juntado juntando jurando justo lavado lavando lembrado
                lembrando lento levado levando levantado levantando leve libertado libertando
                ligado ligando limpado limpando limpo lindo liso longo louco lutado lutando
                machucado machucando macio magnifico maluco mandado mandando manso maravilhoso
                marcado marcando mastigado mastigando medido medindo medroso melhor mentido
                mentindo merecendo merecido mergulhado mergulhando mesquinho misterioso
                misturado misturando miudo moderno modesto molengo molhado monstruoso morado
                morando mordendo mordido mostrado mostrando mudado mudando nadado nadando
                nascendo nascido navegado navegando necessitado necessitando negado negando
                nervoso nomeado nomeando notado notando novo nublado numeroso obedecendo
                obedecido obediente obscuro observado observando ocupado ocupando olhado olhando
                ordinario orgulhoso original ouvindo paciente palido parado parando parecendo
                parecido partido partindo passando passeado passeando pedido pedindo pensado
                pensando perdendo perdido perdoado perdoando perfeito perguntado perguntando
                perigoso permitido permitindo pesado pesando pescado pescando picante pintado
                pintando pisado pisando plantado plantando pobre poderoso pontual pratico
                precioso preguicoso preocupado preocupando preparado preparando prestativo
                procurado procurando produzido produzindo profundo prometendo prometido
                protegendo protegido provado provando proximo prudente puro puxado puxando
                quebrado quebrando queimado queimando querendo querido quieto rapido raro
                rasgado rasgando realizado realizando recebendo recebido recordado recordando
                recusado recusando refletido refletindo reforcado reforcando regado regando reto
                rezado rezando rico rigido rodado rodando roubado roubando rude sabendo sabido
                sabio saboroso sacudido sacudindo salvado salvando saudavel secado secando
                secreto seguido seguindo selvagem sensato sentado sentando sentindo separado
                separando serio servido servindo simpatico simples sincero sofisticado solitario
                soltado soltando sombrio sonhado sonhando sonolento soprado soprando sorrido
                sorrindo subido subindo sujado sujando sujo suportado suportando supremo surgido
                surgindo tapado tapando tentado tentando terminado terminando timido tirado
                tirando tocado tocando tolo tomado tomando torcendo torcido tornado tornando
                trabalhado trabalhando tranquilo trazendo trazido treinado treinando tremendo
                tremido triste trocado trocando umido unico util vago vazio vencendo vencido
                vendendo vendido verdadeiro vestindo viajado viajando vibrante vivendo vivido
                vivo voltado voltando votado votando zangado
            ]],
            longas = [[
                abastecimento acompanhamento aconselhamento acontecimento administrador
                agradecimento alfabetizacao alimentacao aniversario apresentacao aproximacao
                aquecimento arqueologico arquitetura assistencia atualizacao autenticidade
                automaticamente aventureiro bibliografia biodiversidade brasileiro calculadora
                capacitacao caracteristica cardiologista celebracao centimetro cerimonial
                cinematografia circunstancia classificacao colaboracao colecionador combinacao
                comemoracao compartilhar complicacao compreensao comunicacao concentracao
                condicionador confeitaria conferencia confiabilidade congratulacao conhecimento
                consequentemente conservatorio consideracao constitucional construcao consumidor
                contabilidade contemporaneo continuidade contribuicao conveniencia cooperacao
                coordenador corporacao correspondencia criatividade cronometrista cumprimento
                definitivo delicadeza democratizacao demonstracao departamento dermatologista
                desenvolvimento dimensionamento disponibilidade distribuicao diversidade
                dramaturgia educacional eletrodomestico emergencia empreendedor encarregado
                engenharia entretenimento escolaridade estabelecimento estacionamento
                estrategista estruturacao evolucionista exclusividade experimental explicacao
                exploracao extraordinario fabricacao fantasmagorico festividade fiscalizacao
                fisioterapeuta fisioterapia fotografia funcionamento fundamental generosidade
                geografico gerenciamento gradativamente gratificacao habilidade harmonizacao
                hospitalidade identificacao iluminacao ilustracao imaginacao implementacao
                importancia impossibilidade impressionante incentivador independencia
                independente indicadores individualidade industrializacao inexperiencia
                infraestrutura institucional integracao inteligencia interligacao internacional
                investigacao jornalismo jurisprudencia legislacao liquidificador literatura
                luminosidade magnificencia manifestacao manutencao mecanizacao meteorologia
                meteorologista metodologia mobilizacao modernizacao monitoramento movimentacao
                multiplicacao musicalidade naturalidade necessidade neurologista nomenclatura
                nutricionista observatorio oftalmologista operacional oportunista organizador
                originalidade ornamentacao otimizacao paleontologo paralelepipedo paralelismo
                participacao particularidade passatempo pavimentacao penitenciaria periodicidade
                personalidade pesquisador planejamento portabilidade possibilidade
                potencialidade precipitacao preocupacao preparacao preservacao presidencia
                profissional programacao prosperidade protagonista psicologicamente quadrilatero
                quantidade reabilitacao realizacao recomendacao reconhecimento recuperacao
                refrigerador relacionamento remuneracao representacao reproducao
                responsabilidade responsavel restauracao rodoviaria satisfacao sensibilidade
                simplicidade simultaneamente sinalizacao sobrevivencia solidariedade sonoridade
                sustentabilidade sustentavel telecomunicacao terapeutico territorial tradicional
                tranquilidade tranquilizante transbordador transformacao transmissao
                transparencia transportador treinamento universidade urbanizacao utilizacao
                valorizacao vegetariano velocidade verificacao viabilidade vicepresidente
                visibilidade voluntariado
            ]],
        },
        en = {
            comuns = [[
                aback ability able absence abyss accident account action activity actor adult
                adventure advice afraid after again agency agent agree ahead airplane airport
                airy alarm album alive allergy alley allow alloy ally almond alone alphabet
                amazing anarchy anchor ancient angel anger angle angry anguish animal annex
                annoy answer anxiety anyhow apology apple approach april arch area armor army
                array arrow artist attack attic aunt autumn avalanche average avocado awake
                award baby back bacon badge baker bakery balance ball banana band bandy bank
                banner bark barn barrel basket bath battery battle beach beak bean bear beard
                beauty bee beetle bell bellow belly below belt bench berry bicycle billow bird
                birth biscuit bishop black blanket bleach bleak blink blitz blizzard block
                blossom blow blue blush boat body bone book boot booth border borrow bottle
                bottom bowl boxy brain branch brave bread break breath breeze brick bridge
                bright brook broom brother brunch brush bubble buck bucket building bulk bullet
                bully bunch bungalow bunny burrow busy butter butterfly button buzz cabin cable
                cactus cake calendar camel camera camp canary candle candy canoe canvas canyon
                captain card carpet carrot carry cash castle catch cave cavern cavity ceiling
                cellar century cereal chain chair chalk champion chapter check cheek cheese
                cherish cherry chest chew chick chicken child chilly chimney chunk church circle
                circus city clarity claw climax cloak clock cloth cloud cloudy clown clutch
                coach coast coconut codex coffee collar color comedy comet company compass
                complex computer convex cook cookie copper copy coral corner cotton couch
                country courage cousin cozy crack crash crayon crazy cream creamy creek croak
                crook crow crown crunch crush crystal curly currency curtain cycle daddy dagger
                dairy daisy dance danger dark dash dawn death deck deer delivery delta density
                depth desert desk destiny detective diamond diary difficulty dinner dinosaur
                discovery dish disk dispatch dizzy dock doctor doll dolphin donkey door dove
                dragon drank draw drawer dream drench dress drew drink drum duck dungeon dunk
                duplex dusk dust dusty dynasty each eagle early earth east easy echo eclipse
                economy edge eighth elbow elderly elephant embassy ember emerald emergency
                empire empty endow enemy energy engine engineer enjoy enrich entry envy equinox
                essay establish evening exam example explorer eyebrow fabric face factory fairy
                faith falcon fallow family fancy fantasy farm farmer father feather fellow fence
                ferry festival fetch field fiery fifth fifty finger finish fire fish fishy fizz
                flag flame flank flash flavor flax flex flick flock flood floor flourish flow
                flower flute fog foggy folk follow food foolish foot forest fork fortress
                fountain fourth fox frame frank freak fresh friend frizz frog frost frosty fruit
                funny furnish furrow fury fussy future fuzz fuzzy galaxy gallery game garage
                garden garlic gate gaudy gawk gearbox geek geometry ghost giant gift giraffe
                glacier glass glitz gloomy glory glove glow gnash gnaw goat goblin gold golf
                goose gorilla grain grape graph grass gravity gravy greasy greedy green grocery
                grouch ground group grow growth grumpy guard guardian guest guide guitar gulch
                gummy gunk guppy gush gusty hack hair hairy hall hammer hand handy happy harbor
                hare harmony harp harrow harsh harvest hash hasty hatch hawk hazy head health
                healthy heart hearth heat heavy hedge helmet hero hertz hill hippo history hoax
                hobby hockey holiday hollow home honey hook horizon horn horse hospital hotel
                hour house hulk hunch hungry hunter hurricane hurry hush husk hutch ibex iceberg
                icebox icicle idea igloo illusion image imagery imagine inch index industry
                infantry infinity injury inquiry insect instrument invention inventor iron irony
                island itch itchy ivory ivy jack jackal jacket jaguar jail jar jaw jazz jazzy
                jelly jerky jester jet jewel jigsaw jinx job jockey jolly journey joy judge
                juice juicy jukebox jumpy jungle junk jury justice kangaroo kayak kennel kettle
                key keyboard kick kidney kimono king kingdom kiosk kiss kitchen kite kitten
                kitty knee knew knife knight knish knobby knock knot knotty know koala kooky
                kowtow label labyrinth lace lack ladder lady lagoon lake lamb lamp land lantern
                lark laser lash latch latex laugh launch laundry lawn lazy leaf leak leash
                leather legacy legend lemon length leopard letter liberty library light
                lightning lily lion lively lizard lobby lock lonely look lovely luck lucky
                lullaby lunar lunch lurch luxury lynx machine magic magnet mail marble march
                mark market marrow marry marsh mask mastery match math matrix meadow meal medal
                medley mellow melody melon memory menu meow mercy mermaid merry messy metal
                meteor microphone midnight mighty milk mind mine minnow mint mirror mist misty
                mitten mock money monk monkey monster month moon morning morrow moth mother
                motor mountain mouse mouth much muddy muffin mummy munch muscle museum mush
                mushy music musk mystery myth nail name nanny napkin narrow nasty nature nebula
                neck nectar needle needy nest net newspaper nick night ninja ninth noble nobody
                noisy noodle nook noon north nose nosh notch note notebook novelty number nurse
                nursery nut nutmeg nutty oak oasis oath obesity obey ocean octopus oddity office
                oink olive onion only onyx oracle orange oratory orbit orchestra orchid ornery
                ostrich otter ouch outback outbox outgrow outlay outpost ovary oven overflow
                overthrow owl oxbow oyster pack paddle page paint pair palace palm panda pantry
                paper parade paradise parchment parent park parrot party passport pastry patch
                path peach peak peanut pearl pencil penguin penny pepper perch phlox phoenix
                piano pick picky picnic picture pillow pilot pink pirate pitch pith pizza planet
                plank plant plate plenty plow plunk plush pocket poem poetry policy polish pond
                pony pool poppy porch pork portal potato pouch poverty powder pretty prince
                princess privacy prow proxy publish puffy pumpkin punch punish puppet puppy push
                pushy puzzle pyramid quack quail quality quantity quark quarry quarter quartz
                quash queasy queen query quest question quick quicksand quiet quill quilt quirk
                quirky quiver quiz rabbit race rack radio radish raft rain rainbow rainy rally
                ranch ranger rank rapier rash raven razor razz reach ready reality recovery reef
                reek reflex relax relish remedy remix renew reply rhythm ribbon rice rich ring
                rink risk risky rivalry river roach road robbery robot rock rocket rocky roof
                rook room root rope rose rough rowdy royalty rubbish ruby rugby ruins ruler rush
                rusk rusty sack saddle safety sail salad salary salt salty samurai sand sandwich
                sandy sapphire sash satellite scarf scary scenery school scissors scratch screen
                seal search secret seed serpent shadow shallow shape shark sheath sheep shell
                shield shiny ship shirt shock shoe shop shore shoulder show shrink sick silk
                silly silver sister skate skeleton sketch skunk slash sled sleek sleepy sleuth
                slick slow smack smash smooth snack snail snake sneak snow snowy soap soapy
                society sock soil soldier song sorrow sorry soup south spark speak speck speech
                sphinx spider splash spooky spoon sport spray spring spritz square squash squeak
                squirrel stable stack stage stalk stamp star stash station steak steam stench
                stick stitch stock stone stork storm story stove strategy straw streak stream
                street stretch stuck suffix sugar summer summit sunny sunset surgery swallow
                swamp swan sweater swing switch sword symphony syntax table tack tail tailor
                talk tallow tank tapestry tardy task tasty teach teacher teak team teddy teeth
                tempest temple tent tenth territory thank thaw theater theory think thirsty
                thirty thorax thrash thread throne throw thrush thumb thunder ticket tiger tile
                timber tiny toad toast today tomato tomorrow toolbox tooth topaz torch tornado
                touch tough towel tower track tractor tragedy train trash treasure tree trek
                triangle trick tricky trolley trophy truck trumpet trunk truth tuck tulip tummy
                tunnel turkey turtle tusk tweak twenty twilight twitch ugly umbrella unblock
                uncle unearth uneasy unholy unicorn uniform unisex unity universe unlock unlucky
                unpack unruly unscrew uproar upward uranium urchin usury utility utopia valley
                vampire vanish vanity vanquish variety varnish vary vase vegetable velvet vertex
                very vest vetch victory view viking village vine violet violin volcano volley
                vortex vouch voyage vulture wacky waffle wagon waist walk wall wallet wallow
                walrus waltz wand warrior wash watch water waterfall watery wave wavy weak
                wealth wealthy weary weather wedding week weekly weigh whale wheat wheel
                wheelbarrow which whisk whisper whistle wick widow width wiggly willow wind
                window windy wing wink winter wintry wire wish witch wizard wobbly wolf wonder
                wood wool woolly wordy work worm worry worth wrath wreck wrench xanthan xanthic
                xanthine xebec xenograft xenolith xenon xenophobe xenophobia xenophobic xeric
                xerography xerophyte xerosis xerox xiphoid xylem xylene xylitol xylophone
                xylophonist xylose yacht yank yard yarn yeah year yearly yeasty yellow yeti yoga
                yogurt yolk yonder yucky yummy zany zebra zenith zephyr zeppelin zero zesty
                zigzag zilch zingy zipper zippy zodiac zombie zone zonk zoology zucchini
            ]],
            extras = [[
                aardvark abacus abalone abandon abase abash abashed abate abattoir abbe abbess
                abbey abbot abdicate abdomen abduce abduct abductee abduction abductor abet
                abettor abide abject abjure ablate ablative ablution abnegate abode abolish
                abominate aborigine abortion abound abrade abrasion abrasive abreact abridge
                abrogate abrogator abrupt abscess abscise abscissa abscond abseil absent
                absentee absolute absolve absorb absorbent abstain abstract abstruse absurd
                absurdist absurdity abundance abuser abusive abut abutment acacia academic
                academy acanthus accede accent accept access accession accessory acclaim
                acclimate acclivity accolade accompany accord accordion accost accouter accredit
                accrete accrual accrue accuracy accurate accursed accuse accustom acerb acerbate
                acetate acetify acetylate ache achene achieve achy acid acidify acidulate acme
                acne acolyte aconite acorn acquaint acquiesce acquire acquittal acre acreage
                acrid acrobat acronym acropolis acrostic acrylic activate activator active
                activist actress actuality actualize actuary actuate actuator acuminate acute
                adage adagio adamant adapt adapter adaptive addend addition additive addle
                address addressee adduce adduct adenoid adept adequacy adequate adhere adherent
                adhesive adieu adjective adjoin adjourn adjudge adjunct adjure adjust adjuster
                adjutant admeasure admiral admire admission admit admix admixture admonish adobe
                adopt adopter adoption adore adorn adornment adrenal adroit adsorb adsorbent
                adulate adulator adumbrate advance advantage advent adverb adverbial adversary
                adverse adversity advert advertise advisable advise advised advisor advisory
                advocate adze aerate aerator aerial aerialist aerie aerify aerodrome aerosol
                aesthete affair affect affected affection affective affiance affidavit affiliate
                affinity affirm affix afflict afford afforest affray affricate affright affront
                afghan afterglow afternoon afterword agate ageist ageless agenda aggrade
                aggravate aggregate aggress aggressor aggrieve agile agitate agitator agnate
                agnostic agonize agony agrarian agreement aide aigrette aileron ailment aimless
                airbag airbase airbrush airbus airdrop airfare airfield airfoil airhead airlift
                airline airlock airmail airship airstrike airstrip airt airway aisle aitch
                alarmist albacore albatross albino alchemist alchemize alcohol alcove alder
                alehouse alembic alert algebra algorithm alias alibi alien alienable alienate
                alienist alight align aligner alignment aliment alkalify alkalize alkaloid alkyd
                allay allege allegory allegro allele alleluia allergen allergist alleviate
                alleyway alliance alligator allocate allot allotment allowance allude allure
                allusion allusive alluvium almanac almoner almshouse aloe aloha aloof alpaca
                alpha altar alter alterable altercate alternate altimeter altitude altruist alum
                aluminize amalgam amaryllis amass amateur amative amaze amazon ambiance
                ambiguity ambiguous ambition ambitious amble ambulance ambulate ambuscade ambush
                amend amendment amenity amerce amethyst amide ammeter ammoniate ammonify
                amnesiac amnesic amnesty amnion amoeba amorous amorphous amortize amount amour
                ampere ampersand amphibian ample amplify amplitude ampule amputate amputee
                amulet amuse amusement anaconda anaerobe anagram analgesic analog analogize
                analogous analogue analogy analysand analysis analyst analyze analyzer anapest
                anapestic anarchist anathema anatomist anatomize anatomy ancestor ancestry
                anchorage anchorite anchovy ancillary andante andiron android anecdote anele
                anemone aneurysm angelfish angleworm anglicize angora angstrom angulate anil
                animalize animate animation animator animist animosity ankle anklebone anklet
                ankylose annalist anneal annelid annotate annotator announce annoyance annual
                annuitant annuity annul annulment anode anodize anodyne anoint anomalous anomaly
                anorak anorectic anorexic antacid ante anteater antecede antedate antelope
                antenna anteroom anthem anther anthill anthology anti antibody antic anticline
                antidote antigen antipasto antipathy antiphon antiquary antiquate antique
                antiquity antiserum antitoxin antivenin antiviral antler antonym antsy anvil
                anxious anybody anything aorta apart apartment aperitif aperture apex aphasic
                aphelion aphid aphorism aphorize apiarist apiary apogee apologia apologist
                apologize apoplexy apostasy apostate apostle apothegm appall appaloosa apparatus
                apparel apparent appeal appealing appear appease appellant appellate append
                appendage appendix appertain appetite appetizer applaud applet appliance
                applicant applier applique apply appoint appointee apportion appose apposite
                appraisal appraise apprehend apprise apprize approbate approval approve
                approving apricot apron apse aptitude aptness aqua aqualung aquanaut aquaplane
                aquarium aquatic aquatint aqueduct aquifer arabesque arachnid arbiter arbitrage
                arbitrate arbor arboretum arbutus arcade arcane archaism archaist archaize
                archangel archduke archenemy archetype archfiend architect archive archivist
                archway arctic ardor arduous argosy argot arguable argue argufy argument argyle
                aria arid arise armada armadillo armament armature armband armchair armful
                armhole armistice armlet armory armpit armrest aroma aromatic aromatize arouse
                arpeggio arraign arrange arranger arras arrest arrival arrive arrogate arrowhead
                arroyo arsenal arsonist arteriole artery artful arthritic arthropod artichoke
                article artifact artifice artisan artiste artistic artless artsy artwork arty
                arum asbestos ascend ascendant ascension ascent ascertain ascetic ascot ascribe
                ashamed ashcan ashlar ashram ashtray ashy aside asininity aspect asperity
                asperse asphalt asphodel aspic aspirant aspirate aspirator aspire aspirin assail
                assailant assassin assault assay assemble assembler assembly assent assert
                assertion assertive assess assessor asset asshole assiduity assiduous assign
                assignee assigner assignor assist assistant assize associate assoil assonant
                assort assuage assume assurance assure assured aster asterisk asteroid asthmatic
                astonish astound astrolabe astronaut astute asymmetry atavist ataxic atelier
                atheist athlete atoll atom atomize atone atrocious atrocity atrophy attach
                attache attain attaint attemper attempt attend attendant attendee attention
                attentive attenuate attest attire attitude attorn attorney attract attribute
                attune auction audacious audible audience audio audiotape audit audition auditor
                aught augment augur augury august auntie aura aureole auricle aurify auspicate
                auspice austere austerity authentic author authoress authority authorize auto
                autobahn autoclave autocracy autocrat autograph automaker automate automatic
                automaton autopilot autopsy auxiliary avail avatar avenge avenue averse avert
                aviary aviate aviator aviatrix avid avocation avoid avouch avow avowal await
                awaken awakening aware awareness awesome awful awkward axiom axle axletree
                axolotl axon azalea azure babbitt babble babe babel baboon babushka bacchanal
                bach bachelor backache backbite backboard backbone backcomb backcross backdate
                backdrop backfield backfire backhand backhoe backlash backlog backpack backpedal
                backrest backseat backside backslash backslide backspace backstop backtrack
                backup backward backwater backyard baddie badger badmouth baffle bagatelle bagel
                bagful baggy bagpipe baguette baht bail bailiwick bailout bairn bait bake
                bakeshop balaclava balalaika balboa balcony bald baldhead baldric bale baleful
                balk balky ballad balladeer ballast ballcock ballerina ballet ballgame balloon
                ballot ballpark ballpoint ballroom balls ballsy bally ballyhoo balm balmy balsa
                balsam baluster bamboo bamboozle banality bandage bandanna bandbox bandit
                bandoleer bandstand bandwagon bane bang bangle banish banister banjo banjoist
                bankbook bankcard banknote bankroll bankrupt bannock banquet banquette banshee
                bant bantam banter banyan banzai baobab baptism baptize barb barbarian barbarism
                barbarity barbarize barbarous barbecue barbel barbell barber barberry barcarole
                bard bare barf barfly bargain barge barista baritone barkeep barker barm barmaid
                barmy barnacle barnstorm barnyard barometer baron baronage baroness baronet
                baronetcy barony baroque barrack barracuda barrage barre barred barren barrette
                barricade barrier barring barrister barroom barrow bartender barter baryon
                basalt base baseball baseboard baseline basement bash bashful basic basilica
                basilisk basin basinful bask bass basset bassinet bassist basso bassoon basswood
                baste bastinade bastinado bastion batch bate batfowl bathhouse bathmat bathrobe
                bathroom bathtub batik baton batt battalion batten batter battleaxe batty bauble
                baud bawd bawdy bawl bayberry bayonet bayou bazaar bazooka beachhead beacon bead
                beadle beady beagle beam beamy beanbag beanie beanpole beanstalk bearish
                bearskin beast beastly beat beatify beatitude beatnik beau beaut beauteous
                beautify beaver bebop becalm bechance becharm beck beckon becloud becoming
                bedaub bedazzle bedbug bedeck bedevil bedew bedfellow bedight bedizen bedlam
                bedpan bedpost bedraggle bedrock bedroll bedroom bedside bedsore bedspread
                bedstead bedtime beech beechnut beef beefcake beefsteak beefy beehive beekeeper
                beeline beep beery beet befall befool befoul befriend befuddle beggar beginner
                beginning begird begonia begrime begrudge beguile beguine begum behave behavior
                behest behind behold behoove bejewel belabor belated belay beleaguer belfry
                belie belief believe believer belittle bellboy belle bellhop bellyache bellyful
                belong beloved beltway beluga bemire bemoan bemock bemuse benchmark bend bendy
                benefice benefit benighted bent benumb bequeath bequest berate bereave beret
                berg berm berth beryl beseech beseem beshrew besiege besmear besmirch besom
                bespangle bespatter bespeak best bestiary bestow bestowal bestrew bestride beta
                betake bethink betide betoken betray betrayal betroth betrothal better bettor
                bevel beverage bevy bewail beware bewilder bewitch bewray bezel bias biathlon
                bible bicarb bicep bicker bicuspid bicyclist bidder biddy bidet bield biennial
                biennium biff bifurcate bigamist biggie bighead bighorn bight bigot bigotry
                bigwig bike bilabial bilge bilingual bilious bilk bill billboard billet billfold
                billion billy bimonthly binary bind binder bindery binding binge binnacle
                binocular binomial biofilm biography biologist biomarker biopic biopsy biorhythm
                biosphere biped biplane birch birdbrain birdhouse birdie biretta birl birr
                birthday birthmark birthrate bisect bisection bisector bishopric bistro bitcoin
                bite bitt bitter bittern bitty bivalve bivouac biweekly bizarre blab blabber
                blackball blackbird blacken blackhead blackjack blacklist blackmail blackout
                blacktop bladder blade blame blameless blanch bland blandish blank blare blarney
                blaspheme blasphemy blast blastoff blatancy blather blaze blazon bleary bleat
                bleed bleep blemish blench blend bless blessed blight blimp blind blindfold
                blindside blini blinker blintz blip blissful blister blithe blitheful blither
                bloat blob bloc blockade blockage blockhead blocky blog blogger bloke blond
                blonde bloodless bloodline bloom bloomy bloop blot blotch blotchy blotter blouse
                blowfly blowgun blowhard blowjob blowout blowpipe blowtorch blowup blowy blowzy
                blubber bludgeon bluebell blueberry bluebird bluefish bluegill bluenose
                bluepoint blueprint bluesy bluet bluff blunder blunt blur blurb blurry blurt
                blushing bluster boar board boardroom boardwalk boast boastful boathouse
                boatswain bobbin bobble bobby bobcat bobolink bobsled bobtail bobwhite bodega
                bodge bodice bodkin bodyguard bodysuit bogey boggle boggy bogie bogus bohemian
                boil boink bold boldface bole bolero bolivar boll bollix bolster bolt bolus bomb
                bombard bombshell bonanza bonbon bond bonehead bonfire bong bongo bonk bonnet
                bonny bonobo bonus bony boodle boogie boohoo bookcase bookend bookie booklet
                bookmaker bookmark bookplate bookshop bookstore bookworm boom boombox boomerang
                boon boor boorish boost bootblack bootee bootleg bootless bootlick bootstrap
                booty boozy bordello bore born borzoi bosky bosom boss bossy botanical botanist
                botanize botch botchy bother botnet boudoir bouffant bouillon boulder boulevard
                bounce bouncy bound boundary bounder boundless bounteous bountiful bounty
                bouquet bourbon bourgeon bouse bout boutique bouzouki bovine bowel bowleg
                bowlful bowline bowse bowsprit bowstring bowwow boxcar boycott boyhood boyish
                bozo brabble brace bracelet bracer bracero brachiate bracket bract brad brae
                brag braggart bragger braid brail brainwash brainy braise brake bramble brand
                brandish brandy brash brass brassy brat brattice bratty bravo braw brawl brawny
                bray braze brazen brazier breach breadbox breakage breakfast breakout breakup
                bream breathy brecciate breech breed breeder breeding breezy breve brevet
                breviary brew brewery brewpub bribe brickbat bridal bride bridle brie brief
                briefing brig brigade brigand brighten brilliant brim brindle bring brink briny
                brioche brisk brisket bristle bristly brittle broach broad broadcast broaden
                broadside brocade brochure brogan brogue broider broil broken broker bromate
                bromide brominate bronc bronco bronzy brooch brood brooding broody brooklet
                broth brougham brouhaha brow browbeat brown brownie brownout browse bruin bruise
                bruit brunet brunette brushoff brushy brusque brutalize brute brutish bubbly
                buccaneer buckaroo buckeye buckle buckler bucksaw buckskin bucolic buddy budge
                budget budgie buff buffalo buffer buffet buffoon bugaboo bugbear buggy bugle
                build buildup built bulb bulge bulgy bulimic bulkhead bulky bull bulldog
                bulldoze bulletin bullfrog bullhead bullhorn bullish bullock bullpen bullring
                bulrush bulwark bumble bummer bump bumpkin bumpy bunchy bunco bundle bung bungee
                bunghole bungle bunion bunk bunker bunt buoy burble burden bureau burg burgeon
                burgh burglar burglary burgle burgundy burial burka burl burlesque burly burn
                burnable burnish burnoose burnout burr burrito burry bursar bursary burst
                burthen bury busboy busby busgirl bush bushel bushwhack bushy business busk
                buskin buss bust bustle busty busybody butch butcher butchery butler butte
                buttery buttress buyback buyout buzzard buzzkill buzzword bygone bylaw byline
                bypass byroad byte byway byword cabal cabaret cabbage cabby cabinet cablecast
                cabochon caboose cabstand cache cachepot cachet cackle cadaver caddie caddish
                cadence cadenza cadet cadge cadre caesura caff caftan cage cahoot caiman cairn
                caisson caitiff cajole cakewalk calabash calamari calamity calcify calcimine
                calcine calculate caldera calender caliber calibrate caliper calk call calla
                callback caller calling calliope callous callow callus calm calorie calumet
                calumny calve calypso calyx camber cambium came camellia cameo camisole campaign
                camper campfire campsite campus campy camshaft canal canalize canape canard canc
                cancan cancel candid cane canine canister canker cannabis cannery cannibal
                cannon cannonade canny canoeist canon canonize canoodle canopy cant cantata
                canteen canter canticle canto canton cants canty canvass capacity caparison cape
                caper capitate capitol caplet capo capon caponize capped capping caprice
                capriole capsicum capsize capstan capstone capsule capsulize caption captious
                captivate captive captor capture carabin caracole carafe caramel carapace carat
                caravan caravel caraway carbide carbine carbon carbonate carbonize carboy
                carburize carcass cardamom carder cardigan cardinal cardsharp care careen career
                careful careless caress caret carhop caribou carillon carjack cark carload
                carmine carnation carnify carnival carny carob carol carom carotid carousal
                carouse carousel carp carpal carpel carpenter carpool carport carrel carriage
                carryall cart cartel cartload carton cartoon cartwheel carve caryatid casaba
                cascade cascara case caseate caseload casement casework cashbook cashew cashier
                casino cask casket cassava casserole cassette cassia cassock cast castanet
                castaway caste castigate casting castoff castor castrate casual casualty casuist
                catacomb catalog catalpa catalyst catalyze catapult cataract catbird catboat
                catcall catchall catchy cate catechize category catenate cater caterwaul catfish
                catheter cathode catkin catnap cattail catty catwalk caucus cauldron caulk cause
                causerie causeway caustic cauterize caution cautious cavalier cavalry caveat
                cavil cavort cayuse cease cedar cede ceder cedilla ceil celebrate celesta
                celibate cell cellist cellmate cello cellular cement cemetery cenobite cense
                censer censor censure census centaur centavo center centime central centrist
                ceramic ceramist cerate cere cerebrate cerebrum cerement ceremony certain
                certainty certify cesarean cesium cession cesspool cetacean chafe chaff chaffer
                chaffy chagrin chainsaw chaise chalet chalice chalky challenge chamber chamfer
                champ chance chancel chancery chancre chancy chandelle chandler change channel
                chanson chant chantey chap chapbook chapeau chapel chaperon chaplain chaplet
                char charade charbroil charcoal charge charger chariot charity charm charr chart
                charter chary chase chasm chasse chaste chasten chastise chasuble chat chateau
                chattel chatter chatty chauffeur chaw cheap cheapen cheat checker checkmate
                checkoff checkout checkrow checkup cheeky cheep cheer cheerful cheerio cheery
                cheesy chef chelate chemical chemise chemisorb chemist cheroot cherty cherub
                chestful chestnut chesty chevron chevy chewy chic chicane chichi chickpea
                chicory chide chief chigger chignon chilblain childish chill chime chimera chimp
                chin chinchy chine chino chintzy chip chipmunk chipper chirk chirp chirpy chirr
                chirrup chisel chit chitchat chitter chive chivy chloride chock choice choir
                choirboy choke chomp choose choosy chop chopper choppy choral chorale chord
                chordate chore choroid chortle chorus chow chowder christen chrome chronicle
                chub chubby chuck chuckle chuff chug chukka chum chummy chump chunder chunky
                chunter churchly churl churlish churn churr chute chutney chyron ciabatta cicada
                cicatrize cicerone cigar ciliate cinch cinchona cincture cinder cipher circlet
                circuit circular circulate cirque cistern citadel citation cite citify citizen
                citrate citron citrus civet civil civilian civility civilize clabber clack claim
                claimant claimer clam clambake clamber clammy clamor clamp clan clang clank
                clannish clap clapboard clapper claque claret clarify clarinet clarion clash
                clasp class classic classify classy clatter clause claver clavi clavicle clay
                clean cleanly cleanse cleanup clear cleat cleavage cleave clef cleft clematis
                clemency clement clench clergy cleric clerical clerk clever clevis clew cliche
                click client cliff cliffy climate climb clime clinch cling clingy clinic clink
                clip clipper clipping clique cliquish clit clobber cloche clod cloddish clog
                cloggy cloister clomp clone clonk clop close closeout closet closeup closure
                clot clothe clothier cloture clout clove clownish cloy cloying club clubby
                clubfoot cluck clue clump clumpy clumsy clunk clunky cluster clutter coact
                coagulate coal coalesce coalface coarse coarsen coat coattail coauthor coax
                cobble cobweb cobwebby cocainize cochlea cockade cockatoo cockcrow cocker
                cockerel cockle cockney cockpit cocktail cocky coco cocoa cocoon coda coddle
                code coder codfish codger codicil codify codpiece coed coequal coerce coeval
                coexist coff coffin cogitate cognac cognate cognize cognomen cogwheel cohabit
                coheir cohere coherent cohesive coho cohort coif coiffure coil coin coinage
                coincide coinsure coke colander cold coleus coliseum collage collapse collard
                collate collator collect colleen college collide colliery colligate collimate
                collocate collogue colloid collude colly cologne colon colonel colonial colonist
                colonize colonnade colony colophon colorant colorful coloring colorize colt
                coltish column coma comake comb combat combine combiner combo combust come
                comeback comedian comedown comely comfit comfort comfy comic comical comma
                command commando commence commend comment commie commingle comminute commit
                commix commode common commove commune communize commutate commute comp compact
                companion compare compeer compere compete compile complain complete comply
                comport compose composer composite compost compote compound compress comprise
                compute comrade concave conceal conceit conceive concept concern concert
                concerto concise conclave conclude concoct concrete condemn condense condition
                condo condone condor conduce conduit confab confect confer conferee confide
                configure confine confirm conflate conflict confrere confuse confused confute
                cong conga congeal congest congress congruity congruous conic conifer conjugate
                conjunct conjure conk conn connect connive conquer conquest cons conscious
                consent conserve consider consign consist consol consonant conspire constant
                constrict construct construe consul consult consume contact contain contemn
                content contented contest continent continue contort contract contrail contrary
                contrast contrive control contuse convect convene convener convent converse
                convert convey conveyor convict convince convoke convolute convolve convulse
                cookbook cooker cookery cookout cookware cool coolant coolie coonskin coop
                cooper cooperate coot cootie copay cope copilot copious copse copter copula
                copybook copycat copyedit copyhold copyist copyread copyright coquetry coquette
                coracle corbel cord cordial corduroy core corgi cork corker corkscrew corky corm
                corn cornball corncob cornea cornet cornhusk cornice cornrow corny corolla
                coronal coronary coroner coronet corporal corporate corps corrade corral correct
                correlate corridor corrode corrosive corrugate corrupt corsage corsair corset
                cortege coruscate corvette cosh cosign cosine cosmetic cosmos cosponsor cosset
                cost costar costly costume cote coterie cottage cottar cotter cougar cough
                coulee coulomb council counsel count counter countess county coupe couple
                couplet coupling coupon courier course courser court courtesy courtier courtly
                couth couthie cove coven covenant cover coverage coverall coverlet covert covet
                covetous covey coward cowbell cowbird cower cowgirl cowhand cowherd cowhide cowl
                cowlick coworker cowpoke cowrie cowslip coxcomb coxswain coyote coypu cozen crab
                crabbed crabber crabby crackle crackpot crackup cradle craft crafty crag craggy
                cramp crampon crane cranium crank cranky cranny crape crappie crass crate crater
                craunch cravat crave craven craw crawdad crawl crawly crayfish craze creak
                creaky creamery crease create creation creative creator creature creche credenza
                credit creditor credo credulous creed creel creep creepy cremate creme crenel
                crenelate creole creosote crepe crepitate crescendo crescent crest crevasse
                crevice crew crib cribber crick cricket crier crime criminal criminate crimp
                crimson cringe crinkle crinkly crisp crispy critic critical criticize critique
                critter croaky crochet crock crocus croft crone crony crooked croon crop
                cropland cropper croquet crosier cross crossbar crossbow crosscut crosse
                crossruff crotchet crouch croupy crouton crowbar crowd crowdfund crowfoot
                crucible crucifix crucify cruddy crude crudity cruel cruelty cruet cruft cruise
                cruller crumb crumble crumbly crumby crummy crump crumpet crumple crunchy
                crupper crusade cruse crust crusty crutch crux crybaby crypt cube cubicle cubist
                cubit cuckold cuckoo cucumber cuddle cuddly cudgel cuff cuisine cull culminate
                culotte culprit cult cultist cultivar cultivate culture culvert cumber cumulate
                cunning cupboard cupcake cupful cupid cupola curacy curate curative curator curb
                curd curdle cure curer curfew curie curio curious curl curler curlew curlicue
                currant current curry currycomb curse cursive cursor curt curtail curtsy curve
                curvy cushion cushy cusp cuspid cuspidor cuss cussed custard custom customize
                cutaway cutback cute cutesy cuticle cutie cutlass cutler cutlet cutoff cutout
                cutter cutting cutup cutworm cyborg cyclamen cyclical cyclist cyclone cygnet
                cylinder cymbal cynic cynosure cypress cyst czar czarina czarist dabber dabble
                dace dacha dactyl dactylic dadaist daemon daffodil daffy daft dahlia daily
                dainty daiquiri dais dale dally damage damascene damask dame damp dampen damsel
                damson dandify dandle dandy dang dangle danish dank danseuse dapper dapple dare
                daring darken darkroom darling darn darned dart dashiki dastard database dataset
                date dateline dative daub daughter daunt dauphin davit dawdle daybed daydream
                daylight daze dazzle deacon dead deadbeat deadbolt deaden deadhead deadline
                deadlock deadly deadpan deaf deafen deal deanery dear deary deathbed debacle
                debate debauch debility debonair debouch debt debtor debut decade decadent decaf
                decagon decal decay decedent deceit deceive deceiver decency decennial decent
                decibel decide decided decimal decimate decision decisive deckhand declare
                decline decoct decor decorate decorous decorum decoupage decoy decree decrement
                decrypt dedicate deduce deed deejay deem deep deepen deepfake defacer defalcate
                defame defeat defecate defect defective defector defense defensive deferral
                deficit define definer definite deflate deflect defogger defraud defray defrock
                deft defy degauss degree dehisce deicer deify deign deist deity deject dejected
                dekagram delay delegate delete deli delicacy delicate delineate delint delirium
                deliver dell delude delusion delusive delve demand demarcate demean demesne
                demigod demijohn demise demo democrat demolish demon demonize demote demulsify
                demur demure demurral demurrer denazify dendrite denial denigrate denim denizen
                denounce dense dent dentist denture denudate deny deodorize dependent depict
                deplete deplore deploy depone deponent deport deportee deposit deprave deprecate
                deprive depute deputize deputy derby derisive derogate derrick derriere dervish
                descend descry desecrate deserved desiccate design designate desire desist
                desktop desolate despair desperate despise dessert destine destroy destruct
                detach detain detainee detect detector detente deter determine detest dethrone
                detonate detox detoxify detract deuce devastate develop deviant deviate devil
                devilish devilry deviltry devious devise devoice devolve devoted devotee
                devotion devour devout dewberry dewclaw dewdrop dewlap dewy dhoti dhow diabetic
                diabolize diadem diagnose diagonal diagram dial dialect dialogue dialyze
                diameter diapason diaper diarist diaspora diastase diatom diatribe dibble dice
                dicker dickey dictate dictator diddle diesel diet dietary diff differ diffract
                diffuse digest digested digger digit digitize dignify dignity digress dike
                dilate dilator dilemma dill dilly dilute dime dimension diminish dimmer dimple
                dimwit dinar dinette ding dingbat dinghy dingle dingus dingy dinky dint diocesan
                diocese diode diorama dioxide dioxin diploid diploma diplomat dipole dipper
                dippy dipstick dire direct direction director dirge dirk dirndl dirty disable
                disburse discern disciple disclose discord discover discreet discrete discus
                disdain disguise dishevel dishpan dishrag disjoint diskette dislike dislodge
                dismay dismember disparage dispense disperse dispirit disposal dispose dispread
                disproof dispute disquiet disrupt dissect dissemble dissent dissipate dissolute
                dissolve dissuade distaff distance distant distaste distinct distort distrain
                district disturb ditch dither ditto ditty ditz diuretic diva divagate divan dive
                diverge diverse diversify divert divest divide dividend divine divinity division
                divisive divisor divorce divorcee divot divulge divvy dizen djellaba dobbin
                doberman docent docket dockyard doctrine document dodder dodge dodgy dodo does
                doeskin doff dogcart doge dogfish dogged doggone doggy doghouse dogie dogleg
                dogma dogmatize dogtrot dogwood doily doing dole doleful dollar dollop dolly
                dolmen dolorous dolt doltish domain dome domestic domicile dominant dominate
                domineer dominion dona donate donation done dong dongle donne donor doodad
                doodle doom doorbell doorknob doormat doorstep doorstop doorway dooryard dork
                dorky dorm dory dosage dose doss dossier dotard dotcom dotty double doublet
                doubloon doubt doubtful douche doughnut doughty doughy dour douse dovecote
                dovetail dowager dowdy dowel dower down downbeat downfall downgrade downhill
                download downplay downpour downshift downside downsize downturn downward downy
                dowry dowse doxology doyen doyenne dozen dozy drab drachma draft draftee drafter
                drafty drag draggy dragnet dragoon drain drake dram dramatize drape draper
                drapery drawback drawl drawn dray dread dreadful dreamy dreary dredge dresser
                dressing dressy dribble driblet drift drill drip dripping drippy drive drivel
                driveway drizzle drogue droll drollery drone drool droop droopy drop dropkick
                droplet dropout dropper drought drove drown drowse drowsy drubber drubbing
                drudge druggist druid drumbeat drumlin drummer drunkard drunken drupe dryad
                dryer dual duality dubber dubious ducat duce duchess duchy duckbill duckling
                ducky duct ducts dude duel duelist duenna duet duff dugout duke dukedom dulcify
                dulcimer dull dullard dumbbell dumbfound dumdum dummy dump dumpling dumpster
                dumpy dunce dune dungaree dupe duplicate durable dusky dustbin dustpan dutiful
                duty duvet dwarf dwell dwindle dybbuk dyed dyestuff dynamic dynamite dynamo
                dyslexic eager eaglet earache earbud eardrum earful earl earldom earlobe earmark
                earmuff earn earnest earphone earplug earring earthly earthy earwig ease easel
                easement easiness easterly eastern eastward eatable eatery eave ebonize ebony
                echelon eclair eclectic eclogue economize ecstasy eddy edema edgy edible edict
                edifice edify edit edited edition editor editorial educable educate educator
                educe eerie efface effect effective effectual effendi effete efficacy effigy
                effluent effort effuse effusive egest eggcup egghead eggplant eggshell egoist
                egotist egress egret eide eight eighteen eighty eject ejection ejector elaborate
                eland elapse elastic elate elated elder elect election elective elector
                electrify electron elegance elegant elegiac elegize elegy element elevate
                elevator eleven elicit elide eliminate elision elite elitist elixir ellipse
                elodea elongate elope elucidate elude elusive elute elver emaciate email emanate
                embalm embank embargo embark embarrass embed embellish embezzle embitter
                emblazon emblem embody embolden embolism emboss embow embower embrace embrangle
                embrasure embroider embroil embryo emcee emend emendate emerge emetic emigrant
                emigrate emigre eminence emir emirate emissary emission emitter emoji emote
                emoticon emotive empale empathize emperor emphasize emplane employ employee
                employer emporium empower empress empurple emulate emulator emulsify emulsion
                enable enabler enact enactment enamel enamor encamp encase enchain enchant
                encipher encircle enclave enclose encode encomium encompass encore encounter
                encourage encrimson encroach encrust encrypt encumber encyst endanger endear
                endeavor endemic endive endless endorse endpoint endue endure enema energize
                enervate enfeeble enfilade enfold enforce engage engender engorge engraft engram
                engrave engross engulf enhance enjoin enkindle enlace enlarge enlighten enlist
                enlistee enliven enmesh enmity ennoble enormity enormous enounce enplane enqueue
                enrage enrapture enrobe enroll ensconce ensemble enshrine enshroud ensign ensile
                ensnare ensue ensure entail entangle entente enter entertain enthrall enthrone
                enthuse entice entitle entity entomb entrain entrance entrant entrap entreat
                entreaty entree entrench entrust entryway entwine enumerate enunciate envelop
                envenom envious environ envisage envision envoy enzyme epaulet epee epic epicure
                epidemic epigram epigraph epilate epilogue epiphany episode epistle epithet
                epitome epitomize epoxy epsilon equal equality equalize equate equator equerry
                equine equip equipage equipped equity equivocal eradicate erase erasure erection
                erector eremite ermine erode erose errancy errand errata error ersatz eruct
                eructate erudite erupt eruption escalate escallop escapade escape escapee
                escapist escargot escarole escarp escheat eschew escort escrow espalier espouse
                espresso espy esquire essayist essence essential estate esteem ester esterify
                estimate estivate estrange estrogen estrus estuary etch eternal eternity
                eternize ethereal etherify etherize ethic ethical ethnic etiolate etiology etude
                euchre eulogist eulogize eulogy euphemize euro euthanize evacuate evacuee evade
                evaluate evanesce evaporate evasion evasive even evenness event eventful
                eventuate evict eviction evidence evil evildoer evince evoke evolute evolve
                exabyte exact exalt examine examiner excavate exceed except exception excerpt
                excess exchange excise excite exclaim exclude exclusive excoriate exculpate
                excuse exec execrate execute execution executor exemplar exemplify exempt
                exercise exert exertion exfoliate exhale exhaust exhibit exhort exhume exigence
                exigency exiguous exile exist exit exodus exon exonerate exorcise exorcism
                exorcist exotic expand expanse expatiate expect expedient expedite expend
                expense expensive expert expiate expire explain explicate explicit explode
                exploit explore explosive expo exponent export expose exposure expound express
                expunge expurgate extend extent extenuate exterior external extinct extirpate
                extol extort extortion extra extract extradite extreme extricate extrovert
                extrude exudate exude exult exurb exuviate eyeball eyeful eyeglass eyelash
                eyelet eyelid eyeliner eyepiece eyesore fable fabricate fabulous facade facepalm
                facet facial facile facility facsimile fact faction factious factoid factor
                factorize factotum faculty faddist fade faerie faff fail failure fain faint fair
                fairness fairway faithful fajita fake fakir fall fallacy fallible falloff false
                falsetto falsie falsify falsity falter familiar famine famish famous fanatic
                fanboy fanciful fandango fane fanfare fang fanlight fanny fantail fantasia
                fantasize fanzine farad faradize farce fare farewell farmhand farmland farmyard
                farrier farrow farthing fascia fascicle fascinate fascist fashion fast fastback
                fastball fasten fastener fastness fatalist fatality fate fateful fathead fathom
                fatigue fatten fatty fatuous fatwa faucet fault faulty faun fauna fauvist
                favorite fawn faze fear fearful fearless fearsome feasible feast feat feathery
                feature feckless fecundate federal federate fedora feeble feed feedbag feedlot
                feel feeling feign feint feisty felicity feline fell felon felony felt female
                feminine feminist feminize femur fend fender ferment fern ferny ferret ferrule
                fertile fertilize ferule fervid fess fest fester festive festoon fete fetid
                fetlock fetter fettle feud fever feverish fiance fiancee fiat fibber fiber
                fibril fiche fichu fickle fiction fictive fiddle fiddly fidelity fidget fief
                fiefdom fielder fieldwork fiend fiendish fierce fife fifteen fight fighter
                fighting figment figure figurine filament filbert filch file filer filiate
                filigree fill filler fillet filling fillip filly film filmy filter filthy
                filtrate finagle finale finalist finalize finance finch find fine finery finesse
                finial finicky finis finite fink firearm fireball firebox firebug firefight
                firefly firelight fireplug fireproof fireside firetrap firewall firework firm
                first fiscal fishbowl fishcake fishery fishhook fishnet fishpond fishtail
                fission fissure fist fistful fistula fitful fitness fitted fitter fitting five
                fixate fixative fixed fixer fixture fizzle fizzy fjord flabby flaccid flack
                flagon flagpole flagship flail flair flake flaky flam flambe flamenco flamingo
                flan flange flannel flap flapjack flapper flare flareup flashgun flashy flask
                flat flatbed flatboat flatcar flatfish flatfoot flatiron flatten flatter flattop
                flatworm flaunt flaunty flaw flawless flay flea fleabag fleck flection fledge
                flee fleece fleecy fleet flesh fleshly fleshpot fleshy flexed flicker flight
                flighty flimflam flimsy flinch fling flint flinty flip flipper flirt flit
                flitter float floaty floe flogger flogging floozy flop floppy flora floret
                florid florin florist floss flossy flotilla flounce flounder flour flout flowery
                flub fluctuate flue fluent fluff fluffy fluid fluke fluky flume flummox flump
                flunk flunky fluoresce fluoride flurry flush fluster flutist flutter flux
                flyover flypaper flyspeck flyway flywheel foal foam foamy focus fodder foghorn
                fogy foible foil foist fold folder foldout foliate folio folkie folksy folktale
                folkway follicle folly foment fond fondant fondle fondue font fontanel foodie
                fool foolery foolhardy football footfall foothill foothold footle footless
                footnote footrace footrest footsie footstep foppish forage foray forbear force
                forceful ford fore forearm forebear forebode forecast foreclose foredate
                foredoom forego forehand forehead foreign foreknow foreleg forelimb forelock
                foremast forename forenoon forensic forepart foresail foresee foreshow forestall
                forester foretaste foretell forewarn foreword forfeit forgather forge forgery
                forgive forgo forkful forklift forlorn form formal formalize format formation
                former formless formula formulate forsake forswear fort forte fortify fortnight
                fortune forty forum forward fossil fossilize foster foul found founder foundry
                fount four foursome fourteen fowl foxglove foxhole foxhound foxhunt foxtrot foxy
                foyer fracas frack fractal fraction fracture fragile fragment frail frailty
                franc franchise frappe frat fray frazzle freakish freaky freckle free freebase
                freebie freeboot freedom freehold freelance freeload freeway freewheel freeze
                freezer freight frenzy frequent freshen freshet fret fretful fretsaw friar
                friary fricassee friction fridge friendly frieze frigate fright frighten frigid
                frill frilly fringe fringy frippery frisk frisky fritter frivol frizzle frizzy
                frock frogmarch frolic frond front frontage frontier frostbite frosting froth
                frothy froward frown frowzy froze frozen fructify frugal fruiter fruitful fruity
                frump frumpish frumpy frustrate frustum fryer fuchsia fuddle fudge fuehrer fuel
                fugitive fugue fuhrer fulcrum fulfill full fullback fulminate fulsome fumble
                fume fumigant fumigate fumy function fund funeral fungible funky funnel furbelow
                furbish furl furlong furlough furnace furor furry further furtive fuse fusee
                fuselage fusilier fusion fuss fusspot fusty futon futurist futurity futz gabble
                gabby gabfest gable gadabout gadder gadfly gadget gaff gaffe gaggle gain gainly
                gainsay gait gala gale gall gallant galleon galleria galley gallivant gallon
                gallop galoot galosh galumph galvanize gambit gamble gambol gamecock gamester
                gamete gamin gamine gamma gammy gamut gamy gander gang gangrene gangway gannet
                gantlet gantry gape garb garbanzo garble garcon gardenia garfish gargle gargoyle
                garish garland garment garner garnet garnish garnishee garret garrison garter
                gasbag gasconade gash gasify gasket gaslight gasp gassy gatecrash gatepost
                gateway gather gatherer gator gauche gaucho gauge gaunt gauntlet gauzy gavel
                gavotte gawky gawp gaze gazebo gazelle gazette gazump gear gecko geeky geezer
                gelation geld geminate gemstone gendarme gender gene generate generic generous
                genial genie genitive genitor genius genome genre gent genteel gentian gentile
                gentle gentrify gentry genuflect genuine geocache geode geodesic geology
                geranium gerbil germ germane germinal germinate germy gerund gestalt gestapo
                gestate gesture getaway gewgaw geyser ghastly ghat gherkin ghetto ghettoize
                ghostly ghoul ghoulish giantess gibber gibbet gibbon gibbous gibe giblet giddy
                gigabit gigabyte gigawatt giggle giggly gigolo gild gill gilt gimcrack gimlet
                gimme gimmick gimp ginger gird girdle girl girlhood girlish girt give giveaway
                giveback given gizmo gizzard glaciate glad gladden glade gladiola glamorize
                glamour glance gland glare glary glassful glasswork glassy glaze glazier gleam
                glean gleeful glib glide glimmer glimpse glint glissade glisten glister glitch
                glitter glitzy gloam gloat glob globalize globe globular globule gloom glorify
                glorious gloss glossary glossy glottis glower glowworm glue glum glut glutton
                gnarl gnarly gnat gnome gnostic goad goal goalie goalpost goatee goatherd
                goatskin gobbet gobble goblet goddess godless godly godsend godson gofer goggle
                goiter goldbrick golden goldfish goldmine golly gonad gondola gone gong goober
                good goodbye goodly goody goof goofball goofy google goon goosy gopher gorge
                gorgeous gorgon gormless gorp gory goshawk gosling gospel gossip gouge goulash
                gourd gourde gourmand gourmet gouty govern governor gown grab grabber grabby
                grace graceful gracious grackle grad gradate gradation grade graded gradient
                gradual graduate graft grainy gram grammar grampus granary grand grandam
                granddad grandee grandma grandpa grandson grange granite granny grant grantee
                granulate granule graphic grapnel grapple grasp grassy grate grateful gratify
                grating gratuity gravamen grave gravel gravitate gray graze grease great grebe
                greet gremlin grenade grid griddle gridiron gridlock grief grieve grievous
                griffin griffon grill grille grim grimace grime grimy grin grind gringo grip
                grippe grisly grist grit gritter gritty grizzle grizzly groan groat grocer
                groggy grommet groom groove groovy grope grosbeak gross grotesque grotty grouchy
                groupie grouse grout grove grovel growl grown grownup grub grubber grubby grudge
                grudging gruel gruesome gruff grumble grump grunge grungy grunion grunt guarani
                guarantee guaranty guarded guava guess guffaw guggle guild guilty guinea guise
                gulag gulden gulf gull gullet gully gulp gumbo gumboil gumdrop gumshoe gunboat
                gunnel gunner gunwale gurge gurgle gurney guru gushy gusset gussy gust gutsy
                gutter guttle guttural gutty guzzle gymkhana gymnast gypper gypster gyrate
                gyrator gyro gyve habit habitat habitual habituate habitue hacienda hackle
                hackney hacksaw haddock haft haggard haggis haggle hail hairball haircut hairdo
                hairline hairnet hairpin hairstyle hajji hake halberd hale halfback halftime
                halftone halfwit halibut hallmark halloo hallow hallway halo halogen halt halter
                halve halyard hamburg hamlet hammock hammy hamper hamster hamstring handbag
                handball handbill handbook handcar handcart handcraft handcuff handful handheld
                handhold handicap handle handmaid handout handpick handrail handsaw handset
                handshake handsome hangar hangnail hangout hangover hangup hank hanker hankie
                hansom hapless haploid happen harangue harass hard hardback harden hardhat
                hardship hardtop hardwood hardy harebell harelip harem hark harm harmful
                harmless harmonic harmonize harness harpist harpoon harpy harridan harrumph
                harry harshen hart hashtag hasp hassle hassock hast haste hasten hatbox hatcheck
                hatchel hatchery hatchet hatchway hatred hatter hauberk haughty haul haunch
                haunt have haven hawkish hawse hawthorn haycock hayloft haymow hayrick hayride
                hayseed haystack hazard haze hazel hazelnut headache headband headhunt headlamp
                headland headline headlock headpin headrest headset headship headwind headword
                heady heal heap hear heard hearer hearing hearken hearse heartburn hearten
                hearty heater heath heave heaven heavenly heckle hectare hector hedgehog
                hedgerow hedonist heed heedful heedless heehaw heel heft hefty hegira heifer
                height heighten heinous heir heiress heirloom heist heliport hello helm helot
                help helpful helpless helpline helpmate helve hematite hemline hemlock hemmer
                hemostat hemp hemstitch henna henpeck heptagon herald herb herd here heresy
                heretic heritage heritor hermit hernia herniate heroine heron herring hesitate
                hetero hexagon hexagram heyday hiatus hibachi hibernate hibiscus hiccough hiccup
                hick hickey hickory hide hideaway hideous hideout higgle high highball highboy
                highbrow highland highlight highroad hightail highway hijab hijack hike hillock
                hillside hilltop hilly hilt hind hinder hinge hint hipbone hippie hipster hire
                hireling hiss hitch hitcher hitchhike hitter hive hivemind hoagie hoard hoarse
                hoary hobble hobbyist hobnail hobo hock hockshop hoecake hoedown hogan hogback
                hogshead hogtie hoick hoist hoke hold holdout holdover holdup hole holiness
                holler holly hologram holster holy holystone homage homburg homebody homeboy
                homeland homeless homely homepage homer homeroom homestead hometown homework
                homey homicide homily hominid homonym honcho hone honest honesty honeybee
                honeycomb honeydew honeymoon honk honky honor honoree honorer hood hoodie
                hoodlum hoodoo hoodwink hoof hookup hookworm hooligan hoop hoosegow hoot hoover
                hope hopeful hopeless hopper hopple hopsack hopscotch horde hormone hornet
                hornpipe horologe horrid horrify horror horsefly horseshoe hosanna hose hosier
                hospice host hostage hostel hostelry hostess hostile hostler hotbed hotbox
                hotcake hotelier hotfoot hothead hothouse hotplate hotshot hound houri houseboy
                housefly houseful household housetop housing hovel hover howitzer howl hoyden
                huarache hubbub hubby hubcap huckster huddle huff huffy huge hula hulky hull
                human humane humanist humanity humanize humanoid humble humbug humidify humidor
                humiliate hummer hummock humorist humorous humpback humph hunchback hundred
                hunger hunk hunker hunky hunt huntress hurdle hurl hurrah hurried hurt hurtful
                hurtle husband husky hussar hustle huzzah hybrid hybridize hydra hydrant hydrate
                hydrolyze hyena hymen hymn hymnal hymnbook hype hyperlink hyphen hyphenate
                hypnotic hypnotize hypo hysteric iamb iambic iambus ibis iceboat icecap icing
                icky icon ideal idealist idealize ideate identify identity ideogram ideology
                idiocy idiom idle idol idolater idolize idyll iffy ignite ignominy ignore iguana
                illegal illicit illness illume illumine illusive imam imbalance imbibe imbricate
                imbrue imbue imitate imitator immense immerse immigrate immingle immix immolate
                immortal immunity immunize immure impact impair impala impanel impart impasse
                impeach impede impeller impend imperfect imperial imperil impetus impiety
                impinge impious impish implant implement implicate implicit implode implore
                imply impolite import importune impose imposer impost impostor impound imprecate
                imprecise impress imprint imprison improper improve improvise impugn impulse
                impure impurity impute inane inanity inboard inbox incarnate inchoate inchworm
                incident incise incisive incisor inciter incline include increment incubate
                incubus inculcate inculpate incur indemnify indicate indict indigent indite
                induce inductee indulge indurate indwell inebriate inept inert infamy infant
                infarct infatuate infect infection infer inferior inferno infest infidel
                infinite infirm inflame inflate inflect inflict influence influx infract
                infringe infuriate infuse ingenue ingenuous ingest ingot ingraft ingrate ingress
                inhabit inhalant inhere inherit inhibit inhuman iniquity initial initiate inject
                injector injure inkblot inkle inkstand inkwell inky inmate innate innervate
                innocent innovate innuendo inoculate inquire inrush inseam insert inside insight
                insinuate insipid insist insolate insole inspect inspire install instance
                instant instate instigate instinct institute instruct insulate insult insure
                insured insurer intaglio integer integral integrate intellect intended intensify
                intensive intent intention inter interact intercede intercept intercom interdict
                interest interface interfere interfile interior interject interlace interlard
                interline interlink interlock interlope interlude intermix intern internal
                internee interpose interpret interrupt intersect interval intervene interview
                intimacy intimate intonate intranet intrepid intrigue intro introduce introit
                introject introvert intrude intuit inundate inure invade invalid invasion
                inveigh inveigle invent inventory inverse invert invest investor invite invitee
                inviting invoke involve inward iodide iodize ionize ionizer iota ipecac irate
                iris irksome ironclad ironical ironwood ironwork irradiate irregular irrigate
                irritant irritate irrupt isle islet isobar isolate isomer isotherm isotope issue
                issuer isthmus italic italicize item itemize iterate itinerant jabber jabot
                jackass jackboot jackdaw jackknife jacklight jackpot jade jaded jagged jaggy
                jailbird jalapeno jalopy jalousie jamb jamboree jammy jangle janitor japan jape
                jarful jasmine jaundice jaunt jaunty javelin jawbone jaybird jaywalk jealous
                jealousy jean jeep jeer jeering jejune jell jellify jemmy jennet jenny jeremiad
                jerkin jest jetliner jetport jettison jetty jewelry jibe jiff jiffy jigger
                jiggle jihad jihadist jilt jimmy jingle jingoist jink jitney jittery jive jobber
                jock jocose jogger joggle john johnny join joiner joint joist joke jollify jolt
                jolty jonquil josh jostle jotter jotting joule jounce journal joust jowl jowly
                joyful joyless joyous joyride joystick jubilate jubilee judder judgment
                judicious jugful juggle jugular jujube julep jumble jumbo jump jumpsuit junco
                junction juncture jungly junior juniper junket junkyard junta jurist juror just
                justify juvenile juxtapose kaddish kaiser kamikaze kappa karat kart katydid kayo
                kazoo kebab keel keelhaul keen keep keepsake kelvin kepi kerchief kern kernel
                kestrel ketch keyhole keynote keypad keypunch keystone keyword khaki khan kibble
                kibbutz kibitz kickback kickoff kicky kidder kiddie kiddo kielbasa killdeer
                killjoy kiln kilo kilobyte kilogram kiloton kilowatt kilt kind kindle kindly
                kindness kinfolk kingfish kingly kingpin kipper kirsch kissoff kludge kluge
                klutz klutzy knack knacker knapsack knave knavish knead kneecap kneel knell knit
                knitter knob knockoff knockout knoll knothole knowing knuckle knurl kola kook
                kopeck kosher kraal krone kuchen kudzu kumquat kvetch labial labialize labor
                laburnum lacerate lacewing lackey lacquer lactate lacy laddie ladle ladybird
                ladybug ladylove ladyship laggard laicize laid lair laird lamasery lambada
                lambaste lambda lambkin lambskin lame lamebrain lament laminate lamplight
                lampoon lamppost lamprey lanai lance lancet landau landfall landfill landlady
                landline landlord landmark landmass landscape landslide lane language languid
                languish languor lank lanky lanyard lapboard lapdog lapel lapidary lapidate
                lapidify lapin lappet lapse laptop lapwing larboard larceny larch lard lardy
                large lariat larkspur larrup lasagna lase lass lassie lasso last lasting
                latchkey late lateen latency lateral lath lather latitude latrine latte latter
                lattice laud laughing launcher launder laureate laurel lava lavatory lavender
                lavish lawful lawgiver lawless lawmaker lawsuit lawyer laxative layer layette
                layoff layout layover layup laze leach lead leaden leaflet leafy league leakage
                leaky lean leap leapfrog learn learned learner lease leasehold leaser leave
                leaven lectern lecture ledge leech leek leer leery leeward left leftist leftover
                lefty legal legalism legality legalize legate legatee legato legging leggy
                leghorn legion legislate legroom legume leisure lemme lemonade lemur lend
                lengthen lengthy lens lentil leotard leper lepton lesion less lessee lessen
                lesson lessor letdown lettuce letup leukemic levant levee level lever leverage
                levitate levy lexicon liability liaise liaison liar libation libber libel
                liberal liberate librate libretto license licensee lichen licit lick licorice
                lido lied lief liege life lifeboat lifebuoy lifeless lifeline lifetime lifework
                lift liftoff ligament ligate ligature lighten lighter like likely liken likeness
                lilac lilt limb limber limbo lime limeade limerick limit limn limo limp limpet
                limpid limy linchpin linden line lineage lineate lineup linger linguist liniment
                link linkage linkup linnet lint lintel linty lioness lionize lipid lipread
                lipstick liquefy liqueur liquid liquidate liquidize liquor lisp lissome list
                listen listless litany litchi literal literate lithe litigant litigate litter
                little littoral liturgy live liven livery livid living llano load loader loading
                loaf loam loamy loan loanword loath loathing loathly lobber lobbyist lobe
                lobotomy lobster locale locality localize locate location locator locavore
                locket lockout lockup locoweed locust locution lode lodestar lodge lodgment loft
                lofty logbook loge logger loggia logical logician login logjam logoff logon
                logotype logout logroll logy loin loiter lolcat loll lollipop lollop lone
                lonesome long longboat longbow longhair longhorn longing longueur lookout loom
                loon loony loop loophole loopy loos loose loosen loot lope lopsided lord lordly
                lordship loris lorry lose loss lotion lottery lotus loud lounge lour louse lousy
                lout loutish louver love lovebird lover lowboy lowbrow lower lowland lowlife
                lowly loyal loyalist loyalty lozenge luau lubber lube lubricate lucid lucubrate
                luff luge lugger lugsail lukewarm lull lumber luminary luminous lummox lump
                lumpish lumpy lunacy lunate luncheon lung lunge lungfish lunkhead lupine lure
                lurid lurk luscious lush luster lutanist lute lutenist luxate luxuriate lyceum
                lymphoma lyre lyrebird lyric lyricist macaque macaroni macaroon macaw mace
                macerate machete machinate mackerel mackinaw macro macron maculate madam madcap
                madden madder made madhouse madras madrasa madrassa madrigal maffick mafia
                magazine mage maggot magician magma magnate magnetize magneto magnify magnolia
                magnum magpie maharani mahatma mahogany mahout maid maiden mailbag mailbox
                maillot main mainland mainline mainmast mainsail mainstay maintain maintop maize
                majesty major majority make makeover maker makeup making malady malamute male
                maledict malign malinger mall mallard mallet mallow malt malted maltreat malty
                mamba mambo mammal mammy manacle manage manatee mandala mandamus mandarin
                mandate mandible mandolin mandrake mandrel mandrill manducate mane maneuver
                manful mange mangle mangrove mangy manhandle manhole manhunt mania maniac manic
                manicure manifest manifold manikin manioc manly manner mannish manor mansard
                manse mantel mantilla mantis mantissa mantle mantra manual manure maple mapmaker
                mapped mapper marabou marabout maraca marathon maraud marbleize mare margin
                marginal mariachi marigold marimba marina marinade marinate marine markdown
                marker marking markup marl marlin marmoset marmot maroon marque marquee marquess
                marquis marriage married marshal marshy mart martin martinet martini martyr
                martyrize marvel mascot masculine maser mash mashup masker mason masque mass
                massage masseur masseuse massif massive mast master masthead masticate mastiff
                mastodon mastoid matador matchbox mate material matinee matron matte matter
                mattock mattress maturate mature maturity matzo maul maund maunder maven
                maverick mawkish maxi maxim maximize maximum maybe mayday mayfly mayor mayoress
                maypole maze mazurka mazy meager mealtime mealy mealybug mean meander meaning
                meany measly measure meat meatball meathead meaty mecca mechanic mechanize
                medalist meddle media medial median mediate mediator medic medical medicate
                medicine meditate medium medulla meek meet meetup megabit megabyte megaphone
                megaton megawatt melange melanoma meld melee meliorate melodize melt meltdown
                member membrane meme memento memo memoir memorial memorize menace menage mend
                menfolk menial mensch mention mentor mercenary mercer mercerize merchant
                merciful mere merge meridian meringue merino merit mescal mesh mesmerize meson
                mesquite mess message messmate mestizo metalwork metaphor mete meter method
                metier metricate metricize mewl mezzo miasma mickey micro microbe microdot
                microfilm micron microwave micturate midden middle middy midfield midge midi
                midland midpoint midrib midriff midterm midway midweek midwife midyear miff
                might migraine migrant migrate mikado mike milady mild mildew mile mileage
                milepost milf milieu militant military militate militia milkmaid milksop
                milkweed milky mill milliard millibar milline million millpond millrace milt
                mime mimic mimicker mimicry mimosa minaret mince mindful mindless mindset
                mineral mingle mingy mini minibike minibus minicam minify minim minimize minimum
                miniskirt minister ministry minivan mink minor minority minster minstrel minty
                minuend minuet minus minute minx miracle mirage mire mirthful miry misally
                misapply misbehave miscall miscarry miscast miscount miscue misdate misdeal
                misdeed misdemean misdirect misdo miser misery misfile misfire misfit misgive
                misgovern misguide mishandle mishap mishear mishmash misinform misjudge mislabel
                mislay mislead mismanage mismatch mismate misname misnomer misplace misplay
                misprint misquote misread misreport misrule miss missal misshape missile mission
                missive misspeak misspell misspend misstate misstep missus mistake mistime
                mistral mistreat mistress mistrial mistrust mistype misuse mite miter mitigate
                mitt mixture mizzen mizzle mnemonic moan moat mobile mobility mobilize mobster
                moccasin mocha mockery modal mode model modeler modeling modem moderate modern
                modernize modicum modify modish modulate module mogul moiety moil moire moist
                moisten molar mold molder moldy mole molecule molehill moleskin moll mollify
                mollusk molly molt moment mommy monarchy monastic monetize moneybag monger
                mongoose mongrel moniker monist monition monitor monocle monodist monody
                monogram monomer monopoly monorail monotone monoxide monsoon montage monthly
                monument mooch mood moody moonbeam moonlight moonshine moonshot moonwalk moony
                moor moorland moot mope moped moppet moraine moralist morality moralize morass
                moray morbid mordant more morel morgue morn morose morph morpheme morsel mortal
                mortar mortgage mortify mortise mortuary mosaic mosey mosh mosque moss mossback
                mossy most mote motel motet mothball mothproof motif motion motivate motive
                motley motorbike motorboat motorcar motorist motorize motorway mottle moue mound
                mount mounter mounts mourn mournful mousse mousy mouthful mouthy movable move
                movement mover movie muck muckrake mucky muddle mudflat mudguard mudroom
                mudslide muezzin muff muffle mufti mugful mugger mugging muggle muggy mugshot
                mugwump mukluk mulberry mulch mulct mule muleteer mulish mull mullet mulligan
                mullion multiple multiplex multiply mumble mummer mummify munchkin mundane mung
                municipal munition mural muralist murk murky murmur muscat muscatel musette
                mushroom musical musicale musician musing muskeg musket muskox muskrat musky
                muss mussel mussy must mustache mustachio mustang muster musty mutagen mutant
                mutate mute mutineer mutiny mutt mutter muumuu muzzle muzzy myna myriad myrmidon
                myrtle mystic mystical mystify nabob nacelle nacho nacre nadir naff nagger naiad
                naif naive nameless namesake nape napoleon nappe nappy narc narrate narrator
                narwhal nasal nasalize nascence national native nativity natter natty natural
                naught naughty nauseate nauseous nautilus navel navigate navy naysayer neap near
                neat neaten nebulous necklace neckline necktie necrose need needful needless
                negate negative neglect negligee negotiate neigh neighbor nelson nematode neocon
                neonate neophyte neoplasm nephew nepotist nerd nerdy nerve nervous nervy nestle
                netbook nettle network neuritic neuron neurotic neuter neutral neutrino neutron
                newbie newborn newcomer newel newlywed newsboy newscast newsgirl newsreel
                newsroom newsy newt newton nexus nibble nice nicety niche nickel nicker nickname
                nictate nictitate niece nifty nigh nightcap nightie nigrify nihilist nimble
                nimrod nine ninepin nineteen ninety ninny nipper nippy nitpick nitrate nitride
                nitrify nitrite nitwit nobble nock nocturne nocuous noddle node nodule noel
                noggin noise noisome nomad nominate nominator nominee nonage noncom nonesuch
                nonevent nonmetal nonprofit nonsense nonuser nonvoter nonwhite norm normal
                normalize northeast norther northern northwest nosecone nosedive nosegay nostril
                nostrum nosy notable notarize notary notate notation nothing notice notify
                notion nougat noun nourish nova novel novelist novelize novella novena novice
                noxious nozzle nuance nubbin nubbly nubby nucleate nucleon nudge nudist nugget
                nuisance nullify numb numeracy numeral numerate numerous numskull nuncio nunnery
                nuptial nursling nurture nuthatch nutmeat nutpick nutria nutrient nutshell
                nuzzle nylon nymphet oafish oarlock oatcake obdurate obedient obelisk obese
                obfuscate obit obituary object objectify objection objective objector objurgate
                oblate obligate oblige obliging oblique oblong oboe oboist obscure observe
                obsess obsessive obsolesce obsolete obstacle obstruct obtain obtrude obtrusive
                obtund obtuse obverse obviate obvious ocarina occasion occlude occult occupant
                occupier occupy occur ocelot octagon octane octave octavo octet ocular oculist
                oddball oddment odious odometer odor odorous odyssey oeuvre offbeat offend
                offense offensive offer official officiate offish offload offprint offset
                offshoot often ogle ogre ogress ohmmeter oilskin oily ointment okapi okay okra
                oldie oldster oleander omega omelet omicron ominous omission omnibus omnivore
                oncogene onerous onlooker onrush onset onus ooze oozy opal opalesce opaque open
                opera operate operative operator operetta opine opioid opossum opponent
                opportune oppose opposite oppress oppugn optic optician optimism optimist
                optimize optimum option opus oral orangery orate orator oratorio orbital orchard
                ordain ordeal order orderly ordinal ordinary ordinate organ organic organism
                organist organize oriel orient orientate orifice origin original originate
                oriole orison ornament ornate orphan orris oscillate osculate osier osprey
                ossify ostracize other ottoman ounce oust outage outargue outboard outboast
                outbrave outbreak outburst outcast outclass outcome outcrop outcry outdraw
                outface outfield outfight outfit outflank outflow outfox outgo outguess outhouse
                outland outlast outlaw outlet outline outlive outlook outmarch outmatch
                outnumber outpace outplay outpoint outpour output outrace outrage outrange
                outrank outreach outride outroar outsail outscore outsell outset outshine
                outshout outside outsize outskirt outsmart outsource outspend outstay outtake
                outvote outward outwear outweigh outwork ouzo oval ovate ovenbird over overact
                overage overall overarch overarm overawe overbear overbid overbite overbook
                overbuy overcast overcloud overcoat overcome overcook overcrowd overdraw
                overdress overdub overeat overexert overfeed overfill overfly overgraze overgrow
                overhand overhang overhaul overhead overhear overheat overjoy overlap overlay
                overleap overload overlook overlord overly overpass overpay overplay overpower
                overprice overprint overrate overreach overreact override overrule overrun
                oversee oversell oversew overshare overshoe overstate overstay overstock
                overstuff overt overtake overtax overtime overtire overtone overtrump overture
                overturn overuse overvalue overview overweary overwhelm overwork oviduct ovoid
                ovule owlet owner oxcart oxford oxidant oxidate oxide oxidize oxidizer oxygenate
                pace pacifist pacify package packager packer packet pact pacy paddock paddy
                padlock paean pagan pageant pageboy paginate pagoda paid pail pailful pain
                painful painless paintbox painter paisley paladin palatal palate palatine
                palaver pale paleface palette palfrey palisade pall pallet palliate pallid
                palmate palmetto palmist palmtop palmy palomino palpate palpitate palsy palter
                paltry pamper pamphlet panacea panama pancake pancreas pandemic pander pane
                panel panelist pang panhandle panic panicle panne pannier panoply panorama pansy
                pant pantheon panther pantie pantile pantomime pantsuit papacy papaya paperboy
                papist papoose pappy para parable parabola parachute paradigm paradox paragon
                paragraph parakeet parallax parallel paralyze paramour paranoid parapet parasite
                parasol paratroop parboil parcel parch pardon parfait parget parish parity parka
                parkway parlay parley parlor parlous parodist parody parole parolee paroxysm
                parquet parr parry parse parsec parsnip parson part partake parterre partial
                particle parting partisan partite partition partner parvenu pascal pasha passage
                passbook passe passel passing passion passive passivize passkey password past
                paste pastern pastiche pastille pastime pastor pastoral pasture pasty patchy
                pate patella patent pathogen pathway patient patina patriot patrol patron
                patronize patroon patsy patter pattern patty patulous paunch paunchy pauper
                pauperize pause pave pavement pavilion paving pawl pawn pawnshop pawpaw payback
                paycheck payday payee payer payload payment payoff payout payroll payslip
                paywall peace peaceful peachy peacock peafowl peahen peal pear pearly peasant
                peaty pebble pecan peccary peck pectoral peculate pedal pedant peddle pederast
                pedestal pedicab pedicure pedigree pediment peduncle peek peel peep peer peerage
                peeress peeve peevish peewee pegboard peignoir peke pelican pellet pellucid pelt
                pelvis penalize penalty penance penchant pend pendant pendent pendulum penetrate
                penitent penlight pennant penne pennon pensive pentacle pentagon penumbra peon
                peony people peppy peptic peptize percale perceive percent percept percolate
                percuss perennate perennial perfect perfecta perfidy perforate perform perfuse
                pergola perigee peril period perish periwig perjure perjury perk perky perm
                permanent permeate permit permute perorate peroxide perpetual perplex persecute
                persevere persist person personal personate personify perspire persuade pert
                pertain perturb peruke perusal peruse pervade perverse pervious peseta pesky
                pest pester pestle petabyte petal petard petcock peter petiole petite petition
                petrel petrify pettish petty petunia pewee pewit pewter pfennig phaeton phalange
                phalanx phantasm phantom pharisee pharmacy phase phaseout pheasant phenol phenom
                phial philander philter phish phlegmy phobia phobic phoebe phone phoneme phony
                phosphor photo photocopy photon phrase phrasing physic physical physique pianist
                piaster piazza picador piccolo pickax pickerel picket pickle pickup picot
                pictorial pidgin piebald piece piecework piecrust pierce piercing piffle pigeon
                piggish piggy piggyback piglet pigment pigpen pigskin pigsty pigtail pike pilaf
                pilaster pilchard pile pileup pilfer pilgrim pill pillage pillar pillbox pillion
                pillory pimento pimiento pimple pimply pinafore pinata pincer pinch pine ping
                pinhead pinhole pinion pinkie pinko pinnacle pinnate pinon pinpoint pinprick
                pinstripe pint pinto pinup pinwheel pinyon pioneer pious pipe pipeline pipette
                pipit pippin piquant pique piranha pirouette pismire pistil pistol piston pita
                pitapat pitchfork pitchy piteous pitfall pithy pitiful pitiless piton pittance
                pity pivot pixel pixie pixilate pizzazz pizzeria placard placate place placebo
                placekick placement placenta placer placid placket plague plaid plain plaint
                plait plan plane planner plantain plaque plash plasma plaster plastic plat
                plateau plateful platelet platform platoon platter platypus plaudit play
                playable playact playback playbill playbook playboy player playful playgirl
                playgoer playlist playmate playoff playpen playroom pleach plead pleading
                pleasant please pleasing pleasure pleat plebe plebeian plectrum pledge plenary
                pleonasm plexus plight plodder plodding plonk plop plot plotter plover pluck
                plucky plug plugin plum plumage plumb plume plummet plummy plump plumy plunder
                plunge plural pluralize plus plushy poach pock pockmark podcast podium poet
                poetess poetize pogrom point pointed pointy poise poison poke pokey poky
                polarity polarize pole poleax polecat polemic polestar police polio polite
                politic politick politico polity polka poll pollack pollard pollinate polliwog
                pollster pollute poltroon polyglot polygon polygraph polymer polyp pomade
                pomander pommel pompadour pompano pompom pompous ponce poncho ponder pone pong
                poniard pontiff pontoon ponytail pooch poodle poof pooh poolroom poor pope
                popinjay poplar popover poppa popper populace populate populist popup pore porgy
                porky porous porpoise port portable portage portend portent porter porthole
                portiere portion portly portrait portray pose poser poseur posh posit position
                positive positron posse possess possible possum post postcard postdate postdoc
                posterior postlude postmark postpone postulate posture posy potable potbelly
                potential potful pothead pother potherb pothole pothook potion potluck potpie
                potsherd potshot potter pottery potty poultice pounce pound pounding pour pout
                power powerful powwow practical practice praetor prairie praise praline pram
                prance prang prank prate pratfall prattle prawn pray preach preachy preamble
                precancel precede precept precess precinct precious precise preclude precook
                predate predator predicate predict predigest preemie preempt preen preexist
                prefab preface prefect prefer prefigure prefix preform pregame preheat prejudge
                prejudice prelate prelim prelude premed premier premiere premise premium premix
                premolar prenup preoccupy preordain prep prepare prepay preppy prepuce prequel
                prerecord presage preschool prescribe prescript presence present preserve
                preside presort press presser pressing pressor pressure presto presume preteen
                pretend pretense preterit pretest pretext pretreat prettify pretzel prevail
                prevent preview prey price prickle prickly pride prideful priest priestly prig
                priggish prim primary primate prime primitive primp primrose princely principal
                principle prink print printer printing printout prior prioress priority priory
                prism prison prissy private privateer privation privatize privet privilege privy
                prize probable probate probation probe problem proceed process proctor prod
                prodigal prodigy produce producer prof profane proffer profit profiteer profound
                profuse program progress prohibit project prologize prologue promenade promise
                promote prompt pronate prong pronounce proof proofread prop propagate proper
                property prophecy prophesy prophet proposal prorogue proscribe prose prosecute
                proselyte prosody prospect prosper prostrate prosy protect protege protein
                protocol proton prototype protract protrude proud prov prove provide province
                proviso provoke provost prowl prudish prune psalm psalmist psaltery pshaw psych
                psychic ptomaine public publican publicize puck pucker puckish pudding puddle
                pudgy pueblo puff puffball puffin pugilist pull pullback pullet pulley pullout
                pullover pullulate pulp pulpit pulpy pulsar pulsate pulse pulverize puma pumice
                pummel pump puncheon punchy punctuate puncture pundit punitive punster punt puny
                pupate pupil purchase pure purebred puree purge purify purine purist puritan
                purity purl purlieu purloin purple purport purpose purr purse pursue pursuit
                pursy purvey purveyor pushcart pushover puss pussy pussycat pussyfoot pustule
                putout putrefy putsch putt puttee putter putty pygmy pylon pyre pyrite python
                quad quadrant quadrille quadruple quaff quaggy quagmire quahog quaint quake
                qualify qualm quandary quantify quarrel quart quartet quasar quatrain quaver
                quay queenly quell quench queue quibble quiche quicken quickie quid quieten
                quietude quietus quint quintet quintuple quip quipster quire quirt quisling
                quitter quizzer quoin quoit quorum quota quote quotient rabbet rabbi rabble
                rabid raccoon raceme raceway racket racketeer rackety racy raddle radial radiate
                radiator radical raffish raffle raga rage ragged raggedy raglan ragout raid rail
                railing raillery railroad railway raincoat raindrop rainfall raise raisin rake
                rakish ramble ramekin ramify ramjet ramp rampage rampart ramrod random randomize
                randy ranee rang range rangy rankle ransack ransom rant rapid rappel rapper
                rapport rapt rapture rare rarebit rarefy rarity rascal rasp raspy ratchet rate
                ratify ratio ration rational ratline rattan ratter rattle rattrap ratty raucous
                raunchy ravage rave ravel ravenous ravine raving ravioli raze reacquire reactant
                reader reading readout real realist realize realm ream reap rear reason reasoner
                reave rebate reboil rebuild rebuke rebuttal recap receipt receive recent
                receptor recess recessive recipe recital reciter reckless reckon reclaim recline
                recluse reconcile recopy record recount recoup recreant recreate recruit rectify
                recto rector rectory recuse recycle redact redactor redbird redcap redcoat redd
                redden redeemer redesign redhead redivide redline redneck redouble redoubt
                redound redraw redress reduce redwood reecho reedy reel reexport refashion
                referee reference referent referral referrer refill refine reflate reflect
                reflexive refloat reforge reform refortify refract refrain refresh refuge
                refugee refusal refute regain regal regard regatta regency regicide regime
                regimen regiment region register registry regrade regress regret regrind regroup
                regrow regular regulate rehab rehang rehears reify reign reignite reimburse rein
                reinforce reject rejoice relate relative relaxant relegate relent relic relict
                relief relieve religion religious reline relink relist rely remain remainder
                remand remeasure remember reminisce remiss remnant remold remote removal rename
                rend render renegade renege renewal renounce renovate renown rent rental reopen
                reorg repaint repair repeal repeat repellent repent replant replenish replete
                replica replicate report reprehend represent repress reprieve reprimand reprisal
                reprise reproach reptile republic repudiate repugn repute requiem require
                requisite requite reread rerecord resample rescind rescue resemble resent
                reserve reserved reshape resident residual residue resinate resist resistor
                resole resolute resonate resound resow respect respell respire respond response
                rest restful restive restless restore restrain restrict restroom result resume
                resupply resurrect retailer retain retaliate retch rethink retina retinue
                retiree retort retrace retract retrieve retro retrofire retrofit returnee reveal
                revel revelry revenge revenuer revere reverence reverend reverie reversal
                reverse revert revile revise revival revive revoke revolt revolve revue rewarm
                rewash rewind rewrite rhapsody rhea rheostat rhesus rhino rhizome rhomboid
                rhombus rhubarb rhyme rial ribber rick rickety rickshaw ricochet riddle ride
                ridge ridicule rife riff riffle rifle rift rigger right rightful rightist
                rightsize rigid rigidify rigidity rigor rigorous rile rill rime rimy rind
                ringgit ringlet ringtone rinse riot riotous ripcord ripe ripen ripoff riposte
                ripper ripple ripsaw riptide rise risotto rite ritual ritualize ritzy rival rive
                riverbed rivet rivulet riyal roadbed roadblock roadie roadshow roadside roadster
                roadway roadwork roam roan roar roast robber robe robin robocall robotize robust
                rockfall rodent rodeo roebuck roentgen roger rogue roguish roil roily roister
                role roll rollback rollick rollover romaine romantic romeo romp rondo rood
                rooftop rookery rookie roomette roomful roommate roomy roost rootkit rootlet
                ropy rosary rosebud rosebush rosette rosewood rosin roster rostrum rosy rotary
                rotate rotor rototill rotten rotund rotunda roue rouge roughen roughneck round
                roundup rouse roust rout route routine routinize rove rowboat rowel royal
                royalist rubato rubber rubberize rubdown rube ruble rubric rubricate ruche ruck
                rucksack ruckus rudd ruddle ruddy rude rudiment rueful ruff ruffian ruffle
                rugged rugrat ruin rule rumba rumble ruminant ruminate rummage rumor rumple
                rumpus runabout runaway rundown rune rung runlet runnel runner runny runoff runt
                runty runway rupee rupture ruse russet rust rustic rusticate rustle rustproof
                rutabaga ruthless rutty saber sable sabot sabotage saboteur sabra sachem sachet
                sackful sacred sacrifice sacristy sadden sadist safe safeguard saffron saga sage
                saggy saguaro sahib sailboard sailboat sailfish sailor saint saintly sake salaam
                salami sale salient saline salivate sallow sally saloon saltbox saltine salute
                salvage salve salvo samba same samovar sampan sample sanctify sanction sanctum
                sandal sandbag sandbank sandbar sandblast sandbox sandhog sandlot sandpaper sane
                sanguine sanitary sanitize sanity saphead sapling saponify sappy sarcasm sarcoma
                sardine sarge sari sarong sashay sass sassy satanist satchel sate satiate satin
                satire satirist satirize satisfy satrap saturate satyr sauce saucepan saucy
                sauna saunter sauropod sausage saute savanna savant save savior savor savory
                savoy savvy sawbuck sawfly sawhorse sawmill sawyer scab scabbard scabby scabrous
                scad scaffold scalawag scald scale scallion scallop scalp scalpel scaly scam
                scamp scamper scan scandal scanner scant scanty scapegoat scapular scar scarab
                scarce scarcity scare scarify scarp scarper scathe scatter scavenge scenario
                scend scene scent scepter schedule scheme scherzo schism schizo schizoid schlep
                schmooze schmuck schnook schnoz scholar schooner schuss schwa science scimitar
                scion scissor sclaff scoff scofflaw scold sconce scone scoop scoopful scoot
                scope scorch score scorn scornful scorpion scot scotch scoundrel scour scourge
                scout scow scowl scrabble scrag scraggly scraggy scramble scrap scrape scrapper
                scrappy scratchy scrawl scrawny screak scream scree screech screechy screw
                screwy scribble scribe scrim scrimmage scrimp scrimpy scrimshaw scrip script
                scroll scrooge scrounge scroungy scrub scrubber scrubby scruff scruffy scrump
                scrunch scrunchy scruple scrutiny scuba scud scuff scuffle scull scullery
                scullion sculpt sculptor sculpture scum scumbag scummy scupper scurry scurvy
                scuttle scuzzy scythe seabed seabird seaboard seacoast seafarer seafloor
                seafront seagull seahorse sealant sealer seam seamount seamy seance seaplane
                seaport sear searcher seascape seashell seashore seaside season seat seatmate
                seawall seaward seaway seaweed secant secede secern seclude second secondary
                secrete sect sectary section sectional sector secure security sedan sedate
                sedative sedge sediment seduce sedulous seedbed seedcase seeder seedling seedpod
                seedy seek seel seem seemly seep seesaw seethe segment segregate segue seigneur
                seignior seine seize seizure select selected selector self selfie selfish
                selfless sell selloff sellotape sellout seltzer selvage semaphore semblance
                semester semi seminar seminary semitone senate senator send sendoff senior senor
                senora senorita sensate sense sensitive sensitize sensor sensual sensuous sent
                sentence sentient sentinel sentry sepal separate septet sepulcher sequel
                sequence sequent sequester sequin sequoia seraglio serape sere serenade serene
                serf sergeant serial serialize serif serious sermon sermonize serrate serum
                servant serve server service servile servitor servo sesame session setback
                setscrew sett settee settle settler setup seven seventeen seventy sever several
                severe sewer sextant sextet sexton shabby shack shackle shad shade shadowbox
                shadowy shady shaft shag shaggy shake shakeout shakeup shaky shallot sham shaman
                shamble shame shameful shampoo shamrock shanghai shank shanty shapely shard
                share sharp sharpen sharpie shatter shave shawl shay shear sheathe sheave
                shebang shed sheeny sheepdog sheepish sheer sheet sheikdom shekel shellac
                shellfish shelter shelve shepherd sherbet sheriff sherry shew shift shifty
                shiitake shill shim shimmer shimmy shin shinbone shindig shine shingle shingly
                shinny shipload shipmate shipment shipper shipwreck shipyard shire shirk shirr
                shirty shiv shiver shmooze shoal shoat shoddy shoehorn shoelace shoetree shogun
                shoo shoot shootout shoplift shoppe short shortage shortcut shorten shorthand
                shortlist shorty shot shout shove shovel showboat showcase showdown shower
                showgirl showoff showroom showy shred shredder shrew shrewd shrewish shriek
                shrike shrill shrimp shrine shrive shrivel shroud shrub shrubby shrug shtick
                shuck shudder shuffle shuffler shunt shush shutdown shutoff shutout shutter
                shuttle shyster sibilant sibilate sibling sibyl sickbed sicken sickie sickle
                sickly sickness sicko sickout sickroom side sidearm sidebar sidecar sidekick
                sideline sideshow sidestep sideswipe sidetrack sidewalk sidewall siding sidle
                siege sieve sift sigh sight sightly sigma sign signal signalize signer signet
                signify signor signora signpost silence silent silicate silicon silkworm silky
                sill silo silt silty simian similar simile simmer simonize simper simple
                simplify simulate simulator simulcast sincere sine sinecure sinew sinful sing
                singe single singsong singular sinister sink sinkhole sinner sinter sinuous
                sinus siphon sipper sire sirloin sirocco sissy sitar sitarist sitcom site
                sitemap sitter sitting situate sixpence sixteen sixth sixty size sizzle
                skedaddle skeet skein skeptic sketchy skew skewer skid skiff skill skillet
                skillful skim skimmer skimp skimpy skin skinhead skinny skip skipper skirl
                skirmish skirt skit skitter skittish skittle skive skivvy skoal skulk skull
                skullcap skycap skydive skyjack skylark skylight skyline skyrocket slab slabber
                slack slacken slake slalom slam slammer slander slang slangy slant slap slat
                slate slather slattern slaty slay sleaze sleazy sledder sledge sleep sleepwalk
                sleet sleeve sleigh sleight slender slew slice slide slight slim slime slimy
                sling slink slinky slip slipcase slipknot slippage slipper slippery slippy
                slipway slit slither sliver slob slobber sloe slog slogan sloganeer sloop slop
                slope sloppy slosh slot slothful slouch slouchy slough sloughy sloven slovenly
                slowdown slowpoke sludgy slue slug sluggard slugger sluggish sluice slum slumber
                slumdog slumlord slummy slump slur slurp slushy small smarmy smart smarten
                smarty smashup smatter smear smeary smell smelly smelt smidgen smile smiley
                smiling smirch smirk smite smithy smock smog smoggy smoke smoky smolder smooch
                smoothen smoothie smother smudge smudgy smug smuggle snaffle snafu snag snaky
                snap snapper snappish snappy snapshot snare snarf snarky snarl snarly snatch
                snazzy sneaky sneer sneeze snick snicker snide sniff sniffle sniffy snifter snip
                snipe snippet snippy snit snitch snivel snob snobbish snobby snood snooker snoop
                snoopy snoot snooty snooze snore snorkel snort snout snowball snowbank snowbird
                snowboard snowdrop snowfall snowplow snowshoe snowsuit snub snuff snuffbox
                snuffle snug snuggle soak soapbox soar sobbing sober sobriety sociable social
                socialize socket sockeye soda sodden soft softball soften softwood softy soggy
                soiree sojourn solace sold solder sole solecism solemn solemnify solemnize
                solenoid solicit solid solidify solitary solitude soloist solstice soluble
                solute solvable solve solvency solvent somber somebody someone somerset sonant
                sonar sonata sonatina songbird songbook songfest songster sonnet sonny sonogram
                sonority sonorous soon sooth soothsay sooty sophist soppy soprano sorb sorbet
                sorcerer sordid sore sorehead sorority sorption sorrel sort sorter sortie
                souffle sough soul soulful soulless soulmate sound soupcon soupy sour source
                sourpuss souse southeast southern southpaw southward southwest souvenir
                sovereign soviet sovietize soybean space spacewalk spacious spade spadeful spam
                spammer span spang spangle spangly spaniel spank spanner spar spare sparing
                sparkle sparky sparrow sparse spasm spastic spat spate spathe spatter spatula
                spavin spawn spay spear spearfish spearhead spec special specie specific specify
                specimen specious speckle spectacle spectate specter speculate speechify speed
                speedup speedway speedy spell spellbind spend spew sphagnum sphere spheroid
                spice spicule spicy spiel spiff spiffy spigot spike spiky spill spillage
                spillway spin spinal spindle spindly spine spinet spinner spinster spiny
                spiracle spiral spire spirea spirit spiritual spit spitball spite spiteful
                spitfire spittoon splashy splat splatter splay spleen splendid splendor splice
                spline splint splinter split splosh splotch splotchy splurge splutter spoil
                spoiler spoke sponge spongy sponsor spoof spook spool spoonful spoor spore
                sportive sporty spot spotless spotlight spotter spotty spousal spouse spout
                sprain sprat sprawl sprayer spread spree sprig sprightly springy sprinkle sprint
                sprite sprocket sprout spruce spry spud spue spume spunk spunky spur spurious
                spurn spurt sputnik sputter spyglass squab squabble squad squadron squalid
                squall squander squashy squat squatter squaw squawk squeaky squeal squeegee
                squeeze squelch squib squid squiffy squiggle squinch squint squinty squire
                squirm squirmy squirt squish squishy stab stabber stabbing stabilize staccato
                stadium staff staffer stag stagger stagnate stagy staid stain stair stairway
                stake stakeout stale stalemate stall stallion stalwart stamen stammer stampede
                stance stanch stanchion stand standard standee standoff standout stanza staple
                starch starchy stare starfish stargaze stark starlet starling starry start
                starter startle startup starve stat state stately statement static statue
                stature status statute staunch stave stay stead steady steal stealthy steamroll
                steamy steed steel steelwork steely steep steepen steeple steer stein stem
                stencil stenos stent step stepdad stepmom steppe stepson stereo sterilize stern
                sternum steroid stetson stew steward stickle stickpin stickup sticky stiff
                stiffen stifle stigma stile stiletto still stilly stilt stilted stimulate sting
                stingray stingy stink stinkbug stinky stint stipend stipple stipulate stir
                stirrer stirring stirrup stoat stockade stocking stockpile stockpot stocky
                stodgy stogie stoic stoke stole stolid stolon stomach stomp stonewall stony
                stooge stool stoop stop stopcock stopgap stopover stoppage stopper stopple store
                stormy stoup stout stow stowaway straddle strafe straggle straggly straight
                strain strainer strait straiten strand strange strap stratify stray streaky
                stress stretcher stretchy strew striate strickle strict stricture stride strike
                string stringer stringy stripe strive strobe stroke stroll strong strop strophe
                stroppy structure strudel struggle strum strung strut stub stubborn stubby
                stucco stud studbook student studio studious studly study stuff stuffy stultify
                stumble stump stumpy stunt stupefy stupor sturdy sturgeon stutter style stylish
                stylist stylize stylus stymie styptic suasion suave subarea subbase subdivide
                subdue subedit subgroup subhead subhuman subject subjoin subjugate sublease
                sublet sublimate sublime submarine submerge submerse submit suborder suborn
                subplot subpoena subscribe subserve subset subside subsidize subsidy subsist
                subsume subteen subtend subtext subtilize subtitle subtle subtlety subtopic
                subtotal subtract suburb suburban subvert subway succeed success succinct succor
                succulent succumb suck sucker suckle suction sudden sudsy suffer suffice
                suffocate suffrage suffuse sugarcoat sugary suggest suit suitable suitcase suite
                suitor sulfate sulfide sulfur sulk sulky sullen sully sultan sultana sultry
                summarize summary summation summon summons sump sumption sunbath sunbeam sunbelt
                sunblock sunburn sunburst sundae sunder sundial sundown sunfish sunlamp sunn
                sunrise sunroof sunshade sunspot suntan super superb superego superior supermom
                superpose supersede supersize supervene supervise supinate supine supp supplant
                supple suppliant supply support suppose suppress suppurate supreme surbase
                surcease surcharge sure surety surf surface surfboard surfeit surge surgeon
                surly surmise surmount surname surpass surplice surplus surprise surrender
                surrey surround surtax survey surveyor survival survive survivor suspect suspend
                suspense suss sustain susurrate sutler suture suzerain svelte swab swaddle swag
                swagger swain swami swampy swank swanky swap sward swarm swarthy swash swastika
                swat swatch swath swatter sway swayback swear sweat sweaty swede sweep sweeping
                sweet sweetie swell swellhead swelter swerve swift swig swill swim swimmer
                swimming swimsuit swindle swipe swirl swish swivel swizzle swoon swoop swoosh
                sybarite sycamore syllabify syllabize syllable syllabus syllogize symbol
                symbolize symmetry sympathy symptom synapse sync syncopate syndicate syndrome
                synergy synfuel synod synonym syringe syrup system systemic systemize systole
                tabby tablet tabletop tabloid taboo tabor tabulate tacit tackle tacky taco tact
                tactful tactic tactless tadpole taffrail taffy tagger tagline taiga tailback
                tailcoat tailgate tailing tailpipe tailspin tailwind taint take takeoff takeout
                takeover taker taking tale talent talisman talkie tall tallboy tally tallyho
                talon talus tamale tamarack tamarind tame tamp tamper tampon tanager tandem tang
                tangelo tangent tangible tangle tango tangy tankard tankful tanner tannery
                tannin tantalize tantrum tape tapeline taper tapeworm tapir tapper tappet
                taproom taproot tare target tariff tarmac tarn tarnish taro tarot tarp tarpon
                tarragon tarry tarsal tarsi tart tartan tartar taser tassel taste tasteful
                tatami tatter tattle tattoo tatty taught taunt taut tauten tavern tawdry tawny
                taxi taxicab taxonomy taxpayer teacake teaching teacup teal tealight teammate
                teamster teapot tear teardrop tearful teargas tearoom teary tease teasel
                teaspoon teat techy tedious teem teen teenage teeny teeter teethe teetotal
                tegument tektite telecast telegram telegraph telephone teleplay telescope
                teletext telethon televise telex tell teller telltale telly temblor temp temper
                tempera temperate temporary temporize tempt tenancy tenant tend tendency tender
                tenderize tendon tendril tenement tenet tenne tenon tenor tenpin tens tense
                tension tensity tentacle tenuous tenure tepee tepid tequila terabit terabyte
                term terminal terminate termite tern ternary terrace terrain terrapin terrazzo
                terrify terry terse test testa testator tester testify testy tetchy tether tetra
                text textbook textile textual texture thane thankful thatch theft theist theme
                theology theorem theorist theorize therapy theremin therm thermal therme thermos
                thespian theta thew thick thicken thicket thieve thimble thin thinner third
                thirst thirteen thistle thole thorn thorny thorough thou thought thousand thrall
                thready threat threaten three threnody thresh thrift thrifty thrill thrive
                throat throaty throb throe thrombin throng throttle thrum thrust thruway thud
                thump thwack thwart thymus thyroid tiara tick tickle ticklish ticktack ticktock
                tidbit tiddly tide tideland tideway tidiness tidy tieback tiebreak tier tiff
                tight tighten tightwad tigress tilde till tiller tilt timbrel timeless timeline
                timely timeout timestamp timetable timid timorous tinct tincture tine ting tinge
                tingle tinker tinkly tinny tinsel tint tintype tipper tippet tippex tipple
                tipster tipsy tiptoe tiptop tirade tiramisu tire tired tireless tiresome tissue
                titan tithe titillate titivate title titlist titrate titter tittle tizzy toady
                toasty tobacco toboggan tocsin toddle toddy toecap toehold toenail toffee toga
                toggle toil toilet toiletry toke token told tolerant tolerate toll tollgate
                tollway tomahawk tomb tomboy tomcat tome tomtit tonality tone tonearm toner tong
                tongue tonic tonnage tonne tonsil tonsure tony tool toolbar toot toothy tootle
                topcoat topic topknot topmast topper topping topple topsail topside toque
                toreador torment torque torrent torrid torse torso tort torte tortilla tortoise
                tortuous toss tossup total totality tote totem totter toucan touche touchy
                toughen toughie toupee tour tourist tourney tousle tout toward towboat towhead
                towhee towline town townie township towrope toxicity toxin trace tracery tract
                tractile traction trade trademark traduce traffic trail trainee trainer traipse
                trait traitor tram trammel tramp trample trance tranquil transact transcend
                transect transept transfer transfix transform transfuse transient transit
                translate transmit transmute transom transpire transport transpose transude trap
                trapdoor trapeze trapper trashcan trashy trauma travail travel traverse travesty
                trawl tray tread treadle treason treasury treat treatise treaty treble treetop
                trefoil trekker trellis tremble tremolo tremor trench trencher trend trendy
                trephine trespass tress trestle trey triad triage trial tribe tribunal tribune
                triceps trickle tricksy tricolor tricycle trident triennial trier trifecta
                trifle trigger trike trilby trill trillion trilogy trim trimaran trimmer
                trimming trinity trinket trio trip triple triplet triplex tripod tripper trireme
                trisect trite triumph triumvir trivet troat trochee trod trodden troika troll
                trollop trombone tromp troop trope tropic tropism trot trotter trouble trounce
                troupe trouser trout trove trow trowel truant truce truckle trudge true truelove
                truffle truism trump truncate trundle truss trust trustee trustful trusty
                truthful tryout tryst tsetse tsunami tuba tubby tube tubercle tubful tubule
                tucker tuft tugboat tuition tumble tumbrel tumor tumult tuna tundra tune tuneful
                tuneless tuneup tunic tunny tuque turban turbid turbine turbo turbofan turbojet
                turbot tureen turf turgid turmeric turmoil turn turncoat turner turning turnip
                turnkey turnoff turnout turnover turnpike turret tush tussle tussock tutor
                tutorial tutti tutu tuxedo twaddle twang twangy twee tweed tweedy tweet tweeter
                tweeze twelve twerk twerp twiddle twig twiggy twill twin twine twinge twink
                twinkle twirl twist twister twisty twit twitchy twitter twofer twopence twosome
                tycoon tying tyke tympanum type typecast typeface typewrite typhoon typical
                typify typist typo typology tyrannize tyranny tyrant tyro udder uglify ukase
                ukulele ulcer ulcerate ulster ultimate ultra ululate umbel umbra umiak umlaut
                umpire unbend unbox unclean unclear uncommon uncouth unction unctuous underact
                underarm undercoat undercut underdog undergird underlay underline underlip
                undermine underpay underplay underrate undersign undertake undertow undulate
                unequal unfair unfit unfrock ungainly unguent ungulate unicycle unify union
                unionist unique unite unitize univalve universal unkempt unknown unlash unlike
                unlovely unpick unquiet unravel unroll unsay unsound unstack unsteady untidy
                untrue untune unwieldy unwise upbeat upbraid upchuck update updraft upend
                upgrade upheaval uphill uphold upholster upland uplift upload upper uppercut
                uppish upraise uprate uprear upright uprise uproot upset upshot upside upsilon
                upstage upstart upstroke upsurge upswing uptake upthrust uptick upturn urbane
                urbanize uremia ureter urge urticate usable usage useful useless user username
                usher usual usurer usurious usurp utensil utilize utter uvula uvular uxorious
                vacancy vacate vacation vaccinate vaccine vacillate vacuole vacuous vacuum
                vagabond vagary vagrant vague vain valance valence valency valet validate
                validity valise valuable valuate valuation value valuer valve vamoose vamp
                vandal vandalize vane vanguard vanilla vantage vape vapid vaporize vaporous
                variable variance variant variate variegate varietal varlet varmint varsity
                vassal vast vault vaunt vector veejay veep veer vegan vegetate veggie vehicle
                veil vein velar veld vellicate velocity velour vend vendetta vendor veneer
                venerate vengeful venomous vent ventilate venture venue veranda verb verbal
                verbalize verbena verbiage verbify verbose verdict verdigris verdure verge
                verger verify verity vernier verruca verse versify version verso vertical
                vesicle vesper vessel vestal vestibule vestige vestment vestry vesture veteran
                veto vexation viaduct vial viand vibe vibrate vibrato viburnum vicar vicarage
                vice viceroy vicinity vicious victim victimize victor victual vicuna video
                videotape viewer viewing vigil vignette vigorous vile vilify villa villain
                villainy villein vindicate vinegar vineyard vintage vintner vinyl viol viola
                violate violator violist viper vireo virgin virginal virgule virtue virtuous
                virus visa visage viscount viscous vise vision visionary visit visitant visitor
                visor visual visualize vital vitalize vitamin vitiate vitrify viva vivarium
                vivid vivify vivisect vixen vizier vocable vocal vocalist vocalize vocation
                vocative vogue voice void vole volt voltage volume voluntary volunteer volute
                voodoo votary vote voter vouchsafe vowel vowelize voyageur voyeur vulcanize
                vulgar vulgarize vuvuzela wack wacko waddle wade wadi wafer waft wage wager
                waggery waggish waggle wagtail waif wail wain wainscot wait waitress waive wake
                wakeful waken wale walkaway walkout walkover walkway wallaby walleye wallop
                wallpaper walnut wamble wander wane wangle wannabe want wanton wapiti warble
                ward warden warder wardrobe wardroom ware warehouse warhead warhorse wariness
                warlock warlord warm warmonger warn warning warp warplane warrant warranty
                warren warship wart warthog warty wary washable washbowl washout washrag
                washroom washtub washy wasp waspish wassail waste wasteful wastrel watchdog
                watchful waterbed watermark waterway watt wattle wavelet waver wavering waxwing
                waxwork waxy waybill wayfarer waylay wayside wayward weaken weakfish weakling
                weakness weal wean weapon weaponize wear weasel weave weaved weaver webby webcam
                webcast webinar webisode weblog website wedge wedgie weedy weekday weekend
                weensy weep weepy weevil weft weight weighty weir weird weirdie weirdo welcome
                weld well wellhead welsh welt welter wend west wester westerly western westward
                wetland wetter whack wham whammy what wheal wheedle wheelie wheeze wheezy whelk
                whelm whelp when where wherry whicker whiff while whim whimper whimsy whine
                whinge whinny whiny whiplash whippet whipsaw whir whirl whish whisker whiskey
                whit white whitecap whitelist whiten whiteout whitewash whitey whittle whodunit
                whole wholesale whomp whoop whoosh whopper whorl wicked wicket wide widen wield
                wieldy wiener wienie wife wiggle wight wiglet wigwag wigwam wiki wild wildcard
                wildcat wildfire wile will willful willing williwaw wilt wily wimp wimpish
                wimple wimpy wince winch windbag windbreak windburn winder windfall winding
                windlass windmill windpipe windrow windsock windsurf windup wine winery wingding
                wingnut wingspan wingtip winkle winner winning winnow wino winsome winterize
                winy wipe wirehair wireless wiretap wiry wise wiseacre wisecrack wishbone
                wishful wisp wispy wisteria wistful withdraw withe wither withhold witless
                witness witter witting witty wive woad wobble woeful wold womanize womanly womb
                wombat wondrous wonk wonky wont woodcock woodcut wooden woodland woodlot
                woodpile woodshed woodsy woodwind woodwork woody woof woozy word wordbook
                wording workbook workday worker workflow workload workman workout workroom
                workshop workup workweek world worldly wormhole wormy worse worsen worship worst
                worthy wound wove woven wrack wrangle wrap wrapper wrapping wrasse wrathful
                wreak wreath wren wrest wrestle wretch wretched wriggle wright wring wrinkle
                wrinkly wrist writ writhe written wrong wrongful wrought wurst wuss wussy yahoo
                yammer yardage yardarm yarmulke yawl yawn yawp yean yearbook yearling yearn
                yearning yeast yegg yell yelp yeoman yeshiva yield yodel yogi yoke yokel york
                young youth youthful yowl yucca yuppie yuppify yurt zapper zealot zealous zebu
                zest zestful zeta zillion zinc zing zinnia zircon zither zloty zoom zoophyte
                zygote
            ]],
            plurais = [[

            ]],
            ultra = [[
                abaca abamp abampere abandoned abandonment abasement abashment abated abatement
                abatis abbacy abbrev abbreviate abbreviated abcoulomb abdication abdicator
                abdominal abecedarian abele abelmosk aberrance aberrancy aberrant aberration
                abetment abeyance abfarad abhenry abhor abhorrence abhorrent abhorrer abidance
                abiding abjection abjectness abjuration abjurer ablation ablaut ableism
                abnegation abnegator abnormal abnormality abohm abolishment abolition
                abomination abominator aboriginal aborticide abortionist abortive aboulia above
                abracadabra abradant abreaction abridgment abrogation abruption abruptness
                abscission absconder absenteeism absinthe absolution absolutism absolutist
                absorbed absorbency absorber absorbing absorptance absorption abstainer
                abstemious abstention abstinence abstinent abstracted abstraction absurdness
                abulia abundant abusiveness abuttal abutter abvolt abwatt abysm abysmal academe
                academia academical academician academicism academism acaricide acarid
                accelerando accelerate accelerator accented accentor accentuate acceptably
                acceptance acceptation accepted acceptor accessible accessibly accessorize
                accidence accidental acclamation acclimation acclimatize accommodate accompanied
                accompanist accomplice accomplish accordance according accoucheur accountable
                accountably accountancy accountant accounted accounting accredited accretion
                acculturate accumulate accumulator accusal accusation accusative accuser
                accusing accustomed acedia acerbity acetabulum acetal acetamide acetanilide
                acetone acetyl acetylene achievable achievement achiever aching achondrite achoo
                achromatin achromatism achromatize acicula acidimetry acidity acidophil acidosis
                acknowledge acoustic acoustical acoustician acoustics acquainted acquiescent
                acquirement acquisition acquisitive acquit acquittance acridity acridness
                acrimonious acrimony acrobatic acrobatics acrodont acrogen acrolein acromegaly
                acromion acrophobia actin acting actinia actinide actinism actinium actinolite
                actinometer actinomycin activation activeness activism activities actomyosin
                actual actuarial actuation acuity acumen acupressure acupuncture acuteness
                acyclovir adamance adaptation adapted adaption addax addendum adder additional
                addressed adduction adductor adenine adenitis adenoma adenosine adenovirus
                adeptness adherence adhesion adiposity adit adjacency adjacent adjectival
                adjournment adjudicate adjudicator adjunction adjuration adjusted adjustment
                adjuvant adman admass admin administer admiralty admiration admirer admiring
                admissible admissibly admittance admitted admitting admonishing admonition
                adolescence adolescent adoptive adoration adorer adoring adorned adrenaline
                adroitness adsorbate adsorption adulation adulthood adumbration advancement
                advection adventitia adventurer adventuress adventurism adventurist adventurous
                adversarial adverseness advertence advertent advertised advertiser advertising
                advertorial advisee advisement adviser advocacy advowson adynamia aeciospore
                aegis aeration aerobatic aerobatics aerobe aerobic aerobics aerodynamic aerogram
                aerolite aerology aeronaut aeronautic aeronautics aerophagia aerophyte aerospace
                aerostatic aesthetic aesthetics aether affability affaire affectation affecting
                affectless affiliated affiliation affine affirmation affirmative affixation
                afflatus affliction afflictive affluence affluent affordable affranchise
                affricative affusion afghani aficionado afterbirth afterburner aftercare
                afterdamp afterdeck aftereffect afterimage afterlife aftermarket aftermath
                afterpiece aftershaft aftershave aftershock aftertaste afterward afterworld
                agama agapanthus agape agar agaric agateware agave ageism agelessness ageratum
                agglomerate agglutinate agglutinin aggrandize aggravating aggravation aggregated
                aggregation aggregator aggression aggressive aggrieved agility aging agio
                agiotage agitated agitation agitprop aglet agnail agnosia agnosticism agonist
                agonizing agora agoraphobia agoraphobic agouti agraphia agrarianism agreeably
                agreeing agriculture agrimony agrobiology agrology agronomic agronomical
                agronomics agronomist agronomy ague agueweed aided aiglet aigret aikido
                ailanthus aimlessness aioli airbed aircraft aircrew airdrome airflow airframe
                airfreight airiness airing airless airlessness airliner airman airplay airscrew
                airshow airsick airsickness airspace airspeed airtime airwave airwaves airworthy
                aitchbone akee alabaster alacrity alanine alarming alarmism alate albinism
                albite albumen albumin albuminoid albuminuria alcahest alcaic alcazar alchemical
                alchemy alcoholism alcoholize aldehyde alderman alderwoman aldol aldose
                aldosterone alertness aleurone alewife alexandrite alexia alfalfa alfilaria alga
                algarroba algebraical algebraist algin algometer algophobia algorism alienage
                alienation alienism aligned alike alikeness alimony aliquot aliveness aliyah
                alizarin alkahest alkali alkalinity alkalinize alkane alkanet alkene alkyl
                allantois allegation alleged allegiance allegorical allegorist allegorize
                allegretto allemande alleviation allied alliterate allocated allocation
                allocator allogamy allomerism allometry allopathy allophone allotrope allotropy
                allowable allowed allspice allurement alluring alluvial alluvion allyl almandine
                almandite almighty alms almsgiver aloneness aloofness alopecia alpenstock
                alphabetize alpine alpinist altarpiece alteration altercation altered
                alternation alternative alternator alto altruism alula alumina aluminum alumna
                alumnus alumroot alveolar alyssum amadavat amalgamate amanuensis amaranth
                amarelle amaretto amateurish amateurism amativeness amazed amazement ambassador
                amber ambergris amberjack ambit ambivalence ambivalent ambiversion ambler
                amblygonite amblyopia ambo ambrosia ambulation ambulatory ameliorate amen
                amenability amended amenorrhea ament amentia amercement americium ametropia
                amiability amiable amiableness amicability amice amidship amigo amine
                aminopyrine amity ammine ammo ammonia ammoniac ammonite ammonium ammunition
                amnesia amontillado amoral amoralism amoralist amorality amorist amorousness
                amoxicillin amperage amphetamine amphibious amphibole amphibolite amphibology
                amphictyony amphigory amphioxus amphipod amphisbaena amphora ampicillin
                ampleness amplifier amputation amused amusing amygdala amylase amyloid amylum
                amyotonia anabolism anachronism anachronous anacoluthia anacoluthon anagoge
                analeptic analgesia analogical analyses analytic analytical anaphase anaphora
                anarchical anarchism anasarca anastigmat anastomose anastrophe anatomical
                ancestral ancestress anchored anchorman anchorwoman ancientness andesite
                andradite androgen androgyne androgynous androgyny anecdotal anecdotist aneled
                anemia anemography anemometer anemometry anergy aneroid anesthesia anesthetic
                anesthetist anesthetize aneurin angelica angelical angina angiogram angiography
                angiology angioma angioplasty angiosperm angler anglicism angling anglophile
                anglophone angriness angst angular angularity angwantibo anhinga anhydride
                aniline anima animadvert animalcule animalism animality animated anime animism
                animus anion anise aniseed aniseikonia anisette anisotropy ankh ankylosaur
                anlage anna annal annals annexation annihilate annihilator anniversary annotated
                annotation announced announcer annoying annular annulate annulet annulus
                annunciate annunciator anoa anointment anole anon anonym anonymity anonymous
                anopheles anorexia anorthite anosmia anoxemia anoxia answerable answered
                answerphone antagonism antagonist antagonize antecedence antecedency antecedent
                antechamber antefix antepenult anterior anteriority antheridium antherozoid
                anthologist anthologize anthozoan anthracite anthrax anthropoid anthurium
                antibaryon antibiotic anticipate anticipated anticlimax anticyclone antifascist
                antifreeze antifungal antihero antiknock antilepton antilog antimatter antimony
                antineutron antinomian antioxidant antiphonal antiphonary antiphony antipodal
                antipode antipodean antipodes antiproton antipyretic antiquarian antirrhinum
                antisepsis antiseptic antisocial antistrophe antithesis antitussive antitype
                antivirus antlion antonymy antrum anuran anuria anxiousness anyone anyway
                anywhere aorist aoudad apache apartheid apathy apatite apatosaurus apercu
                aperient apery aphanite aphasia aphonia aphorist aphrodisiac apical apiculture
                apish aplasia aplite aplomb apnea apocalypse apocope apocrypha apocryphal
                apoenzyme apogamy apolitical apologetic apologue apolune apomict apomixis
                apomorphine apophthegm apostatize apostleship apostrophe apothecary apotheosis
                apotheosize appalling appanage apparatchik apparition appealable appearance
                appeasable appeased appeasement appeaser appellation appellative appendicle
                apperceive appetence appetency appetizing applauder applause applecart applejack
                applesauce applicable application applicator appointment apposition appositive
                appraiser appraising appreciable appreciably appreciate appreciated appreciator
                apprentice approbation appropriate approved approximate apraxia apteryx
                aquaculture aquamarine aquatics aquavit aquilegia arability arachnoid arak
                araroba araucaria arbitrager arbitrageur arbitrament arbitrary arbitration
                arbitrator arborvitae arcanum archaeology archbishop archdeacon archdiocese
                archduchess archduchy archenteron archer archery archespore archil archine
                archipelago architrave archness archpriest arcuate ardeb ardent arduousness
                areaway areca arena areola arete arethusa argal argali argent argentine
                argentite argillite arginine argon argonaut arguably arguer aridity aridness
                arietta aril arioso arista aristocracy aristocrat arithmetic armet armiger
                armload armoire armored armorer armyworm arnica aroid arousal arpeggiate arpent
                arquebus arrack arraignment arrangement arrear arrears arrester arrhythmia
                arroba arrogance arrogant arrogation arrowroot arrowworm arsenate arsenic arsine
                arson artemisia arterialize arteritis artfulness arthralgia arthritis arthromere
                arthroscope arthroscopy arthrospore articulacy articulate articulated artificer
                artificial artillery artiness artiodactyl artistry artlessness arugula arytenoid
                asafetida ascendance ascendancy asceticism ascidian ascocarp ascomycete
                ascospore ascription asdic asinine asked asparagine asparagus aspartame aspen
                aspersion asphyxia asphyxiate aspidistra aspiration aspiring assagai assailable
                assailed assassinate assayer assegai assemblage assemblyman assessment
                asseverate assibilate assignation assigned assignment assimilable assimilate
                assimilated assistance assisted associated association associative assonance
                assortment assuaged assuagement assumed assumption assuredness astatine asterism
                asthenia asthenopia asthma astigmatism astigmia astilbe astonishing astounding
                astragal astragalus astrakhan astral astringency astringent astrodome astrogate
                astrologer astrologist astrology astrometry astronautic astronomer astronomy
                astuteness asymptote ataractic ataraxia ataraxic atavism ataxia atheism
                atheistical athenaeum atheroma athletic athleticism athletics athodyd atlas
                atmometer atmosphere atmospheric atomic atomization atomizer atonal atonalism
                atonality atonement atony atrium atropine attached attachment attacker
                attainable attainder attained attainment attar attempted attendance attended
                attenuated attenuation attenuator attestation attested attractant attraction
                attractive attractor attributed attribution attributive attrition atypical
                aubergine auburn auctioneer audacity audibility audibly audile audiologist
                audiology audiometer audiophile audiovisual audited auditorium augend auger
                augite augmenter augustness auklet aural auricula aurochs aurora auscultate
                auspicious austenite autacoid autarchy autarky auteur authorized authorship
                autism autobus autodidact autoerotism autogamy autogiro autograft automat
                automation automatism automatize automobile autonomous autonomy autophyte
                autoplasty autosome autostrada autotomize autotomy autotype autoworker auxin
                avadavat available avarice avaricious avenged avenger avens aventurine averment
                aversion aviation avidity avidness avifauna avionic avionics avocet avoidable
                avoidably avoidance avoirdupois avowed avulsion avuncular awakened awardee
                awesomeness awfulness awkwardness awlwort awning awoke axehead axial axil axilla
                axiology axis axseed ayah ayatollah ayin azide azimuth azote azotemia baba
                babassu babbler babirusa babyhood babysit babysitter babysitting baccarat
                bacchanalia bacchant baccy bacillus bacitracin backbench backbend backbiter
                backchat backed backer backflow backgammon background backhanded backhander
                backing backpacker backpacking backplate backroom backsaw backsheesh backslap
                backslapper backslider backspin backstage backstair backstay backstitch
                backstory backstreet backstretch backstroke backsword backtalk backwash
                backwoods bacteria bacterial bactericide bacterium bacteroid badinage badland
                badlands badman badminton badness bafflement baffler bagasse baggage bagger
                baggie bagginess bagging bagnio bagpiper bailee bailey bailiff bailment bailor
                bailsman baiza baize baked baklava baksheesh balanced balancer balas balata
                balbriggan baldachin balderdash baldness baldpate baldy baleen balefire
                balefulness baler ballade balladry balletomane ballgirl ballgown ballistic
                ballistics balloonist ballplayer ballyrag balminess baloney balustrade bambino
                banal bandeau banderilla bandicoot banditry bandleader bandmaster bandsaw
                bandsman baneberry bangtail banian banishment banker banking bankruptcy banksia
                banned banneret banning banns banqueter bantering baptist baptistery baptized
                baptizer barbershop barbet barbette barbican barbie barbital barbitone
                barbiturate barbwire bareback barefaced barefoot bareness bargainer bargello
                bargeman barhop barilla barite barium barkeeper barley barleycorn barman barney
                barnstormer barong barouche barramunda barrelhouse barrenness barrio barterer
                barye baryta barytone basal bascule baseless baseman baseness basenji baserunner
                bashfulness basil basinet basis basketball basketful basketry basketwork
                basophil basque bassline bassoonist bast bastardize bastardy baster bated bathe
                bather bathing bathos bathymetry bathyscaphe bathysphere batiste batman
                batrachian batsman batterer batting battledore battlefield battlefront
                battlement battler battleship battlewagon battue bauxite bawbee bawdiness bawdry
                bawdyhouse bazar bazillion bdellium beachcomber beachwear beading beaker
                beanball beanfeast beano beansprout bearable bearably bearberry bearcat bearer
                bearing bearishness bearwood beastliness beatable beaten beater beating
                beautician beautifier beautiful bechamel become becquerel bedchamber bedclothes
                bedcover bedder bedding bedevilment bedhead bedim bedlamite bedmaker bedsit
                bedsitter bedspring bedstraw beebread beefalo beefburger beefeater beefiness
                beefwood beekeeping beeper beeswax beetroot befit befitting befog beget begetter
                beggarly beggarweed beggary begin begrudging beguilement beguiler beguiling
                behalf behavioral behaviorism behaviorist behemoth beholder beige being beldam
                belemnite believable believably believed belladonna bellarmine bellbird
                bellbottom belled belletrist bellflower bellicosity belligerent belling bellman
                bellwether bellwort bellyband bellybutton belonging belting belvedere bema
                bemused bemusement bender benedict benediction benefaction benefactor
                beneficence beneficent beneficial beneficiary benevolence benevolent benign
                benignancy benignant benignity benison benjamin benne bennet benny benthos
                bentonite bentwood benzene benzine benzoate benzocaine benzofuran benzoin benzol
                benzyl berceuse bereavement bergamot beriberi berk berkelium berlin berserk
                beryllium beseecher beseeching beset beside besieger besot besprinkle bestial
                bestiality bestialize bestir bestseller betatron betel bethel betrayer betrothed
                betterment bevatron bevvy bewildering bewitching bewitchment bezant bezique
                bialy biannual bibb bibliolatry bibliomania bibliophile bibliopole bibliotheca
                bibulous bicarbonate bicentenary biceps bichloride bichromate bickerer bicorn
                bicycler bidden bidding bide bier bifocal bifocals bifurcation bigamy bigeye
                biggin bighearted bigmouth bigness bijou biker bilateral bilberry bile
                biliousness bilker billhook billiard billiards billing billionaire billionth
                billposter billycan biltong bimetal bimetallic bimetallism binaural bindweed
                bine bingle bingo binturong biocatalyst biochemical biochemist biodegrade
                bioengineer bioethics biofeedback biog biographer biological biology biomass
                biomedicine biometric bionic bionics biophysics bioreactor bioscope biosensor
                biota biotin biotite biotype bipolarity biquadratic birdbath birdcage birder
                birdlime birdseed birdwatcher birther birthplace birthright birthroot births
                birthstone birthwort bismuth bison bisque bister bitartrate biter bitewing
                biting bitmap bitstock bitterness bitternut bitterroot bitters bittersweet
                bitterweed bitumen bituminize bizarreness blackamoor blackberry blackboard
                blackbody blackcap blackcock blackdamp blackface blackguard blackheart blacking
                blackleg blackmailer blackness blackpoll blacksmith blacksnake blacktail
                blackthorn bladdernose bladderwort blaeberry blag blah blahs blain blameworthy
                blancmange blandness blankness blasphemer blasphemous blastema blaster
                blastocoel blastoderm blastomere blastopore blastula blat blatant blazer
                blazonry bleached bleacher bleakness bleariness bleb bleeder bleeding bleeper
                blemished blenched blende blender blenny blessedness blessing blinder blinding
                blindness blindworm blintze bliss blistering blitheness blithesome blitzkrieg
                blivet blockader blockbuster blockchain blocker blockhouse blondness bloodhound
                bloodied bloodiness bloodmobile bloodroot bloodstock bloodstone bloodstream
                bloomer blooper blower blowhole blowlamp blown blowtube blucher bluebill
                bluebonnet bluebottle bluegrass bluejacket bluejeans blueness bluestone blueweed
                bluffer bluffness bluing blunderbuss blunderer blundering blunge bluntness
                blurriness blusher blusterer boarder boarding boarhound boaster boatbill boater
                boating boatload boatman boatyard bobbysoxer bobsledder bobsledding bobsleigh
                boccie bock bode bodied bodyboard bodybuilder bodywork boffin bogbean bogeyman
                bogyman bohemianism boiled boiler boilermaker boilerplate boisterous bola
                boldness bolide boliviano bollard bollocking bollworm bolo bologna bolometer
                bolshevism bolthole bombardier bombardment bombardon bombast bomber bombsight
                bombsite bombycid bonce bondholder bonding bondmaid bondman bondsman bondwoman
                boned boner boneset bonesetter boneshaker bonhomie boniness bonito bonsai bonze
                booger boogeyman boogieman bookbinder bookbindery bookbinding booked booking
                bookkeeper bookkeeping bookmaking bookmobile bookseller bookshelf bookstall
                boondocks boondoggle boondoggler boonies boorishness booster bootjack bootlace
                bootlegger bootlegging boozer borage borate borax borderland borderline borecole
                boredom borehole borer boring bornite boron borough borrower borrowing borscht
                borsht borstal bosh boson bossiness bossism botany botcher botfly botheration
                bothered bottleful bottleneck bottler bottomland botulin botulinus botulism
                bouffe bough bought boule bouncer bounciness bourdon bourgeois bourgeoisie
                bourne boutonniere bovid bowdlerize bowed bower bowerbird bowfin bowhead bowknot
                bowler bowling bowman boxberry boxer boxful boxing boxroom boxthorn boxwood
                boyfriend boyishness boysenberry brachiopod brachyuran bracing bracken bracketed
                brackish bracteole bradawl bradycardia braggadocio braiding braille brainchild
                braininess brainless brainpan brainpower brainstorm brainteaser brainwave
                brakeman bran branched branchiopod branded brander brant brashness brasier
                brassard brassbound brasserie brassiere brassiness bratwurst bravado braveness
                bravery bravura brawler brawn brawniness brazenness brazer brazil breadbasket
                breadboard breadcrumb breadfruit breadline breadroot breadstick breadstuff
                breadth breadwinner breakable breakaway breakdown breaker breakfront breakwater
                breastbone breastplate breastwork breathable breathalyze breathed breather
                breathing breathless breccia bred breechblock breezeway breeziness brent brevity
                brewage brewer briarroot briarwood briber bribery brickkiln bricklayer
                bricklaying brickwork bricky brickyard bricole bridegroom bridesmaid bridgeable
                bridged bridgehead bridgework bridleway bridoon briefcase briefness brier
                brierwood brigadier brigandage brigandine brigantine brightener brightness
                brights brill brilliance brilliancy brimstone brine bringer brininess briony
                briquette bris brisance briskness bristletail brit britches brittleness broadax
                broadband broadbill broadcaster broadcloth broadloom broadminded broadness
                broadsheet broadsword broadtail broccoli brochette brocket broiler broke
                brokenness brokerage brolly bromine bronchiole bronchitis bronchus brontosaur
                bronze brooder broodmare brooklime brookweed broomcorn broomstick brotherhood
                brownness brownstone browser brucine bruised bruiser bruising brunt brushed
                brushstroke brushwood brushwork brusqueness brutal brutality brutishness bryony
                bryophyte bryozoan bubblegum bubo buckboard bucketful buckjump buckram buckshot
                buckthorn bucktooth buckwheat buckyball budded budding buddleia budgerigar
                budgeted budging bufflehead buffoonery bugbane bugged buggery bugging bugler
                bugleweed bugloss buhl builder bulbil bulbul bulghur bulginess bulgur
                bulimarexia bulimia bulkiness bulla bullace bullbat bulldozer bulletproof
                bullfighter bullfinch bullheaded bullion bullishness bullnose bullwhip bullyboy
                bullyrag bumbag bumblebee bumbler bumboat bumper bumpiness bumptious bundled
                bungler bunkhouse bunkmate bunkum bunting buoyancy buoyant burbot burbs burdock
                bureaucracy bureaucrat burette burger burgess burgher burglarize burgomaster
                burgoo burgrave buried burin burke burlap burliness burned burner burnisher
                burnt burro burrower bursa bursitis bushbuck bushiness bushing bushman
                bushmaster bushtit bushwhacker businessman busing busload bustard buster
                busyness busywork butadiene butane butanol butcherbird butene butted butterball
                butterbur buttercup butterfat buttermilk butternut butterwort butting buttonhole
                buttonhook buttonwood butty butut butylene butyrin buxom buxomness buyer buzzer
                bypath byplay byproduct byre byrnie byssus bystander caballero cabana
                cabbageworm cabdriver cabinetry cabinetwork cablegram caboodle cabotage
                cabriolet cacao cachalot cachexia cachinnate cachou cacique cackler cacodyl
                cacography cacomistle cacophony cadaster cadaverine cadaverous caddishness
                cadency cadetship cadger cadmium caduceus caecilian cafe cafeteria cafetiere
                caffeine caged caginess cagoule cairngorm cajolement cajoler cajolery cajoling
                calaboose caladium calamine calamint calamitous calamus calash calceolaria
                calciferol calcination calcite calcium calculable calculated calculating
                calculation calculator calculus calefaction calendula calf calfskin calibrated
                calibration calibrator caliche calico californium caliph caliphate calisaya
                calisthenic called calligraphy calliopsis callosity callousness callowness
                calmness calomel calorimeter calorimetry calque caltrop calumniate calumniator
                calumnious calvaria calvary calx calycle calyptra camail camaraderie camarilla
                camass cambric camcorder camelopard cameraman camerawoman camouflage camouflager
                campaigner campanile campanology campanula campground camphor camphorate camping
                campion campstool canasta canceled canceler cancer cancerous cancroid candela
                candelabra candelabrum candescence candescent candidacy candidate candidature
                candidness candleberry candlelight candlenut candlepower candler candlestick
                candlewick candlewood candor candytuft canebrake canella caner cankerworm canna
                cannabin cannelloni cannibalism cannibalize cannikin cannily canniness
                cannonball cannoneer cannula canola canonical canonist cantaloupe cantilever
                cantillate cantle cantonment cantor canvasback canvasser caoutchouc capability
                capable capably capacious capacitance capacitate capacitor capelin capeskin
                capful capillarity capillary capital capitalism capitalist capitalize
                capitalized capitation capitulate caplin capote cappuccino capricious caprifig
                capsaicin capsid capsulate captaincy captainship captivation captivator
                captivity capuchin capybara carabao carabineer caracal caracara carambola
                caramelize carangid caravansary carbamate carbonado carbonation carbonyl
                carborundum carboxylate carbuncle carburet carburetor carcajou carcinogen
                carcinoma cardamon cardboard cardholder cardie cardinalate cardiogram
                cardiograph cardioid cardiology carditis cardoon cardsharper careerism careerist
                carefulness caregiver carer caretaker carfare cargo caricature caries carina
                caring carjacker carjacking carl carmaker carminative carnage carnal carnality
                carnallite carnauba carnelian carnivore carnivorous carnotite caroler carotene
                carotenoid carouser carpentry carper carpetbag carpeted carpeting carpospore
                carpus carrack carrageen carrageenan carragheen carrefour carriageway carrier
                carrion carrycot carryover carsick carsickness cartage carte carter carthorse
                cartilage cartography cartoonist cartouche cartridge caruncle carver carvery
                carving cascabel cascarilla casebook cased caseharden casein casern caseworker
                caseworm cashback cashbox cashed cashmere casing casque cassareep cassiterite
                cassowary caster castigation castigator castration castrato casualness
                casuistical casuistry catabolism cataclysm catafalque catalase catalepsy
                cataleptic cataloged cataloger catalysis catalytic catamaran catamount
                cataplasia cataplasm catarrh catastrophe catatonia catatonic catcher catchfly
                catchment catchphrase catchword catechetic catechism catechist catechu
                catechumen categorical categorize catenary caterer caterpillar catgut catharsis
                cathartic cathedral catheterize catholic catholicity catholicize cathouse cation
                catmint catnip catsuit cattalo cattery cattiness cattle cattleman cattleya
                caudal caudate caudex caught caul cauliflower caulker causal causalgia causality
                causation caused causer causticity cautery cavalcade cavalla cavalryman caveman
                cavernous caviar caviler caving cavy cayenne ceasefire ceaseless cecal cecity
                cecum cedi celandine celeb celebrant celebrated celebration celebrator celebrity
                celeriac celerity celery celestial celestite celibacy cellarage cellblock
                cellophane cellphone cellularity cellulite cellulitis celluloid cellulose
                cellulosic celom cementer cementite cementum cenotaph censored censorious
                censorship censured censurer cent cental centare centaury centenarian centenary
                centennial centerboard centerfold centering centerpiece centesimal centesimo
                centigram centiliter centimeter centimo centipede centner centrality centralize
                centralizer centric centrifugal centrifuge centriole centripetal centrism
                centroid centromere centrosome centrum centurion cephalic cephalopod ceramicist
                ceramics ceratodus cercaria cerebellum cerebral cerebration ceremonial
                ceremonious cerise cerium cermet cero ceroplastic cert certificate certified
                certiorari certitude cerulean cerumen cerussite cervicitis cervix cessation
                cessionary cesspit cestode chacma chad chaffinch chairlift chairman chairperson
                chairwoman chalaza chalcedony chalcocite chaldron chalkboard chalkiness
                challenged challenger challenging challis chamaeleon chamberlain chambermaid
                chamberpot chambray chameleon chamfron chamois chamomile champagne champaign
                chancellery chancellor chanciness chancroid chandelier chandlery changeable
                changeably changed changeless changeling changeover changer changing channelize
                chanter chanterelle chanteuse chanticleer chantry chaos chaparral chapati
                chapatti chaperonage chaperoned chapiter chaplaincy chappy charabanc character
                charcuterie chard chardonnay chargeable charged chariness charioteer charisma
                charismatic charitable charitably charivari charlady charlatan charlatanry
                charlie charlock charmer charming charnel charted chartered charterer chartist
                chartreuse charwoman chaser chassis chasteness chastiser chastity chatelaine
                chatline chatroom chatterbox chatterer chattiness chaulmoogra chauvinism
                chauvinist cheapness cheapskate cheater cheating checkable checkbook checked
                checkers checklist checkpoint checkrein checkroom cheddar cheekbone cheekiness
                cheekpiece cheerer cheeriness cheerleader cheerless cheeseboard cheesecake
                cheesecloth cheesiness cheetah chela chelonian chemistry chemo chemurgy chenille
                cherimoya cherrystone chert chervil chess chessboard chessman chetrum chevalier
                cheviot chevre chevrotain chewer chewiness chewink chiaroscuro chiasma chiasmus
                chicanery chickadee chickenfeed chickenpox chickweed chicle chicness chiding
                chiefdom chieftain chieftaincy chiffon chiffonier chigetai chigoe chihuahua
                childbed childbirth childcare childhood childless childminder childproof
                children chili chiliad chiller chilliness chilling chillness chimer chimerical
                chimpanzee china chinaberry chinaware chincapin chinch chinchilla chinkapin
                chinoiserie chinook chinquapin chinstrap chintz chinwag chipboard chipolata
                chipping chippy chirography chiromancer chiromancy chiropodist chiropody
                chiropteran chiseler chitin chiton chivalrous chivalry chivaree chlamydia
                chloral chloramine chlorate chlordane chlorella chlorinate chlorine chloroform
                chlorophyll chloroplast chloroprene choanocyte choc chocoholic chocolate
                chocolaty choiceness choirmaster chokecherry chokedamp choker choler cholera
                cholesterol choline cholla chondrite chondroma chondrule chooser choosiness
                chophouse chopine choppiness chopstick choragus chordophone chorea choreograph
                chorister chortler chowchow chrism chrisom christened christening christian
                chroma chromate chromatic chromatid chromatin chromatism chromite chromium
                chromoplast chromosome chronicled chronicler chronograph chronology chronometer
                chronoscope chrysalis chrysarobin chrysoberyl chrysolite chrysoprase chrysotile
                chubbiness chuckhole chuckwalla chufa chukker chumminess chunkiness churchgoer
                churchgoing churchman churchyard churner chutzpah chyle chyme ciao cicala
                cicatrix cicero cichlid cider cigarette cigarillo cilantro cilium cimetidine
                cinema cinematize cineraria cinnabar cinnamon cinque cinquefoil circuitous
                circuitry circuity circularity circularize circulated circulation circumcise
                circumcised circumflex circumfuse circumspect circumvent cirrhosis cirrhotic
                cirrus cisco cither citizenry citizenship citrange citrin citrine citronella
                civic civics civilized civvies clad cladding cladistic cladophyll claimed
                clairvoyant clamant clamberer clamminess clamorous clampdown clamshell
                clandestine clangor clangorous clansman clapperclaw clapping claptrap
                clarinetist claro clary classical classicism classicist classicize classified
                classifier classiness classless classmate classroom classwork clavichord clavier
                claymore cleaner cleaning cleanliness cleanness cleanser clearance clearing
                clearness clearstory clearway cleaver clementine cleome clepsydra clerestory
                clergyman clergywoman clericalism clerihew clerkship cleverness clicker
                clientage clientele cliffhanger clifftop climacteric climatical climatology
                climbable climbed climber climbing clincher clinger clingstone clinical
                clinician clinker clinometer clintonia cliometric cliometrics clipboard cloaca
                cloakroom clockmaker clockwork clodhopper clogged clogging cloisonne clonus
                closeness closing clostridium clothesline clothespin clothing cloudberry
                cloudburst clouded cloudiness cloudscape clover cloverleaf clubber clubhouse
                clumsiness clunker clupeid clypeus clyster cnidarian coachload coachman
                coachwhip coaction coadjutor coagulant coagulase coagulation coagulator coagulum
                coalescence coalfield coalition coalmine coaming coarseness coaster coastguard
                coastland coastline coated coatee coati coating coatrack coatroom coaxer coaxial
                coaxing cobalt cobaltite cobber cobbler cobblestone cobia cobnut cobra coca
                cocci coccus coccyx cochineal cockateel cockatiel cockatrice cockchafer cockeye
                cockhorse cockiness cocklebur cockleshell cockloft cockroach cockscomb cockshy
                cockspur cocksucker cockup cocotte codeine codename codependent codeword
                codifier codon coeducation coefficient coelostat coenzyme coercer coercible
                coercion coeternal coexistence coextensive coffeecake coffeehouse coffeemaker
                coffeepot coffer cofferdam cogency cogent cogitable cogitation cogitator
                cognition cognitive cognizance cognizant cognoscente cohabitant coherence
                coherency cohesion cohosh cohune coiffeur coiffeuse coign coincidence coiner
                coinsurance coir coition coitus cola coldness cole coleslaw colewort coley colic
                colicroot colitis collaborate collagen collarbone collateral collation colleague
                collected collectible collecting collection collective collector collegian
                collet collie collier collimator collins collision collocation colloquial
                colloquium colloquy collotype collusion collusive collyrium colobus colone
                colonelcy colonialism colonialist colonic colonizer colonoscopy colophony
                coloration coloratura colorblind colorcast colored colorfast colorimeter
                colorist colorless colorway colossal colossus colostomy colostrum colpitis
                coltsfoot colubrid colugo columbine columbite columbium columnist colza comaker
                comatulid combatant combative combed comber combination combined combings
                combustible combustibly combustion comedienne comedo comeliness comestible
                comeuppance comfortable comfortably comforter comforting comfrey comicality
                coming comity commandant commandeer commander commanding commandment commemorate
                commensal commentary commentate commentator commerce commercial comminate
                commiserate commissar commissary commission commitment committal committed
                committee committer committing commixture commodify commodious commodity
                commodore commonage commonality commonalty commoner commonness commonplace
                commonweal commotion communal communalize communicant communicate communion
                communique communism communist community commutable commutation commutator
                commuter compaction compactness compactor comparably comparative comparator
                comparison compartment compassion compatible compatibly compatriot compel
                compelling compendious compendium compensate compensated competence competency
                competent competition competitive competitor compilation compiler complacence
                complacency complacent complainant complainer complaining complaint complaisant
                complect complement completed completion completist complexion complexity
                complexness compliance compliancy compliant complicate complicated complicity
                compliment compline complot compo component comportment composition compositor
                composure compounded comprehend compressed compression compressor compromise
                comptroller compulsion compulsive compulsory compunction computable computation
                computerize computing comradery comradeship concaveness concealed concealer
                concealment concede conceited conceivable conceivably concentrate conception
                conceptual concerned concerted concertgoer concertina concertize concession
                conch concha conchie conchology concierge conciliate conciliator conciseness
                concision concluded conclusion conclusive concoction concomitant concord
                concordance concordant concordat concourse concretion concretize concubinage
                concubine concur concurrence concuss concussion condemner condensable condensate
                condenser condign condiment conditional conditioned conditioner condolence
                condominium conducive conductance conduction conductive conductor conductress
                condyle cone coneflower confabulate confection confederacy confederate
                conference conferral conferrer conferva confessed confession confessor confetti
                confidant confidante confidence confident confider confiding confined
                confinement confirmed confiscate confiscator confiture conflation conflicting
                confluence conflux conformable conformance conformism conformist conformity
                confounded confusing confutation congealment congener conger congeries
                congestion conglobate congou congrats congregant congregate congressman
                congruence congruent conical conjectural conjecture conjoint conjugal
                conjugation conjunctiva conjunctive conjuration conjurer connatural connection
                connective connector conniption connivance conniver connoisseur connubial conoid
                conquerable conquered conqueror consecrate consecrated consecutive consensus
                consenting consequence conservancy conservator considerate considered consignee
                consignment consistence consistency consistent consistory consociate consolable
                consolation consoled consolidate consoling consomme consonance consonantal
                consortium conspectus conspicuous conspiracy conspirator constable constancy
                constantan constellate consternate constipate constituent constitute constrain
                constrained constraint constricted constrictor constringe constructor consuetude
                consular consulate consulship consultancy consultant consumable consumed
                consumer consumerism consumerist consummate consummated consumption consumptive
                contagion contagious containable container containment contaminant contaminate
                contemplate contempt contender contention contentious contentment contestable
                contestant contested contiguity contiguous continence continental contingency
                contingent continual continuance continuant continuate continuity continuous
                continuum conto contortion contra contraband contrabass contraction contractual
                contracture contradance contradict contraflow contralto contraption contrarian
                contrariety contrasting contravene contredanse contretemps contribute
                contributor contrition contrivance contrived contriver controlled controller
                controlling controversy controvert contumacy contumely contusion conundrum
                conurbation convalesce convection convector convenance convenience convenient
                conventicle convention convergence convergency conversance conversancy
                conversant converted converter convertible convexity conveyance conviction
                convinced convincing convivial convoluted convolution convolvulus convoy
                convulsion convulsive cony cooked cookhouse cooking cookstove cooler coolness
                coonhound coontie cooperage cooperation cooperative cooperator coordinate
                coordinated coordinator copaiba copal copartner copepod copier coping
                copiousness copolymer copperhead copperplate copra coprocessor coprolalia
                copywriter coquet coquettish coquille cordage cordiality cordierite cordillera
                cordite cordoba cordon cordovan corduroys cordwain cordwood coreopsis corer
                coriander corium corkage corkwood cormorant cornbread corncrake cornel cornelian
                cornerstone cornetist cornfield cornflake cornflakes cornflower corniness
                cornmeal cornpone cornstalk cornstarch cornu cornucopia cornute corollary corona
                coronation coronavirus corporation corporator corporeal corporeity corposant
                corpsman corpulence corpus corpuscle corrasion correctable corrected correction
                corrective correctness corrector correlated correlation correlative correspond
                corrida corrie corrigible corroborate corrosion corrugation corrupted
                corruptible corruption corruptness corselet cortex cortisol cortisone corundum
                coruscation corvee corydalis corymb coryza cosecant cosher cosignatory cosigner
                cosmetician cosmetology cosmical cosmogonist cosmogony cosmography cosmologist
                cosmology cosmonaut cosmopolite coss cossack costliness costmary costumer
                costumier cotangent cotenant coterminous cotillion cotinga cotoneaster cottager
                cottier cottonmouth cottonseed cottontail cottonweed cottonwood cotyledon coucal
                couchette coulisse coulter coumarone councilman councilor counselor countable
                countdown counted countenance counteract counterblow counterfeit counterfoil
                counterglow counterman countermand countermine countermove counterpane
                counterpart counterplot countersign countersink counterspy countervail
                countryman countryside coup coupler courageous courgette courlan coursebook
                coursing courteous courtesan courthouse courtliness courtroom courtship
                courtyard couscous couture couturier couvade covalence covalent covariance
                covenanted covertness cowage cowardice cowberry cowboy cowcatcher cowherb
                cowling cowman cowpat cowpea cowpox cowpuncher cowshed cowskin coyness cozenage
                coziness crabbedness crabbiness crabgrass crackbrain crackdown cracker
                crackerjack crackhead crackleware crackling cradlesong craftiness craftsman
                craftswoman cragginess crake cram crammer cramping cranberry craniate
                craniometer craniotomy crankcase crankiness crankshaft crashing crassitude
                crassness cravenness craving crawler crawlspace cray crayola craziness crazyweed
                creakiness creamer creaminess created creatine creationism creationist
                creativity credence credential credibility credible credibly creditably credited
                credulity creeper creepiness cremains cremation crematorium crematory crenate
                crenelation crenulate crepitation cresol cress cretinism cretonne crewel
                crewelwork crewman cribbage cricketer criminality criminalize criminology
                cringle crinkleroot crinoid crinoline criollo crippler crippling crisis crispate
                crispbread crispiness crispness crisscross criterion criticality criticism
                criticizer crocheter crocheting crockery crocket crocodile crocodilian croissant
                cromorne cronyism crookback crookedness crookneck crooner cropped croquette
                crore crossbeam crossbill crossbones crossbowman crossbreed crosscheck crossfire
                crosshatch crosshead crossing crossjack crossness crossover crosspatch
                crosspiece crossroad crossroads crosstie crosswalk crosswind crossword crotchety
                croton croup croupier crowberry crowded crownwork crucial crucifer crucifixion
                cruciform crud crudeness crudites cruelness cruiser crumbliness crumhorn
                crumminess crunchiness crusader crusher crushing crustacean crustiness cruzeiro
                crying cryogen cryogenic cryogenics cryolite cryometer cryonic cryoscope
                cryostat cryosurgery cryptic cryptogam cryptogram cryptograph crystallite
                crystallize ctenophore cubby cubbyhole cubeb cuber cubical cubism cuboid
                cuckoldry cuckoopint cucurbit cudbear cuddy cudweed cuirass cuirassier cuisse
                cuke cullis culm culmination culpability culpable cultism cultivated cultivation
                cultivator cultural cultured cumbersome cumbrous cumin cummerbund cumulative
                cumulus cunctation cuneiform cupbearer cupel cupidity cuppa cupping cuprite
                cupronickel cupule curability curare curassow curation curatorship curbing
                curbstone cured curet curettage curette curia curiosity curiousness curium
                curliness curling curmudgeon currentness curriculum cursoriness cursory
                curtailment curtained curtness curvaceous curvature curved curvet cushat cusk
                cuspidate cussedness custodian custody customary customer customhouse cutch
                cuteness cutey cutis cutlery cutpurse cutthroat cuttle cuttlefish cutwork cyan
                cyanamide cyanide cyanogen cyanohydrin cyberbully cybercafe cybernetic
                cybernetics cyberpunk cyberspace cycad cycleway cycling cycloid cyclometer
                cyclopedia cyclops cyclorama cyclostome cyclostyle cyclothymia cyclotron
                cylindrical cyma cymatium cymbalist cyme cynical cynicism cyprinid cyprinodont
                cysteine cystine cystocele cytologist cytology cytoplasm cytosine dabbler
                dabchick dachshund dacoit dacoity dada dadaism dado daffiness daftness dago dahl
                daikon dailiness daimon daintiness dairying dairymaid dairyman dairywoman dalasi
                dalliance dallier dalmatian daltonism damaged damages damaging damar dammar
                damoiselle damped dampener damper dampness damselfly dancer dancing dandelion
                dander dandruff dangerous dangler dankness danseur daphne dapperness daredevil
                daredevilry darer darkener darkle darkness darky darnel darner dartboard darter
                dashboard dasheen dasher dashing dasyure datebook dated dater datum dauber
                daunting dauntless davenport dawdler daybook daybreak daycare daydreamer
                dayflower dayfly daylights dayspring daytime dazed dazzler dazzling dded dding
                deaconess deadlight deadliness deadness deadwood deafening deafness dealer
                dealership dealing dean deanship dearest dearness dearth deathless debarkation
                debarment debatable debater debating debauchee debauchery debenture debilitate
                debit debris debugger debutante decadence decadency decagonal decahedron
                decalcify decampment decapod decathlete decathlon deceased deceitful deceiving
                decelerate decelerator decennary decennium deception deceptive decidable
                deciduous decigram decile deciliter decillion decimalize decimation decimeter
                deckchair deckle declamation declaration declared declarer declension declinable
                declinate declination decliner declivity decoction decolletage decompose
                decongest deconstruct decorated decorating decoration decorative decorator
                decorticate decreasing decrepit decrepitude decussate dedicator deductible
                deduction deductive deepfreeze deepness deerhound deerskin deerstalker
                defacement defalcation defamation defamer defaulter defeasible defeated defeater
                defeatism defeatist defecation defection defend defendant defended defenseless
                defensible defensibly deference deferential defiant deficiency deficient
                defilade defiled defilement definable definably defined definition definitive
                deflagrate deflation deflator deflection deflector defoliant defoliation
                defoliator deform deformity defrauder defrayal defrayment defroster deftness
                degeneracy degenerate deglutition dehiscence dehiscent dehorn dehydrator deictic
                deification deionize deistical dejection dekaliter dekameter dekko delaminate
                delate delectate delectation deleterious deletion delft delftware deliberate
                delicious delighted delightful delimitate delineation delinquency delinquent
                deliquesce delirious deliverable deliverance delivered deliverer delphinium
                deltoid deluded deluge delver demagogical demagogue demagoguery demagogy
                demanding demantoid demarcation demarche demeanor demented dementia demigoddess
                demimonde demitasse demiurge democracy democratic democratize demographer
                demographic demography demoiselle demolition demoniacal demonical demonism
                demonology demonstrate demulcent demureness demurrage denaturant denature dengue
                deniable deniably denied denier denigration denominate denotative denouement
                denseness densimeter dental dentate denticle denticulate dentifrice dentin
                dentistry dentition denudation denunciate deodar deodorant deodorizer
                deoxyribose departed department departure depend dependence dependency depiction
                depilatory depletion deployment deportation deportment depositor depository
                depravity deprecating deprecation depreciate depreciator depredate depredation
                depressant depressing depression depressive depressor depurate deputation
                deracinate derailleur derailment derangement derelict dereliction deride
                derision deriv derivation derivative derma dermatitis dermatology dermatome
                dermis derogation derringer derris desalinate desalinize descant descendant
                descender describable describer description descriptive descriptor desecration
                desensitize deserter desertion deserving desiccant desiccation desiccator
                desiderate desideratum designation designator designed designing desirably
                desired desmid desolation despairing desperado desperation despicable
                despoilment despondence despondency despondent despotism desquamate dessiatine
                destination destitute destitution destroyer destruction destructive desuetude
                desultory detached detachment detainment detectable detected detection detent
                detention detergency detergent deteriorate determent determinacy determinant
                determinate determined determiner determinism determinist deterred deterrence
                deterrent detestation detonation detonator detoxicate detribalize detriment
                detrimental detrition detritus deuterium deuteron deutzia devastating
                devastation devastator developed developer development deviance deviancy
                deviating deviation devilment deviousness devisal devisee devoir devolution
                devolvement devotional devoutness dewiness dexterity dexterous dextral
                dextrality dextrose dhole diabetes diabolical diabolism diacritic diacritical
                diaeresis diagnosable diagnosed diagnosis diagnostic diagnostics diagonalize
                dialectic dialectical dialectics dialing dialysis diamagnet diametrical diamine
                diamondback diaphanous diaphone diaphoretic diaphragm diarchy diarrhea diastole
                diathermy diatomite diazepam diazonium dibbuk dibs dices dichloride dichotomize
                dichotomy dichroism dichromate dickens dickhead dickybird dicot dicotyledon
                dictation dictatorial diction dictionary dictum didactic didactical diddler
                didgeridoo dido dieback dielectric dieresis diestock dieter dietetic dietetics
                dietitian difference different difficult diffidence diffident diffraction
                diffuseness diffusion digerati digestible digestion digestive digging diggings
                digicam digital digitalin digitalis digitalize dignified dignitary digraph
                digression digressive diktat dilapidate dilatation dilation dilatory dilettante
                diligence diligent dillydally diluted dilution dimensional diminished diminuendo
                diminution diminutive dimity dimmed dimness dine diner dinge dinginess dingo
                dink dinnertime dinnerware diopter dioptric diorite diphtheria diphthong diplex
                diplodocus diplomacy diplomatic diplomatist dipso dipsomania dipsomaniac
                dipteran diptych directed directional directive directness directorate directory
                direful dirham dirigible dirt dirtball dirtiness disablement disarming
                disassemble disastrous disbandment disbarment disbursal disc discernible
                discernibly discerning discernment discharged discipline disciplined disclosed
                disco discography discomfit discommode discordance discordant discotheque
                discourage discouraged discovered discoverer discrepancy discretion discuss
                discussant discussed discussion disdainful disembowel disgruntle disgusted
                disgusting dishabille dishcloth dishtowel dishware dishwasher dishwater
                disillusion disincline disjointed disjunct disjunction disjunctive disjuncture
                dismal dismantle dismayed dismaying dismissive disorder disparaging disparate
                dispatcher dispel dispensary dispenser dispersal dispersion dispersive
                dispirited dispiriting displeasure disposable disposed disposition dispraise
                disputably disputant disputation disputed disputer disrepair disrepute
                disruption disruptive dissembler disseminate dissension dissenter dissertate
                dissidence dissident dissimilate dissipation dissociate dissoluble dissolved
                dissonance dissonant distal distention distillate distillery distinction
                distinctive distinguish distorted distortion distracted distracting distraction
                distraint distressed distressing distribute distributed distributor disturbance
                disturbed disturber disturbing disulfiram disunion disyllable ditherer dithyramb
                dittany diurnal divaricate diver divergence divergency divergent diverseness
                diversion diversity diverting divestiture divestment divided divider divination
                diviner diving divisible divorcement divulgate divulgence diwan dixie dixieland
                dizziness dobra dobsonfly docile docility dockage dockhand dockland dockworker
                doctorate doctrinaire doctrinal docudrama documentary documented dodecagon
                dodgem dodger doer dogbane dogcatcher doggedness doggerel dogmatic dogmatism
                dogmatist dogsbody dogsled dogwatch doit doldrums dolefulness dollhouse dolman
                dolomite dolor doltishness domesticate domesticity dominance domination
                dominatrix domineering dominie domino donee donjon donna donnybrook doodlebug
                doodler doohickey doomsayer doomsday doomster doorframe doorjamb doorkeeper
                doorknocker doorman doornail doorplate doorpost doorsill dopa dopamine doper
                dopiness doping dormancy dormer dormitory dormouse dorsal dorsum dosimeter
                dosshouse dotage dote doter doting dotterel dottle doubled doublespeak
                doublethink doubleton doubter doubting doubtless dough dourness dovecot dovekie
                dovish dovishness dowdiness dowery dowitcher downcome downdraft downer
                downhearted downland downpipe downsizing downspout downstairs downstate
                downstroke downswing downtick downtime downtown downtrend dowser doxy doze
                drabness dracena draftiness drafting draftsman draftswoman dragoman dragonet
                dragonfly dragonhead dragster drainage drainboard drainer drainpipe drama
                dramatic dramatics dramatist dramaturgy drawbridge drawee drawing drawshave
                drawstring dreadlocks dreadnought dreamboat dreamed dreamer dreaminess dreamland
                dreamworld dreariness dredger dreg dregs dressage dressiness dressmaker
                dressmaking dribbler drier driftage drifter driftnet driftwood driller
                drillmaster drinkable drinker driveler driver driveshaft droid drollness
                dromedary droopiness drooping dropping droppings dropsy droshky drosophila dross
                drover drowning drowsiness drub drudgery drugget drugstore druidism drumfire
                drumhead drumstick drupelet druthers dryness drywall duad dualism dualist dubbin
                dubbing dubiety dubiousness dubitable duckboard duckpin duckpins duckweed
                ductile ductility dudeen dudgeon dueler duffel duffer dugong dulciana dulled
                dullness dulse duly dumbwaiter dumpcart dumpiness dumpsite dunderhead dunlin
                dunnock duodenum duologue duopoly duper dupery duplication duplicator
                duplicitous duplicity durability duramen durance duration durative durbar duress
                durian durmast durra durum duskiness dustcart duster dustiness dustsheet dustup
                duteous dutifulness dwarfism dweller dwelling dwelt dyad dyarchy dyeing dyer
                dyewood dying dynamical dynamics dynamism dynamiter dynamometer dynast dyne
                dysentery dysfunction dysgenic dyslectic dyslexia dyspepsia dyspeptic dysphasia
                dysphoria dysplasia dyspnea dysprosium dystopia dziggetai eagerness eagre
                eardrop earflap earlap earliness earned earner earnestness earnings earpiece
                earshot earthenware earthiness earthling earthnut earthquake earths earthstar
                earthward earthwork earthworm earwax easily easterner eaten eater eavesdrop
                ebonite ebullience ebullient ebullition eccentric ecdysiast echidna echinoderm
                echoes echolocate echovirus eclampsia eclat eclecticism ecliptic ecocide
                ecological ecologist ecology econometric economic economical economics economist
                economizer ecosystem ecotourism ecotourist ecru ecstatic ectoblast ectoderm
                ectomorphy ectoplasm ecumenical ecumenicism ecumenism eczema edacity edelweiss
                edentate edger edginess edging edibility edibleness edification edifier edifying
                editorship educability educated education educational educt edulcorate
                edutainment eelgrass eelpout eelworm eeriness effable effaceable effacement
                effectivity effector effectuate effeminacy effeminate effeminize effervesce
                effeteness efficacious efficiency efficient effleurage effloresce effluence
                effluvium efflux effortless effrontery effulgence effulgent effusion egad
                egalitarian eggbeater eggnog eglantine egocentric egocentrism egoism egoistical
                egomania egomaniac egomaniacal egotism egotistical egregious egression eider
                eiderdown eigenvalue eigenvector eighteenth eightieth einsteinium eisteddfod
                elaboration elan elapid elastance elasticity elasticize elastin elastomer
                elaterid elation elbowroom elderberry eldercare elecampane electable elected
                electioneer electoral electorate electric electrical electrician electricity
                electrifier electrocute electrode electrolyte electrolyze electronic electronica
                electronics electrotype electrum elegancy elegiacal elegist elemental elementary
                elemi elevation elevens eleventh elicitation eligibility eligibly elimination
                eliminator elitism elkhound ellipsis ellipsoid elliptical ellipticity elocution
                elongation elopement eloquence eloquent elucidation elusion elusiveness elytron
                emaciation emanation emancipate emancipated emancipator emasculate embalmer
                embalmment embankment embarkation embarkment embarrassed embattle embay
                embedding embellished embezzler embodiment embolectomy embolus embonpoint
                embosser embossment embouchure embrocate embrocation embroiderer embroidery
                embroilment embryology emendation emergence emersion emery emigration eminent
                emissivity emit emmer emmet emollient emolument emotion emotional empathy
                empennage emphasis emphatic emphysema empirical empiricism empiricist
                emplacement employable employment empowerment emptiness empyrean emulation
                emulsifier enameler enamelware enate encampment encapsulate encasement encaustic
                encephalon enchanted enchanter enchanting enchantment enchantress enchilada
                enchiridion enclosed enclosure encoder encouraging encryption encumbered
                encumbrance encyclical encystment endangered endearing endearment endemism
                endgame ending endlessness endoblast endocardium endocrine endoderm endodontic
                endodontist endogamy endogenous endometrium endomorphy endoplasm endorphin
                endorsed endorsement endorser endoscope endoscopy endosperm endospore endowment
                endpaper endurable endurance energetic energid energizer enervation enforceable
                enforced enforcement enforcer enfranchise engaged engagement engineering
                enginery englut engorgement engraver engraving engrossment engulfment
                enhancement enigma enigmatical enjambment enjoinment enjoyable enjoyment
                enlargement enlarger enlightened enlistment enlivenment enmeshment ennead
                ennoblement ennui enologist enology enough enquirer enriched enrichment enrolled
                enrollee enrollment ensilage enslavement ensnarement ensurer entablature
                entailment entangled entellus entered enteritis enteron enterovirus enterprise
                entertainer enthalpy enthusiasm enthusiast enticement enticing entire entirety
                entitlement entoblast entoderm entombment entomology entourage entrails
                entranceway entrancing entrapment entreating entrepot entropy entryphone
                enumeration enumerator enunciation enuresis envelope enveloper envelopment
                enviable enviousness environment environs envoi envying enwrap eohippus eosin
                eosinophil eparchy epergne ephedrine ephemera ephemeral ephemerid epical
                epicalyx epicarp epicenter epicurean epicycle epicycloid epidermis epidiascope
                epidural epiglottis epigone epigraphy epilepsy epileptic epinephrine epiphyte
                episcopacy episcopate episiotomy epistrophe epitaph epithelioma epithelium
                epithetical epoch eponym epos equability equalizer equanimity equation
                equestrian equidistant equilateral equilibrate equilibrium equipment equipoise
                equipping equitable equitably equitation equivalence equivalency equivalent
                equivocate equivocator eradicable eradication eradicator erasable eraser erbium
                erectness ergonomic ergonomics ergosterol ergot ergotism eringo erne erosion
                erosional erosive errant erratum erroneous eructation erudition eryngo
                erysipelas erythrocyte escalade escalation escalator escalope escapement
                escapism escarpment eschalot eschar eschatology escolar escorted escritoire
                escudo escutcheon esophagus espadrille especial espial espionage esplanade
                espousal esprit essayer esse essive essonite established estaminet esthetician
                estimable estimably estimation estimator estoppel estragon estrone etagere
                etamine etcher etching eternalize eternalness ethane ethanol ethene ether
                etherealize ethics ethnicity ethnography ethnologist ethnology ethologist
                ethology ethos ethyl ethylene ethyne etiological etiologist etiquette etna etui
                etymologist etymologize etymology etymon eucalyptus eudemon eudemonism
                eudiometer eugenic eugenicist eugenics euglena eukaryote eulogizer eunuch
                euphemism euphonious euphonium euphony euphoria euphoriant euphuism eurhythmic
                europium eurypterid eurythmic eutectic euthanasia euthenics eutherian evacuation
                evader evaluated evaluation evaluator evanescence evanescent evangel evangelical
                evangelism evangelist evangelize evaporation evaporator evaporite evasiveness
                evenfall evenhanded evensong eventide eventual eventuality everglade evergreen
                everlasting eversion everybody everyone everything evident evildoing evilness
                eviscerate evite evocation evocative evolution ewer exacerbate exacting exaction
                exactitude exactness exaggerate exaggerated exaggerator exajoule exaltation
                examination examined examinee exampled exasperate exasperated excavation
                excavator exceeding excel excelled excellence excellency excellent excelsior
                exceptional excessive exchequer excision excitation excited excitement exciter
                exciting exclamation exclusion exclusivity excogitate excoriation excrement
                excrescence excreta excretion excruciate exculpation excursion excursive
                excursus excusable excusably excused execration executant executioner executive
                executrix exegesis exegetic exemplary exemption exercised exerciser exhalation
                exhaustible exhaustion exhaustive exhibition exhibitor exhilarate exhortation
                exhumation exiguity existence existent existential exobiology exocarp exodontist
                exogamy exogenous exoneration exoplanet exorable exorbitance exorbitant
                exoskeleton exosphere exoticism expanded expansion expansive expat expatiation
                expatriate expectancy expectant expectation expectorant expectorate expedience
                expediency expediter expedition expeditious expel expendable expended
                expenditure experience experienced experiment expertise expertness expiable
                expiation expiration expired expiry explainable explained explanation expletive
                explicable explicably explication exploded exploited exploiter exploration
                explored explosion exponential exportation exporter exposed exposition expositor
                expostulate expounder expressage expressed expressible expression expressive
                expressway expropriate expugnable expulsion expunction expurgated expurgation
                exquisite extemporary extemporize extender extensible extension extensional
                extensive extensor extenuation exteriorize exterminate extern externality
                externalize extinction extinguish extirpation extoller extortioner extraction
                extractor extradition extrados extralegal extraneous extrapolate extravagant
                extravasate extremeness extremism extremist extremity extricable extrication
                extrusion exuberance exuberant exudation exultant exultation exulting exurbanite
                exurbia eyas eyecup eyedropper eyeopener eyeshade eyeshadow eyeshot eyesight
                eyespot eyestrain eyetooth eyewash eyewitness eyra fabrication fabricator
                fabulist facecloth faceplate facetious facilitate facilitator facing factitious
                factorial factual factuality faddish faddy fadeout faience failing faille
                faintheart faintness fairground fairing fairlead fairyland fairytale faithless
                fajitas faker fakery falafel falchion falconer falconry fallacious fallal
                fallback fallibility fallibly fallout falsehood falseness falsifiable falsifier
                faltering fame familiarity familiarize famulus fanatical fanaticism fancier
                fanciness fancywork fandom fantasist fantast fantastical faqir faquir farandole
                farcical fardel farina farmhouse farming farmstead faro farrago farsighted
                farthingale fasciate fascicule fascinating fascination fascism fashionable
                fashionably fashioner fashionista fastening fastidious fatal fatalism
                fatefulness fatherhood fatherland fatherless fathomable fathomed fatigues
                fattiness fatuousness faubourg faultfinder faultiness faultless faunal fauteuil
                fauvism fave favor favorable favorably favoritism fawner fawning fazed fealty
                fearfulness fearing feasibility feaster featherbed featurette febricity
                febrifuge feces fecund fecundation fecundity federalism federalist federalize
                federated federation federative feebleness feedback feeder feeding feedstuff
                feeler feigned feldspar felicitate felicitous felid fella felloe fellowman
                fellowship felly felucca femaleness femininity feminism femtosecond fenced
                fencer fencing fenestella fenestra fennel fentanyl fenugreek feoff feria
                fermented fermi fermion fermium ferocious ferocity ferrite ferritin ferryboat
                ferryman fertility fertilized fertilizer fervency fervent fervidness fervor
                fescue festal festinate festiveness festivity feta fetcher fetching feticide
                fetidness fetishism fetishist fetor fettuccine feudal feudalism feudatory
                feverfew fewness fiasco fiberboard fiberfill fiberglass fibrillate fibrin
                fibrinogen fibroblast fibrosis fibula fickleness fictional fictitious ficus
                fiddlehead fiddler fiddlestick fidgetiness fidgety fiduciary fieldfare fielding
                fieldstone fieldworker fierceness fieriness fiesta fifer fifteenth fiftieth
                figurate figuration figurative figurehead figurer figwort filagree filature
                filename filial filibuster filled filminess filmmaker filmstrip fils filtered
                filterer filth filthiness filtration fimbriate finagler final finality financial
                financier financing finback finder finding findings fineable fineness
                fingerboard fingering fingerling fingermark fingernail fingerprint fingerstall
                fingertip finickiness finished finiteness finitude fipple firebase firebird
                fireboat firebrand firebrat firebreak firebrick firecracker fired firedamp
                firedog firedrake firefighter fireguard firehouse firelock fireman fireplace
                firepower firer firescreen firestone firestorm firetruck firewater fireweed
                firewood firkin firmament firmness firmware firstborn firth fisc fisher
                fisherman fishgig fishiness fishing fishmonger fishplate fishwife fishworm
                fisticuff fisticuffs fistulous fitch fitfulness fitment fittingness fixation
                fixedness fixings fixity fizgig flab flabbergast flabbiness flaccidity
                flagellant flagellate flagellum flageolet flagging flagitious flagman flagrance
                flagrancy flagrant flagstaff flagstone flak flakiness flambeau flamboyance
                flamboyancy flamboyant flameproof flammable flanker flannelette flashback
                flashbulb flashcard flashcube flasher flashiness flashing flashlight flathead
                flatland flatlet flatmate flatness flatterer flattering flattery flatulence
                flatulency flatulent flatus flatware flaunting flavored flavoring flaxseed
                fleabane fleabite fleapit fleawort fledged fledgling fleecer fleeciness
                fleetingly fleetness fleshiness fletch flew flexibility flexible flexibly
                flexion flexor flextime flexure flickering flier flightiness flimsiness
                flintlock flippancy flippant flippy flirtation flirtatious flitch floater
                floatplane floc flocculate floccule flocking flog floodgate floodlight
                floodplain floodwater floorboard flooring floorshow floorwalker flophouse
                floppiness floral florescence florescent floridness flotation flotsam floury
                flouter flowage flowchart flowerbed floweriness flowering flowerpot flowing
                fluctuation fluency fluffiness flugelhorn fluidity fluidize fluidness flummery
                fluor fluorescein fluoridate fluorinate fluorine fluorite fluoroscope
                fluoroscopy fluorspar fluting fluxion flyby flycatcher flying flyleaf flypast
                flysheet flyswatter flytrap flyweight foamflower foaminess focal focused foehn
                fogged fogginess fogging folacin folderol foliage foliation folium folklore
                folklorist folksiness folksinger folksinging follower following followup
                fomentation fondness foodstuff foolishness foolscap footage footballer footboard
                footbridge footgear footing footlight footlights footling footlocker footman
                footmark footpad footpath footplate footprint footslog footsore footstall
                footstool footwall footwear footwork foppery foppishness forager foramen
                foraminifer forbearance forbid forbiddance forbidding forced forcemeat forceps
                fordable foreboding forebrain forecaster forecastle foreclosure forecourt
                foredeck forefather forefinger forefoot forefront foreground foreigner
                foreignness forelady foreman forensics foreordain forepaw foreperson foreplay
                forequarter forerunner foreseeable foreseen foreseer foreshadow foreshank
                foreshore foreshorten foresight foresighted forestage forestation forestay
                forestland forestry forethought foretold foretop forever forewing forewoman
                forfeiture forger forget forgetful forgettable forging forgivable forgiven
                forgiveness forgiver forgiving forgoer forgotten forint forlornness formalin
                formalism formalist formality formational formatted formatting formed
                formication formidable formularize formulated formulation formulator fornix
                forsaken forsythia forthcoming forthright fortieth fortified fortifier fortitude
                fortuitous fortuity fortunate forwarder forwardness fossa fosse fosterage fought
                foulard foulness foumart foundation founded founding foundling fourpence
                fourposter fourscore fourteenth fovea foxfire foxiness foxtail fractional
                fractionate fractious frag fragility fragmentary fragrance fragrant frailness
                fraise frambesia framboise framed framer framework franchisee franchiser
                francium frangible frangipane frangipani frankfurt frankfurter franklin
                frankness frantic frap fraternal fraternity fraternize fraternizer fratricide
                fraud fraudster fraudulence fraudulent fraxinella freebooter freedman freehanded
                freeholder freelancer freeloader freeman freemasonry freesia freestone freestyle
                freethinker freeware freightage freighter frenemy frenetical frenzied frequency
                frequented frequenter fresco freshener freshman freshness freshwater fretfulness
                fretwork friability friable fricandeau fricative frictional friedcake friendless
                friendship frig frightening frightful frigidity frigidness friskiness frisson
                fritillary frittata fritz frivolity frivolous frogging froghopper frogman
                frolicker frontal frontbench frontlet frontward frosh frostiness frothiness
                frottage frotteur froufrou frowardness frowning frowziness fructose frugality
                frugalness fruitage fruitcake fruitiness fruition fruitless frumenty frustrating
                frustration fucoid fucus fugacious fugacity fugal fulfilled fulfilling
                fulfillment fulgent fulgurate fuller fullness fulmar fulmination fulsomeness
                fumarole fumbler fumbling fumigation fumigator fuming fumitory functional
                functionary fundament fundamental funded funding fundraiser funereal funfair
                fungicide fungus funicle funicular funk funkiness funniness funnyman furan
                furcula furfural furfuran furious furnished furnishings furniture furrier
                furriness furring furtherance furtiveness furuncle furze fusain fusebox
                fusibility fusible fusil fusillade fusionism fussbudget fussiness fustian
                fustiness futile futility futurism futurology fuzzball fuzziness gabardine
                gabbiness gabbro gaberdine gadgeteer gadgetry gadoid gadolinite gadolinium
                gaffer gaiety gaillardia gainer gainful gainsayer gaiter galactose galangal
                galantine galbanum galena galere galingale gallantry gallbladder gallfly
                gallimaufry gallinule gallium gallows gallstone galvanism gambler gambling
                gamboge gambrel gamekeeper gameness gametocyte gametophore gametophyte gaminess
                gaming gammon gamp gangboard ganglion gangplank ganja ganoid gaping garbage
                garboard garboil garbology gardant gardener gardening garganey garget garibaldi
                garishness garnierite garnishment garpike garrote garroter garrulity garrulous
                gasholder gaskin gasohol gasoline gasometer gassed gassing gastritis gastronome
                gastronomy gastropod gastrula gasworks gateau gatecrasher gatehouse gatekeeper
                gathering gathers gaucheness gaucherie gaud gaudiness gauffer gauntness gauntry
                gaur gauss gauze gauziness gavial gawkiness gazer gazetteer gazillion gazpacho
                gean gearing gearshift gearwheel gegenschein geisha gelatin gelatinize gelcap
                gelding gelid gelidity gelignite gemination gemmate gemologist gemology gemsbok
                gendarmerie genealogist genealogy general generalist generality generalize
                generalship generation generative generator generosity genes genesis genet
                genetic geneticist genetics geneva geniality genip genipap genitival genomic
                genotype genteelness gentianella gentility gentlefolk gentlefolks gentleman
                gentlemanly gentleness gentlewoman genu genuflexion genuineness genus geodesy
                geographer geography geological geologist geometer geometrical geometrid
                geophysical geophysics geophyte geopolitics geoponic geostatic geosyncline
                geothermal geotropism gerenuk gerfalcon geriatric geriatrics germander
                germaneness germanium germicide germinated germination gerontology gerrymander
                gestation gestational gesticulate getup gharry ghastliness ghee ghostliness
                ghostwrite ghostwriter giantism gibberish gibbosity gibbousness gibing giddiness
                gifted gigagram gigahertz gigajoule gigameter gigantism gigapascal gigapixel
                giggler gigot gilbert gilder gilding gillie gillion gillyflower gimbal gimbals
                gimcrackery gimel gimmickry gingerbread gingerly gingersnap gingham gingivitis
                ginglymus ginkgo ginseng girandole girasol girder girlfriend girlishness giro
                girth gist gite gittern giver glace glacial glaciation gladiator gladiolus
                gladness gladsome gladstone glamorous glancing glandular glans glaring glasnost
                glassblower glasshouse glassiness glassware glasswort glaucoma glauconite glazed
                glazing gleaner gleanings glebe glee gleefulness gleet glen glia glibness glider
                gliding glimmering glioma glissando glittering gloaming gloating global
                globalism globalist globeflower globin globulin glom glomerate gloominess glop
                glossa glossiness glossitis glossolalia glowering glowing gloxinia glucagon
                glucose glucoside gluiness glume glumness gluon glutamate glutamine glutelin
                gluten glutinosity glutinous gluttonize gluttonous gluttony glyceride glycerin
                glycerol glyceryl glycine glycogen glycol glycoside glyptic gnatcatcher gneiss
                gnomon gnoses gnosis goalkeeper goalkeeping goalscorer goaltender goatsbeard
                goatsucker gobbler gobstopper goby godchild godchildren goddaughter godfather
                godhead godhood godlessness godliness godmother godown godparent godwit goer
                goethite goffer goggles going goldarn goldbricker goldcrest goldeneye goldenrod
                goldenseal goldfield goldfinch goldsmith goldstone goldthread golem golfer
                golliwog gomuti gondolier goner goniometer gonk gonorrhea goodhearted goodness
                goods goodwill goofiness googly goop goosander gooseberry goosebumps goosefoot
                gooseneck goosestep gopherwood goral gorgerin gorget goriness gormandize
                gormandizer gorse gossamer gossiper gotcha gotten gouache gouger gout governable
                governance governed governess government graceless gradational grader gradualism
                gradualness graduand graduation graffito grafter graham grail grainfield
                graininess gramicidin grammarian grammatical gramophone gran granadilla
                grandaunt grandchild granddaddy grandeur grandfather grandiose grandiosity
                grandmaster grandmother grandnephew grandness grandniece grandparent grandstand
                granduncle graniteware granola granter granularity granulation granulocyte
                granuloma grapefruit grapeshot grapevine grapheme graphical graphite graphology
                grappa grasping grasshopper grassland grater graticule gratifying gratin
                gratitude gratuitous gratulant gratulate gravedigger graveness graveside
                gravestone graveyard gravidity gravimeter gravitation graviton gravure grayback
                graybeard grayness grazer grazier greaseball greasepaint greasewood greasiness
                greatcoat greatness greave gree greed greediness greegree greenback greenbelt
                greenbrier greenery greenfly greengage greengrocer greenhorn greenhouse
                greenmail greenness greenockite greenroom greensand greenshank greensward
                greenwood greeter greeting gregarine gregarious greisen grenadier grenadine grep
                grew greybeard greyhound greylag gribble griddlecake grievance griever grift
                grigri grillroom grillwork grimacing griminess grimness grinder grinding
                grindstone gripe griper gripper gripping gripsack grisaille grisliness grison
                gristle gristmill grits grittiness grivet grog grogginess grogram grok gromwell
                groomer grooming groomsman groper groping groschen grosgrain grossness grot
                grotesquery grotto grouchiness grounder groundhog grounding groundless
                groundmass groundnut groundsel groundsheet groundspeed groundswell groundwater
                groundwork grouper grouping groupware grouser groveler groveling grower growing
                growler growths grubbiness grubstake grue grueling gruffness grugru grumbler
                grumpiness guacamole guacharo guaiacum guan guanaco guanine guano guar guarantor
                guarder guardhouse guardrail guardroom guardsman guayule guck gudgeon guenon
                guerdon guereza guerrilla guessable guesser guesstimate guesswork guestbook
                guesthouse guestroom guff guidance guidebook guided guideline guidepost guider
                guilder guildhall guile guileful guileless guillemot guilloche guillotine guilt
                guiltiness guiltless guimpe guitarist gula gulfweed gullibility gulper gumball
                gumboot gumma gumminess gummite gumption gumtree gumwood gurgling gurnard gusher
                gushing gustation gusto gutless gutlessness gutsiness guttersnipe guvnor guyot
                guzzler gymnasium gymnastic gymnastics gymnosperm gymslip gynecology gynoecium
                gypsum gyration gyre gyrfalcon gyrocompass gyroscope gyrostatic gyrus
                haberdasher habergeon habiliment habilitate habitancy habitation habituation
                habitude hacek hachure hackamore hackberry hackbut hacker hacking hackneyed
                hacktivist hackwork hade hadron hadrosaur haemostat hafnium hagberry hagbut
                haggardness haggler hagiography hagiolatry hagiology hahnium haiku hailstone
                hailstorm hairband hairbreadth hairbrush haircloth hairdresser hairdryer
                hairgrip hairiness hairpiece hairspray hairspring hairstreak hairstylist hajj
                halal haleness half halfbeak halfhearted halfpenny halide halite halitosis
                hallelujah hallucinate halm halocarbon halogenate halon halophyte halothane
                halterneck halting hamadryad hamate hamburger hame hammerer hammerhead
                hammerlock hammertoe hampered handbarrow handbrake handclap handclasp handedness
                handfast handgrip handicapper handicraft handiness handiwork handlebar handled
                handler handmaiden handoff handover handspike handspring handstand handwork
                handwriting handyman hanger hankering hanuman haphazard haplessness happening
                happily happiness harasser harassing harassment harbinger harborage hardball
                hardboard hardcover hardened hardener hardheaded hardhearted hardihood hardiness
                hardliner hardness hardpan hardstand hardtack hardware haricot harlequin
                harmattan harmed harmfulness harmonica harmonious harmonium harmonizer harpooner
                harpsichord harquebus harrier harshness hartebeest harvested harvester hashish
                haslet hastiness hatband hatchback hatched hatching hatpin hatstand haughtiness
                haulage hauler haulier haulm haunter haunting hautboy hauteur haver haversack
                havoc hawfinch hawkbill hawker hawkishness hawkshaw hawkweed hawsehole hawsepipe
                hawser hayfield hayfork haymaker hayrack hazan hazardous hazer haziness hazing
                headbanger headboard headcase headcheese headcount headdress header headgear
                headhunter headhunting headiness heading headlight headliner headman headmaster
                headphone headpiece headquarter headrace headroom headsail headshrink headsman
                headspring headstall headstand headstock headstone headteacher headwaiter
                headward headwater headwaters headway headwork healed healer healthful healthily
                healthiness hearsay heartache heartbeat heartbreak heartbroken hearthrug
                hearthstone heartiness heartland heartless heartsease heartsick heartthrob
                heartwood heated heathen heathendom heathenism heather heating heatstroke
                heatwave heaume heavens heavenward heaver heaviness heavyweight hebdomad
                hebephrenia hebetude hecatomb heck heckelphone heckler heckling hectogram
                hectograph hectoliter hectometer hectoring hedgehop hedger hedonic hedonism
                heeded heedfulness heftiness hegemony heinousness helianthus helical helicon
                helicopter heliograph heliolatry heliotrope heliotype heliozoan helipad helium
                helix hellebore helminthic helmsman helper helpfulness helping hemangioma
                hematology hematoma hematuria heme hemeralopia hemicrania hemicycle hemiplegia
                hemipode hemisphere hemoglobin hemophilia hemophiliac hemorrhage hemorrhoid
                henbane henbit henchman hendiadys henhouse henry heparin hepatica hepatitis
                hepatocyte heptad heptane heptathlon heralded heraldry herbage herbal herbalist
                herbicide herbivore herbivorous herder herdsman hereabout hereafter hereditary
                heredity heretical heritable hermeneutic hermetical hermitage herniation heroic
                heroical heroics heroism heronry herpes herpetology herringbone hesitance
                hesitancy hesitant hesitating hesitation hessian heterodoxy heterodyne
                heterograft heteronym heuristic heuristics hewer hexad hexadecimal hexagonal
                hexahedron hexameter hexane hexose hibernation hibernator hidden hiddenite
                hideousness hider hiding hierarchy hieroglyph highbinder highchair highflier
                highhanded highlander highlighter highness hight highwayman hijacker hijacking
                hiker hiking hilarious hilarity hillbilly hilliness hindbrain hindered hindgut
                hindquarter hindrance hindsight hinny hinter hinterland hipness hippodrome hirer
                hirsute hirsuteness hirsutism histaminase histamine histidine histiocyte
                histogram histologist histology histone historian historical historicity
                histrionic histrionics hitchhiker hoactzin hoarder hoarding hoarfrost hoariness
                hoars hoarseness hoatzin hoaxer hobbit hobbledehoy hobbler hobbyhorse hobgoblin
                hobnob hodgepodge hodometer hoer hoggish hogwash hogweed hokum holdall holder
                holdfast holding hollowness hollowware hollyhock holmium holocaust holograph
                holography holothurian holotype holp hombre homecoming homegirl homeliness
                homemaker homemaking homeopath homeopathy homeostasis homeowner homeschool
                homesick homespun homesteader homestretch homeward homewrecker homeyness
                homiletic hominoid hominy homogeneity homogeneous homogenize homogeny homograft
                homograph homologize homology homophobe homophobia homophone homophony honer
                honeylocust honeymooner honeypot honeysucker honeysuckle honker honorably
                honorarium honored honorific hooch hooey hookah hooknose hooky hooliganism
                hoopla hoopoe hootenanny hooter hoped hopefulness hora horehound horizontal
                hormonal hornbeam hornbill hornblende horniness hornstone hornwort horologist
                horology horoscope horrendous horrible horridness horrifying horripilate
                horseback horsebox horsecar horseflesh horsehair horsehide horselaugh horseleech
                horseman horsemint horseplay horsepower horseradish horsetail horseweed
                horsewhip horsewoman horst hosepipe hosiery hospitable hospitably hospitality
                hospitalize hosteler hostilities hostility hotheaded hotkey hotlink hotness
                hotpot hots hottie hourglass houseboat housebreak houseclean housecoat
                housefather householder housekeeper houselights housemaid houseman housemaster
                housemate housemother houseparent houseplant houseroom housewares housewife
                housewifery housework hoverboard hovercraft howdah howler hubris huckaback
                huckleberry hucksterism huffiness hugeness hullabaloo huller humaneness humanism
                humanities humanizer humankind humanness humblebee humbleness humbler humdinger
                humdrum humerus humid humidifier humidity humiliating humiliation humility
                humming hummingbird hummus humor humoresque humorless humus hundredth hungriness
                hunting huntsman hurdler hurdling hurler hurling hurriedness hurtfulness
                husbandman husbandry husker huskiness hustings hustler hutment hyacinth hyaline
                hybridism hydrangea hydration hydraulic hydraulics hydrazine hydride hydro
                hydrocarbon hydrofoil hydrogen hydrogenate hydrograph hydrography hydroid
                hydrologist hydrology hydrolysis hydrolyzate hydromel hydrometer hydrometry
                hydropathy hydrophobia hydrophone hydrophyte hydroplane hydroponic hydroponics
                hydrosphere hydrostatic hydroxide hydroxyl hydrozoan hygiene hygienic hygienist
                hygrometer hygroscope hymenium hymnody hyoid hyoscine hypallage hyperactive
                hyperbaton hyperbola hyperbole hyperbolize hyperboloid hypercube hyperemia
                hypermarket hypermedia hyperon hyperopia hyperplane hyperplasia hyperspace
                hypertext hypertrophy hypervisor hyphenated hyphenation hypnosis hypnotism
                hypnotist hypoblast hypocrisy hypocrite hypocycloid hypodermic hypodermis
                hypoglossal hypoplasia hypostasize hypostatize hypotension hypotenuse
                hypothecate hypothermia hypothesis hypothesize hypothyroid hypoxia hyrax hyssop
                hysteria hysterical hysterics ibuprofen icebreaker icefall icehouse iceman
                icepick ichneumon ichor ichthyology ichthyosaur iciness iconoclasm iconoclast
                iconography iconolatry iconoscope icosahedron icterus ictus idealism identical
                identified identikit ideograph ideography ideological ideologist ideologue ides
                idiolect idiomatic idleness idler idocrase idolatress idolatrous idolatry
                idolization iffiness ignition ignoble ignobleness ignominious ignoramus
                ignorance ignorant iguanodon ileitis ileum ilium illation illegality illegalize
                illiberal illicitness illiteracy illiterate illogic illogical illuminance
                illuminant illuminate illusionist illusory illustrate illustrated illustrator
                illustrious ilmenite imaginable imaginably imagination imaginative imagined
                imagism imago imaret imbecility imbiber imbibition imbrication imbroglio
                imidazole imide imit imitable imitation imitative immaculate immanence immanency
                immanent immaterial immature immaturity immediacies immediacy immediate
                immemorial immenseness immensity immersion immigrant immigration imminence
                imminent immobility immobilize immoderate immodest immodesty immolation immoral
                immorality immortality immortalize immortelle immunology immurement impaction
                impaired impairment impalement impartial impassable impassible impassioned
                impassive impassivity impasto impatience impatiens impatient impeachable
                impeacher impeachment impecunious impedance impeded impediment impedimenta impel
                impenitence impenitent imperative imperialism imperialist imperilment imperious
                impermanent impersonal impersonate impertinent impervious impetigo impetuosity
                impetuous impingement impiousness impishness implemented implication implicative
                implied imploring implosion impolitic importance important importation importer
                importunate importunity imposing imposition impossible imposture impotence
                impotency impotent impoundment impoverish impractical imprecation imprecision
                impregnate impresario impressed impression impressive impressment imprimatur
                imprinter impromptu impropriety improved improvement improvident improviser
                imprudence imprudent impudence impudent impugner impuissance impulsion impulsive
                impunity impureness imputation inaction inadequacy inadvertent inamorata
                inanimate inanition inaugural inaugurate incantation incarcerate incardinate
                incarnadine incarnation incendiary incense incentive incept inception incessancy
                incessant incidence incidental incinerate incinerator incipience incipiency
                incipient incision incitation incitement inclination inclusion inclusive
                incognito incoherency incoherent incommode incompetent incomplete inconstant
                incontinent incorporate incorrect increasing incremental incubation incubator
                inculcation incumbency incumbent incunabulum incurable incurrence incurs
                incursion incus indebted indemnity indene indentation indention indenture
                indexation indexer indicant indication indicative indicator indiction indictment
                indie indigence indigenous indignant indignation indigo indigotin indirect
                indiscrete indistinct indium individual individuate indolence indolent
                indomitable inducement inducer inductance induction inductive inductor
                indulgence indulgent industrial industrious inebriant inebriation inebriety
                ineligible ineptitude ineptness inertia inertness inevitable inexact inexpert
                infamous infancy infanticide infantilism infantryman infarction infatuation
                infected infectious inference inferential inferiority infernal infestation
                infidelity infiltrate infiltrator infinitive infinitude infirmary infirmity
                inflammable inflatable inflater inflation inflator inflected inflection
                infliction influenced influential influenza info infomercial informal informant
                information informative informed infrared infrequence infrequent infuriating
                infuser infusorian ingenious ingenuity ingestion inglenook ingrain ingratiate
                ingredient ingroup ingurgitate inhabitable inhabitancy inhabitant inhabited
                inhalation inhalator inhaler inherence inherent inheritance inheritor inheritrix
                inhibition inhibitor inhumane inhumation inimical iniquitous initialize
                initialized initiated initiation initiative initiator injection injured injurer
                injurious inkberry inkiness inkling inland inly innards innateness inner
                innersole innervation inning innkeeper innocence innovation innovator
                inoculation inordinate inositol inpour inquirer inquiring inquisition
                inquisitive inquisitor insane insanity insatiable insatiate inscriber
                inscription insecticide insectivore insecure inseminate insensate inseparable
                insertion insider insidious insightful insignia insincere insinuating
                insinuation insinuator insipidity insipidness insistence insistency insistent
                insisting insolence insolent insolvency insomnia insomniac insouciance
                insouciant inspection inspector inspiration inspired inst instability installer
                installment instancy instantiate instar instigation instigator instillment
                instinctive instituter institution instructed instruction instructive instructor
                insufflate insular insularity insulated insulation insulator insulin insulting
                insurable insurance insurgence insurgency insurgent intact intactness integrand
                integration integrative integrator integrity integument intel intelligent intend
                intens intensifier intensional intensity intentional intentness interaction
                interactive interbrain interbreed intercalate interceptor intercessor
                interchange intercostal intercourse interested interesting interferon interfuse
                interim interiorize interleave interleukin interlining interloper intermarry
                interment intermezzo intermingle intermit internalize internist internment
                internship internuncio interphone interplay interplead interpolate interpreted
                interpreter interred interregnum interrelate interring interrogate interrupter
                intersperse interstate interstice intertwine interviewee interviewer interweave
                intestacy intestinal intestine inti intima intimation intimidate intonation
                intoxicant intoxicate intrados intravenous intrepidity intricacy intricate
                intriguer intriguing intrinsic introspect intruder intrusion intrusive intuition
                intuitional intuitive inulin inundation invader invaginate invalidism invaluable
                invective inveigler inventive inverter invested investigate investiture
                investment inveteracy inveterate invidious invigilate invigilator invigorate
                inviolate invitation invited invocate involucre involuntary involution involved
                involvement inwardness iodine iodoform ionization ionosphere irateness ireful
                irenic irenical iridescence iridescent iridium irksomeness ironed ironing
                ironist ironmonger ironstone ironware ironweed irradiation irrational
                irredentism irredentist irrelevance irrelevancy irrelevant irreligion
                irreligious irreparable irresolute irreverence irreverent irrevocable irrigation
                irritable irritating irritation irruption isinglass islander isogamete isogamy
                isolation isolator isoleucine isomerism isometric isometrical isometrics
                isometropia isometry isomorphism isopod isopropanol isothermal issuance issued
                italics itchiness itemization iteration iterative iterator itinerary jabberer
                jabiru jacamar jacaranda jackanapes jackfruit jackhammer jackrabbit jackscrew
                jacksmelt jackstraw jacquard jactation jactitation jadedness jadeite jaeger
                jaggedness jaggery jaguarundi jailer jailhouse jakes jambalaya jammed jamming
                jampan jangler japonica jardiniere jargon jarring jasper jato jaundiced
                jauntiness java jawbreaker jawline jaywalker jaywalking jeans jejuneness jejunum
                jellaba jello jellybean jellyfish jellyroll jeopardize jeopardy jerboa jerkiness
                jeroboam jerrycan jersey jesting jetsam jeweler jewelweed jezebel jigaboo jigged
                jiggermast jigging jimsonweed jingoism jinni jinrikisha jitter jitterbug
                jitteriness jitters jobbery jobholder jobless joblessness jobshare jockstrap
                jocoseness jocosity jocular jocularity jocund jocundity jodhpur jodhpurs joey
                jogging johnnycake joinery jointed jointure jointworm joker jokester joking
                jolliness jollity jolter jongleur jorum josher joss journalese journalism
                journalist journeyer journeyman journo jouster jousting jovial joviality
                joyfulness joylessness joyousness joyrider joyriding jubilance jubilant
                jubilation judgeship judgmental judicatory judicature judicial judiciary judo
                jugal juggernaut juggler jugglery juicer juiciness jujitsu juju jumper jumpiness
                junctional junker junketeer juridical juryman jurywoman justiciar justiciary
                justifiable justifiably justified justness jute juvenility juvenilize kabuki
                kafir kahuna kail kainite kaki kale kali kalian kalif kalmia kanzu kaoliang
                kaolin kaolinite kaon kapok karakul karaoke karate karma karstify karyoplasm
                karyotype kasha kauri kava kayaking kedgeree keelson keenness keeper keeping
                keeshond keister kelp kelt kenaf kenned kenning keno kept keramic keratin
                keratose kerbstone kerfuffle kernite kerosene ketchup ketone ketonuria ketose
                kettledrum keybinding keyboarder keyboardist keynoter keypuncher keystroke khoum
                kiang kibbutznik kibe kibitzer kibosh kickball kicker kickshaw kicksorter
                kickstand kidding kidnap kidnapper kidnapping kidskin kieselguhr kilderkin
                killifish kilobit kilocalorie kilocoulomb kilocycle kilohertz kilojoule
                kiloliter kilometer kilonewton kilopascal kilovolt kilter kina kindhearted
                kindliness kindling kindred kine kinematic kinematical kinematics kinescope
                kinesthesia kinetic kinetics kinfolks kingbird kingbolt kingcup kingfisher
                kinglet kingmaker kingship kingwood kinkajou kinkiness kino kinsfolk kinship
                kinsman kinswoman kirtle kishke kismet kissed kisser kissogram kitchenette
                kitchenware kith kitsch kitschy kittenish kittiwake kiwi kiwifruit klaxon
                kleptomania klutziness klystron knap knapweed knavery knawel kneader kneepan
                knicker knickers knickknack knighthood knitting knitwear knobkerrie knockabout
                knockdown knocker knockwurst knotgrass knotted knottiness knotting knout
                knowledge knucklehead knur koan kobo kohl kohlrabi koine kolkhoz koodoo
                kookaburra kookiness kopje koruna koto kraft krait kremlin krill krona krummhorn
                krypton kudo kudos kudu kulak kummel kunzite kurrajong kvass kvetcher kwacha
                kwanza kyat kyle laager labdanum labeled labium laboratory laborer laborious
                laceration lacework lachrymose laconicism laconism lacrimation lacrimator
                lacrosse lactalbumin lactation lactoflavin lactose lacuna ladanum laddish lade
                laden lading ladyfinger ladylike laetrile lagan lager lagging lagniappe laical
                laity lakefront lama lambency lambent lambert lambrequin lamella lameness
                lamentation lamented lamia lamina lamination laminitis lammergeier lampblack
                lamplighter lampshade lancelet lancer lancewood landform landgrave landholder
                landholding landing landless landlubber landmine landowner landowning landscaper
                landscapist landside landslip landsman landward langouste langsyne languidness
                languishing languorous langur lankiness lankness lanolin lantana lanthanide
                lanthanum laparoscope laparoscopy laparotomy lapful lapping lapser larcener
                larcenist larder largeness largess largo larva larvicide laryngitis larynx
                lascar lascivious lashing lassitude lastingness latchstring latecomer lateness
                latent laterite latest lathe lathi latitudinal latke latria latticework laudable
                laudanum laughable laughter launce launchpad launderer launderette laundress
                laundromat laundryman lavabo lavage lavaliere lavation lave lavishness
                lawbreaker lawbreaking lawfulness lawlessness lawmaking lawman lawnmower
                lawrencium laxity laxness layabout layaway layering layman layperson laywoman
                lazar lazaretto laziness lazuli lazybones leader leadership leading leadwort
                leafage leafhopper leafstalk leakiness leaning leanness leaper learnedness
                leaseback leaseholder least leatherback leatherette leatherneck leatherwood
                leathery leavened leavening leaver leavings lecher lecherous lechery lecithin
                lector lecturer lectureship ledger leeriness leering leeway leftism leftward
                legalese legateship legator legerdemain legginess legibility legible legionary
                legionnaire legislation legislative legislator legislature legitimacy legitimate
                legitimize legman legwarmer legwork leisurewear leitmotif leitmotiv lemma
                lemming lempira lender lengthiness lenience leniency lenient lenity leone
                leopardess lepidolite leporid leprechaun leprosy lesbianism lethal lethality
                lethargy letterbox lettered letterer letterhead lettering letterpress letting
                leucine leucopenia leucotomy leukemia leukocyte leukoderma leukorrhea leveler
                levelheaded levelness leveret leviathan levier levitation levity levulose
                lewdness lexeme lexical lexicology lexis liable liana libeler libelous
                liberalism liberality liberalize liberalness liberation liberator libertarian
                libertine libidinal libidinous librarian librettist licensed licentiate
                licentious licitness licking lidocaine lien lieu lieutenancy lieutenant lifebelt
                lifeblood lifeguard lifer lifesaver lifesaving lifespan lifestyle lifter ligan
                ligand ligation liger lighted lightener lighterage lightface lightheaded
                lighthouse lightness lightship lightweight lignin lignite likability likableness
                likelihood likeliness liking lilo limberness limbus limekiln limelight limen
                limestone limewater limey limitation limited limiting limitless limnology
                limonene limonite limousine limpidity limpidness limpkin limpness linage
                linalool lindane lindy lineal lineament linear linearity linearize linebacker
                lined lineman linen linens liner linesman ling lingam lingcod lingerer lingering
                lingo lingonberry lingua lingual linguine linguistic linguistics lining linkboy
                linocut linoleum linseed lionization lipase lipoid lipoma lipoprotein
                liposuction lippy lipreader lipreading liquescent liquidambar liquidation
                liquidator liquidity liquidizer liquidness lira lisle lisper lissomeness listed
                listener listing liter literacy literalism literalize literalness literary
                literati literature litheness lithium lithograph lithography lithophyte
                lithosphere lithotomy litigation litigator litigious litmus litotes litterateur
                litterbug litterer littleneck littleness liturgical liturgist livability
                livelihood liveliness livelong liver liverish liverwort liverwurst liveryman
                liverymen livestock lividity lividness llama loach loafer loaner loather
                loathsome lobate lobectomy lobelia loblolly lobotomize lobscouse lobule lobworm
                local localism locatable locative lockage lockbox locked locker lockjaw locknut
                locksmith lockstep loco locoism locomotion locomotive locum locus lodestone
                lodger lodging lodgings loftiness loganberry logarithm loggerhead logging logic
                logicality logicalness loginess logistic logistical logistician logistics logo
                logogram logorrhea logrolling logwood loincloth loiterer loitering lolly
                lollygag loment loneliness loner longan longanimity longe longevity longhand
                longhouse longicorn longitude loofah lookalike looker loonie looseness
                loosestrife looter looting lopper loquacious loquacity loquat lordliness lore
                lorgnette lorikeet lory loser losing lota lotto loudhailer loudmouth loudness
                loudspeaker lounger loupe lousiness lovableness lovage lovechild loved
                loveliness lovemaking lovesick lovey loving lowdown lowercase lowering lowlander
                lowliness lowness loxodrome loxodromic loyalism lubricant lubrication lubricator
                lubricious lubricity lucent lucerne lucidity lucidness lucifer luciferin luckily
                luckiness lucrative lucre lucubration ludicrous luffa luggage lughole lugubrious
                lugworm lulu lumbago lumberer lumbering lumberjack lumberman lumberyard lumen
                luminance luminosity lumpectomy lumpiness lunchbox lunchroom lunchtime lunette
                lungful lungi lunula lupus lurching luridness lushness lutetium lutist
                luxuriance luxuriant luxuriation luxurious lwei lycanthrope lycanthropy lychgate
                lychnis lying lymph lymphatic lymphoblast lymphocyte lyophilize lyrical lyricism
                lyse lysine macadam macadamia macadamize macaronic macedoine maceration mach
                machicolate machination machinator machinery machinist machismo macho mackintosh
                mackle macrame macrobiotic macrocosm macrology macrophage macula macule madame
                madrasah madrepore madrigalist madrona madrono madwort maelstrom maenad maestro
                mafioso magdalen magenta magi magical magisterial magistracy magistrate
                magnanimity magnanimous magnesia magnesite magnesium magnetic magnetism
                magnetite magneton magnetron magnificent magnified magnifier magnitude maguey
                magus maharajah maharishi mahlstick maidenhair maidenhead maidenhood maidservant
                mailer mailing mailman mailshot mainframe mainsheet mainspring mainstream
                maintained maintenance maisonette majolica majordomo majorette makeshift
                makeweight makings mako malachite maladroit malaise malaprop malapropism malaria
                malarkey malathion malcontent maleate malediction malefaction malefactor
                maleficence malemute maleness malevolence malevolent malfeasance malfeasant
                malfunction malice malicious malignancy malignant malignity malingerer malleable
                mallee malleus malmsey malodor malodorous malposition malpractice maltha maltose
                malvasia malware mama mamey mamma mammalian mammalogy mammogram mammography
                mammon mammoth mana manageable manageably management manager manageress
                managerial managership manakin manana mandola manege manfulness manga manganate
                manganese manganite manger mangetout manginess mango mangosteen manhattan
                manhood maniacal manicotti manicurist manifesto manila manipulate manipulator
                mankind manliness manna manned mannequin mannerism mannerly manning mannishness
                manometer manpower manservant mansion manta mantelet mantelpiece mantrap mantua
                manubrium manufactory manufacture manumission manumit manumitter manuscript many
                manzanita mapping maquiladora mara marasca maraschino marasmus marathoner
                marauder marbling marc marcel marcher marchioness marchland marchpane margarine
                margarita margay marge marginalia marginalize margrave marguerite maria
                marijuana marinara marination mariner marionette marital marjoram marked
                marketable marketeer marketer marketing marketplace markhor markka marksman
                marline marmalade marmite marocain marquetery marquetry marquise marquisette
                marred marrowbone marshalship marshland marshmallow marsupial marten martensite
                martial martian martingale martyrdom marvelous marzipan mascara masculinity
                masher mashie masjid masochism masochist masonry masquerade masquerader
                massasauga massiveness mastectomy masterclass mastered masterful masterly
                mastermind masterpiece mastership masterwork mastic mastication matchable
                matchboard matchbook matched matchlock matchmaker matchmaking matchstick
                matchwood matelote materialism materialist materiality materialize materiel
                maternal maternity matey mathematic mathematics matin mating matins matriarch
                matriarchy matricide matriculate matrilineal matrimonial matrimony matronly
                matronymic matting maturation matureness matzoh mauler maulstick mausoleum mauve
                mavis mawkishness maxilla maximal maxwell mayapple mayflower mayhem mayo
                mayonnaise mayoralty mayweed mazzard mead meadowlark meagerness mealiness
                mealworm meanderings meanie meaningful meaningless meanness meant meantime
                meanwhile measles measurable measured measureless measurement meatiness meatloaf
                meatpacking meatus mechanical mechanics mechanism mechanized medallion meddler
                mediacy mediant mediated mediation medicaid medicament medicare medication
                medicinal medick medico medieval medievalist mediocre mediocrity meditation
                meditative medlar medusa meed meekness meerkat meerschaum meeting megabuck
                megabucks megachurch megacycle megagram megahertz megajoule megalith megalomania
                megalopolis megameter megapascal megapixel megaspore megastar megathere megilp
                megohm megrim meiosis melamine melancholia melancholic melancholy melanin
                melanism melatonin melilot melioration meliorism meliorist mellifluous
                mellowness melodic melodious melodrama meloid melted melting membership
                memorabilia memorable memorandum memorialize memorized memsahib menacing
                menadione menagerie menarche mendacious mendacity mended mendelevium mender
                mendicancy mendicant mending menfolks menhaden menhir meningitis meninx meniscus
                menopause menorah menorrhagia menses menstruate mensuration menswear mental
                mentalism mentalist mentality mentation menthol mentioned meperidine meprobamate
                merchandise merchantman merciless mercurial mercury merganser merger meristem
                merited meriting meritocracy meritocrat meritorious merle merlin merman
                merozoite merriment merriness merrymaker merrymaking mesa mesalliance mescaline
                mesenchyme mesentery meshwork mesmerism mesmerist mesmerizer mesmerizing
                mesoblast mesoderm mesomorph mesosphere mesotron messenger messiah messiahship
                messiness messuage metabolism metabolite metabolize metacarpal metacarpus
                metalhead metalize metallurgy metalworker metaphase metaphysic metaphysics
                metastasis metastasize metatarsal metatarsus metathesis meteorite meteoritic
                meteoroid meteorology methadone methane methanol metheglin methenamine
                methionine methodical methodology methyl metic metical meticulous metonym
                metonymical metonymy metralgia metric metrical metrication metritis metro
                metronome metronymic metropolis mettle mews mezereon mezereum mezzanine
                mezzotint mica micelle mick microbrew microchip microcopy microcosm microcyte
                microfiber microfiche microfloppy microgram microgroove microlight microloan
                micromanage micrometer micropyle microscope microscopy microsecond microseism
                microsome microspore microtome micturition midair midbrain midday middlebrow
                middleman middling midinette midiron midlife midline midsection midship
                midshipman midst midstream midsummer midtown midwifery midwinter mien mightiness
                mignonette migration mildness miler milestone militance militancy militarism
                militarist militarize militiaman milker milkiness milkman milkshake milkwort
                millage millboard milldam milled millenarian millennial millennium miller
                millerite millet milliampere milligram millihenry milliliter millime millimeter
                millimicron milliner millinery milling millionaire millionth millipede
                millisecond millivolt millrun millstone millstream millwork millwright milo
                milometer milord milquetoast mimeograph mimes mincemeat mincer mincing minded
                mindfulness minefield minelayer miner mineralize mineralogy minestrone
                minesweeper miniature miniaturist miniaturize minibar minicab minimal minimalism
                minimalist mining minion miniseries ministerial ministrant minium miniver
                minnesinger minoxidil minstrelsy mintage minter minuscule minuteman minuteness
                minutia miraculous mirth mirthless misaddress misalliance misallocate
                misanthrope misanthropy misbehavior misbelieve miscarriage miscellany mischance
                mischief mischievous miscibility misclassify misconceive misconduct misconstrue
                miscopy miscreant misdemeanor misdiagnose misdoing miserliness misfeasance
                misfeature misfortune misgiving misguidance misguided misidentify misjudgment
                misleading misogamist misogamy misogynist misogyny misology misperceive
                mispickel misprision misreading misremember missed misshapen missilery
                missionary missioner misspelling missy mistakable mistaken mistiness mistletoe
                mistrustful miterwort mitigation mitosis mixed mixer mixologist mizenmast
                mizzenmast moaner mobbed mobbing mobcap mobilizer mocker mocking mockingbird
                modality moderation moderator modernism modernist modernity modernizer
                modernness modest modesty modifiable modified modifier modillion modishness
                modiste modularize modulation modulator mohair moistener moistness moisture
                moisturize moisturizer moke mola molarity molasses moldboard molded moldiness
                molding mollycoddle molter molybdenite molybdenum momentary momentous momentum
                momism monad monandry monarch monarchism monarchist monarda monas monastery
                monastical monasticism monaural monetarism monetarist moneybox moneylender
                moneymaker moneymaking moneywort mongo mongol mongolism mongoloid mongrelize
                monism monitored monkeyshine monkish monkshood mono monochrome monocot monocycle
                monocyte monogamist monogamous monogamy monograph monogyny monolatry monolayer
                monolingual monolith monologist monologue monomania monomaniac monomial
                monophthong monoplane monopole monopolist monopolize monopolizer monotheism
                monotheist monotonous monotony monotype monseigneur monsieur monsignor
                monstrance monstrosity monstrous monte monumental moocher moodiness mooneye
                moonlighter moonscape moonseed moonshiner moonstone moonwort moorage moorhen
                mooring moorwort moose mopboard moper mopish moquette mora moral morale
                moralizer moralizing moratorium morbidity morbidness mordacious mordancy morello
                mores morganite morgen moribund morocco moroseness morphia morphine morphing
                morphology morse mortality mortarboard mortgagee mortgagor mortician mortifying
                mortmain mosquito motherboard motherhood motherland motherwort motile motility
                motionless motivated motivation motivator motivity motmot motocross motorbus
                motorcade motorcycle motorman motormouth motortruck motto mouflon moujik
                mountable mountaineer mountaintop mountebank mounted mourned mourner mourning
                mouser mousetrap mousiness moussaka mouthiness mouthpart mouthpiece mouthwash
                mouton movability movableness movably moved moviegoer moving mower moxie
                mozzarella muchness mucilage mucin muckraker mucor mucosa mucus mudcat muddiness
                muddlehead mudflap mudflow mudlark mudpack mudra mudskipper mudslinger
                mudslinging muenster muesli muffler mugginess muggins mujik mulatto muleskinner
                mulishness mullah mullein multicolor multilayer multimedia multiplayer
                multiplexer multiplier multitask multitude multiverse mumbler mumbletypeg
                mummery mump mumps munchie munchies munificence munificent muniment muntjac muon
                murkiness murmuration murmurer murmuring murphy murrain murre muscadel muscadine
                muscular muscularity musculature muse mushiness musicality musicology musjid
                muskellunge musketeer musketry muskie muskiness muskmelon muslin musquash
                mussiness mustard musteline mustiness mutability mutableness mutation mutational
                muteness mutinous mutterer muttering mutton muttonchops muttonhead mutual
                mutuality muzhik myalgia mycelium mycological mycologist mycology myelin myeline
                myelitis myeloma myocarditis myocardium myoglobin myology myopia myosin myotonia
                myriapod myrobalan myrrh mysterious mysticism mystifying mystique mythical
                mythologist mythologize mythology myxedema myxomycete naan nagging nailbrush
                nailhead nainsook naira naiveness naivete naivety nameable named nameplate
                nankeen nanobot nanometer nanosecond napery naphtha naphthalene napper
                narcissism narcissist narcissus narcolepsy narcoleptic narcose narcosis nard
                nardoo narghile narration narrative narrowness narthex nary nasality nascency
                nascent nasopharynx nastiness nasturtium natatorium nation nationalism
                nationalist nationality nationalize nationhood nativism nativist natterjack
                nattiness naturalism naturalist naturalize naturalized naturalness naturism
                naturist naturopathy naughtiness naumachia nausea nauseating nautch nautical
                nave navicular navig navigable navigation navigator navvy neanderthal nearness
                nearsighted neatness nebulize necessarily necessary necessitate necessity
                neckband neckerchief necking neckpiece necrology necromancer necromancy
                necrophilia necropolis necropsy necrosis nectarine needed neediness needlecraft
                needlepoint needlewoman needlework nefarious negation negativism negativist
                negativity neglectful negligence negligent negotiable negotiant negotiation
                negotiator negritude negus nekton nemertean nemesis neodymium neoliberal
                neologism neologist neology neomycin neon neonatal neoprene nepenthe nephoscope
                nephrectomy nephrite nephritis nephron nepotism neptunium nerveless nerviness
                nervousness nescience ness nestling netherworld netiquette netter netting
                networking neural neuralgia neuritis neuroblast neuroglia neurologist neurology
                neurosis neuroticism neutralism neutralist neutrality neutralize neutralizer
                neutrophil nevus newline newness news newsagent newscaster newsdealer newsflash
                newsgroup newshound newsletter newsman newsmonger newsprint newsreader newsstand
                newsweekly newswoman newsworthy next ngultrum niacin nibbler niblick niceness
                nickelodeon nickle nicotine nidus nightclub nightdress nightfall nightgown
                nighthawk nightingale nightjar nightlife nightlight nightmare nightrider
                nightshade nightshirt nightspot nightstand nightstick nighttime nightwalker
                nightwear nihil nihilism nilgai nimbleness nimbus nimiety ninepins nineteenth
                ninetieth niobium nipa nippiness nirvana nisei nisus niter nitpicker nitpicking
                nitration nitrile nitrogen nobelium nobility nobleman nobleness noblesse
                noblewoman noctiluca nocturnal nogging noiseless noisemaker noisiness
                noisomeness nombril nominal nominalism nomination nominative nonactive nonagon
                nonbeliever nonce nonchalance nonchalant noncitizen nonclerical noncriminal
                nondelivery nondescript nondrinker nondriver none nonentity nonexempt
                nonfeasance nonfiction nonfood nonillion nonliving nonmember nonnarcotic
                nonnative nonofficial nonparallel nonpareil nonpartisan nonpayment nonperson
                nonphysical nonplus nonporous nonresident nonresidual nonsensical nonsmoker
                nonstarter nonstick nonsuccess nonsupport nonviolence nonviolent nonworker
                noonday noontide noontime noria normalcy normality normative northeaster
                northerly northerner northward northwester nosebag nosebleed nosepiece nosewheel
                nosher nosiness nosology nostalgia nostoc notability notational notecase notelet
                notepad notepaper noteworthy nothingness noticeable noticeably noticeboard
                noticed notifier notional notochord notoriety notorious notornis notwork
                nourishment nous novelette noviciate novitiate novobiocin nowadays noway nowhere
                noxiousness nucellus nuclear nucleation nucleolus nucleonic nucleoplasm
                nucleoside nucleotide nucleus nudism nudity null nullity numbat numbered numbing
                numbness numerable numeration numerator numerical numerology numismatic
                numismatics numismatist nummulite nursemaid nurser nurseryman nursing nurturer
                nutation nutcase nutcracker nuthouse nutriment nutrition nutritional nutritious
                nutter nuttiness nuzzler nyala nybble nyctalopia nyctophobia nylghau nylons
                nymph nymphalid nystatin oafishness oakum oarsman oarsmanship oarswoman oast
                oatmeal oats obbligato obduracy obedience obeisance obfuscation objectivity
                objurgation oblateness oblation obligation obligato obliqueness obliquity
                obliterate oblivion oblivious obloquy obnoxious obscureness obscurity obsequious
                obsequy observable observance observant observation observatory observed
                observer observing obsession obsessional obsidian obsolescent obstetric
                obstetrics obstinacy obstinate obstructed obstruction obstructive obtainable
                obtainment obtrusion obtuseness obviation obviousness occasional occident
                occidental occiput occlusion occultism occultist occupancy occupation occupied
                occurred occurrence occurring oceanfront oceanic oceanology ocher ocker ocotillo
                octad octahedron octameter octant octillion octonary octopod octroi odalisque
                oddness odds odiousness odium odoriferous odorless oenology oenophile
                oenophilist oersted offal offended offender offending offered offering offertory
                offhanded officer officialdom officialese officialism officiant officiator
                officious offing offshore offside offspring offstage ogdoad ogee ogive ogler
                ohmage oilbird oilcan oilcloth oilfield oiliness oilskins oilstone oldness
                oleaster olein oleo oleoresin olfaction olfactory olibanum oligarch oligarchy
                oligochaete oligoclase oligopoly oliguria olivine olla ology ombudsman omen
                omentum ominousness omit omnipotence omnipotent omniscience omniscient
                omnivorous omphalos onager onanism onanist once oncologist oncology oneness
                onerousness onionskin onomastic onslaught ontogeny ontological ontology oocyte
                oodles oological oosphere oospore opacity opalescence opaqueness opcode opened
                opener openhanded opening openness openwork operable operand operation
                operational operculum ophidian ophthalmia opinion opportunism opportunist
                opportunity opposed opposition oppression oppressive oppressor opprobrious
                opprobrium optative optical optics optimal optional optometrist optometry
                opulence opulent oracular orang orangeade orangewood orangutan oration
                oratorical orbicular orbiter orca orchestral orchestrate orchitis ordained
                ordainment ordered orderliness ordinance ordinand ordination ordnance ordure
                oregano organdy organelle organically organicism organized organizer organon
                organza orientalist orientalize orientation orienteer origami originality
                origination originator orinasal orlop ormolu ornamental ornateness orneriness
                ornithine ornithology ornithopod orotundity orphanage orphrey orpiment orpine
                orrery orthicon orthoclase orthodontia orthodontic orthodox orthodoxy orthogonal
                orthography orthopedic orthopedics orthopedist orthopteran orthotic ortolan oryx
                orzo oscillation oscillator oscillogram oscine osculation osmium osmosis ossicle
                ostentation osteoblast osteoma osteopath osteopathy ostiole ostler ostracism
                ostracod ostracoderm otalgia otherness otherworld otiose otology otoscope ottar
                oubliette ouguiya ousel ouster outbalance outbid outbuilding outcaste
                outcropping outdate outdistance outdo outdoor outdoors outerwear outfall
                outfielder outfitter outgeneral outgrowth outgun outhit outing outlandish
                outlawry outlier outmaneuver outpatient outperform outplace outport outpouring
                outproduce outrageous outrider outrigger outrun outsider outsole outsourcing
                outspan outspoken outspread outstand outstanding outstation outstretch outstrip
                outturn outwit ouzel ovariectomy ovation ovenware overachieve overalls
                overbalance overbearing overbuild overburden overcharge overclock overcrop
                overdevelop overdo overdraft overdrive overeducate overexcite overexpose
                overextend overflight overgrowth overhasty overindulge overinflate overmantel
                overmaster overmatch overmuch overnight overplus overpraise overproduce
                overprotect overrefine overriding overripe overscale oversea overseer overshadow
                overshoot oversight overskirt oversleep overspecify overspend overspread
                overstaff overstep overstrain overstress overstretch oversupply overthink
                overtop overweening overweight overwinter overwrite ovipositor ovulation ovum
                owlish owned ownership oxalate oxalis oxblood oxheart oxidase oxidation
                oxidative oxidization oxime oxtail oxyacid oxycephaly oxygen oxygenation
                oxymoron oxytocin ozone pablum pabulum pacemaker pacer pacesetter pacha pachisi
                pachyderm pachysandra pacifier pacifism packaging packhorse packsaddle
                packthread padauk padding paddler pademelon padre padrone paella paganism
                pageantry paged pager paginated pagination painfulness painkiller painstaking
                paintbrush painted painting paired pairing paisa pajama pajamas palanquin
                palatable palatably palatalize palatial palatinate palazzo paleness paleobotany
                paleography palimony palimpsest palindrome paling palladium pallbearer pallette
                palliasse palliation palliative pallidness pallium pallor palmistry palmitin
                palp palpability palpation palpitation palsgrave paltriness pampa pampas
                pamphleteer panache panatela panatella pandanus pandemonium panderer pandowdy
                panegyric panegyrical panegyrist paneling panga pangolin panhandler panjandrum
                pannikin panpipe panpipes pantaloon pantaloons pantheism pantheist panting panto
                pantomimist pantyhose pantyliner pantywaist panzer papa papain papal paparazzi
                papaverine paperback paperbark paperboard paperclip paperer papergirl
                paperhanger paperweight paperwork papilla papilloma papillon pappus paprika
                papule papyrus paraboloid paracetamol parachutist parader paradiddle paradoxical
                paraffin paralegal paralleled parallelism parallelize paralogism paralysis
                paralytic paralyzing paramagnet paramecium paramedic paramedical parameter
                parametrize paramnesia parang paranoia paranoiac paranormal paraphrase
                paraplegia paraplegic paraquat parasitical parasitism parathion parathyroid
                paratrooper paratroops paratyphoid pardner pardonable pardonably pardoner pare
                paregoric parentage parenthesis parenthood parenting parer pares paresis
                paresthesia paretic pariah parietal parimutuel paring parishioner parking
                parlance parliament parlormaid parochial parotitis parquetry parricide parsimony
                parsley parsonage partaker partiality partialness participant participate
                participial participle particular particulate partitive partnership partridge
                parturition parvis pasquinade pass passageway passenger passer passerby
                passerine passionate passionless passivate passiveness passivism passivity
                passphrase pasta pasteboard pastel pasteurize pasteurized pasteurizer pastil
                pastiness pastis pastorale pastorate pastorship pastrami pasturage pastureland
                pataca patchiness patchouli patchwork patented patentee paternal paternalism
                paternalist paternity paternoster pathfinder pathologist pathology pathos
                patience patio patisserie patness patois patriarch patriarchy patrician
                patricide patrimony patriotic patriotism patrolman patrolwoman patronage
                patroness patronizer patronizing patronymic patten paucity pauperism pavane
                paved pavis pavlova pawnbroker pawnbroking paymaster paynim payola payphone
                peacekeeper peacemaker peacemaking peacetime peacoat peag pean peasantry
                peasecod peashooter peat peavey peba peccadillo pectin peculation peculator
                peculiar peculiarity pedagogic pedagogical pedagogue pedagogy pedalo pedantry
                peddler pederasty pedestrian pediatric pediatrics pedicel pedicurist peekaboo
                peeled peeler peeling peeper peepul peerless peevishness peewit pegmatite
                pejoration pejorative pekan pekingese pekoe pelecypod pelf pelisse pellagra
                pellicle pellitory pellucidity pelmet pelota pemmican pemphigus penal pendragon
                pendulous penetrating penetration penfriend penicillin peninsula penitence
                penknife penman penmanship penni pennoncel pennyroyal pennyweight penologist
                penology pension pensionary pensioner pensiveness penstock pentad pentagram
                pentahedron pentameter pentathlete pentathlon penthouse pentlandite pentode
                pentose penuche penult penultimate penurious penury peonage peppercorn
                peppermint pepperoni peppiness pepsin peptidase peptide peptone perambulate
                perceived percentage percentile perception perceptive perceptual percipience
                percipient percolation percolator percussion percussive perdition perdure
                peregrinate peregrine peremptory perestroika perfected perfection perfective
                perfectness perfervid perfidious perforated perforation performance performed
                performer perfume perfumer perfumery perfunctory peri pericardium peridium
                peridot perigon perihelion perilous perilune perimeter perineum periodical
                periodicity peripatetic peripheral periphery periphrasis periscope perishable
                peristalsis peristome peristyle peritoneum peritonitis periwinkle perjurer
                perjurious perkiness permafrost permanence permanency permeation permissible
                permission permissive permutation pernicious peroration perpetrate perpetrator
                perpetuate perpetuity perplexed perplexing perplexity perquisite perry
                persecution persecutor perseverate persevering persiflage persimmon persistence
                persistency persistent persona personable personage personality personalize
                personalty personnel perspective perspicuity perspicuous persuaded persuader
                persuasion persuasive pertinacity pertinence pertinency pertinent pertness
                perturbed perturbing pertussis pervasion pervasive perversion perversity pesewa
                peskiness peso pessary pessimism pessimist pesthole pesthouse pesticide
                pestiferous pestilence pesto petajoule petawatt petitioner petrodollar petrol
                petrolatum petroleum petrologist petrology petticoat pettifog pettifogger
                pettiness petting petulance petulant peyote phage phagocyte phalanger phalarope
                phanerogam pharaoh pharmacist pharos pharyngitis pharynx phellem phenacetin
                phenolic phenomenal phenomenon phenotype pheromone philanderer philatelist
                philately philhellene philippic philistine philologist philology philosopher
                philosophy phisher phlebitis phlebotomy phlegm phloem phlogopite phocomelia phon
                phonate phonecard phonemic phonetic phonetician phonetics phonic phonics
                phoniness phonogram phonograph phonologist phonology phosgene phosphate
                phosphine phosphorus phot photocell photocopier photoflash photoflood photograph
                photographs photography photometer photostat phrasebook phraseology phratry
                phrenology phylactery phyle phyllo phylloclade phyllode phylogeny phylum
                physicalism physicality physician physicist physics physio physiognomy
                physiology phytology piaffe pianism pianissimo pianoforte pianola pibroch pica
                piccalilli piccaninny pickaninny picker pickings pickpocket picnicker picofarad
                pictogram pictograph picturesque picul piddock pieceworker pieplant pier pieta
                pietism pietistical piety pigeonhole piggery piggishness pigheaded pignut
                pigweed pika piker pikestaff pilewort pilferage pilferer pilgrimage piling
                pillager pillock pillowcase pillowslip pilotage pilothouse pilsner pimpernel
                pinball pinchbeck pincushion pineapple pinewood pinfeather pinfold pinkeye
                pinkness pinna pinnace pinned pinning pinniped pinnule pinny pinochle pinsetter
                pintail pintle pintsize pinworm pinyin piousness pipage pipeful piper piperine
                piping pipistrelle pipsissewa pipsqueak piquancy piquet piracy pirana piratical
                pirogi pirogue piroshki piscary pissoir pistachio piste pistoleer pitchblende
                pitcher pitcherful pitchman pitchstone piteousness pithead pithiness pitiable
                pitman pitsaw pitta pituitary pitying pivotal pixelate pizzicato placating
                placation placed placeholder placekicker placental placidity placidness plage
                plagiarism plagiarist plagiarize plagiarizer plagiary plagioclase plaice
                plainness plainsman plainsong plainspoken plaintiff plaintive planarian planchet
                planchette planeload planer planetarium planetoid plangency plangent planimeter
                planking plankton planned planning planography plantation planted planter
                planting plasm plasmid plasmin plasmodium plasterer plasticity plasticize
                plastid plastique platelayer platen plating platinum platitude platy plausible
                playacting played playfellow playfulness playground playgroup playhouse playlet
                playschool playsuit plaything playtime playwright plaza plea pleader pleas
                pleasance pleasantry pleased pleb plebiscite plectron plenitude plenteous
                plentiful plenum pleochroism pleopod plesiosaur plethora pleura pleurisy
                pleurodynia plexor pliability pliable pliancy pliant pliers plimsoll plinth plod
                plosion plosive plotted plowboy plowed plowman plowshare ploy pluckiness plugged
                plugging plughole plumbago plumbed plumber plumbery plumbing plumbism plumcot
                plumpness plunderer plunger pluperfect pluralism pluralist plurality plushness
                plutocracy plutocrat pluton plutonium plywood pneumatic pneumatical pneumonia
                poacher poaching pochard pocketbook pocketful pocketknife podiatrist podiatry
                poesy poetaster poetic poetical pogey pogge pogonia pogy poignance poignancy
                poignant poilu poinciana poinsettia pointer pointillism pointillist pointless
                poised poisoner poisoning poisonous poker pokeweed polarimeter polariscope
                polemical polemicist polemicize polemics policeman policewoman policymaker polis
                polished polisher politburo politeness politesse political politician politicize
                politicking politics polled pollen pollination pollinator polling pollutant
                polluted polluter pollution polo polonaise polonium poltergeist poltroonery
                polyamide polyamory polyandrist polyandry polyanthus polychaete polychrome
                polyclinic polyester polygamist polygamous polygamy polygynist polygyny
                polyhedron polymath polymerase polymerize polymyxin polynomial polypeptide
                polyphone polyphony polyploid polypody polypus polysemy polystyrene polytechnic
                polytheism polytheist polythene polyzoan pomatum pome pomegranate pomelo pomfret
                pommy pomology pomp pomposity pompousness ponderer ponderosa ponderosity
                ponderous pondweed pongee pongid pontifical pontificate pood poofter poolside
                poon poorboy poorhouse poorness popcorn popery poplin poppadom poppet poppycock
                popular popularity popularize populated population populism populous porbeagle
                porcelain porcupine porker porkpie porosity porousness porphyria porphyry
                porridge porringer portability portcullis portentous porterage porterhouse
                portfolio portico portliness portmanteau portraitist portraiture portrayal
                portulaca posed positional positioned positioner positioning positivism
                positivist positivity posology possession possessive possessor posset
                possibility postage postal postbag postbox postcode poster posterity postern
                postfix posthole posthumous postiche postie postilion posting postman postmaster
                postmortem postnatal postscript postseason postulant postulation posturing
                potability potage potash potassium potation potboiler potboy poteen potency
                potent potentate potentiate potholder pothouse pothunter potoroo potpourri
                pottage pottle potto pouf pouffe poulterer poultry poundage poundal pounder
                pouter pouting powerboat powerhouse powerless practicable practiced practicum
                praenomen pragmatic pragmatical pragmatism pragmatist prancer prancing prankster
                prat prater pratincole prattler prayer prayerful preacher preachment preapply
                prearrange preassemble preassign prebend prebendary precarious precatory
                precaution precedence precedency precedent precentor preceptor precession
                preciosity precipice precipitant precipitate precipitin precipitous precis
                preciseness precision preclusion preclusive precocious precocity preconceive
                preconcert precursor predatory predecease predecessor predefine predestine
                predicament predication predicative predictable predictably predicted prediction
                predictor predispose predominant predominate preeminence preeminent preemption
                preemptive prefecture preference preferment pregnancy pregnant prehensible
                prehension prehistory prehuman prejudgment prejudiced prelacy prelature
                preliminary premature premeditate premiership premonition prenatal prenotify
                prentice prepackage preparation prepayment preposition prepossess preregister
                prerogative presbyopia presbyter presbytery preschooler prescience prescient
                prescreen preseason preselect presentable presenter presentment presentness
                preserved preserver preset preshrink presidency president presidium pressed
                pressie pressman pressmark pressurize pressurized pressurizer prestige
                presumption presumptive presuppose pretender pretending pretension pretentious
                preterition pretor pretrial prettiness prevailing prevalence prevalent
                prevaricate preventable prevention preventive previous prevision prezzie priced
                pricker pricket prickliness prier priestcraft priestess priesthood primacy
                primal primateship primatology primer primeval priming primitivism primness
                primordial primordium primula primus princedom principled printable printed
                printmaker printmaking prion prioritize priorship prismatoid prismoid prisoner
                prissiness pristine privateness privileged prizefight prizewinner proactive
                probabilism probability probationer probity problematic proboscis procaine
                procedural procedure proceeding proceeds processed procession processor proclaim
                proclaimed proclivity procreate proctology proctoscope procurance procurement
                procuress prodigality prodigious prodrome producible product production
                productive profanation profaneness profanity professed profession professor
                proficiency proficient profitable profitably profiterole profligacy profligate
                profundity profuseness progenitor progeny progestin prognosis prognostic
                programmed programmer programming progression progressive prohibited prohibition
                prohibitive projectile projection projective projector prokaryote prolamine
                prole proletarian proletariat proliferate prolific prolificacy proline prolix
                prolixity prolongate prolusion prom promethium prominence prominent promiscuity
                promiscuous promisee promising promo promontory promoter promptbook prompted
                prompter prompting promptitude promptness promulgate promulgator proneness
                pronghorn pronominal pronounced proofreader propaganda propagation propagator
                propane propel propellant propeller propellor propene propensity properness
                prophase prophesier prophetess prophetical prophylaxis propinquity propitiate
                propitious propjet proponent proportion proprietary proprieties proprietor
                propriety propulsion propylene prorogation prosaic prosaicness proscenium
                prosciutto prosecution prosecutor proselytism proselytize prosiness prospective
                prospector prospectus prosperity prosperous prostatitis prosthesis prosthetic
                prostration protagonist protamine protanopia protease protected protection
                protective protector protegee proteinase protestant protesting protist
                protoplasm protoplast protozoan protrusion protuberant provability provable
                proved proven provenance provender provenience proverbial provided providence
                provident provider provincial provision provisional provocateur provocative
                provoked provoker provoking provolone prowess prowler proxemic proximal
                proximate proximity prudence prudent prudential prudery prudishness pruner
                prurience prurient pruritus prying psalmody psephology pseud pseudo pseudonym
                psilocybin psilomelane psittacosis psoriasis psyche psychedelic psychiatry
                psychical psychodrama psychology psychometry psychopath psychopathy psychos
                psychosis psychotic ptarmigan pterodactyl pterosaur ptosis ptyalin ptyalism
                puberty pubes pubescence pubis publication publicist publicity publicized
                publishable published publisher publishing puccoon puce puckishness puddling
                pudendum pudginess puerile puerility puffer puffiness pugilism pugnacious
                pugnacity puissance puissant pula pulchritude pule puller pulpiness pulpwood
                pulque pulsation pumper pumpkinseed punchbag punchball puncher punchline
                punctilio punctilious punctual punctuality punctuation punditry pung pungency
                pungent puniness punished punishing punishment punk punkie punnet punning punter
                pupa puppeteer puppetry purblind purchaser purdah pureness purgation purgative
                purgatory purger purified purifier purism puritanical puritanism purpleness
                purported purposed purposeful purposeless purposive purpura purser purslane
                pursuance pursuer purulence purveyance purview pushball pushbike pushchair
                pusher pushiness pushpin putative putrescence putrescine putrid putridity
                putridness putted putterer putting puttyroot putz puzzlement puzzler puzzling
                pycnidium pylorus pyorrhea pyralid pyramidal pyramidical pyrethrum pyrexia
                pyridine pyridoxine pyrimidine pyrites pyromania pyromaniac pyrometer pyrostat
                pyrotechnic pyroxene pyrrhic pyrrhuloxia pythoness pyxie qindarka qintar
                quackery quadrangle quadrate quadratic quadrature quadrennial quadrennium
                quadric quadriceps quadrillion quadrivium quadruped quadruplet quagga quaintness
                qualifier qualitative quamash quango quantified quantifier quantize quantum
                quarantine quarreler quarrelsome quarterback quarterdeck quarterly quartern
                quartic quartile quarto quartzite quassia quaternary quaternion quaternity
                quavering quayside queasiness queerness quenchable quenched quencher quern
                querulous quesadilla quested quester questing questioned questioner questioning
                quetzal quibbler quicklime quickness quicksilver quickstep quiesce quiescence
                quiescent quietism quietness quiff quilter quilting quin quinacrine quince quine
                quinine quinsy quintal quintillion quintuplet quipu quirkiness quit quitclaim
                quittance quivering quixotism quizmaster quizzical quodlibet quorate quot
                quotability quotation rabato rabbinate rabbinical rabidness rabies racecourse
                racegoer racehorse racer racetrack rachis racial racialism racialist raciness
                racing racism racon raconteur racquetball radar radarscope radian radiance
                radiancy radiant radiation radiational radicalism radicalize radicchio radicle
                radioactive radiocarbon radiogalaxy radiogram radiograph radiography radiolarian
                radiologist radiology radioman radiometer radiometry radiophone radioscopy
                radiosonde radium radius radix radome radon raffia raffinose raffishness rafter
                rafting ragamuffin ragbag raggedness ragi raging ragtag ragtime ragweed ragwort
                raider railcard railhead railroader railroading raiment raincloud rainmaker
                rainmaking rainstorm rainwater raised raiser rajah rakishness rale rambler
                rambutan ramie rammer rampancy rampant rancher ranching rancid rancidity
                rancidness rancor rancorous rand randiness randomness rangefinder ranginess
                ranking rankness ransomer ranter ranting rapacious rapacity rapidity rapidness
                rapine rapporteur rapscallion raptness raptor raptorial rapturous rarefaction
                rareness rascality rasher rashness raspberry raster rasterize ratafia ratan
                ratatouille ratbag rated ratel ratepayer rater rath rathskeller ratified
                ratifier rating ratiocinate rationale rationalism rationalist rationality
                rationalize ratite rattlebox rattlebrain rattler rattlesnake rattletrap
                raucousness raunchiness rauwolfia ravager ravages ravisher ravishing ravishment
                rawhide rawness rayon razorback razorbill razzmatazz reachable reached react
                reactance reactionary readability readable readership readily readiness realgar
                realism realistic realizable realization realized realness realpolitik realty
                reamer reaper reappraise rearguard rearward reasonably reasoning reassume
                reassuring rebato rebel rebellion rebellious rebid rebirth rebuking rebutter
                recalibrate recantation recce receivables received receiver recency recentness
                receptacle reception receptive receptivity recessional recharge recidivism
                recidivist recipient reciprocal reciprocate reciprocity recitalist recitative
                reckoning reclaimed reclamation recliner recognition recognize recognized
                recommended recompense recompensed recompile recon reconciled recondite
                reconnoiter reconstruct recorded recorder recording recordist recourse
                recoverable recriminate recrudesce recruiter recruitment rectal rectangle
                rectifier rectilinear rectitude recumbent recuperate recur recurrence recursion
                recusal recusancy recusant recyclable recycling redaction redbreast redbud
                redbug redcurrant reddish redeemable redeemed redemption redisplay redistrict
                redlining redness redo redolence redolent redpoll redroot redshank redshift
                redstart reduced reducer reductase reduction redundancy redundant reduplicate
                redwing redye reed reedbird reediness reefer reeve refection refectory refer
                referendum referential refined refinement refiner refinery reflectance reflected
                reflecting reflection reflective reflector reflexivity reflow reformat
                reformatory reformed reformist refractive refractor refractory refreshed
                refresher refreshing refreshment refrigerant refrigerate refulgence refulgent
                refund refutation refuter regalement regalia regarded regardful regardless
                regards regeneracy regex regexp reggae regimental regimented regional
                regionalism registered registrant registrar regression regressive regretful
                regularity regularize regulated regulation regulator regulatory regurgitate
                rehearsal rehearsed reimport reindeer reinfuse reinstall reiterate rejection
                rejoicing rejoinder rejuvenate relatedness relater relation relational
                relativism relativist relativity relativize relaxation relaxer relay release
                released relentless relevance relevancy relevant reliability reliably reliance
                reliant reliever religionist religiosity relinquish reliquary reluctance
                reluctant reluctivity remark remarkably remarked remembered remembrance reminder
                reminiscent remissness remit remittal remittance remitting remodify remonstrant
                remonstrate remora remorse remorseful remorseless remoteness removable removed
                remunerate remunerated remunerator renaissance renascence rendering rendezvous
                rendition reneger renewed rennet rennin renotify renovation renovator rented
                renter rentier repaid repairer repairman reparation reparations repartee
                repatriate repealed repeatable repeated repeater repeating repel repelling
                repentance repentant repenting repertoire repertory repetition repetitious
                repetitive repine repleteness repletion replication replicator reportage
                reported reposeful repository repp represented repressed repression repressive
                reproachful reproaching reprobate reproval reprove reproved reproving reptilian
                repudiation repudiator repugnance repugnant repulsion repulsive repurchase
                reputably reputation reputed requiescat requirement requisition requital
                requiter reredos rescission rescript rescuer reseau resect reseda resegregate
                resend resentful resentment reserpine reservation reservist reservoir reshow
                reside residence residency residential residuum resignation resigned resilience
                resiliency resilient resin resinoid resistance resistant resistive resolvable
                resolve resolved resonance resonant resonator resorcinol resorption resounding
                resourceful respectful respective respiration respirator resplendent respondent
                responsible responsive restart restaurant restfulness restharrow restitution
                restiveness restoration restorative restorer restrained restraint restricted
                restriction restrictive resultant resumption resurgence resuscitate retainer
                retake retaliation retaliator retardant retardation retarder rete retention
                retentive retentivity reticence reticent reticle reticulate reticule reticulum
                retinol retirement retiring retraction retractor retread retribution retrieval
                retriever retroact retroactive retrograde retrogress retrorocket retrospect
                retrovirus retsina retune returnable returned revalidate revamping revealed
                revealing reveille revelation reveler revenged reverberant reverberate reverent
                reverential reverify revers reversion revetment revilement reviler revisal
                revised reviser revision revisionism revisionist revivalism revivalist revoked
                revolting revolution revolver revulsion rewarded rewarding rhapsodical
                rhapsodize rhenium rheology rhetoric rhetorical rhetorician rheum rheumatic
                rheumatism rhinestone rhinitis rhinoceros rhinoplasty rhinovirus rhizoid
                rhizopod rhodium rhomb rhumb rhymed rhymer rhymester rhyolite rhythmic
                rhythmical riata ribaldry riband ribband ribbing riboflavin ribose ribosome
                ribwort ricebird ricer richness ricketiness rickets rickettsia rickey rickrack
                ricotta rictus riddance rider ridership ridgepole ridiculous riding riel
                riffraff rifleman rifler rifling rigatoni rigging righteous rightism rightness
                rightward rigidness rigmarole rilievo rinderpest ringdove ringer ringhals
                ringing ringleader ringmaster ringside ringtail ringworm rioter rioting ripened
                ripeness riser risibility risible rising riskiness rissole ritualism ritualist
                rivaled riverbank riverboat riverside riveter riveting riviera roadhouse
                roadrunner roadstead roamer roaming roarer roaring roaster roasting roble
                robotic robotics robustness rocaille rocambole rockabilly rocker rockery
                rocketry rockiness rockrose rockweed rococo rodomontade rogation rogatory
                roguery roguishness roisterer rolled roller rollerskate rollicking rollmop roman
                romance romancer romanticism romanticist romanticize romper rondel roofer
                roofing rooftree roomer roominess rooster rooter rootless rootstock ropedancer
                roper ropeway rorqual rosebay rosemary rosewater rosiness rosinweed rota
                rotation rotator rote rotenone rotgut rotifer rotisserie rotl rotogravure
                rototiller rottenness rotter rottweiler rotundity rotundness roughage roughcast
                roughhouse roughness roughrider roulette roundabout rounded roundel roundelay
                roundhouse roundness roundworm roustabout router rover rowan rowdiness rowdyism
                rower rowing rowlock royalties rubberneck rubbery rubbing rubble rubella rubeola
                rubidium ruction rudder rudderpost ruddiness rudeness ruefulness ruffianism
                ruffled ruggedness rugger ruination ruinous ruling rumbling rumbustious
                rumination ruminative rummer rummy rumormonger rumrunner runaround rundle
                running rupiah rural rusher rustication rusticity rustiness rustler ruthenium
                rutile sabayon sabbath sabbatical sabin saccharide saccharin saccharose saccule
                sackbut sackcloth sacker sacking sacrament sacramental sacredness sacrificial
                sacrilege sacristan sacroiliac sacrosanct sacrum saddleback saddlebag saddlebow
                saddler saddlery sadhu sadism sadness safari safecracker safekeeping safeness
                safflower sagacious sagacity sagebrush sago sahuaro said saiga sailboarder
                sailcloth sailing sailplane sainfoin sainthood saintliness salability salable
                salacious salacity salamander saleratus saleroom salesclerk salesgirl saleslady
                salesman salespeople salesperson salesroom saleswoman salicylate salience
                saliency salientian salinity salinometer saliva salivation sallet sallowness
                salmagundi salmi salmon salmonberry salmonella salol salon salpa salpingitis
                salpinx salsa salsify saltcellar salted saltiness saltpeter saltshaker saltwater
                saltwort salubrious salubrity salutary salutation salvation salver salvia
                samarium samarskite sambar sameness samiel samizdat samosa samphire sampler
                sampling sanatorium sanctimony sanctioned sanctity sanctuary sandalwood sandarac
                sandbagger sandblaster sandcastle sander sandfly sandglass sandiness sandlotter
                sandman sandpiper sandpit sandstone sandstorm saneness sangfroid sangria
                sanguineous sanguinity sanitarian sanitarium sanitation sapidity sapience
                sapient sapodilla saponin sapota sapper sapphic sapphirine sapphism sappiness
                saprolite saprophyte sapsago sapsucker sapwood saraband saran sarcophagus sard
                sardius sardonyx sargasso sargassum sarnie sartor sartorial saskatoon sassaby
                sassafras satang satanical satanism sateen satiable satiation satiety satinwood
                satirical satisfiable satisfied satisfying satori satsuma saturation saturnalia
                saturniid saturnine satyriasis saucer sauciness sauerbraten sauerkraut saurel
                saurischian saury savageness savarin saved saveloy saver saving savings savorily
                savoriness sawbones sawdust saxhorn saxifrage saxophone saxophonist saying
                sayonara scabbiness scabies scabious scaffolding scag scalage scalar scaled
                scaliness scalper scammer scammony scampi scandalize scandalous scandium
                scanning scansion scantiness scantness scape scapegrace scapula scarabaeid
                scarabaeus scarceness scarecrow scaremonger scariness scarlatina scarlet scarred
                scathed scathing scatology scattering scavenger scenarist scented scheduled
                scheduler scheelite schematic schematize schemer schilling schipperke schismatic
                schist schistosome schizogony schlemiel schlock schmaltz schmaltzy schmear
                schmeer schmo schnapps schnauzer schnitzel schnozzle scholarly scholarship
                schoolbag schoolbook schoolboy schoolchild schooled schoolgirl schoolhouse
                schooling schoolkid schoolmarm schoolmate schoolroom schoolwork schoolyard
                schottische sciatica scientific scientist scilla scintilla scintillate scission
                scissure sclera sclerite scleritis scleroderma sclerometer sclerosis sclerotomy
                scoffer scolding scoliosis scooter scopolamine scorcher scoreboard scorecard
                scorekeeper scoreline scorer scorner scorpaenid scorpaenoid scourer scouting
                scoutmaster scowling scrabbler scram scrambler scrapbook scraper scrapheap
                scrappiness scrapyard scratchcard scratched scratchpad scrawniness screamer
                screaming screed screened screening screenplay screensaver screenshot screwball
                screwdriver screwiness screwworm scribbler scripted scriptural scripture
                scrivener scrod scrofula scrog scrounger scrubland scruffiness scrum scrummage
                scrumptious scrupulous scrutable scrutineer scrutinize sculler sculpin
                sculptress scumble scup scuppernong scurf scurfy scurrility scurrilous scut
                scutcheon scute scuttlebutt scyphozoan seafaring seafood sealskin seaman
                seamanship seamless seamstress seaquake searchable searching searchlight searing
                seasick seasickness seasonably seasonal seasoned seasoning seawater seaworthy
                seborrhea sebum secession seclusion seclusive seconder secondment secrecy
                secretariat secretary secretin secretion secretive sectarian secular secularism
                secularist secularize secundine secured sedateness sedation sedentary sedition
                seditious seducer seduction seductive seductress sedulity sedum seeded seediness
                seedless seedtime seeing seeker seeming seemliness seen seepage seer seersucker
                segfault segmental segmented segno segregated segregation seigneury seigniorage
                seiner seism seismical seismograph seismology seismometer seizin selachian
                seldom selection selective selectivity selectman selectness selenium selfishness
                semantic semantical semanticist semantics semiannual semibreve semicircle
                semicolon semifinal semigloss semimonthly seminal seminarian seminarist semiotic
                semiotician semiotics semipro semiquaver semitrailer semivowel semiweekly
                semolina sempiternal sempstress sender senega senescence seneschal senile
                senility seniority senna sensation sensational senseless sensibility sensible
                sensibly sensitivity sensualism sensualist sensuality sensualize sensualness
                sentential sententious sentience sentiency sentiment sentimental separably
                separation separatism separatist separator separatrix sepia sepsis sept
                septennial septicemia septillion septum sepulchral sepulture sequacious
                sequencing sequential sequestrate seraph seraphical serendipity sereneness
                serenity serfdom serge serialism sericulture seriema series serigraph serigraphy
                serin serine seriousness serjeant serological serologist serology serosa
                serotine serotonin serow serpentine serranid serration serrulate serval servery
                serviceable serviceman serviette servility servitude servomotor sestet setaceous
                setsquare settable setter setting settlement seventeenth seventh seventieth
                severable severalty severance severeness severity sewage sewellel sewerage
                sewing sewn sforzando shabbiness shadberry shadbush shaddock shaded shadiness
                shading shadowiness shadowland shagbark shagginess shah shakable shakedown
                shaken shaker shakiness shako shale shallowness shamanism shambles shamefaced
                shameless shampooer shandy shanny shantung shantytown shaped shapeless
                shapeliness sharecrop shared shareholder sharer shareware sharia sharkskin
                sharpener sharper sharpness shattering shaved shaven shaver shaving shawm sheaf
                shearer shearwater sheatfish sheathing shebeen shedding sheen sheepcote
                sheepfold sheepherder sheepshank sheepshead sheepskin sheepwalk sheerness
                sheeting sheikh sheila shelduck shelf shellacking shellbark shelled shellfire
                sheltered shelving shenanigan shepherdess shes shiatsu shibboleth shielded
                shiftiness shiftless shigella shiksa shillelagh shilling shimmering shindy
                shiner shinguard shininess shinsplints shipboard shipbuilder shipowner shipped
                shipping shipway shipworm shipwright shirker shirring shirtfront shirting
                shirtmaker shirtsleeve shirttail shirtwaist shiva shivaree shivering shmear
                shockable shocker shocking shod shoddiness shoebill shoeblack shoemaker
                shoemaking shoeshine shoestring shofar shogunate shopaholic shopfitter shopfront
                shophar shopkeeper shoplifter shoplifting shopper shopping shoptalk shopwindow
                shorebird shoreline shoring shortbread shortcake shortchange shortcoming
                shortening shortfall shorthorn shortness shortstop shortwave shouter shovelful
                shovelhead showbiz showground showiness showing showman showmanship showpiece
                showplace showstopper shrapnel shrewdness shrift shrillness shrinkage shrinking
                shrubbery shrunk shucks shuddering shun shut shuteye shutterbug shuttlecock
                shyness siamang sickbay sickening sideband sideboard sideburns sidelight sideman
                sidepiece siderite sidesaddle sideslip sidestroke sideward sideway sidewinder
                sienna sierra siesta sifted sifter sighted sighting sightless sightseeing
                sightseer signage signaler signalman signatory signature signboard signed
                significant signorina signory sika silage sild silencer silenus silesia
                silhouette silica silicle silicone silicosis siliqua silique silkiness
                silkscreen silkweed silliness siloxane siltstone silurid silva silverfish
                silverpoint silverside silversmith silverware silverweed silvery similarity
                similitude simony simoom simp simpering simpleness simpleton simplex simplicity
                simulacrum simulation sinapism sincerity sinciput sinfulness singalong singer
                singing singleness singles singlestick singlet singleton singletree singularity
                singularize sinistral sinkable sinker sinuate sinuosity sinuousness sinusitis
                sinusoid sinusoidal sirdar siren sirree sisal siskin sisterhood sisterly situ
                situation sixshooter sixteenth sixtieth sizable sizing sizzling skateboard
                skater skating skeg skep skepful skeptical skepticism skerry sketchbook sketcher
                sketchiness sketchpad skewbald skewness skibob skidpan skier skiffle skiing
                skilled skimpiness skincare skinflint skink skinner skinniness skipjack skirret
                skua skulduggery skulker skydiver skydiving skyjacker skyjacking skysail
                skyscraper skyward skywriter skywriting slacker slackness slacks slagheap
                slanderer slanderous slanginess slanting slapstick slasher slavishness slaw
                slayer slaying sleazebag sleazeball sleaziness sleekness sleeper sleepiness
                sleepless sleepover sleepwalker sleepwear sleepyhead slenderize slenderness
                sleuthhound sliced slicer slicker slickness slider slideshow slighting
                slightness sliminess slimmer slimming slimness slingback slingshot slipcover
                slipover slipperwort slipstream slipup slivovitz sloppiness slops sloth sloucher
                slowcoach slowness slowworm slub sludge slugabed sluggardly sluiceway
                slumgullion slung slurry slush slushiness slyness smacker smallholder smallness
                smallpox smalltime smaltite smarm smarminess smartness smartphone smarts
                smartwatch smartypants smasher smattering smegma smelliness smelter smeltery
                smew smilax smirking smith smithereens smocking smokehouse smoker smokescreen
                smokestack smokiness smoking smoldering smoothness smorgasbord smuggler
                smuggling smugness smurf smuttiness snakebird snakebite snakeroot snapdragon
                snapped snappiness snapping snark snarling snatcher sneaker sneakiness sneaking
                sneering snickering sniffer sniper snips sniveler sniveling snobbery snog snook
                snooper snootiness snorer snorkeler snorkeling snorter snottiness snowberry
                snowblower snowboarder snowdrift snowfield snowflake snowiness snowman
                snowmobile snowstorm snuffer snuggery snugness soakage soaking soapberry
                soapiness soapstone soapsuds soapwort soaring soberness sobriquet socage soccer
                sociability sociably socialism socialist socialite sociality sociologist
                sociology sociometry sociopath socle sodalite sodality sodium sofa sofar
                softener softhearted softness software sogginess soiled soilure sojourner solan
                solarium solderer soldierly soldiery solemness solemnity solemnness solferino
                solicited solicitor solicitous solicitude solidarity solidity solidness solidus
                soliloquize soliloquy solipsism solipsist solitaire solleret solmization solo
                solon solubility solubilize solubly solved soma somatotype somberness sombrero
                somersault something sometime someway somewhat somite sommelier somnolence
                somnolent sone songstress songwriter sonic sonneteer soot soother soothing
                soothsayer soothsaying sootiness sophism sophistical sophistry sophomore
                soporific sorceress sorcery sordidness sordine soreness sorghum sorgo sorriness
                sorrowful sorted sortition sottish soubrette sought souk soulfulness soundalike
                soundbar soundbite soundboard soundcheck sounder sounding soundless soundness
                soundproof soundscape soundtrack soupspoon sourball sourdough sourness soursop
                sourwood sousaphone soutache soutane southeaster southerly southerner southland
                southwester sovereignty sovietism sower sown soymilk spacecraft spaceflight
                spaceman spaceport spacer spaceship spacesuit spacewoman spaciness spacing
                spadework spadix spaghetti spambot spandex spandrel spanned spanning spareness
                sparerib spareribs sparge sparid sparkler sparkling sparrowhawk sparseness
                sparsity spasticity spatial speakable speakeasy speaker spearmint specialism
                specialist specialize specialized specialty speciation species specificity
                specified specs spectacles spectacular spectator spectral spectrogram spectrum
                speculation speculative speculator speculum speechless speechmaker speedboat
                speeder speediness speeding speedometer speedster speedwell speleology
                spellbinder spellcheck spelldown speller spelling spelunker spelunking spence
                spender spending spendthrift spent spermaceti spermatid spermicide spermophile
                spewer sphalerite spherical sphericity spherule sphincter spiceberry spicebush
                spiciness spiderweb spiderwort spikelet spikenard spikiness spile spillover
                spinach spindrift spinel spineless spinnaker spinneret spinney spinning spirant
                spirited spiritualty spirochete spirogyra spirula spittle spittlebug spitz spiv
                splashboard splashdown splashiness splayfoot spleenwort splendent splenectomy
                splicer spliff splitter splitting splodge spodumene spoilage spoiled spoilsport
                spoken spokeshave spokesman spokeswoman spoliation spondee spondylitis sponger
                sponginess sponsorship spontaneity spontaneous spookiness spoonbill spoondrift
                spoonerism spoonfeed sporocarp sporophore sporophyll sporophyte sporozoite
                sporran sportiness sporting sportscast sportsman sportswear sportswoman spotted
                spottiness sprag spreader spreadsheet springboard springbok springiness
                springtail springtime sprinkler sprinkling sprinter sprit spritsail spritzer
                sprog spruceness sprue sprung spryness spumoni spurge spurry sputum spymaster
                spyware squabbler squalidness squalor squareness squatness squawker squeaker
                squeakiness squealer squeamish squeezebox squeezer squill squirearchy stabile
                stability stabilizer stableboy stableman stablemate stably staffing stagecoach
                stagecraft stagehand stagflation staggering staghound staginess staging
                stagnancy stagnant stagnation staidness stained stainless staircase stairhead
                stairwell stakeholder stalactite stalagmite staleness stalker stalking
                stallholder stamina stammel stammerer stammering stamper standardize standby
                stander standing standoffish standpipe standpoint standstill stannite stapes
                staph stapler starboard starburst starchiness stardom stardust starer starflower
                stargazer starkness starlight startling starvation starveling starwort
                statecraft stated statehood statehouse stateless stateliness stateroom statesman
                stateswoman statical stationer stationery statistic statistical stator statuary
                statuette staunchness staysail steadfast steadily steadiness steakhouse stealth
                steamboat steamer steamfitter steaminess steamroller steamship stearin steatite
                steeliness steelmaker steelworker steelworks steelyard steenbok steeplejack
                steepness steerage steerageway steering steersman stegosaur stegosaurus steinbok
                stela stele stellate stemware steno stenograph stenography stentor stepbrother
                stepchild stepfather stephanotis stepladder stepmother stepparent stepper
                stepsister steradian stereoscope stereoscopy stereotype sterile sterility
                sterilized sterilizer sterling sternness sternpost sterol stertor stertorous
                stet stethoscope stevedore stewardess stewardship stewpan stibnite sticker
                stickiness stickleback stickler sticktight stiffener stiffening stiffness
                stifling stigmatism stigmatize stilbestrol stillbirth stillness stimulant
                stimulated stimulation stimulus stinger stinginess stinker stinkhorn stinkpot
                stinkweed stipe stipendiary stippling stipulation stirk stirred stitcher
                stitchery stitching stockbroker stockholder stockiness stockinette stockist
                stockjobber stockroom stocktaking stockyard stodge stodginess stoical stoicism
                stokehold stokehole stoker stolidity stolidness stoma stomachache stomacher
                stomatitis stonechat stonecrop stonecutter stonefly stonemason stoner stoneware
                stonework stonewort stoniness stoplight stoppable stopped stopping stopwatch
                storage storax storefront storehouse storekeeper storeroom storminess storyboard
                storybook storyteller stoutness stovepipe stowage strabismus straddler straggler
                straighten strained strake strangeness stranger strangulate straphanger
                strapless strapped strapper strapping stratagem strategic strategical strategics
                strategist stratum stratus strawberry strawboard strawflower strawworm streaker
                streambed streamer streamlet streamline streetcar streetlamp streetlight
                strength strengthen strenuous strep stressed stressful stressor stria striation
                strick striction strictness stridence stridency strident stridor stridulate
                strife strikeout striker striking stringency stringent stringiness striped
                stripling striptease stripteaser strobile stroboscope stroller strongbox
                stronghold strongman strongroom strontium structural structured struma strutting
                strychnine stubbiness stubble studding studentship studhorse studied studier
                stuffiness stuffing stumbler stumbling stun stunner stunning stupefying
                stupendous stupidity sturdiness stutterer stuttering stylet stylishness
                stylistic stylite stypsis styrax styrene suasive suaveness suavity subaltern
                subapical subbasement subbranch subcategory subclass subclassify subcompact
                subcontract subculture subdivision subdomain subdominant subduct subdued
                subeditor subfamily subfloor subheading subjection subjective subjugation
                subjunction subjunctive subkingdom sublethal sublimation subliminal sublimity
                submariner submediant submergence submersible submersion submission submissive
                submitted submitter submitting subordinate subornation subprogram subrogate
                subroutine subscriber subscript subsection subsequence subsequent subservient
                subshrub subsidence subsidiary subsidized subsidizer subsistence subsoil
                subspace subspecies substance substantial substantive substation substitute
                substrate substratum subsumption subsurface subsystem subtenancy subtenant
                subterfuge subtly subtonic subtraction subtrahend subtreasury subtropic
                subtropics subtype subunit suburbanite suburbanize suburbia subvention
                subversion subversive successful succession successive successor succory
                succotash succubus succulence succulency succussion suckling sucre sucrose
                suddenness sudor suds suede suet sufferable sufferably sufferance sufferer
                suffering sufficiency sufficient suffixation suffocating suffocation suffragan
                suffragette suffragist suffusion sugarcane sugariness sugarplum suggestion
                suggestive suitability suitably suited suiting sukiyaki sulfa sulfonamide
                sulfonate sulfurize sulkiness sullenness sullied sultanate sultriness sumac
                summat summerhouse summertime summitry summoner sumo sumpter sumptuous sunbather
                sunbathing sunbed sunbonnet sundeck sundew sundog sundress sundries sundry
                sunflower sung sunglass sunglasses sunhat sunk sunlight sunniness sunroom
                sunscreen sunshine sunstone sunstroke sunsuit suntrap sunup superable superbug
                supercargo supercharge supercity superclass supercool superfamily superficial
                superfluity superfluous supergiant supergrass superheat superhero superhuman
                superimpose superintend superiority superlative superman supermarket supermodel
                supernal supernatant supernova superorder superphylum superpower superscribe
                superscript supersedure supersonic superstar superstate superstore supertanker
                supertax supertonic superuser supervised supervision supervisor superwoman
                supper supplejack supplement suppleness supplicant supplicate supplier
                supportable supported supporter supportive supposal supposed supposition
                suppository suppressant suppressed suppression suppressor suppuration
                supremacist supremacy supremo sura surcingle surd sureness surfaced surfactant
                surfbird surfboat surfer surficial surfing surgical suricate surliness surmullet
                surpassable surpassed surpassing surplusage surprint surprised surprising
                surreal surrealism surrealist surrebuttal surrebutter surrogacy surrogate
                surrounding surtitle surveil surveying survivalist susceptible sushi suslik
                suspected suspender suspension suspensor suspicion suspicious sustainable
                sustained sustainment sustenance suttee suzerainty swage swallowtail swampland
                swankiness swansong swapper swarthiness swathe swayed swearer swearword
                sweatband sweatbox sweatpants sweats sweatshirt sweatshop sweatsuit sweeper
                sweepings sweepstakes sweetbread sweetbrier sweetened sweetener sweetening
                sweetheart sweetmeat sweetness sweetsop swelling sweltering swiftlet swiftness
                swindler swineherd swinge swinger swingletree switchback switchblade switchboard
                switcher switcheroo swordfish swordplay swordsman swordtail swot syconium
                sycophancy sycophant syllabary syllabicate syllabicity syllabub syllogism sylph
                sylvanite sylvite symbiosis symbolic symbolical symbolism symbolist symmetrical
                symmetrize sympathetic sympathies sympathize sympathizer symphonist symploce
                symposium synagogue synchromesh synchronism synchronize synchronous synchrony
                synchrotron syncopation syncope syncretize syncytium syndic syndicalism
                syndicalist syndication synecdoche synergism synergist synesthesia synodical
                synonymity synonymous synonymy synopsis synoptical synovia synovitis syntactic
                syntactical synthesis synthesize synthesizer synthetic synthetical syphilis
                syphilitic syringa syrinx sysadmin sysop systematic systematize syzygy tabard
                tabbouleh tabernacle tabla tablature tableau tablecloth tableland tablespoon
                tableware taboret tabular tabulation tabulator tach tacheometer tachometer
                tachycardia tachyon tacitness taciturn taciturnity tacker tackiness tackler
                taconite tactfulness tactical tactician tactile tactility taffeta tagged
                tagmemic tailboard tailbone tailgater taillight tailorbird tailoring tailpiece
                tailrace tailstock tainted taipan taka takeaway taken takin takings tala
                talapoin talc talcum talebearer talented talkative talker tallier tallness
                tamandua tamarau tamarin tamarisk tambac tambala tambour tambourine tamed
                tameness tamer tammy tamperer tanbark tandoori tangency tangential tangerine
                tangibility tangibly tanginess tangram tanka tankage tanker tanned tanning tansy
                tantalite tantalizer tantalizing tantalum tantra tapering taphouse tapioca tapis
                tapped tapping tapster taradiddle tarantella tarantula tarball tarboosh
                tardigrade tardiness tarnished tarpan tarpaulin tarradiddle tarriance tarsia
                tarsus tartlet tartness tartrate tarweed taskmaster tass tasset tasted tasteless
                taster tastiness tasting tater tatouay tatting tattler tattletale tattooer
                tattooist taunter taunting taupe tautness tautog tautologous tautology taverna
                tawdriness tawniness taxation taxed taxer taxidermist taxidermy taximeter taxing
                taxiway taxon taxonomist tayra teabag teaberry teacart teachable teacupful
                teahouse teakettle teakwood teamwork tearaway tearjerker teaser teashop teasing
                teaspoonful teatime tech technetium technic technical technician technique
                technocracy technocrat technology technophobe tectonic tectonics tediousness
                tedium teeming teenager teenybopper teeterboard teething teetotaler teetotalism
                teetotum telecaster telecommute telegrapher telegraphy telekinesis telemeter
                telemetry teleology teleost telepathist telepathy telephoner telephonist
                telephony telephoto teleprinter teletype television teleworker telfer telling
                tellurian telluride tellurium telophase telpher telpherage temerity temperament
                temperance temperature tempered tempestuous template tempo temporal temporarily
                temporizer temptation tempted tempter tempting temptress tempura tenability
                tenableness tenacious tenacity tenanted tenantry tench tendance tended
                tendentious tenderfoot tenderizer tenderloin tenderness tendinitis tenia tennis
                tenno tenpins tenrec tenseness tensible tensimeter tensiometer tensional tensor
                tentative tenter tenterhook tenuity tenuousness tepidity tepidness terahertz
                terajoule terapixel teratogen teratology terawatt terbium terce tercel tercet
                teredo teriyaki termagant terminable terminated termination terminator
                terminology terminus ternion terpene terracotta terraform terrarium terrestrial
                terrible terrier terrifying terrine territorial terrycloth terseness tertiary
                terzetto tesla tesselate tessellate testable testament testate testatrix testbed
                tested testee testifier testimonial testimony testiness testis testudo tetanus
                tetherball tethered tetracaine tetrad tetragon tetragram tetrahedron tetralogy
                tetrameter tetrapod tetraspore tetrode textualism textualist textural thalamus
                thalidomide thallium thallophyte thallus thalweg thankless that thatcher
                thatching theatergoer theatrical theatricals theatrics thebe thee their theism
                then theocracy theodolite theologian theological theoretic theoretical
                theosophist theosophy therapeutic therapsid there thereabout thermel thermionic
                thermistor thermometer thermometry thermophile thermopile thermostat theropod
                thesaurus these thesis theurgy thiamine thiazine thickener thickening thickhead
                thickheaded thickness thicko thief thievery thieving thievish thigh thighbone
                thill thimbleful thimblerig thimbleweed thimerosal thing thingamabob thingamajig
                thingumabob thingumajig thingummy thingy thinkable thinker thinness thiouracil
                thirstiness thirteenth thirtieth thistledown tholepin thorite thorium thorniness
                thoughtful thoughtless thousandth thralldom thrasher thrashing threader
                threadfin threatening threepence threescore threesome threonine thresher
                threshold thriftiness thriller thrilling thrips throatiness throbbing
                thrombocyte thrombosis thrombus throstle throttler throughput throwaway
                throwback thrower thuggee thuggery thulium thumbnail thumbprint thumbstall
                thumbtack thumping thunderbolt thunderclap thunderer thunderhead thunderous
                thunk thurible thurifer thus thwacker thylacine thyme thymine thymol thyristor
                thyroxine tibia tical ticker ticking tickler ticktacktoe tidal tiddler
                tiddlywink tiddlywinks tidemark tidewater tidily tidings tiebreaker tiepin
                tierce tiercel tiffin tightener tightness tightrope tights tigon tiler tiling
                tillage tilled tiltyard timbale timberland timberline timbre time timecard
                timekeeper timekeeping timeliness timepiece timer timescale timeserver
                timeserving timeshare timework timezone timidity timidness timing timothy
                timpani timpanist tinamou tinder tinderbox tinea tineid tinfoil tinged tingling
                tininess tinkerer tinniness tinnitus tinplate tinsmith tinware tippler tipsiness
                tipstaff tiredness tisane titania titanium titch tither titi titian titillating
                titillation titivation titlark titled titleholder titmouse titty toadflax
                toadstool toadyism toaster toastmaster tobacconist tobogganer tobogganing
                tobogganist toccata tocology tocopherol toddler tody toea toeclip toerag toff
                tofu together togs toiler toilette tokenism tolbutamide tole tolerable tolerably
                tolerance toleration tollbooth tollhouse tolu toluene tombac tombola tombstone
                tomfool tomfoolery tommyrot tomography tonal toneless tonicity tonight
                tonsillitis tontine tonus took toolmaker tooter toothache toothbrush toothpaste
                toothpick toothsome toothwort tootsy topdressing tope topee topgallant topiary
                topical topicality topminnow topographer topography topological topologist
                topology toponym topsoil topspin torchbearer torchlight torero toreutic
                tormenting tormentor torpid torpidity torpor torr torridity torridness torsion
                torsional torsk tortellini torticollis tortoni tortricid tortuosity torturous
                tosh totalizator totalizer totemism totterer touchback touchdown touched
                touchiness touching touchline touchpaper touchscreen touchstone touchwood
                toughener toughness touraco tourer tourism tourmaline tournament tourniquet
                towage towelette toweling towering townee townhouse townsfolk townsman
                townspeople townswoman towpath toxemia toxic toxicology toyboy traceable tracer
                trachea tracheid tracheitis tracheotomy trachoma tracing trackball tracker
                tracksuit trackway tractable tractably trader tradesman tradeswoman trading
                tradition traditional traducement traducer trafficator trafficker trafficking
                tragedian tragedienne tragical tragicomedy tragopan trailblazer trailer
                trainbearer trained trainload trainman traitorous trajectory tramcar tramline
                trammeled tramontane tramper trampler trampoline tramway tranche tranquility
                tranquilize trans transaction transactor transceiver transcribe transcriber
                transcript transducer transferal transferee transfigure transformed transformer
                transfusion transgress tranship transience transiency transistor transition
                transitive transitory translated translation translator translocate translucent
                transmittal transmitted transmitter transparent transplant transponder
                transporter transputer transship transudate transverse trapezium trapezoid
                trapping trappings trashiness traumatize trave traveled traveler traveling
                travelogue traversal traversed trawler treacherous treachery treacle treadmill
                treasurer treatable treated treatment treehopper treenail treillage trematode
                trembling tremendous tremolite tremulous trenail trenchancy trenchant
                trencherman trendiness trendsetter trepan trepang trepidation treponema
                trespasser trestlework triangular triangulate triathlete triathlon tribal
                tribalism tribesman tribeswoman tribulation tribuneship tributary tribute trice
                triceratops trichina trichinosis trichloride trichomonad trichroism trickery
                trickiness trickster tricorn tricorne tricot tricyclic tried triffid trifler
                trifling trifocal trifocals trig trigeminal trigon trigram trilateral trillionth
                trillium trilobite trimester trimmed trimmings trimness trine triode trioxide
                tripalmitin tripartite tripe triphammer tripletail triplicate tripos triptych
                tripwire trisection trisyllable tritanopia triteness tritium triton triturate
                triumphant triumvirate trivia trivial triviality trivialize trivium troche
                trochlear troglodyte trogon trolleybus trombonist tron trooper troopship
                trophozoite tropical tropics tropopause troposphere troth troubadour troubled
                troublesome trough trouncer trouper trousers trousseau troy truancy trucker
                trucking truckload truculence truculency truculent trueness trug truly trumpery
                trumpeter truncation truncheon trundler trunnel trunnion trusteeship trustiness
                trusting trustworthy truther truths trying tryptophan tuatara tubate tubbiness
                tubeless tuber tuberculin tuberose tuberosity tubing tufter tughrik tugrik
                tuitional tularemia tulipwood tulle tumblebug tumbler tumbleweed tumbling
                tumescence tumescent tumid tumidity tumultuous tumulus tunefulness tuner
                tungstate tungsten tunicate tunnage tunneler tupelo tuple tuppence turaco
                turbidity turbidness turbinal turbinate turbocharge turboprop turbulence
                turbulent turducken turgidity turgidness turgor turnabout turnaround turnbuckle
                turndown turned turnery turnspit turnstile turnstone turntable turpentine
                turpitude turquoise turtledove turtleneck tussore tutelage tutored tutorship
                twaddler twain twayblade tweediness tweeds tweezers twelfth twelvemonth
                twentieth twinberry twiner twinflower twinkling twinset twirler tympan tympani
                tympanist typescript typeset typesetter typesetting typewriter typewriting
                typhoid typhus typicality typing typographer typography typological tyrannical
                tyrannicide tyrannosaur tyrannous tyrocidine tyrosine tyrothricin ubiety
                ubiquitous ubiquity ufologist ufology ugliness uintathere ulceration ullage ulna
                ultimacy ultimatum ultralight ultramarine ultrasonic ultrasound ultraviolet
                ululation umber umbilicate umbilicus umbrage umpteen unabridged unalloyed
                unanimity unanimous unassuming unavailing unaware unbelieving unbending unbiased
                unblinking unbosom unbound unbridle uncanny uncap unceasing unchaste unchurch
                uncial uncleanly unclench unclose unconcern unconnected unconscious uncross
                uncrown undaunted undeceive undecided underage underbelly underbid underbody
                underbrush undercharge underclass underdress underexpose underfeed underfund
                underfur undergo undergrad underground undergrowth underhanded underlie
                underling underneath underpants underpart underpass underpin underquote
                underscore undersea undersell undershirt undershoot undershorts underside
                undersigned underskirt underspend understand understate understudy undertaker
                undertaking underthings undertone undervalue underwear underweight underwhelm
                underwing underwire underwood underworld underwrite underwriter undesirable
                undine undisguised undoubted undulation unease unemployed unerring uneven
                unexpected unfading unfailing unfamiliar unfeeling unfitting unflagging
                unflinching unfortunate unfriendly unglue ungodly ungraceful unground
                unguiculate unhallow unhandy unhappy unhealthy unhouse unicyclist unification
                uniformity uniformness unilateral uninhibited uninspiring unionism uniqueness
                unison university unkemptness unkind unkindly unknowable unleaded unlikely
                unlink unload unmanly unmannered unmitigated unmusical unmuzzle unnerving
                unnilhexium unoffensive unofficial unornament unpeople unpin unprepared
                unqualified unread unready unrelenting unrelieved unremitting unrepair
                unrequited unresisting unrest unripe unruliness unsafe unsaturate unsavory
                unseeing unseemly unseen unsettling unsightly unsocial unstable unstick
                unstinting unswerving unteach unthinking untimely untiring untouchable untoward
                untruth unusual unvoice unwary unwelcome unwish unwitting unwonted unworthy
                unwound upbringing upcast upcountry upholder upholsterer upholstery upkeep
                uppercase uppishness uprightness uprising uproarious uprooted upstate upthrow
                uptown upwell uracil uraninite uranyl urbanity urbanology urea urethane urethra
                urethritis urgency urgent urial urinalysis urination urologist urology uropygium
                urticaria urus usability usably usance used usefulness uselessness usherette
                usualness usurpation usurper uterus utile utilitarian utilization utilized
                utmost utricle utterable utterance uttered uttermost uvea uveitis uvulitis
                vacant vacationer vacationist vaccination vaccinia vacillation vacillator
                vacuity vacuousness vagabondage vagarious vaginal vagrancy vagueness vainglory
                vale valediction valedictory valentine valerian valiance valiancy valiant valid
                validation validness valine valor valorous valse valuably valuator valued
                valvulitis vambrace vamper vampish vanadate vanadinite vanadium vanda vandalism
                vanillin vanishing vanquished vanquisher vapidity vapidness vapor vaporizer
                vaquero vara variability variably variation varicella varicose varied
                variegation variola variometer variorum various varnished varying vasectomize
                vasectomy vasodilator vassalage vastness vaticinate vaudeville vaulter vaulting
                vaunting veal vedalia veery vegeburger vegetarian vegetation vegetative
                vehemence vehemency vehement velleity vellum velocipede velodrome velum
                velveteen venal venality venation vendee vendue venerable veneration venereal
                venesection vengeance venial venireman venison venom venous ventail venter
                ventilated ventilation ventilator ventral ventricle ventriloquy venturesome
                venturous venule veracious veracity verbosity verdancy verdant verdin veridical
                verifiable verified verite vermicelli vermiculate vermiculite vermifuge
                vermilion vermin vermouth vernacular vernal veronica versatile versatility
                versed versicle versifier verst vertebra vertebrate verticality vertiginous
                vertigo vertu vervain verve vervet vesicant vesicatory vesiculate vespid
                vestigial vesting vestryman vesuvian vesuvianite veterinary vetted vexatious
                viability viator vibes vibraharp vibrancy vibrant vibraphone vibration vibrio
                vicariate vicarious vicarship vicegerent vicereine viceroyalty viceroyship
                vichyssoise viciousness vicissitude victorious videodisc videophone viewership
                viewfinder viewpoint vigilance vigilant vigilante vigilantism vigilantist
                vignettist vigor vileness villager villainage villainess villainous villeinage
                villus vinaigrette vincible vindication vindicator vindictive vinegarroon vinery
                vino vinous violable violation violence violent violincello violinist
                violoncello virago viral virescent virga virginity viridity virility virion
                virologist virology virtu virtual virtuosity virtuoso virulence virulent
                viscacha visceral viscid viscidity viscometer viscose viscosity viscountcy
                viscountess viscounty viscousness viscus visibility visible visibly visional
                visitable visitation visited vista visualizer vita vitalism vitalist vitality
                vitals vitiation viticulture vitiligo vitreous vitric vitrine vitriol vittle
                vittles vituperate vivacious vivacity vividness viviparous vivisection vixenish
                viziership vocabulary vocational vociferate vociferous voiceless voicemail
                voidance voile volatile volatility volatilize volcanism volcanology volition
                volitional volleyball voltmeter volubility voluble voluminous voluntarily
                voluntarism voluptuary voluptuous voluted volva volvulus vomitory voodooism
                voracious voracity vortical vorticella voucher vouge voussoir voyager voyeurism
                vulcanite vulcanology vulgarian vulgarism vulgarity vulgarizer vulnerable
                vulnerably vulvitis wabbit wackiness wadding wader waders wadge waffler wafture
                waged wagerer waggishness wagoner wahoo wailer wailful wailing wainscoting
                wainwright waistband waistcoat waistline waiter waiting waitperson waitstaff
                waiver wakefulness waldo walkabout walker walking wallboard wallflower walloping
                wally waltzer wampum wampumpeag wanderer wandering wanderings wanderlust wangler
                wannabee wanness wanted wantonness warbler warbonnet wardress warfare warfarin
                warily warmed warmer warmhearted warmness warmth warned warpath warrantable
                warranted warrantee warrantor warrigal wartime washbasin washboard washcloth
                washday washed washer washerwoman washhouse washing washstand waspishness
                wastage wastebasket wasteland wastepaper waster watchable watchband watched
                watcher watchmaker watchmaking watchman watchstrap watchtower watchword
                waterbird waterboard waterbuck watercolor watercourse watercraft watercress
                waterfowl waterfront waterhole wateriness waterlily waterline waterloo
                watermelon watermill waterproof waters watershed waterside waterspout waterwheel
                waterworks wattage waveband waveform waveguide wavelength waverer waviness
                waxiness wayfaring waylayer wayleave waywardness wazoo weakener weald
                wealthiness weaned weaponry wearable wearer wearied weariness wearisome wearying
                weathercock weathered weathering weatherize weatherman weaverbird webbing
                webfoot webmaster webmistress webworm wedded wedlock weeder weedkiller weeknight
                weeper weigela weighbridge weighed weighs weighted weightiness weightless
                weirdness weka welder welfare welkin wellington wellness wellspring welly
                welsher wept werewolf westerner westernize wether wetness wetsuit wetware
                whaleboat whalebone whaler whaling whap wharf wharfage wharve whatnot whatsit
                wheatear wheatworm wheedler wheedling wheelbase wheelchair wheelhouse wheelwork
                wheelwright wheeziness whereabout whereabouts wherefore wherewithal whet
                whetstone whey whiffle whiffletree whimpering whimsical whin whinchat whiner
                whingeing whipcord whippletree whipstitch whirligig whirlpool whirlwind
                whirlybird whiskbroom whisperer whist whistler whitebait whiteboard whitefish
                whitefly whitehead whitener whiteness whitening whitetail whitethorn whitethroat
                whitewall whitewater whitewood whiting whitlow whittler whiz whizkid whizzbang
                wholefood wholeness wholesaler wholesome whoopee whooper whop whup wickedness
                wicker wickerwork wickiup wicopy widener wideness widescreen widget widower
                widowhood wielder wigeon wigging wiggler wildcatter wildebeest wilderness
                wildflower wildfowl wildlife wildness wilds wiliness willed willet willfulness
                willies willingness willowware willpower willy wimble windage windbreaker
                windcheater windchill windflower windiness windjammer windowpane windowsill
                windscreen windshield windstorm windsurfer windsurfing windward wineglass
                winegrower winemaker winepress wineskin wingback wingspread winker winking
                winnable winnower winsomeness wintergreen wintertime wiper wired wiretapper
                wiretapping wirework wireworm wiriness wiring wisdom wiseguy wisenheimer wisent
                wisher wishfulness wistfulness witchcraft witchery witchgrass withdrawal
                withering withers withholding within withstand withy witlessness witnessed wits
                witticism wittiness wivern wizardry wizen woadwaxen wobbliness wodge woefulness
                wolfhound wolfish wolfram wolframite wolfsbane wolverine woman womanhood
                womanizer womankind womanlike womanliness womble women womenfolk womenfolks
                wonderful wondering wonderland wonderment woodbine woodblock woodborer
                woodcarver woodcarving woodchuck woodcraft woodcutter woodcutting woodenness
                woodiness woodman woodpecker woodruff woods woodsia woodsiness woodsman
                woodwaxen woodworker woodworking woodworm wooer woofer woolen woolgather
                woolliness wooziness wordage wordiness wordless wordplay workability workable
                workaholic workaround workbag workbasket workbench workfare workforce workhorse
                workhouse workingman workings workmanship workmate workpiece workplace works
                worksheet worksite workspace workstation worktable worktop worldliness worldview
                wormseed wormwood worn worried worrier worriment worrying worrywart worshiper
                worshipful worsted wort worthily worthiness worthless would wows wraith wrangler
                wraparound wrapped wraps wreckage wrecker wrestler wrestling wriggler wringer
                wrinkled wristband wristlet wristwatch write writer writing wrongdoer wrongdoing
                wrongheaded wrongness wrote wryneck wryness wunderkind xanthophyll xref xterm
                xylol yachting yachtsman yachtswoman yammerer yang yardman yardmaster yardstick
                yarmulka yarrow yashmak yataghan yautia yawner yawning yaws yellowbird
                yellowness yellowtail yellowwood yenta yeomanry yest yesterday yesteryear yobbo
                yodeler yore youngster younker your ytterbium yttrium yuan yule yuletide
                zabaglione zaire zamia zaniness zarf zayin zeal zealotry zealousness zebrawood
                zeitgeist zeolite zestfulness zeugma zidovudine zine zinfandel zinger zinkenite
                zipped zipping zirconia zirconium ziti zonal zonate zoning zooid zookeeper
                zoolatry zoological zoologist zoophobia zooplankton zoospore zoril zoster zoysia
                zwieback zydeco zygoma zygotene zymase zymurgy
            ]],
            longas = [[
                aardwolves abbreviation abdominous abirritant abirritate abjuratory abolitionism
                abolitionist abominable abominably abortifacient aboveboard abrasiveness
                absentminded absinthism absoluteness absolutize absorbable absorbance absorptive
                absorptivity absquatulate abstemiousness abstergent abstractedness
                abstractionism abstractionist abstractness abstruseness acanthocephalan
                accelerant acceleration accelerometer accentuation acceptability acceptableness
                accessibility acciaccatura acclimatization acclimatized accommodating
                accommodation accompaniment accompanyist accomplished accomplishment
                accordionist accouchement accountability accouterments accreditation accrescent
                acculturation accumulation accurateness accursedness accusatory acephalous
                acetaldehyde acetaminophen acetometer acetophenetidin acetylcholine achlorhydria
                achondroplasia achromatic acidimeter acknowledged acknowledgment acotyledon
                acquaintance acquiescence acquisitiveness acquitting acrimoniousness acronymous
                acrophobic acroterion acrylamide acrylonitrile actiniform actinology
                actinomycete actinozoan actionable actionably actionless activistic
                actualization acupuncturist adactylous adamantine adaptability adaptivity
                additament additivity addlepated adduceable adenectomy adenocarcinoma
                adenoidectomy adequateness adhesiveness adjudgment adjudication adjuratory
                adjustable administrate administration administrative administrator admirability
                admirableness admissibility admissions admonishment admonitory adorableness
                adrenergic adsorptive advantageous adventitious adventurousness adversaria
                advertisement advisability aerobioses aerobiosis aerodontia aerodynamical
                aerodynamics aeroembolism aerography aeromarine aeromechanic aerophobia
                aeroponics aerosphere aestheticism affectionate affections affenpinscher
                affettuoso affinitive affirmable affordably afforestation afterbrain afterguard
                afterlives aftermaths aftersensation afterthought afteryears agglomeration
                agglutination agglutinogen aggrandizement aggravator aggressiveness agoraphobe
                agreeableness agribusiness agricultural agriculturalist agriculturist
                agrochemical aircrewman airdropped airletters airworthiness alacritous
                albumenize albuminate albuminous alcheringa alderwomen algolagnia alienability
                alimentary alimentation alkaloidal alkylation allargando allegeable allergenic
                alleviator alliaceous alliteration alliterative allocution allographs allomorphs
                allopathic allopatric allophonic allotropic allusiveness almightily almucantar
                alongshore alpestrine alphabetic alphabetical alphabetization alphabetized
                alphabetizer alphameric alphanumerical altazimuth alterative altocumuli
                altogether altostrati altruistic amalgamation amanuenses amateurishness
                ambassadorship ambassadress ambidexter ambidexterity ambidextrous ambitiousness
                amboceptor ambulacrum amelioration amenableness amendatory aminoplast ammoniacal
                amniocentesis amorphousness amortization ampelopsis amphiaster amphibolic
                amphibrach amphictyon amphidiploid amphimacer amphimixes amphimixis amphitheater
                amphoteric amplification amygdalate amygdaline amygdaloid amylaceous amylolyses
                amylolysis anacolutha anadromous anagrammatical anagrammatize analogousness
                analphabetic analyzable anamorphic anaplastic anarthrous anathematize anatropous
                anchoritic anchorperson andalusite androecium androgenic androsterone anecdotage
                anemically anemochore anemograph anemoscope anesthesiology anesthetization
                aneurysmal angelology angiogenic anglepoise animadversion animations
                anisometropia annalistic annihilation announcement annualized annularity
                annunciation anomalousness answerably antebellum antepenultimate anthelmintic
                anthophore anthracene anthracoid anthropological anthropologist anthropology
                anthropometry anthropophagite antiabortionist antibacterial antibiosis
                anticancer anticatalyst anticipant anticipation anticlinal anticoagulant
                anticommunism anticommunist antidepressant antidiarrheal antidromic antifeminism
                antifeminist antigenicity antigorite antiheroes antiheroic antihistamine
                antilogarithm antilogism antimacassar antimasque antimonial antimonous
                antinausea antineutrino antiparticle antiperspirant antipsychotic antipyrine
                antiquarianism antisemite antisemitism antispasmodic antistatic antisyphilitic
                antitheses antithetic antithetical antitrades antitragus antonymous aphoristic
                aphrodisia apiculturist aplacental apocalyptical apocarpous apodeictic
                apologetical apopemptic apoplectic aposematic apostolate apostrophize apothecium
                apotheoses apotropaic apparently appendectomy appendicectomy appendices
                appendicitis apperception applicability applicably appoggiatura apportionment
                appositeness appraisees appreciation appreciative apprehensible apprehension
                apprehensive apprenticeship approachability approachable appropriated
                appropriateness appropriation appropriator approximal approximation appurtenance
                apterygial aquamanile arachnidan arbitrariness arboriculture arboriculturist
                archaeological archaeologist archaeopteryx archaistic archbishopric archdeaconry
                archegonia archerfish archetypal archetypic archimandrite archiplasm
                architectonic architectonics architectural architecture archoplasm arenaceous
                argumentation argumentative argumentum arithmetical arithmetician armipotent
                aromatherapy arrestable arrestment arrhythmic arsenopyrite arteriolar
                articulateness articulation artificiality artilleryman asbestosis ascariases
                ascariasis ascertainment ascogonium asphaltite asphyxiant asphyxiation
                assassination assemblywoman assertions assertiveness assessable asseveration
                assiduousness assignable assimilation associationism assonantal assumptive
                asteriated asthenosphere astigmatic astomatous astonishment astrionics
                astrograph astrologic astrological astromancy astronautical astronautics
                astronavigation astronomic astronomical astrophysicist astrophysics asymmetric
                asymmetrical asymptotic asymptotical asynchronism asynchronous atherosclerosis
                atmospherics atomically atrociousness attainability attainture attentions
                attentiveness attitudinize attorneyship attractiveness attributable attributor
                audaciousness audiocassette audiogenic audiovisuals augmentation auriculate
                auriferous auscultation auspiciousness autecology authenticate authenticated
                authentication authenticator authenticity authoritarian authoritative
                authorization autobiographer autobiography autochthon autocratic autocratical
                autogenous autographical autographs autography autoimmune autoimmunity
                automorphism automotive autonomist autosuggestion autotrophs auxochrome
                availability avariciousness aviatrices aviculture avitaminosis avunculate
                axinomancy ayatollahs azidothymidine azobenzene baccalaureate bacchanalian
                bachelorhood backbitten backblocks backcloths backgrounder backlogged
                backscratcher backscratching backslapping backstabber backwardness backwoodsman
                bacteriological bacteriologist bacteriology bacteriophage bacteriostat
                baculiform baldachino ballflower balneology banderillero bandwidths bantamweight
                barbarianism barbarization barbarousness barbellate barehanded bareheaded
                barelegged bargeboard barhopping barkentine barographs barometric barometrical
                baronetage baronetess barrelhead barycenter basaltware baseburner basidiomycete
                basidiospore bastardization batholiths bathometer battleground beachfront
                beatification beauteousness beautification beaverette bedazzlement bedwetting
                beforehand beforetime befuddlement behindhand believability belittlement
                belletrism belligerence belligerency belowdecks benedicite benefactress
                bequeathal bestirring bestraddle bestridden bewilderment biannulate biblicists
                bibliofilm bibliogony bibliographer bibliographical bibliography bibliology
                bibliopegy bibliotaph bicameralism bicapsular bicentennial bidirectional
                bigheartedness bijouterie bilingualism billingsgate billionths bimestrial
                bimodality binational binucleate biocellate biochemistry bioclimatology
                biodiversity bioecology bioethical biogeneses biogenesis biogenetic biogeography
                biographic biographical bioluminescence biomedical bionically biophysicist
                bioremediation bioreserve biospheric biostatics biotechnology biparietal
                bipartisan bipartisanship bipedalism bipetalous biquadrate birdtables
                birefringence bismuthous bissextile bitterling bituminous bivouacked bizarrerie
                blabbermouth blackcurrant blacklight bladdernut blamelessness blameworthiness
                blandishment blanquette blastocyst blastosphere blatherskite blindstory
                blissfulness blockbusting bloodbaths bloodlessness bloodletting bloodsport
                bloodstain bloodsucker bloodthirsty bluestocking bluetongue blusterous
                boardgames boardinghouse boastfulness bobbysocks bobsledded bobsleighs
                bodybuilding bogtrotter boisterousness bondswoman bondswomen boosterism
                bootlegged borosilicate bothersome botryoidal bottomless bottommost
                bougainvillea bouillabaisse boundlessness bounteousness bountifulness
                bourgeoisify boustrophedon bowdlerism bowdlerization brachiator brachylogy
                brackishness bradytelic brainchildren brainstorming brainwashing branchless
                branchlike bravissimo breakthrough breastfeed breaststroke breathlessness
                breathtaking breezeless brevetting brewmaster bridlewise brightwork brilliantine
                brinkmanship broadcasting brokenhearted bronchitic bronchoscope broncobuster
                brontosaurus brotherliness brownfield brusquerie brutalization bubonocele
                buccinator buffoonish bulldogged bullfighting bullheadedness bumbailiff
                bumptiousness burdensome bureaucratize bushhammer bushranger businessperson
                businesswoman butterfingers butterfish butterscotch buttonball byssinosis
                cabalistic cabinetmaker cabinetmaking cacciatore cacogenics calamander
                calamondin calaverite calcareous calceiform calcification caliginous
                calisthenics calligrapher calligraphist calumniation camerawork camerlengo
                campanologist campestral canaliculi canalization cancellation candlefish
                candyfloss cannibalization canonicate canonicity canonization cantankerous
                cantatrice capaciousness capacities capacitive capercaillie capitalization
                capitulary capitulation capitulatory capreolate capriciousness captiousness
                carbohydrate carbolated carbonades carbonization carcinogenic carcinogenicity
                cardialgia cardinalship cardiography cardiologist carefuller caregiving
                carelessness caricaturist carmagnole carnassial carnivorousness carpetbagger
                carpophore cartographer cartographical cartomancy cartoonish caruncular
                caseinogen castellany catabolite cataclinal catalectic catamnesis catarrhine
                catchpenny catechetical categorization catholicon catnapping catoptrics
                caulescent cauterization cautionary cautiousness cavalrymen cavitation
                ceaselessness ceilometer cellarette cellobiose censoriousness centigrade
                centillion centipoise centistere centralism centralist centralization
                cephalochordate cerebellar cerebritis cerecloths ceremoniousness cerography
                certification certitudes ceruminous chainplate chairborne chairmanship
                chairwomen chalcopyrite chalkstone chalybeate champignon championship
                chancellorship changeability changeableness channelization chaparajos chapfallen
                chaplainship characteristic characterize charactery charismata charitableness
                charlatanism chartulary chastisement chatoyance chatoyancy chaudfroid chautauqua
                checkerberry checkerbloom checkerboard cheerfulness cheerlessness cheeseburger
                cheeseparing cheesewood chemisette chemisorption chemoreceptor chemotaxes
                chemotaxis chemotherapy chersonese chervonets chesterfield chickenhearted
                chieftainship chiffchaff chifforobe childbearing childishness childlessness
                chiliastic chimneypiece chiropractic chiropractor chirurgeon chitarrone
                chitterlings chivalrousness chlamydate chlamydiae chloramphenicol chlorination
                chlorothiazide chlorpromazine chokeberry cholecystectomy chondriosome chopfallen
                choreographer choreography chromaticity chromatogram chromatography chromomere
                chromonema chronicity chronogram chronological chronologist chronometrical
                chronopher chrysanthemum churchless churchlike churchwarden churlishness
                cicatrices cinchonine cinchonism cinchonize cinematograph cinematographer
                cinematography cinerarium circuitousness circularization circulator
                circumambulate circumcision circumference circumlocution circumnavigate
                circumscribe circumscription circumspection circumstance circumstantial
                circumstantiate circumvallate circumvention circumvolution cismontane cistaceous
                civilization cladoceran clairvoyance clannishness clanswoman clanswomen
                clapperboard clarabella clarification classifiable classification claudicant
                claudication claustrophobia clearinghouse cleromancy clientship climatological
                climatologist clinkstone cliometrician cliquishness clothbound clotheshorse
                clothespress clownishness cnidoblast coacervate coadjutant coadjutrix coagulable
                coalescent coalitionist coaptation coatimundi cockalorum cockamamie cockfighting
                cockleboat cockneyism codependency codification codswallop coeducational
                coelacanth coelentera coelenterate coequality coetaneous coeternity coexecutor
                coexistent cohabitation cohesiveness coincident coincidental colatitude
                colchicine colemanite coleoptile coleorhiza collaboration collaborative
                collaborator collarless collectivism collectivist collectivize collegiality
                collegiate collocutor colloquialism colloquies colonization colorblindness
                colorfastness colorfield colorfulness colorization colorlessness colporteur
                columbaria columniation combativeness combustibility comedietta comfortableness
                comitative commeasure commemoration commemorator commencement commendation
                commendatory commensalism commensurable commensurate commercialism commercialize
                commiseration commissariat commissionaire commissioner commissure committeeman
                committeewoman commodiousness commonplaceness commonwealth commorancy
                communicability communicable communication communicative communicator
                communization companionship companionway comparability compassionate
                compatibility compensation competitiveness complaisance complementarity
                completeness complicacy complication complimentary complotted composedly
                comprehended comprehensible comprehensibly comprehension comprehensive
                compressibility compressible compulsiveness compunctious computational
                computerization concatenation conceitedness conceivability concelebrate
                concentration concentrator concentrical concentricity conceptualism
                conceptualize concertino concertmaster concessionaire concessive conchiolin
                conchoidal conciliation conciliatory concinnate concinnity concinnous
                conclusiveness concomitance concreteness concupiscence concurring condemnation
                condensation condescending condescension conditionality conditioning condominia
                conductibility conductivity confabbing confabulation confectioner confectionery
                conferring confessional confidential confidentiality configuration
                configurational confirmand confirmation confiscation conflagration confrontation
                congelable congeneric congenialness conglomerate conglomeration conglutinate
                congratulate congratulation congregation congressional congressperson
                congresswoman congruency congruousness conidiophore coniferous conjugational
                conjunctional conjunctivitis connectivity connoisseurship conoscenti
                conquistador consanguineous consanguinity conscientious conscionable
                consciousness conscription consecration consequential conservation
                conservationism conservationist conservatism conservative conservatoire
                conservatory considerable considerably considerateness consideration
                consolidated consolidation consolidator conspicuousness conspiratorial
                constabulary constellation consternation constipation constituency constitution
                constitutional constitutive constriction constructible construction
                constructional constructionist constructive constructivism constructivist
                consuetudinary consultation contagiousness containerize contaminated
                contamination contaminator contemplation contemplative contemporaneity
                contemporaneous contemptibility contemptuous contentedness contentiousness
                conterminous contestation contextualize contexture contiguousness continuation
                continuousness contortionist contrabandist contrabassoon contraception
                contraceptive contractility contradiction contraindicate contrapose contrapuntal
                contrapuntist contrarily contrariness contravention contrecoup contribution
                controllability controllable controllably controllership controversial
                controvertible contumacious convalescence convalescent convenable conventional
                conventionalism conventionality conventionalize conventioneer conventual
                convergent conversation conversational convertibility convertite conviviality
                convulsant cooperativeness coordination coparcener copartnership copolymerize
                copycatted copyeditor coquelicot coquillage corelation corelative coreligionist
                corespondent coriaceous cormophyte cornaceous cornerback cornerwise corporeality
                corpulency corralling correctitude correspondence correspondent corresponding
                corrigenda corrigibility corroborated corroboration corroborator corroboree
                corrodible corrosible corruptibility corticosteroid corticosterone corybantic
                coryphaeus cosmetologist cosmogonic cosmographer cosmologic cosmological
                cosmopolis cosmopolitan cosmopolitanism cossetting costarring costermonger
                coulometer councilmen councilorship councilperson councilwoman counselorship
                counteraction counterargument counterattack counterbalance counterblast
                counterchange countercheck counterclaim counterculture countercurrent
                counterexample counterfeiter countering counterirritant countermarch
                countermeasure countermelody countermen counteroffer counterpoint counterpoise
                counterproposal counterpunch counterstroke countertenor counterweight
                countinghouse countrymen countrywoman countywide courageousness coursework
                courteousness covenantal covenantee covenantor covetousness cowardliness
                craftsmanship craniology crapshooter crapulence craquelure creaseless creatinine
                creativeness creditworthy credulousness crematoria crepuscule crescentic
                cretaceous cribriform cricketeer criminalization criminological criminologist
                criticalness crosscurrent crossopterygian crosspollinate crownpiece cruciality
                cruiserweight cryptocurrency cryptographer cryptography cryptology cryptozoic
                crystallization crystallized crystallography cuckooflower cuculiform cuddlesome
                culinarian culinarily cultivable cumbersomeness cumuliform cumulonimbus
                cupelation curatorial curmudgeonly curricular curvaceousness curvetting
                custodianship customization cuttlebone cyanocobalamin cyclograph cyclopropane
                cylindroid cymographs cystectomy cystitides cystoliths cystoscope cytochrome
                czarevitch daguerreotype dairywomen damageable damselfish dangerousness
                daredeviltry dastardliness dauntlessness deaconship deadpanned deathwatch
                debilitating debilitation debonairness decaffeinate decahedral decalcomania
                decaliters decameters decasyllable deceitfulness deceleration decentness
                deceptiveness decidability decipherable decipherment decisiveness decolorant
                decompound decongestant decorousness decryption dedicatory deepfrozen defalcator
                defamatory defeasance defecatory defectiveness defenestrate defenselessness
                defensibility defensiveness deferrable defibrillate defibrillator definiteness
                degression deipnosophist delectability delectable delectably deliberateness
                deliberative delicateness delicatessen deliciousness delineator deliriousness
                delocalize delusional demarcator demicanton demimondaine demineralize demirelief
                demisemiquaver democratically democratization demographics demonetization
                demonstrability demonstrable demonstration demonstrative demonstrator dendriform
                dendrology denegation denigrator denominational denouncement densitometer
                denuclearize denunciation deodorization deontology departmental departmentalize
                dependability dependableness dependably deplorably deployable depositary
                deprecator depreciation depredator derisiveness dermatogen dermatologist
                dermatosis desalination desalinization descriptiveness descriptivist desecrator
                desiderata designedly desirability desirableness desolateness desperateness
                despicableness despicably despiteful dessertspoon dessertspoonful
                destructibility destructible destructiveness destructor deterioration
                determinable determinably determinateness determination determinative detestably
                dethronement detoxification detruncate deuteranopia deutoplasm developmental
                deviationism deviationist devilishness dexamethasone dexterousness dextroglucose
                diacaustic diachronic diaconicon diaconicum diadromous diagenesis diagnostician
                diagrammatical diagrammed diakineses diakinesis dialectician diamagnetism
                diapedesis diastrophism diathermic diatropism dibranchiate dictatorship
                didynamous diencephalon differential differentiate differentiated
                differentiation differentiator diffusible digestibility digestions digitalism
                digitiform digitization dilapidation dilatorily dilatoriness dilettantism
                dimenhydrinate dimensionality diminuendi diminutiveness dimorphism dimorphous
                dinoflagellate dipetalous diphosgene diphtheric diphthongize diphyllous
                diphyodont diplococci directionality directorship disaccharide disambiguate
                disappointing disarticulate disbelieving disbudding disbursement discarnate
                discipleship disciplinarian discobolus discoloration discombobulate discomfiture
                discommend disconcerting disconcertion disconcertment disconnected disconsolate
                discophile discouragement discouraging discreeter discreetness discrepant
                discreteness discriminant discriminate discriminating discrimination
                discriminator discursion discursiveness disembogue disembowelment disenthral
                disentitle disentwine disepalous disfeature disfigurement disgorgement
                disgruntlement disgustful dishcloths disheartening disheartenment disherison
                dishevelment disillusionment disinfectant disinfection disjointedness
                dislodgement dismantlement dismemberment disorganization disparagement
                disparateness dispelling dispensation dispermous dispersant dispersoid
                dispiritedness dispossession disproportion disputatious disquisition
                dissemblance dissemination disseminator dissertation dissimilitude dissipator
                dissociation dissoluteness dissonancy distichous distillation distincter
                distinctiveness distinctness distinguee distinguishable distinguishably
                distinguished distraught distribution distributive distributorship
                distrustfulness disulphide disyllabic ditchwater dithionite diversification
                diverticulitis divertimento divinatory divisibility divisional divisiveness
                documental documentation dodecahedron doglegging dogtrotted dollarbird
                dollarfish domesticated domestication doodlesack doppelganger doubleheader
                doubletree doubtfulness downheartedness downmarket downstream draftsmanship
                dragonnade dragonroot dramatization dramaturge dramaturgical draughtboard
                drawknives dreadfulness drillstock drivetrain drunkenness dubitation dumbstruck
                duodecimal duodenitis dupability duumvirate dwarfishness dynamicist dysarthria
                dysenteric dysfunctional dysgraphia dysphemism dysplastic dystrophic eaglestone
                earthbound earthlight earthmover earthshine earwitness eavesdropper ebracteate
                ebulliency eburnation eccentricity ecchymosis ecclesiastic ecclesiastical
                ecclesiasticism echolocation echopraxia econometrician ecospecies ecphoneses
                ecphonesis ectoenzyme ectogenous ectomorphs ectoparasite ecumenicalism
                eczematous editorialist editorialize educationalist educationist educations
                effectiveness effectuality effectualness effervescence effervescent
                efficaciousness efflorescence effortlessness effusiveness egalitarianism
                egocentricity egregiousness eighteenmo eightieths eightpence elaborateness
                elaborator electrification electrochemical electrocution electrodynamic
                electrojet electrokinetic electrologist electrolysis electromagnet electrometer
                electroplate electroscope electroshock electrostatic electrostatics
                elephantiasis elocutionist elucidator eluviation emalangeni emancipation
                emarginate emasculation embarrassing embarrassment embellishment embezzlement
                embitterment emblazonment emblazonry emblematic emblematical emblements
                embryogeny embryologist embryotomy emmetropia emollience emotionalism
                emotionality emotionalize empathetic emphysemic employability empoverish
                emulsification encapsulation encephalic encephalitis encephalogram encincture
                encirclement encompassment encouragement encroachment encrustation encyclopedia
                encyclopedist endangerment endemicity endocarditis endocrinologist endocrinology
                endodermis endoenzyme endogamous endometria endomorphism endomorphs endoparasite
                endoscopic endoskeleton endosmosis endostosis endothelia enfeeblement enfleurage
                enfranchisement engagingly englutting enharmonic enlightening enlightenment
                enneastyle enormousness enphytotic ensanguine enshrinement entanglement
                enterotomy enterprising entertaining entertainment enthrallment enthronement
                enthusiastic entitative entomologist entrancement entrapping entrenchment
                entrepreneur entrepreneurial enumerable enunciator environmental enwrapping
                enzymology eolotropic epanaphora epeirogeny epenthesis epexegesis ephemerality
                ephemeralness epicanthus epicardium epicentral epideictic epidemiologist
                epidemiology epidermoid epididymis epigeneses epigenesis epiglottal epigraphic
                epileptoid epilimnion epineurium epiphenomenon epispastic epistemological
                epistemologist epistemology episternum epistolary epithelial equalitarian
                equalization equanimous equatorial equestrianism equestrienne equivocalness
                equivocation eremitical ergativity ergocalciferol ergonomist ergophobia
                ericaceous erinaceous erotogenic erotomania erraticism erroneousness erubescent
                erythritol erythroblast erythromycin escadrille escapologist escapology
                escharotic eschatological eschatologist esophageal essayistic essentiality
                essentialness establishment estipulate estrangement estrogenic ethnically
                ethnocentrism ethnographer ethnographical ethnologic ethnological etymological
                eucalyptol eudemonics euhemerism euhemerize eukaryotic eulogistic eupatorium
                euphuistic eutrophicate evangelicalism evaporable eventfulness everliving
                everyplace everywhere evidential evisceration evolutionist exacerbation
                exaggeration examinable exasperating exasperation exceptionable exceptionably
                excessiveness excitability excitableness exclusiveness excommunicate
                excommunication excrescent excruciating excursionist excursiveness excusatory
                execratory exegetical exemplification exemptible exenterate exfoliator
                exhaustibility exhaustiveness exhibitionism exhibitionist exhilarant
                exhilarating exhilaration existentialism existentialist exocentric exodontics
                exonerator exophthalmos exospheric exothermal exothermic exotically expansible
                expansionism expansionist expansiveness expatriation expectoration
                expeditiousness expellable expensiveness experiential experimental
                experimentalism experimentalist experimentation experimenter expiratory
                explicator explicitness exploitation explosiveness exponentiation expository
                expostulation expressionism expressionist expressionless expressiveness
                expressman expropriation expropriator expurgator exquisiteness exsanguine
                extemporaneous extemporization extensiveness extenuator extermination
                exterminator externalization extinguishable extinguisher extirpator extortionate
                extortionist extramural extraneousness extrapolation extrasolar extravagance
                extravaganza extroversion eyeopening facecloths facetiousness facilitation
                factionalism factorization faithfulness faithlessness fallaciousness
                fallibleness falsification familiarization fanaticize fancifulness fantoccini
                faradmeter farsightedness fasciculus fascinator fastidiousness fastigiate
                fatalistic fatherliness fathomless faultfinding faultlessness favorableness
                fearlessness fearnought feasibleness featherbedding featherbrain feathercut
                featherweight febrifugal fecklessness federalese federalization feebleminded
                felicitation felicitousness fellmonger feminineness fenestration fermentation
                fermenting ferociousness ferricyanide ferroconcrete ferrocyanide ferromagnetism
                fertilization festoonery fetiparous fetterlock feuilleton feverishness
                fibrillation fibrinolysin fictionalize fictionist fiddlewood fieldpiece
                fifteenths filariases filariasis filibusterer filmmaking finalization fingerless
                firefighting firewarden flabellate flagellation flamethrower flammability
                flapdoodle flashboard flavescent flavorless flavorsome flawlessness fleeringly
                fleetingness flexibleness flexuosity flibbertigibbet flightless flightpath
                flirtatiousness floatstone flocculant flocculent floribunda floriculture
                florilegia flowerless flowerlike fluorescence fluoridation fluorocarbon
                fluoxetine fluviatile foliaceous follicular folliculin foolhardiness
                forcefulness forecourse foreignism foreknowledge foreordination foreseeing
                foresightedness forgetfulness forgetting formaldehyde formalization
                formidability formidably formlessness forsterite forthrightness fortification
                fortissimo fortuitism fortuitousness fortuneteller fortunetelling fossilization
                fosterling foudroyant fountainhead fourchette foursquare foxtrotted
                fractiousness fragmental fragmentation frangibility frankincense fraternization
                freakishness freedwoman freedwomen freemartin freethinking friendlies friendlily
                friendliness frightfulness frigorific frivolousness frogmouths frolicking
                frolicsome frontality frontiersman frontispiece fruitarian fruitfully
                fruitfulness fruitlessness frutescent fugaciousness fuliginous fulminator
                fumatorium functionalism functionalist functionality fundamentalism
                fundamentalist fungicidal funiculate funnelform furosemide fustanella futuristic
                futurologist galimatias galloglass galvanization galvanometer gamesmanship
                gametangia gangbusters ganglionic gangrenous garbageman gargantuan garrulousness
                gasteropod gastralgia gastroenteritis gastrolith gastrological gastrology
                gastronomical gastrotomy gastrulation gaultheria gaussmeter gelatinate
                gelatinoid gelatinous geminately genderless genealogical generalissimo
                generalization generatrix generousness geniculate genteelism gentilesse
                gentrification genuflection geocentric geochemist geochemistry geographic
                geographical geomagnetism geometrician geometrize geomorphic geomorphology
                geophilous geophysicist geopolitical geosynchronous geothermic geratology
                geriatrician germicidal germinable germinator gerontologist gerrymandering
                gestaltism gestaltist gesticulation gesundheit ghostwrote ghoulishness
                glacialist glaciologist glaciology glamorization glandulous glassblowing
                glitterati globalization globetrotter globularness glochidium glockenspiel
                glomerulus glorification glossarial glossology glossotomy glottology glucosuria
                glutinousness glycogenic glycolyses glycolysis glycoprotein glycosuria
                glyoxaline glyptodont glyptography gnomically gnosticism goalmouths gobbledygook
                gobsmacked goldilocks goldsmiths gonadotropin gonococcal gonococcus gonorrheal
                googolplex gorgeousness gorgoneion gormandism governmental governorship
                gracefulness gracelessness graciousness gradualist graffitist gramineous
                grandchildren granddaughter grandiloquence grandiloquent grandmamma grangerize
                granophyre grantsmanship graphemics graphitize graphologist graptolite
                grassroots gratefulness gratification gratuitousness gravimetrical gravitational
                greaseless greenfield greenfinch greengrocery greenheart greensickness
                greenstone gregariousness gressorial greynesses grievousness griseofulvin
                groceryman grotesqueness groundbreaking groundling groundsill groundskeeper
                groundsman groundsmen groupthink grovelling gruesomeness guacharoes guardianship
                guideboard guilelessness guitarfish gumshoeing gymnasiast gymnosophist
                gynandrous gynecological gynecologist gyniatrics gypsophila gyroscopic
                gyrostabilizer haberdashery habitability habitualness hagiocracy hagiographer
                hagioscope haircutter hairdressing hairsbreadth hairsplitter hairsplitting
                halfcocked halfheartedness halfwitted hallucination hallucinogen hallucinogenic
                halogenous hammerless handkerchief handsomeness haphazardness happenstance
                harbormaster hardheadedness hardheartedness harelipped harlequinade harmlessness
                harmonicon harmoniousness harmonization harpsichordist harvestman harvestmen
                hatefulness hatemonger haubergeon haustellum haustorium hawsepiece headmistress
                headquarters headshrinker headstream headstrong healthcare healthfulness
                heartbreaking hearthside heartlessness heartrending heartsickness heartstrings
                heathberry heathenish heathenize hebdomadal hectically hedonistic heedlessness
                hegemonism hegemonist heliocentrical heliometer heliotaxis heliotropism
                helplessness hemachrome hematocele hematologist hematomata hematozoon hemelytron
                hemihedral hemimorphite hemophilic hemostasis hemostatic henceforth hendecagon
                henotheism heptachord heptagonal heptameter heptastich herbaceous herbicidal
                hereditament heresiarch heretofore heritability hermaphrodite hermaphroditism
                hermeneutical herniotomy herpetologist hesperidin heterogamy heterogeneity
                heterogeneous heterogony heteronomy heulandite hexaemeron hexamerous hexametric
                hexangular hexavalent hierarchal hierarchic hierarchical hierocracy hieroglyphic
                hieroglyphical hierolatry hierophant highhandedness highwaymen hilariousness
                hindermost hiphuggers hippocampi hippogriff hippopotamus histaminic histologic
                histological histolysis historiographer historiography histrionical hithermost
                hitherward hobnobbing holidaymaker holoenzyme holographical holographs
                holohedral holophrase holophytic homelessness homeomorphism homeopaths
                homeotherm homeschooling homesickness homocercal homocyclic homogeneousness
                homogenization homographs homologate homologous homomorphism homonymous
                homophobic homophonic homorganic homozygote homozygous homunculus honeybunch
                honorableness honorarily hoodlumism hopelessness horizontality horologium
                horribleness horsemanship horsewomen horticultural horticulture horticulturist
                hospitalization hotblooded hotheadedness housebound housebreaker housebreaking
                housebroke housecleaning househusband housekeeping housemistress houseproud
                housewarming housewives humanistic humanitarian humanitarianism humanization
                humbuggery humbugging humidification humidistat humorlessness humorousness
                hundredths hundredweight husbandmen hyaloplasm hybridization hydrastine
                hydratable hydrocephalus hydrochloride hydrocortisone hydrodynamic hydrodynamics
                hydrogenation hydrographical hydrokinetic hydrologic hydrological hydrolyses
                hydrolytic hydromagnetic hydromancy hydrophane hydropower hydroscope
                hydrostatical hydrotaxis hydrotherapy hyetograph hygrograph hygrometry
                hylotheism hymenopteran hyoscyamus hypabyssal hypanthium hyperactivity
                hyperbaric hyperbolic hyperbolical hypercritical hyperdulia hyperextension
                hyperglycemia hypergolic hypermeter hypermetropia hyperploid hyperpyrexia
                hypersensitive hypersonic hypertension hypertensive hyperthermia hyperthyroid
                hyperthyroidism hypertonic hyperventilate hypnagogic hypnogogic hypnotherapy
                hypocenter hypochlorite hypochondria hypochondriac hypocorism hypocritical
                hypogenous hypoglycemia hypoglycemic hypogynous hypophyses hypophysis hypostases
                hypostasis hypothalamus hypotheses hypothetic hypothetical hypothyroidism
                hypozeugma hypozeuxis hypsometer hypsometry hysterectomy hysteresis iatrogenic
                ichthyologist ichthyosaurus ichthyosis iconically icosahedra idealistic
                idealization ideational idempotent identicalness identifiable identification
                ideographs idiopathic idiosyncrasy idiotropic idolatrize ignobility
                ignominiousness illaudable illegibility illegitimacy illegitimate illiberality
                illocution illogicality illuminati illuminating illumination illuminism
                illuminist illusional illusorily illustration illustrative illustriousness
                imaginativeness imitativeness immaculacy immaculateness immateriality
                immaterialize immaterialness immeasurable immediateness immersible immiscible
                immobilization immoderacy immoderateness immoralist immovability immunization
                immunochemistry immunoglobulin immunological immunologist immunosuppress
                immuration immutability impalpability impalpable impalpably impanation
                imparadise impartiality impartible impassably impassibility impassibly
                impassiveness impeccability impeccable impeccably impecuniousness impeditive
                impenetrability impenetrable imperativeness imperceptive imperfection
                imperfective imperfectness imperiousness imperishability impermanence
                impermanency impermeability impersonation impersonator impertinence
                imperviousness impetuousness implacability implacable implacably implantation
                implausibility implementable implementation implicitness impoliteness
                imponderable imposingly impossibility impossibly impoundage impoverishment
                impracticality imprecator impreciseness impregnability impregnation
                impressibility impressionable impressionism impressionist impressiveness
                impressure imprisonment improbability improbable improbably improperness
                improvidence improvisation impudicity impuissant impulsiveness inactiveness
                inadequateness inadvertence inadvertency inalienability inanimateness
                inapplicability inapposite inappropriate inarticulate inauguration incandesce
                incandescence incandescent incapableness incapacitate incarceration
                incautiousness incendiarism incessance incessantness incineration incisiveness
                inclusiveness incogitant incomparable incongruousness inconvenience incoordinate
                incorporated incorporation incorporeality incorrigibility incorrigible
                incrassate incredibleness incrementalist incrimination incrustation inculcator
                incunabula incurability indebtedness indecorousness indemnification
                indeterminacy indicatory indifference indigenousness indigestibility
                indiscipline indiscreetness indiscriminate indispensable indisputable
                individualism individualist individuality individualize individuation
                indoctrinate indoctrination indoctrinator indomitability indophenol
                indubitability industrialism industrialist industrialize industriousness
                ineffability ineloquent ineludible inevasible inevitability inevitably
                inexactitude inexertion inexhaustible inexorability inexorably inexplicit
                infectiousness inferrable infinitesimal inflammation inflectional inflexible
                informativeness infotainment infrasonic infrastructure infringement ingenerate
                ingeniousness ingenuousness ingratiating ingratiation ingression inhabitability
                inharmonic inhibitory inhomogeneity inimitably initialism initialization
                initiatory injunctive injuriousness innocuousness innominate innovatory
                innumerate inoculable inoculator inosculate inquisitiveness inquisitorial
                insalivate insatiability insatiably inscrutability inscrutableness insemination
                insensible insensitiveness insertions insidiousness insightfulness insipience
                insociable inspectorate inspirational inspissate installation instantaneous
                instauration instillation institutional instructorship instrumental
                instrumentalist instrumentality instrumentation insubordinate insurrection
                insurrectionist intangibleness integrable intellection intellectual
                intellectualism intellectualize intelligence intelligentsia intelligibility
                intelligible intelligibly intemerate intemperateness intendancy intenerate
                intensification intensiveness intentionality interblend interception
                intercession intercommunion interconnect interconnected interconnection
                intercross interdependence interdependent interdiction interfaith interference
                interferometer interfluve intergrade interjection interjectional interlanguage
                interlocutor interlunar intermarriage intermediary intermediate interments
                intermezzi interminable intermission intermittence intermittency intermittent
                intermixture internalization international interoperate interpellate
                interpenetrate interpersonal interphase interpolation interposition
                interpretable interpretation interpretive interrelation interrogation
                interrogative interrogator interrogatory interruption intersection intersession
                interspace interspersion interstitial interstratify intertidal intertwist
                interurban intervenor intervention interventionism interventionist interwoven
                intimidating intimidation intinction intoxication intramural intramuscular
                intransigence intransigency intransigent intransitivity intrastate intrigante
                introduction introjection intromission introspection introspective introversion
                intrusiveness intuitionism intuitiveness intumescence intussusception
                invaluableness invariance inventiveness inveracity invertible investigation
                investigator invidiousness invigorating invigoration invincibility invincibly
                inviolability inviolably invitational invitatory invocatory involucrum
                involuntariness irascibility iridaceous iridectomy iridosmine ironhanded
                ironmaster irradiance irradiator irrationality irrecoverable irregularity
                irrelative irreligiousness irremeable irresistible irresoluteness irresolution
                irrespective irresponsible irretrievable irreversibility irritability isentropic
                isochronal isochroous isocyanide isodynamic isolationism isolationist isomorphic
                isopiestic isotropism italicization itinerancy jackknives janitorial jeopardous
                jerrybuilt jingoistic jitterbugger jobsworths jollification journalize
                journeymen joyfullest judicative judiciousness juncaceous jurisdiction
                jurisprudence juristical justification juvenescence juxtaposition kaffeeklatch
                kaffeeklatsch kaisership kaleidoscope karmically karyolymph karyolysis
                katabolism kenspeckle keratinize keratinous keratoplasty kerseymere kickboxing
                kilometric kimberlite kindergarten kindergartner kindheartedness kindnesses
                kleptomaniac kneecapped knickerbocker knickerbockers knighthead knightliness
                knowledgeable knuckleduster kohlrabies kriegspiel krugerrand kummerbund
                kymographs labionasal labiovelar laboriousness labyrinthodont labyrinths
                lackadaisical lackluster lactescent lactometer lactoscope lacustrine lagomorphs
                lambdacism lamentably lampoonery lampoonist lanceolate landlocked landwaiter
                laniferous lansquenet lardaceous laryngitic laryngoscope lasciviousness
                laterality latitudinarian lattermost laughingstock laundrymen laundrywoman
                lauraceous laureateship lavatorial leaderless lebensraum lecherousness
                lectionary lederhosen legalistic legalization legitimatize legitimism legitimist
                legitimization leguminous leishmania leisureliness lemniscate lemongrass
                lengthwise lentamente lenticular lentissimo lepidopteran lepidopterist
                lesseeship letterbomb leucoderma leucomaine leucoplast leukocytic
                levelheadedness levogyrate lexicographer lexicographical lexicography
                lexicologist lexigraphy liberalist liberalization liberationist libertarianism
                librarianship licentiousness lifelessness lighterman lightermen lightheadedness
                lighthearted lightproof likenesses liliaceous limicoline limicolous limitative
                limitlessness linguiform lipography lipophilic lipotropic lipotropin
                liquefaction listlessness listserver literalist literality literarily
                literariness lithographer lithographical lithologic lithomarge lithotrity
                litigiousness livebearer loansharking loathsomeness localization locational
                locksmiths locomobile logarithmical logography loincloths lonesomeness
                longitudinal longshoreman lophophore lopsidedness loquaciousness loudmouths
                lovability lovesickness luciferase luciferous lucrativeness lucubrator
                ludicrousness lugubriousness lukewarmness lumbricoid luminescence luminousness
                lumisterol luncheonette lusciousness lutestring luxuriousness lycopodium
                macrobiotics macrocephaly macroeconomic macroeconomics macromolecule
                macroscopical macrospore mademoiselle magnanimousness magnetization magnetometer
                magnetosphere magnification magnificence magniloquence magniloquent maharajahs
                maintainable majoritarian majuscular malacology maladapted maladjustment
                maladroitness malapropos maleficent malformation maliciousness malleability
                malnourishment malnutrition malocclusion malodorousness maltreatment malvaceous
                malversation mammillary mammillate manageability manageableness manchineel
                mandibular mandragora maneuverability manifestation manipulability manipulation
                manipulative mannerless manometric manstopper mansuetude mantellone manteltree
                manufacturer manufacturing manumitted manzanilla marcelling marcescent
                marginalization margravine marketability marksmanship markswoman marlinespike
                marquisate marriageability marriageable marseilles marshaller martellato
                maskanonge masterstroke masticator mastigophoran mastitides mastoidectomy
                materialization materialized mathematical mathematician matriarchate matriarchs
                matricidal matriculation matrilineage matrilocal matronhood maxilliped
                maximization meadowland meaningfulness meaninglessness measurably meatloaves
                mechanization meddlesome meditativeness mediumship medullated meetinghouse
                megadeaths megagamete megalithic megalocardia megalomaniac megaparsec meitnerium
                melancholiac melanistic meliorable mellifluousness mellophone melodiousness
                melodramatic melodramatics membranous memorability memorization menarcheal
                menopausal menstruation mensurable mentorship mephitical mercantile mercantilism
                mercaptide mercaptopurine merchandiser merchandising mercifulness mercilessness
                meretricious meridional meritoriousness meronymous mesencephalon mesitylene
                mesocratic mesomorphs mesothelia mesothorax metacenter metagalaxy metalanguage
                metalepses metalepsis metalinguistic metallurgist metalworking metamerism
                metamorphism metamorphose metamorphosis metaphoric metaphorical metaphrase
                metaphrast metaphysical metaplasia metastable metastases metastatic metatheses
                metathetic metempsychosis metencephalon meteorological meteorologist
                methamphetamine methaqualone methodicalness methodological methylated
                meticulosity meticulousness metronomic metrorrhagia mettlesome microaggression
                microbalance microbiological microbiologist microbiology microbrewery microburst
                microcephaly microcircuit microcline microcomputer microcosmical microcurie
                microeconomic microeconomics microelectronic microfarad micrograph microhenry
                micromanagement micromanager micrometeorite micrometry microorganism microphyte
                microprint microprocessor microscopical microsurgery middlebreaker middlemost
                middleweight midshipmen migrainous militarily militarization militiamen
                millenarianism millesimal millionairess millionths minatorial mindblower
                mindlessness mineralization mineralogical mineralogist mineraloid
                miniaturization minicomputer minimality minimization ministration minuscular
                miracidium mirthfulness misadventure misadvised misadvises misaligned
                misalignment misanthropical misanthropist misapplication misapprehend
                misapprehension misappropriate miscalculate miscalculation miscegenation
                miscellaneous mischievousness misconception misconstruction miscreance
                miscreated misdiagnosis misdirection miseducate miserableness misericord
                misfitting misgovernment misinformation misinterpret misjoinder mismanagement
                misogynous misplacement mispronounce misquotation misrepresent misstatement
                mistranslate mistreatment misunderstand mithridate mitigatory mizzensail
                mobilization moderateness modernization modification modularity modulatory
                molecularity mollescent mollification molluscoid momentariness momentousness
                monandrous monanthous monarchial monetarily monetization moneychanger moniliform
                monitorial monoatomic monocarpic monoclinal monoclonal monocotyledon monocyclic
                monographs monohydric monolithic monomerous mononucleosis monophonic monoplegia
                monopolization monopteros monosaccharide monosyllable monotonousness monovalent
                monumentalize moonlighting moonstruck moralistic moralities moralization
                morbidezza morganatic morphinism morphological morphophoneme mortification
                mosquitoes mossbunker motherless motherliness motionlessness motiveless
                motoneuron motorcyclist motorization mountaineering mountainside mournfulness
                mousseline mouthorgan mugwumpery mujaheddin mujahideen muliebrity mulligatawny
                mulligrubs multifarious multigrain multilateral multilevel multilingualism
                multimeter multinational multiparty multiphase multiplicand multiplicate
                multiplication multiplicity multiprocessor multisense multistage multistory
                multitasking multitudinous multivitamin multivocal mummification municipality
                musicianship musicologist myasthenia myasthenic mycetozoan mycorrhiza
                myelencephalon myocardial myological myopically myriameter myrtaceous mystagogue
                mysteriousness mystification mythmaking mythologer mythologic mythological
                mythomania mythopoeia namelessness nanotechnology narcotization nasalization
                natatorial nationalization nationalized nationwide nativistic naturalization
                naturopath nauseousness navigability nearsightedness nebulosity nebulousness
                neckcloths necrolatry necrologic necrophile necrophiliac necrophilism necroscopy
                nectareous needlefish needlessness nefariousness negativeness neglectfulness
                negligible negligibly negotiability neighborhood neighborliness neoclassic
                neoclassicism neoclassicist neocolonialism neocolonialist neoconservative
                neoliberalism neological neoplastic nephograph nephralgia nephridium nephrolith
                nephrotomy nepotistic nervelessness nethermost nettlesome neurasthenia
                neurasthenic neurilemma neuritides neurogenic neurologic neurological neuropathy
                neurophysiology neuropsychiatry neuroscience neurosurgeon neurosurgery
                neutralization newfangled newspaperman newspaperwoman newsworthiness nicotinism
                nidicolous nidifugous nifedipine nightblind nightclothes nigrescent nihilistic
                nincompoop ninetieths nitrification nitrobenzene nitrocellulose nitroglycerin
                nitrometer noblewomen noctambulism noctambulist noiselessness nomenclature
                nominalist nomography nomothetic nonabsorbent nonabusive nonacceptance
                nonagenarian nonaggression nonaligned nonalignment nonappearance nonarrival
                nonattendance nonavailability nonbelligerent nonbinding noncaloric noncandidate
                noncombatant noncommercial noncommittal noncompetitive noncompliance
                nonconductor nonconformance nonconformist nonconformity noncooperation
                noncurrent nondeductible nondevelopment nondisclosure nondurable nonelastic
                nonelected nonequivalent nonethical nonexistence nonexplosive nonextinct
                nonfactual nonfascist nonferrous nongaseous nonintellectual noninterference
                nonintervention nonjoinder nonlogical nonmedical nonnuclear nonobservance
                nonoccurrence nonorganic nonparticipant nonperformance nonplussed nonpolitical
                nonprofessional nonprotein nonreceipt nonreciprocal nonrecognition nonresistance
                nonreturnable nonsalable nonscoring nonsecular nonsmoking nonspecialist
                nonspiritual nonswimmer nonsympathizer nontaxable nontenured nontrivial
                nontypical nonunified nonuniform nonworking noodlehead norepinephrine
                normalization northbound northeastward northwestward nosography nosologist
                nostalgist nostomania notarization noteworthiness notifiable notification
                novaculite novelistic novelization nudibranch nullification numberless
                numerologist numerousness nunciature nurselings nurserymen nutritionist
                nutritiousness obdurateness objectionable objectiveness objectless objurgator
                oblational obligatory obligingness obliteration obliviousness obloquious
                obnoxiousness obnubilate obscurantism obscurantist obsequiousness observably
                observational obsessiveness obsolescence obsoleteness obsoletism obstetrician
                obstreperous obstructionism obstructionist obstructiveness obstructor
                obtrusiveness occupational oceanarium oceangoing oceanographer oceanography
                ochlocracy octahedral octamerous octangular octavalent octodecimo octogenarian
                octosyllable oculomotor odontalgia odontology offensiveness offensives
                offhandedness officeholder officiousness offsetting oftentimes oldfangled
                oleaginous oleomargarine oligarchic oligarchical oligonucleotide oligopsony
                oligosaccharide olivaceous ommatidium omnipresence omnivorousness onomatopoeia
                ontologism ontologist oophorectomy opalescent openhandedness ophicleide
                ophiolatry ophthalmic ophthalmitis ophthalmologist ophthalmology ophthalmoscope
                opportuneness oppositeness oppressiveness optimality optimistic optimization
                optometric orbiculate orchardist orchardman orchestration orchestrator
                orchidectomy ordinarily ordinariness ordonnance organicity organismic
                organization organizational organology ornamentation ornithischian
                ornithological ornithologist ornithosis orogenesis orographic orographical
                orphanhood orthodontics orthodontist orthogenic orthographical orthoscope
                oscilloscope oscitation osculatory ossiferous ossification osteitides ostensible
                ostensibly ostentatious osteoarthritis osteoclast osteomalacia osteopaths
                osteophyte osteoporosis otherwhere otolaryngology outbargain outbidding
                outcropped outfitting outflatter outgrowths outgunning outhitting outlandishness
                outplacement outputting outrageousness outrunning outspanned outspokenness
                outwitting ovariotomy overabound overabundance overabundant overachievement
                overachiever overambitious overassertive overattentive overbearingness
                overblouse overbought overcapacity overcapitalize overcommitment overcompensate
                overconfidence overcrowding overdecorate overdetermine overdiversify
                overdramatize overdubbed overemphasis overemphasize overestimate overestimation
                overexercise overexertion overexpand overexposure overgeneralize overground
                overindulgence overinsure overinvest overlapped overlavish overmanned overmatter
                overmedicate overmodest overmodify overoptimism overpopulate overpopulation
                overpowering overprescribe overproduction overprompt overprotection overreaction
                overrefinement overregulate overridden overseeing oversensitive oversevere
                oversimple oversimplify overslaugh overspecialize overstatement overstimulate
                overstrict overstride overstrung oversubscribe oversubtle overthrown overthrust
                overtopped overvaluation overwhelming oxidimetry oxidizable oxyacetylene
                oxymoronic oxytetracycline oystercatcher ozonolysis pacemaking pacification
                pacificism pacifistic packetboat packinghouse paddlefish painfuller painlessness
                palatability palatalization paleobiology paleogeography paleographer paleoliths
                paleontologist paleontology paleozoology palmaceous palpebrate pancratium
                pancreatic pancreatin pandectist panegyrize panelboard pangenesis paniculate
                pantechnicon pantheistical pantograph pantomimic paperbound paperhanging
                papistical papyrology parabolize paracasein paradisaic paradisiac paraffinic
                paraglider paragraphs parallelepiped parallelogram paralogist paramagnetism
                parameterize parametric paramilitary paraphernalia paraphilia paraphrast
                parapodium parapsychology paraselene parasitize parasympathetic paratactic
                paregmenon parenteral parenthesize parenthetical pargetting parliamentarian
                parliamentary parmigiana parochialism paronychia paronymous paroxysmal
                parricidal parrotfish parsimonious parthenogenesis participation participator
                particleboard particularism particularity particularize partisanship
                partridgeberry parturient pasqueflower passementerie passionflower pasteurism
                pasteurization paterfamilias pathogenic pathognomy pathologic pathological
                patination patriarchate patriarchs patriciate patricidal patrilineage patrilocal
                patrolling peacefulness peacekeeping pectoralis pederastic pedestrianize
                pediatrician pediculous pedimental peduncular pellagrous pellucidness
                penalization penetrability penetrable penetralia penetrance peninsular
                penitentiary pennyworth pentagonal pentaprism pentastich pentastyle pentatomic
                pentatonic pentimento pentobarbital pentstemon penuriousness pepsinogen
                peradventure perambulation perambulator perceptibility perceptiveness
                perceptivity percussionist perdurability perdurably perdurance peregrination
                perfectibility perfectionism perfectionist perfoliate perforator periastron
                pericardia peridotite perigynous perimetric periodontics periodontist periosteum
                peripeteia peripteral periscopic perishably perissodactyl perithecia peritoneal
                permanganate permeability permissibility permissiveness permitting
                perniciousness peroxidase peroxidize perpendicular perpetration perpetuation
                perseverance personableness personably personalization personification
                perspicacious perspicacity perspicuousness perspiration persuasiveness
                pertinacious perturbation pervasiveness perverseness perviousness petrifaction
                petrochemical petroglyph pettifoggery phagocytic phalangeal phantasmagoria
                phantasmal phantasmic pharmaceutic pharmaceutical pharmaceutics pharmacologist
                pharmacology pharmacopoeia pharyngeal phelloderm phenacaine phenformin
                phenobarbital phenocryst phenothiazine phenotypic phenotypical phenylalanine
                pheromonal philandering philanthropical philanthropist philanthropy philatelic
                philharmonic philistinism philodendron philological philosophical philosophize
                philosophizer phlebotomize phlegmatic phlegmatical phlogistic phlogiston
                phonically phonologic phonological phonometer phonoscope phosgenite phosphatic
                phospholipid phosphoprotein phosphorescence phosphorescent phosphoric photoaging
                photocathode photochemical photochemistry photocompose photodrama photoduplicate
                photoelectrical photoelectron photoemission photoengrave photoengraver
                photoengraving photofinishing photogenic photographer photographical
                photogravure photojournalism photojournalist photolysis photolytic photometrical
                photometry photomontage photomural photophore photosensitize photosynthesis
                photosynthesize phototaxis phototonus phototropism phrenological phrenologist
                phylloquinone phyllotaxy phylloxera phylogenic physicking physiognomical
                physiography physiological physiologist physiotherapy physiotype phytohormone
                phytoplankton picaresque piccoloist pickerelweed picnicking picrotoxin
                picturesqueness pigeonwing pigheadedness pigmentary pigmentation pilgrimize
                piliferous pilliwinks pinchpenny pinnatifid pinnatiped pinspotter piperidine
                pistillate pitilessness pixillated placentation plainchant plainclothesman
                plaintiveness planetesimal planimetry planktonic planometer planospore
                plasmosome plasterboard plasticine plausibility plausibleness playreader
                pleasanter pleasantness plenipotentiary plentifulness pleomorphism pleonastic
                ploughings pluralization pneumonectomy pointblank pointlessness polarization
                policlinic policyholder poliomyelitis politicization pollinoses pollinosis
                polyatomic polybasite polychromy polycyclic polycythemia polydactyl polydipsia
                polydipsic polyethylene polygraphs polygynous polyhedral polyhistor polyhydric
                polymathic polymerism polymerization polymerous polymorphism polyphagia
                polyphonic polypropylene polysaccharide polysemous polysyllable polysyndeton
                polytonality polyunsaturate polyurethane polyvalent pomiferous ponderousness
                popularization populistic populousness poriferous porphyroid portamenti
                portamento positiveness possessiveness possessory postcoital posteriority
                postgraduate postlaunch postliminy postmistress postmodern postmodernism
                postmodernist postoperative postpartum postponement postulancy potentiality
                potentilla potentiometer poultryman poultrymen pourparler powerfulness
                powerlessness powertrain practicability practicality practitioner praetorian
                praiseworthy praseodymium prayerbook preadamite preaddress preadolescence
                preambular preappoint preapprove prearrangement precalculate precariousness
                preceptorship preceptory preciousness precipitance precipitancy precipitateness
                precipitation precipitator precipitousness precociousness precognition
                precollege preconception precondemn precondition preconscious precursory
                predaceous predesignate predestinate predestination predeterminate predetermine
                predeterminer predicable predictability predictory predilection predisposition
                prednisone predominance preexamine preexistence prefabbing prefabricate
                prefabrication preferably preferential preferring prefiguration prefrontal
                preglacial prehensile prehistorian prehistorical prehominid prekindergarten
                prelatical premarital premaxilla premedical premeditated premeditation
                premenstrual premundane prenuptial preoccupancy preoccupation preoperative
                preordination preparator preparedness preplanned preponderance preponderant
                preponderate prepositional prepositor prepossessing prepossession preposterous
                prepotency preprogram prepuberty prepubescence prepubescent preregistration
                prerelease prerequisite presbyopic prescription prescriptive presentation
                presentational presentiment preservation preservationist preservative presetting
                presidentship presignify preslavery pressurization prestidigitate
                prestidigitator presumably presumptuous presupposition presurmise
                pretentiousness preternatural pretreatment prevarication prevaricator prevenient
                preventative prevocalic pridefulness priestliness priggishness primitiveness
                primogenitor primogeniture princeliness princeling principality principalship
                principate principium printwheel privatization prizefighter prizefighting
                problematical proboscidean procambium processional proclamation procrastinate
                procrastination procrastinator procreator proctologist proctorial procumbent
                productiveness productivity profascist professional professionalism
                professionalize professorial professorship profitability profiteering profitless
                profoundness progesterone proglottis prognosticate prognostication
                prognosticator programmable progressiveness progressivity prohibitionist
                prohibitor projectionist proliferation prolocutor prologuize prolongation
                promiscuousness promissory promulgation pronounceable pronouncement pronucleus
                pronunciamento pronunciation propagable propagandist propagandize propelling
                prophylactic propitiation propitiousness proportional proportionality
                proportionate propositus proprietorial proprietorship proprietress
                proprioception proprioceptive propulsive propylaeum prosciutti proscription
                proscriptive proselytizer proslavery prosodical prosopopoeia prostatectomy
                prostheses prostomium protactinium proteanism protectionism protectionist
                protectiveness protectorate protectorship proteiform protestation prothallus
                prothalmia protoactinium protohistory protohuman protostele prototypal
                prototypic prototypical protoxylem protozoology protrusile protrusive
                protuberance providential provincialism provitamin provocativeness psalterium
                psephological psephologist pseudocarp pseudoscience psittacine psychiatrist
                psychoanal psychoanalysis psychoanalyst psychoanalyze psychobabble psychological
                psychologist psychometric psychoneurosis psychoneurotic psychopathology
                psychosomatic psychotherapy psychotropic psychrometer pteranodon pteridophyte
                puberulent puerperium pugilistic pugnaciousness pulsimeter pulsometer pulverable
                pulverization pumpernickel punchboard punctiliousness pupiparous purification
                purposefulness pursuivant purtenance pushbutton pusillanimity pusillanimous
                putrefaction putrescent pycnometer pyrogallol pyrogenous pyrography pyrophoric
                pyrotechnics pyroxenite pyrrhotite quadrantal quadrilateral quadriplegia
                quadriplegic quadrireme quadrisect quadrivial quadruplex quadruplicate
                quadruplication quadrupole qualification quantifiable quantification
                quantitative quarrelsomeness quarterage quarterfinal quartermaster quartersaw
                quarterstaff quatrefoil quattrocento quenchless querulousness questionable
                questionably questionnaire quincentenary quinquefid quinquennial quintessence
                quintessential rabbitfish rachitides racketball racketeering raconteuse
                radicalization radioactivity radiochemistry radiographer radioisotope
                radiolocation radiologic radiological radiopaque radioscope radiotelegraph
                radiotelegraphy radiotelephone radiotelephony radiotherapy railwayman railwaymen
                rambunctious ramification rampageous ramrodding ramshackle randomization
                ransomware ranunculus rapaciousness rappelling rapprochement rarefiable
                ratifiable ratification ratiocination ratiocinator rationalization rationalness
                rattlehead rattlepate ravenousness rawinsonde readmitted readoption
                realistically reasonableness reasonless reassembly rebelliousness rebreather
                rebuttable recalcitrance recalcitrancy recalcitrant receivership receptionist
                receptiveness recidivate recidivous recipience reciprocality reciprocation
                recitativo recklessness reclaimant reclusiveness recognizable recognizably
                recognizance recognizee recognizor recoilless reconceive reconcilable
                reconciliation recondense reconditeness reconnaissance reconstructed recontract
                recrimination recrudescence rectangularity rectification rectorship recumbency
                recuperation redelivery redemptive redemptory redintegrate rediscount
                redistribute reductionist reemphasis reenergize reentrance reexchange refereeing
                reflectivity reflexiveness refractiveness refractivity refractometer
                refractoriness refreshments refrigerated refrigeration refrigerator
                refurbishment refuseniks refutative regimentation registration regretting
                regularization regurgitation rehabilitate rehabilitation reimbursement
                reimprison reinforcement reinscribe reinstatement reinstruct reinvestigate
                rejuvenation relationship relentlessness reliableness religieuse religiousness
                relinquishment remarkableness remediable remediless reminiscence remissible
                remissibly remittable remonetize remorselessness remuneration remunerative
                rencounter renouncement renunciant renunciation reparative reparatory
                repatriation repeatably repellence repellency repercussion repetitiousness
                repetitiveness rephotograph replenishment replicable reprehension representative
                reproducible republicanism repulsiveness reputability rescissory resentfulness
                reservedness reshipping resistible resistless resoluteness resourcefulness
                respectability respectfulness resplendence resplendency responsibility
                responsibleness responsiveness responsory restaurateur restfuller restlessness
                restrictiveness restructuring resumptive resupinate resurrection resuscitation
                resuscitator retentiveness reticulation retrenchment retrochoir retroflexion
                retrogression retrogressive retrospection retrospective retroversion reunionist
                revanchism revanchist revegetate revelatory reverberation reversible reversibly
                revertible revivification revocatory revolutionary revolutionist revolutionize
                rhapsodist rheostatic rheumatoid rhinoscopy rhizogenic rhododendron
                rhombencephalon rhombohedron rhomboidal rhythmless ribbonfish ribbonwood
                ridiculousness righteousness rightfulness rigorousness ritardando ritornello
                riverfront roadworthy roboticist robustious roentgenogram roisterous
                rollerskating romantically roofgarden roquelaure rosaniline rotational
                rubbernecker rubiaceous rubiginous rubricator rudderhead rudderless rufescence
                rustically ruthenious rutherfordium ruthlessness saccharase saccharate
                saccharify saccharine saccharoid sacerdotal sacerdotalism sacrilegious
                sacrosanctness saddletree sadomasochism sadomasochist sailboarding salaciousness
                salesmanship saleswomen saliferous salinization salpiglossis salpingectomy
                saltarello saltigrade salubriousness salutarily salutatorian salutatory
                salverform sanctification sanctimonious sanctitude sandbagged sanderling
                sanguinary sanguineness sanitarily sapiential sappanwood saprogenic sarcophagi
                sarmentose sarracenia sarsaparilla satanistic satisfaction satisfactorily
                satisfactory satyagraha scaleboard scandalization scandalmonger scansorial
                scaramouch scarification scatologic scatterbrain scenically schematism
                schematization scherzando schizophrenia schizophrenic schizothymia schlepping
                schlimazel scholastic scholasticism schoolchildren schooldays schoolfellow
                schoolmaster schoolmistress schoolteacher schussboomer scientifically
                scintillation scintillator sciolistic scleroprotein scratchily scratchiness
                screenwriter screenwriting scriptoria scriptwriter scrofulous scrubwoman
                scrupulosity scrupulousness sculptural scurrilousness seaborgium seamanlike
                seasonableness seaworthiness sebiferous seborrheic secessionism secessionist
                secondhand secretaryship secretiveness sectarianism sectionalism sectioning
                secularity secularization sedimentation seductiveness sedulousness segmentation
                segregable segregationist segregator seguidilla seismicity seismogram
                seismographer seismography seismologist selectable selenodont selenographer
                selenography selenology selflessness semeiology semiautomatic semiconductor
                semidarkness semidivine semifinalist semiformal semiliquid semination semipostal
                semiyearly senatorial sensationalism sensationalist sensationalize senselessness
                sensibleness sensitiveness sensitives sensitization sensitometer sensuosity
                sensuousness sentiently sentimentalism sentimentalist sentimentality
                sentimentalize separability separateness septically septicemic septicidal
                septuagenarian sequestration serendipitous serialization sericulturist
                serigraphs seriocomic serviceability serviceableness serviceberry servicemen
                servicewoman servomechanism sesquipedalian sestertium sevenpence shadowless
                shamefacedness shamefulness shamelessness shandrydan shapelessness sharecropper
                shareholding sharpshooter sharpshooting sheathbill sheepishness sheepshearing
                shellacked shellproof shiftlessness shinleaves shipbuilding shipentine
                shipfitter shipmaster shockproof shortcrust shortsighted shotgunned shovelnose
                shreddable shrewishness shrewmouse shrievalty shuffleboard sialagogue sicklebill
                siderolite sightlessness signalization significance significancy signification
                silviculture simplification simultaneity simultaneous sinistrality siphonophore
                sisterliness skateboarder skateboarding skillfulness skittishness slatternliness
                slaveholder sledgehammer sleeplessness sleepwalking slipperiness slothfulness
                slovenliness sluggishness smallholding snappishness snobbishness snowboarding
                sociableness socialization sociobiological sociobiologist sociobiology
                sociolinguistic sociological softheartedness solemnization solicitation
                solicitousness solidification solitariness somnambulant somnambulate
                somnambulism somnambulist sonorousness sophisticate sophisticated sophistication
                sorrowfulness soundproofing southeastward southwestward spaciousness
                speakerphone specialization specification speciousness spectrometer spectrometry
                spectroscope spectroscopical spectroscopy speechlessness speechwriter
                speleologist spellchecker spermatocyte spermatophyte spermatozoid spermatozoon
                spiegeleisen spinsterhood spiritualism spiritualist spirituality spiritualize
                spitefulness splatterpunk splenomegaly spokesperson sportiveness sportscaster
                sportsmanlike sportsmanship sportswriter spotlessness sprightliness spuriousness
                squeamishness stabilization stalwartness standardization standoffishness
                staphylococcus statelessness statesmanship stationmaster statistician
                steadfastness stealthiness steamfitting steeplechase stenographer stepchildren
                stepdaughter steppingstone stereotypical sterilization sternutation sternutatory
                stigmatization stockbreeder stockbroking storytelling stouthearted straightaway
                straightedge straightener straightforward straightness straitjacket
                strangulation stratification stratosphere streetwalker strengthener
                strenuousness streptococcus streptokinase streptomycin streptothricin
                strikebreaker strontianite strophanthus structuralism structuralist stubbornness
                studiousness stultification stupefaction subcommittee subconscious subcontinent
                subcontractor subcutaneous subdirectory subinfeudate subjectiveness subjectivism
                subjectivity sublieutenant submissiveness subnormality subordination
                subpopulation subprofessional subscription subservience subsidiarity
                subsidization substantially substantiate substantiated substantiation
                substitution substructure subversiveness successional succinctness
                suggestibility suggestiveness suitableness sulfanilamide summarization
                sumptuousness superabundance superannuate superannuation supercharger
                supercilious supercomputer superconduct superconductor supererogate
                supererogation superfetation superficiality superfluousness superhighway
                superimposition superintendence superintendency superintendent supernatural
                supernaturalism supernumerary superordinate superpatriotism superposition
                supersaturate supersaturation superscription supersession superspreader
                superstition superstitious superstructure supervention supplementation
                supplication suppositious suppressible surmountable surrejoinder surreptitious
                surroundings surveillance susceptibility suspiciousness sustainability
                sustentation swashbuckler swashbuckling swordsmanship syllabication
                syllabification symbolization sympathetically synchroflash synchronicity
                synchronization synecdochical systematical systematization tablespoonful
                tachistoscope tactlessness talkativeness tangibleness tantalization taskmistress
                tastefulness tastelessness tatterdemalion tautological technicality
                technological technologist telecommuter telecommuting teleconference
                telegraphese telegraphist telemarketer telemarketing telencephalon
                telephotography teleprocessing teleprompter teletypewriter televangelism
                televangelist temperamental temperateness tempestuousness temporariness
                tenaciousness tendentiousness tenderhearted tentativeness tercentenary
                tercentennial tergiversate terminological terribleness territoriality
                terrorization tessellation testosterone tetrachloride tetracycline thankfulness
                thanklessness thanksgiving theatricality thenceforward theoretician theosophical
                therapeutical therapeutics thermocouple thermodynamic thermodynamical
                thermodynamics thermoplastic thermosphere thermostatic thoroughbred thoroughfare
                thoroughness thoroughwort thoughtfulness thoughtlessness thromboembolism
                thrombokinase thromboplastin thumbscrew thundercloud thundershower thunderstorm
                ticklishness timelessness timorousness tirelessness tiresomeness toastmistress
                togetherness tonsillectomy toothsomeness topographical tortoiseshell
                tortuousness totalitarian totalitarianism toxicological toxicologist
                tracheostomy tractability tractableness tradespeople traditionalism
                traditionalist tragicomical trailblazing trainspotter traitorousness
                tranquilizer transcendence transcendency transcendent transcendental
                transcription transcriptional transduction transferable transference
                transfiguration transformation transgender transgression transgressor
                transistorize transitional transitiveness transitivity transitoriness
                translatable transliterate transliteration translucence translucency
                transmigrate transmigration transmission transmittance transmitting transmogrify
                transmutability transmutation transnational transparency transphobia
                transpiration transplantation transportation transposition transshipment
                transvestism transvestite transvestitism trapezohedron trapshooting
                treacherousness tremulousness trephination triangulation tribromoethanol
                tricentennial triglyceride trigonometry trinitrotoluene trisaccharide
                trivialization troublemaker troubleshoot troubleshooter troubleshooting
                trustfulness trustworthiness truthfulness tuberculosis tumultuousness
                turbocharger typification typographical tyrannosaurus ubiquitousness
                ultracentrifuge ultramicroscope ultrasonograph ultrasonography unacceptability
                unaffectedness unalterability unassertiveness unassumingness uncertainness
                uncomprehending uncompromising unconditional uncooperative unctuousness
                underachieve underachiever undercarriage underclassman underclothes
                underclothing undercoating undercurrent underemployment underestimate
                underestimation underexposure undergarment undergraduate underhandedness
                underpayment underpinning underproduction undersecretary understanding
                understatement undersurface undervaluation unearthliness unexpectedness
                unflappability ungainliness ungraciousness unimportance uninterrupted
                universalism universality universalize unmentionable unmentionables unnilpentium
                unnilquadium unprecedented unprofessional unprofitability unquestioning
                unrestrained unsavoriness unselfconscious unsightliness unsociability
                unspectacular unstableness unsuspecting unwieldiness upperclassman urbanization
                urbanologist utilitarianism uxoriousness vainglorious valedictorian
                valetudinarian vaporization variableness vasoconstrictor vasodilation
                vaudevillian vegetarianism veggieburger venerability vengefulness ventriloquism
                ventriloquist venturesomeness venturousness verbalization verification
                verisimilitude versification veterinarian vibraphonist vicariousness
                victimization videocassette vilification villainousness vindictiveness
                violoncellist virtuousness visualization vitalization viticulturist vitrifaction
                vitrification vituperation vituperative vivaciousness vivification
                vivisectionist vocalization vociferation vociferousness voicelessness
                voluminousness volunteerism voluptuousness voraciousness vulcanization
                vulgarization vulnerability walkingstick warmheartedness warmongering
                wastefulness watchfulness waterboarding watercolorist waterproofing weatherboard
                weatherglass weatherization weatherperson weatherproof weatherstrip
                weightlessness weightlifter weightlifting welterweight westernization
                whatchamacallit whimsicality whippersnapper whippoorwill wholehearted
                wholesomeness whortleberry wicketkeeper witchdoctor wonderfulness woolgathering
                workingwoman worthlessness wretchedness wrongfulness wrongheadedness
                yellowhammer yellowthroat youthfulness
            ]],
        },
        es = {
            comuns = [[
                abeja abismo abrazo abrigo abuelo accion aceite acero actriz acuerdo adios
                agosto agua aguila aguja ahora aire ajedrez ala alarma alba alegria alfombra
                algodon alma almuerzo alto altura amanecer amarillo ambiente amigo amor ancla
                anillo animal antena antifaz antiguo anuncio apodo arbol arco arena armadura
                armario arroz arte asiento asunto atleta audaz aula aurora aventura avestruz
                avion azucar azul azulejo babosa bahia bailarin baile bajo balanza balcon
                ballena balon banco banda bandera bano barba barco barniz barrio baston basura
                batalla bateria baul bebe belleza berenjena besar beso biblioteca bicicleta
                bigote billete blanco blusa boca boda bola bolsa bombero bonito borax borrador
                bosque bota botella boton brazo brillo brisa bronce bruja bruma buey buho
                burbuja burro caballo cabana cabello cabeza cabra cacao cadena cadera cafe caja
                calcetin calendario caliz calle calor cama camello camino camisa campana campeon
                campo cancion canguro canica cansancio cantante capa capaz capital cara caracol
                caramelo carne carpeta carrera carro carta casa casco castillo catarata cazador
                cebolla ceja celda cena centro cepillo cerca cereza cero cerro cerviz cesta
                chaqueta chico chimenea chiste chocolate cicatriz ciego cielo ciencia cierre
                cigarra cine cinta cinturon circo ciudad clase clave clima climax cobre cocina
                cocodrilo codo codorniz cofre cohete cojin cola colina collar color columna
                cometa comida compas concha conejo consejo convoy copa corazon cordon corona
                correo corriente cortex cortina cosa costa crayon cristal cruz cuaderno cuadro
                cuchara cuchillo cuello cuento cuerda cuerpo cueva cuidado cumbre cuna curva
                dado danza dedo defensa delfin dentista deporte derecha desafio desayuno
                desierto destino diablo diamante diario dibujo diccionario diente dieta dinero
                dinosaurio direccion disco disfraz distancia doctor dolor domingo domino dragon
                ducha duende dulce durazno duro eclipse edificio eficaz ejemplo ejercito
                elefante elevador embudo emocion empresa enano energia enero enigma ensalada
                entrada envase epoca equipo esbeltez escalera escama escasez escoba escritor
                escudo escuela escultura esmeralda espacio espada espejo esperanza espina
                esponja esposa esquina estacion estadio estante estatua estrechez estrella
                estudio etapa eterno examen fabrica falda familia fantasma faro favor febrero
                felicidad feliz fenix feria feroz fiebre fiesta figura fila filtro final firma
                flauta flecha flor foca fogata fondo forma foto fresa frio frontera fruta fuego
                fuente fuerza fuga fugaz funk futuro gafas galaxia galleta gallina gallo
                ganancia garaje garra garza gato gaviota gemelo genio gente geografia gesto
                gigante gimnasio globo golfo golpe goma gorila gorra gota grado granja grano
                grieta grillo gripe gris grito grupo guante guerra guerrero guia guisante
                guitarra gusano gusto habito hacha hada halcon hamaca harina hechizo helado
                helice helix herencia hermano heroe herramienta hielo hierba hierro higado hilo
                himno historia hobby hogar hoja hombre hongo hora horario horizonte hormiga
                horno hospital hotel hoyo hueso huevo humano humo huracan idea idioma iglesia
                imagen iman imperio impuesto incendio indio infancia infinito insecto instante
                instrumento invalidez invierno invitado isla itinerario izquierda jabon jaguar
                jamon jardin jarra jaula jefe jersey jinete jirafa joven joya juego jueves
                jugador jugo julio jungla junio junto justicia juventud karaoke karate kayak
                kilometro kimono kiwi koala laberinto labio lado ladrillo lago lagrima laguna
                lampara lana lancha lapiz largo lata latex lavabo leche lector lectura legumbre
                lejos lengua lente leon letra leyenda libertad libro licor liebre limon limpieza
                linea linterna liquido lista llama llanura llave llegada lluvia lobo local
                locura lodo lombriz lucidez luciernaga lugar lujo luna lunes luz madera madre
                madrugada maestro mago maiz maleta malla mama manana mandarina mano manta
                manzana mapa maquina mar maraton marcador mariposa martes martillo marzo masa
                mascara mastil matematica matriz mazorca mecanico medalla medico medio mejilla
                melon memoria mensaje mente mercado mesa metal meteoro metro miedo miel
                miercoles milagro minuto mirada misterio mochila moneda mono monstruo montana
                morado moral mordaz mosca motor muela muerte mujer muleta mundo muralla museo
                musica nada nadador naranja nariz natacion naturaleza navaja nave navidad
                neblina negocio nervio nido niebla nieve ninfa ninja nino nitidez nivel noche
                nombre norte nota noticia noviembre nube nudo nuez numero oasis objeto obra
                oceano ocho octubre oeste oficina oido ojo ola oleo olivo olla ombligo onda onix
                oreja organo orgullo orilla oro orquesta oscuro oso otono oveja oxigeno
                paciencia padre paella paisaje pajaro palabra palacio paleta palma palo paloma
                pan panaderia pantalla pantera papa papel paraguas pared pareja parque parte
                pasado pasaje paseo pasta pastel patata patio pato pausa payaso paz pecho pedazo
                pegamento peine pelicula peligro pelo pelota peluche pension pera perdiz perfume
                pergamino periodico perla permiso perro persona pertinaz pesca pescado peso pez
                piano picaporte pie piedra piel pierna pijama pila piloto pimienta pina pincel
                pinguino pino pintor piramide pirata piscina piso pista pizarra planeta planta
                plastico plata plato playa plaza pluma poder poema poesia policia pollo polvo
                pomada ponche portal princesa puente puerta puerto pulpo pulsera punk puno punto
                quemadura queso quetzal quimera quimica quince quinto quiosco rabo radio raiz
                rama rana ranura rapidez rascacielos rata raton rayo razon realidad receta
                recibo recuerdo red reflejo regalo regla reina reino relax reloj remedio remo
                repisa reposo resorte respuesta restaurante reunion revista rey rico rigidez rio
                riqueza risa ritmo robot roca rocio rock rodilla rojo rollo romance ropa rosa
                rostro rubi rueda rugby ruido ruina ruta sabado sabana sabor sacapuntas saco
                safari sagaz sal sala salida salmon salon salsa saltamontes salto salud samurai
                sandalia sandia sangre sapo satelite secreto sed seda segundo semana semilla
                senal sencillez sendero sensatez sentido sepia serpiente servicio show sierra
                siesta siglo silla sillon simbolo sirena sistema sitio sol soldado sombra
                sombrero sonrisa sopa sorpresa sotano suelo sueno suerte sueter sur susurro
                tabla tacon tambor tapa tapete tapiz taquilla tarde tarea tarjeta taza teatro
                techo tecla tejado tela telefono tema templo tenaz tenedor tenis terremoto
                tesoro testigo tia tiburon tiempo tienda tierra tigre tijera timbre timidez
                timido tinta tio tiza toalla tobillo tomate torax tormenta toro torre tortuga
                tos trabajo trampa tranvia trapo tren trigo trineo trovador trueno tubo tulipan
                tunel turquesa ultimo una unguento unico unicornio uniforme universo uno urbano
                urgencia urraca uso usuario utensilio uva vaca vacio vagon valle valor vampiro
                vapor vaquero vaso vecino vejez vela velero veloz vena venado vendedor ventana
                ventilador verano verdad verde vereda verniz vestido via viaje victoria vida
                vidrio viejo viento viernes vinagre vino violeta violin virrey visita vista
                vitrina viudez vizcacha volante volcan voluntad voraz voz vuelo waffle xantina
                xantofila xenofilia xenofobia xenofobo xenon xerocopia xerofilo xerofito
                xeroftalmia xerografia xifoides xilema xileno xilofago xilofono xilografia
                xilosa xoconostle yate yegua yema yerba yoga yogur yuca zafiro zanahoria zanja
                zapato zarza zebra zombi zona zoologico zorro zumbido zurdo
            ]],
            extras = [[
                abanico abedul abertura abogado abono abrazar abrir absurdo acabar acantilado
                accidente acento aceptar acera acompanar acordar acordeon acostar acrobata actor
                adivinar admirar adorar aduana adulto aeropuerto afilador agenda agradecer
                agricultor aguacate aguacero alacran alambre albondiga alboroto alcalde alcance
                alcancia alcanzar aldea alegrar alegre alerta alfiler aliado alimento alivio
                almacen almendra almohada almorzar alquilar altar altavoz alumno amapola amar
                ambulancia amenaza amistad amuleto analista andamio andar anecdota anfibio
                anguila anis anoche anotar antorcha anzuelo apagar apagon aparecer apartamento
                apellido apetito aplaudir aplauso aprender apretar aprovechar apuesta apuntar
                arado arandano arbusto archivo ardilla arenque argolla armadillo aroma arquero
                arquitecto arrecife arreglar arroyo artesano ascensor asfalto asistente asistir
                aspiradora asteroide asustar atacar atardecer ataud atencion atlas atmosfera
                atomo atravesar atun audiencia auditorio autobus autor avalancha avellana avena
                avenida avisar aviso ayudar azada azafran azotea azucena bacalao bachillerato
                bailar bajar bala balneario bambu banar bandeja bandido banquero baraja
                barandilla barbero barraca barranco barrer barrera barril bastidor basurero
                batata batidora beber bebida bellota bendicion bicho billar binoculares biologia
                biombo bisabuelo bisonte bizcocho bloque bobina bocadillo bochorno bodega
                bombilla bombon bondad borde borrasca bostezo botanica botiquin boveda bravura
                brecha brillar brocha bromear brote brujula bucle bufalo bufanda bufon buitre
                bulevar bulto burla buscar buzon cabaret caber cabina cable cacahuete cacique
                cactus caer cafetera caiman cajon calabaza calabozo calamar calavera caldera
                caldo calefaccion calesa calibre calidad caliente callar camara camaron camarote
                cambio camilla caminar camion campesino canal canario cancha candado candelabro
                canela cangrejo canoa canon cantar cantera cantina capataz capitan capullo
                caracola caratula caravana carbon carcel cardenal carga cargar caries carnaval
                carnero carnicero carpa carpintero carreta carroza cartero carton cartucho casar
                casino castana castigo catalogo catedral cavar cavidad cazuela cebada cebra
                cedro ceguera celebracion celeste cementerio cemento ceniza centavo centinela
                ceramica cerdo cereal cerezo cerilla cerrar cerrojo certamen cesto chacal chaman
                champinon chancla chandal chaparron charco charla chicle chinche chorro choza
                chuleta churro ciclista ciclon ciguena cilindro cima circuito cisne cita
                ciudadano clarinete claustro clavel clavo clinica cobertizo cobija cocinar
                cocinero coctel cofradia coger colcha colchon colega colegio colgar colibri
                colmena colmillo colonia columpio comadreja combate comedor comenzar comer
                comisario companero compota comprar comunidad concierto concurso condor conducir
                confeti congreso conocer conseguir conserje consola constelacion construir
                contador contar continuar contrato copete coral corbata cordero cordillera
                corneta coro corral correa corredor correr cortar corteza cortijo cosecha coser
                costilla costumbre cotorra crecer creer creyente cria criar crimen crisantemo
                croqueta crucero crudo cruzar cuadrilla cuartel cuenco cuervo cuesta cuidador
                cuidar culebra cumplir cuota cupon cupula curandero curar dama dardo datil
                debate deber decidir decir decoracion defecto dejar delantal delegado delicia
                demonio denuncia dependiente deposito derramar derrota desayunar descansar
                descanso descubrir descuento desear deseo desfile despacho despensa despertador
                destello detective detergente deuda diagrama dialecto dialogo dibujante dibujar
                dictador diferencia dificultad digestion dignidad dilema diploma director
                discurso disfrutar disputa distrito diversion dividir division doblar doctrina
                dolencia domador dominio donativo dormir dormitorio dosis dragona drogueria
                dudar duelo duna duquesa ebanista ecologia economia edicion editor educacion
                educar efecto egoista elastico eleccion elector electrodo elegir elenco elogio
                embalaje embarcacion emblema embrion emigrante empezar empleo encaje encender
                enchufe enciclopedia encina encontrar enfermeria enfermero enfrentar enganar
                engranaje enredadera ensayo ensenanza ensenar entender entierro entrar entregar
                entrevista enviar envoltorio epidemia episodio equilibrio equipaje equivocar
                erizo erosion escalada escandalo escarabajo escenario escoger escolar esconder
                escopeta escribir escritorio escuadra escuchar escultor esfera esmalte espagueti
                espalda espanto esparrago espectaculo esperar espiga espinaca espiral espuma
                esqueleto esquiar estaca estampa estandarte estanque estatura estera estiercol
                estilo estomago estrategia estrecho estribo estructura estudiante estudiar
                estufa etiqueta evento evidencia evitar excursion exhibicion exilio existencia
                expedicion experiencia explicar explosion exposicion extintor extracto fabricar
                fabula fachada faisan faja falta faltar fama fanfarria faraon farmacia fatiga
                favela fenomeno ferreteria ferrocarril fertilidad festival fibra ficha fideo
                filete filial filosofo finca fingir firmar flamenco flan fleco flotador fluido
                folleto fontanero forastero forja formulario fortuna fosil fotografo fracaso
                fragancia fragil fraile frambuesa frasco frazada frecuencia fregadero fregar
                frente fresco fruteria fuerte fulano fundador furgon fusil fusion gabinete gaita
                galeria gallinero galope gamba ganado ganador ganar gangster garbanzo garganta
                gargola garrafa gasolina gastar gastronomia gatillo gaucho gavilan gelatina
                generacion gerente gimnasia ginebra girasol glaciar gloria gnomo golondrina
                golosina gorrion gotera gracia grada grafico granada granero granizo grasa grava
                gremio gritar grua grueso gruta guardar guardia guarida guepardo guiar guijarro
                guinda guino guion guirnalda guiso guitarrista gustar habitat hablar hacer
                hacienda hallazgo hamburguesa haragan harapo haren hazana hechicero hectarea
                helicoptero hemisferio herbivoro heredar heredero herida herir hermandad
                hermosura herradura hervidor hervir hidrante hiedra hiena higuera hijastro
                hilera hipopotamo hipotesis hispano hocico hogaza holgura hombro homenaje
                honestidad hormiguero horquilla horticultor hospedaje hostal hostilidad hucha
                huella huerta huesped huir humildad humorista iglu ignicion igualdad ilustracion
                imaginar imitacion impermeable impresora impulso incienso incisivo indicio
                industria infiel infierno influencia informacion ingeniero ingrediente inicio
                inquilino inscripcion insecticida inspector instituto insulto intencion interes
                interruptor intervalo intestino intriga inundacion invasion inventar inventor
                investigador invitacion iris jabali jaca jacinto jalea jarabe jardinero jarron
                jazmin jeroglifico jornada jubileo judia juerga jugada jugar juglar juguete
                juicio junco juntar jurado jurar kilogramo kiosco laboratorio lacayo lacre
                ladron lagarto lamento lancero lanza lapicero lapida largavista lasana lastima
                latitud laud laurel lavanderia lavaplatos lavar lazo lealtad lechuga lechuza
                leer legado legion lejia lemming lena lenceria lentejuela leopardo letrero
                levantar libelula liberal libertador libreta licencia lienzo liga ligadura
                lijadora lima limbo limosna limpiador linaje lince liquidacion lirio liston
                litoral llamar llanto llavero llegar llenar llevar llorar llover localidad
                locomotora logotipo longitud loro loteria lucero lucha luchar lugareno lunar
                lupa lustre macarron maceta machete madriguera madrina magia magnate maletin
                mamut manada mancha mandar mandato manguera manicura manivela mansion manteca
                mantel manual manzano maqueta marcar marea margarita mariachi marinero marmita
                marmota marron martirio mascar mascota matadero matorral matricula mausoleo
                mediador medicina medida medir medusa mejillon melena melocoton melodia membrana
                mendigo menta mentir mentira mercader mercadillo mercurio merecer meridiano
                merienda meson mestizo meteorito metodo mezclar microbio miembro migaja milenio
                millonario mimbre minero ministro minoria mirador mirar miseria misil mision
                mitad mito moda modelo moho molino molusco momia monarca monasterio monopatin
                montaje monumento morada morder mordisco morena mosaico mostaza mostrar motin
                motocicleta mover movimiento muchedumbre mudar muebles muelle muestra mugre
                mulato multitud muneca municipio murcielago nabo nacer nacimiento nacion nadar
                nafta narciso narrador nata navegante navegar necesidad necesitar nectarina
                negar nene neon nevera nicho ninera nobleza nombrar noria nostalgia notar
                notario novato novela noviazgo nudillo nuera nutria obedecer obediencia obelisco
                obrero observar obstaculo ocaso octavo ocupar odiar odisea oferta oficial
                ofrenda oler olimpiada olmo olor olvidar oraculo orador orangutan orden
                ordenador oregano orfanato organillo ornamento orquidea ortiga oruga osadia
                osamenta ostra ovillo pabellon pacto padrino pagar paisano pajar pajarita
                paladar palanca palestra paliza palmera palomar palomita pancarta panda pandilla
                panel panuelo papagayo papeleria papiro paquete paraiso parar parcela parecer
                parentesis parlamento parroquia partera partir pasaporte pasar pasarela pasear
                pasillo pastor patinete patron patrulla pavo peaje peaton pecera pedal pedestal
                pedir pedregal pegar pellizco peluquero pendiente pendulo penicilina pensar
                peonza pepino perchero perder perdonar pereza perfil perico perifollo permitir
                persiana personaje pertiga pesadilla pesar pescar pesebre pestana petalo
                petirrojo petroleo pezuna piara picadura pichon pidgin piedad pilar pilote
                pimiento pinacoteca pinchazo pintar pinza pionero pirana pirueta pisada pisar
                pistola pitillo pizarron placa plaga plan plancha plano plantar plantilla
                plataforma platano platillo plebeyo plegaria pleito plomero poblacion pobreza
                poeta polea polilla pollito polo pomelo pomo pompa poner porteria portico posada
                poste postre potrero pozo prado precio precipicio predicador prefecto pregon
                preguntar premio prender prensa preocupar preparar presidente prestamo
                presupuesto primavera primo principio prision privilegio probar probeta
                procesion producir producto profesor profeta programa promesa prometer
                pronostico propina propuesta protector proteger proverbio provincia prueba
                psicologo publicidad pueblo puercoespin pulga pulir pulmon pulpa pulpito punzon
                pupitre pureza quebrar quedar quehacer quemar querer quesadilla quirofano quiste
                quitar quitasol rabadilla rabano rabino racimo radar radiador raja ramillete
                rampa rancho rapaz rasgar rastrillo rastro ratonera realizar rebano rebelde
                recado recamara recepcion recibir recinto recluta recoger recompensa recordar
                recorrido recreo redaccion redil reflector reflexionar reforma refugio regadera
                regalar regar regata regimen region registro regreso reinado relampago relato
                relevo relicario relieve religion remero remolque renacuajo rencor rendicion
                renuevo reparto repertorio repetir reportaje represa republica requeson rescate
                reserva resfriado respiracion resumen retablo reten retrato revancha revolucion
                rezar rezo ribera rifle rincon rinon risco ritual rival robar roble robledo
                rodeo rodillo romeria rompecabezas romper ronda rosal rosca roseta rotonda rubor
                ruedo ruisenor rumor saber sabio sable sacar sacerdote sacrificio sacudida
                sacudir saga salamandra salchicha saleroso salir saltar saludar salvar
                salvavidas samba sancion santuario sarampion sarcofago sardina sargento sarten
                sastre satira saxofon sebo secador secar secretario secuela sedal sede segador
                seguidor seguir sello selva semaforo semblante senado senora sensacion sentar
                sentencia sentinela sentir separar sequia serenata serie serpentina serrucho
                servilleta servir sesion seto sherpa sibila sidra siega sigilo silbato silencio
                silueta silvestre sima simpatia sinfonia sintoma sirviente soberano sobrino
                sociedad socorro sofa soldador soledad soltar solucion sombrilla sonaja sonar
                sonata sonido soplar soplete sorbete sorteo subasta subida subir submarino
                suburbio suceso sudor suegra sueldo suero sufrir sujetar sultan suplemento surco
                susto tabaco tablero tablon taburete tacho tajada talento taller talon tamano
                tamiz tangerina tanque tapadera tapar tapiceria tarantula tarifa tarima tarro
                tartana tatuaje tazon tebeo tecnologia tejedor tejon teleferico telescopio telon
                temblor temer temor temporada tendedero tendon tener tenista tentaculo teoria
                terminal terminar termometro ternera terraza terreno territorio tertulia textura
                tiara tictac tiendas tijeras timon tinaja tintero tintoreria tiovivo tirano
                tirar tirita titan titulo tobogan tocador tocar tocino tolva tomadura tomar
                tonada tonel tonelada topo torbellino torcaza torcer toreo torneo tornillo
                torpedo torrente torreon tortilla tostada totem trabajador trabajar tradicion
                traer trafico tragedia traicion traje trampolin tranquilidad transporte trapecio
                trasero tratado tratar trebol tregua trenza triangulo tribu tribuna tributo
                trigal trillo trinchera tripulacion triunfo trofeo trombon trompeta tronco tropa
                trote trozo truco trueque tuberia tumba tumulto tunica turbante turbina turismo
                turista turno turron tutor ubre ultimatum umbral unanimidad union urbanismo urna
                usar utopia vacante vacuna vagabundo vaina vajilla valer valiente valla vals
                vanguardia variedad varilla vasallo vecindario vegetacion vehiculo veinte vejiga
                velocidad vencer vendaval vender veneno venir ventaja verbena verdugo verduleria
                verguenza verruga version vertigo vestibulo vestir vestuario veta veterano
                viaducto viajar vibracion vicio victima vidriera vigilante vikingo villa villano
                vinagreta vinatero vinedo virgen virtud virus visera visillo vitral viudo vivero
                vivir vocabulario volar voluntario volver votar vuelta yacimiento yerno yesca
                yodo yunque zaguan zambullida zancada zanco zangano zapatero zarpa zarzuela
                zocalo zodiaco zopilote zorra zorzal zueco
            ]],
            plurais = [[
                abanicos abedules abejas aberturas abismos abogados abonos abrazos abrigos
                absurdos abuelos acantilados accidentes acciones aceites acentos aceras aceros
                acordeones acrobatas actores actrices acuerdos aduanas adultos aeropuertos
                afiladores agendas agostos agricultores aguacates aguaceros aguas aguilas agujas
                ahoras aires ajedreces alacranes alambres alarmas albas albondigas alborotos
                alcaldes alcances alcancias aldeas alegres alegrias alertas alfileres alfombras
                algodones aliados alimentos alivios almacenes almas almendras almohadas
                almuerzos altares altavoces altos alturas alumnos amaneceres amapolas amarillos
                ambientes ambulancias amenazas amigos amistades amores amuletos analistas anclas
                andamios anecdotas anfibios anguilas anillos animales anoches antenas antifaces
                antiguos antorchas anuncios anzuelos apagones apartamentos apellidos apetitos
                aplausos apodos apuestas arados arandanos arboles arbustos archivos arcos
                ardillas arenas arenques argollas armadillos armaduras armarios aromas arqueros
                arquitectos arrecifes arroces arroyos artes artesanos ascensores asfaltos
                asientos asistentes aspiradoras asteroides asuntos atardeceres ataudes
                atenciones atletas atmosferas atomos atunes audaces audiencias auditorios aulas
                auroras autores avalanchas avellanas avenas avenidas aventuras avestruces
                aviones avisos azadas azafranes azoteas azucares azucenas azulejos azules
                babosas bacalaos bahias bailarines bailes bajos balanzas balas balcones ballenas
                balnearios balones bancos bandas bandejas banderas bandidos banos banqueros
                barajas barandillas barbas barberos barcos barnices barracas barrancos barreras
                barriles barrios bastidores bastones basuras basureros batallas batatas baterias
                batidoras baules bebes bebidas bellezas bellotas bendiciones berenjenas besos
                bibliotecas bichos bicicletas bigotes billares billetes biologias biombos
                bisabuelos bisontes bizcochos blancos bloques blusas bobinas bocadillos bocas
                bochornos bodas bodegas bolas bolsas bomberos bombillas bombones bondades
                bonitos bordes borradores borrascas bosques bostezos botanicas botas botellas
                botiquines botones bovedas bravuras brazos brechas brillos brisas brochas
                bronces brotes brujas brujulas brumas bucles bufalos bufandas bufones buhos
                buitres bulevares bultos burbujas burlas burros buzones caballos cabanas
                cabellos cabezas cabinas cables cabras cacahuetes cacaos caciques cadenas
                caderas cafes cafeteras caimanes cajas cajones calabazas calabozos calamares
                calaveras calcetines calderas caldos calendarios calesas calibres calices
                calidades calientes calles calores camaras camarones camarotes camas cambios
                camellos camillas caminos camiones camisas campanas campeones campesinos campos
                canales canarios canchas canciones candados candelabros canelas cangrejos
                canguros canicas canoas canones cansancios cantantes canteras cantinas capaces
                capas capataces capitales capitanes capullos caracolas caracoles caramelos caras
                caratulas caravanas carbones carceles cardenales cargas carnavales carneros
                carnes carniceros carpas carpetas carpinteros carreras carretas carros carrozas
                cartas carteros cartones cartuchos casas cascos casinos castanas castigos
                castillos catalogos cataratas catedrales cavidades cazadores cazuelas cebadas
                cebollas cebras cedros cegueras cejas celdas celestes cementerios cementos cenas
                cenizas centavos centinelas centros cepillos ceramicas cercas cerdos cereales
                cerezas cerezos cerillas ceros cerrojos cerros certamenes cervices cestas cestos
                chacales chamanes champinones chanclas chandales chaparrones chaquetas charcos
                charlas chicles chicos chimeneas chinches chistes chocolates chorros chozas
                chuletas churros cicatrices ciclistas ciclones ciegos cielos ciencias cierres
                cigarras ciguenas cilindros cimas cines cintas cinturones circos circuitos
                cisnes citas ciudadanos ciudades clarinetes clases claustros claveles claves
                clavos climas clinicas cobertizos cobijas cobres cocinas cocineros cocodrilos
                cocteles codornices codos cofradias cofres cohetes cojines colas colchas
                colchones colegas colegios colinas collares colmenas colmillos colonias colores
                columnas columpios comadrejas combates comedores cometas comidas comisarios
                companeros compotas comunidades conchas conciertos concursos condores conejos
                congresos consejos conserjes consolas contadores contratos copas copetes corales
                corazones corbatas corderos cordilleras cordones cornetas coronas coros corrales
                correas corredores correos corrientes cortezas cortijos cortinas cosas cosechas
                costas costillas costumbres cotorras crayones creyentes crias crimenes
                crisantemos cristales croquetas cruceros cruces crudos cuadernos cuadrillas
                cuadros cuarteles cucharas cuchillos cuellos cuencos cuentos cuerdas cuerpos
                cuervos cuestas cuevas cuidadores cuidados culebras cumbres cunas cuotas cupones
                cupulas curanderos curvas dados damas danzas dardos datiles debates decoraciones
                dedos defectos defensas delantales delegados delfines delicias demonios
                dentistas denuncias dependientes deportes depositos derechas derrotas desafios
                desayunos descansos descuentos deseos desfiles desiertos despachos despensas
                destellos destinos detectives detergentes deudas diablos diagramas dialectos
                dialogos diamantes diarios dibujantes dibujos diccionarios dictadores dientes
                dietas diferencias dificultades digestiones dignidades dilemas dineros
                dinosaurios diplomas direcciones directores discos discursos disfraces disputas
                distancias distritos diversiones divisiones doctores doctrinas dolencias dolores
                domadores domingos dominios dominos donativos dormitorios dragonas dragones
                droguerias duchas duelos duendes dulces dunas duquesas duraznos duros ebanistas
                eclipses ecologias economias ediciones edificios editores educaciones efectos
                eficaces egoistas ejemplos ejercitos elasticos elecciones electores electrodos
                elefantes elencos elevadores elogios embalajes emblemas embriones embudos
                emigrantes emociones empleos empresas enanos encajes enchufes encinas energias
                eneros enfermerias enfermeros engranajes enigmas enredaderas ensaladas ensayos
                ensenanzas entierros entradas entrevistas envases envoltorios epidemias
                episodios epocas equilibrios equipajes equipos erizos erosiones esbelteces
                escaladas escaleras escamas escandalos escarabajos escaseces escenarios escobas
                escolares escopetas escritores escritorios escuadras escudos escuelas escultores
                esculturas esferas esmaltes esmeraldas espacios espadas espaldas espantos
                esparragos espectaculos espejos esperanzas espigas espinacas espinas espirales
                esponjas esposas espumas esqueletos esquinas estacas estaciones estadios
                estampas estandartes estanques estantes estatuas estaturas esteras estiercoles
                estilos estomagos estrategias estrecheces estrechos estrellas estribos
                estructuras estudiantes estudios estufas etapas eternos etiquetas eventos
                evidencias examenes excursiones exhibiciones exilios existencias expediciones
                experiencias explosiones exposiciones extintores extractos fabricas fabulas
                fachadas faisanes fajas faldas faltas famas familias fanfarrias fantasmas
                faraones farmacias faros fatigas favelas favores febreros felices felicidades
                fenomenos ferias feroces ferreterias fertilidades festivales fibras fichas
                fideos fiebres fiestas figuras filas filetes filiales filosofos filtros finales
                fincas firmas flamencos flanes flautas flechas flecos flores flotadores fluidos
                focas fogatas folletos fondos fontaneros forasteros forjas formas formularios
                fortunas fosiles fotografos fotos fracasos fragancias fragiles frailes
                frambuesas frascos frazadas frecuencias fregaderos frentes fresas frescos frios
                fronteras frutas fruterias fuegos fuentes fuertes fuerzas fugaces fugas fulanos
                fundadores furgones fusiles fusiones futuros gabinetes gaitas galaxias galerias
                galletas gallinas gallineros gallos galopes gambas ganadores ganados ganancias
                gangsteres garajes garbanzos gargantas gargolas garrafas garras garzas gasolinas
                gastronomias gatillos gatos gauchos gavilanes gaviotas gelatinas gemelos
                generaciones genios gentes geografias gerentes gestos gigantes gimnasias
                gimnasios ginebras girasoles glaciares globos glorias gnomos golfos golondrinas
                golosinas golpes gomas gorilas gorras gorriones gotas goteras gracias gradas
                grados graficos granadas graneros granizos granjas granos grasas gravas gremios
                grietas grillos gripes gritos gruas gruesos grupos grutas guantes guardias
                guaridas guepardos guerras guerreros guias guijarros guindas guinos guiones
                guirnaldas guisantes guisos guitarras guitarristas gusanos gustos habitos hachas
                haciendas hadas halcones hallazgos hamacas hamburguesas haraganes harapos
                harenes harinas hazanas hechiceros hechizos hectareas helados helices
                helicopteros hemisferios herbivoros herederos herencias heridas hermandades
                hermanos hermosuras heroes herraduras herramientas hervidores hidrantes hiedras
                hielos hienas hierbas hierros higados higueras hijastros hileras hilos himnos
                hipopotamos hispanos historias hocicos hogares hogazas hojas holguras hombres
                hombros homenajes honestidades hongos horarios horas horizontes hormigas
                hormigueros hornos horquillas hospedajes hospitales hostales hostilidades
                hoteles hoyos huchas huellas huertas huesos huespedes huevos humanos humildades
                humoristas humos huracanes ideas idiomas iglesias igniciones igualdades imagenes
                imanes imitaciones imperios impermeables impresoras impuestos impulsos incendios
                inciensos incisivos indicios indios industrias infancias infieles infiernos
                infinitos influencias ingenieros ingredientes inicios inquilinos insecticidas
                insectos inspectores instantes institutos instrumentos insultos intenciones
                intervalos intestinos intrigas inundaciones invalideces invasiones inventores
                inviernos invitaciones invitados islas itinerarios izquierdas jabones jacas
                jacintos jaguares jaleas jamones jarabes jardineros jardines jarras jarrones
                jaulas jazmines jefes jeroglificos jinetes jirafas jornadas jovenes joyas
                jubileos judias juegos juergas jugadas jugadores juglares jugos juguetes juicios
                julios juncos junglas junios juntos jurados justicias juventudes karaokes
                karates kilogramos kilometros kimonos kioscos koalas laberintos labios
                laboratorios lacayos lacres lados ladrillos ladrones lagartos lagos lagrimas
                lagunas lamentos lamparas lanas lanceros lanchas lanzas lapiceros lapices
                lapidas largavistas largos lasanas lastimas latas latitudes laudes laureles
                lavabos lavanderias lazos lealtades leches lechugas lechuzas lectores lecturas
                legados legiones legumbres lejias lenas lencerias lenguas lentejuelas lentes
                leones leopardos letras letreros leyendas libelulas liberales libertades
                libertadores libretas libros licencias licores liebres lienzos ligaduras ligas
                lijadoras limas limbos limones limosnas limpiadores limpiezas linajes linces
                lineas linternas liquidos lirios listas listones litorales llamas llantos
                llanuras llaveros llaves llegadas lluvias lobos locales localidades locomotoras
                locuras lodos logotipos lombrices longitudes loros loterias luceros luces luchas
                lucideces luciernagas lugarenos lugares lujos lunares lunas lupas lustres
                macarrones macetas machetes maderas madres madrigueras madrinas madrugadas
                maestros magias magnates magos maices maletas maletines mallas mamas manadas
                mananas manchas mandarinas mandatos mangueras manicuras manivelas manos
                mansiones mantas mantecas manteles manuales manzanas manzanos mapas maquetas
                maquinas maratones marcadores mareas mares margaritas marineros mariposas
                marmitas marmotas marrones martillos martirios marzos masas mascaras mascotas
                mastiles mataderos matematicas matorrales matrices matriculas mausoleos mazorcas
                mecanicos medallas mediadores medicinas medicos medidas medios medusas mejillas
                mejillones melenas melocotones melodias melones membranas memorias mendigos
                mensajes mentas mentes mentiras mercaderes mercadillos mercados mercurios
                meridianos meriendas mesas mesones mestizos metales meteoritos meteoros metodos
                metros microbios miedos mieles miembros migajas milagros milenios millonarios
                mimbres mineros ministros minorias minutos miradas miradores miserias misiles
                misiones misterios mitades mitos mochilas modas modelos mohos molinos moluscos
                momias monarcas monasterios monedas monopatines monos monstruos montajes
                montanas monumentos moradas morados morales mordaces mordiscos morenas mosaicos
                moscas mostazas motines motocicletas motores movimientos muchedumbres muelas
                muelles muertes muestras mugres mujeres mulatos muletas multitudes mundos
                munecas municipios murallas murcielagos museos musicas nabos nacimientos
                naciones nadadores nadas naftas naranjas narcisos narices narradores nataciones
                natas naturalezas navajas navegantes naves navidades neblinas necesidades
                nectarinas negocios nenes neones nervios neveras nichos nidos nieblas nieves
                nineras ninfas ninjas ninos nitideces niveles noblezas noches nombres norias
                nortes nostalgias notarios notas noticias novatos novelas noviazgos noviembres
                nubes nudillos nudos nueces nueras numeros nutrias obediencias obeliscos objetos
                obras obreros obstaculos ocasos oceanos ochos octavos octubres odiseas oestes
                ofertas oficiales oficinas ofrendas oidos oleos olimpiadas olivos ollas olmos
                olores ombligos ondas oraculos oradores orangutanes ordenadores ordenes oreganos
                orejas orfanatos organillos organos orgullos orillas ornamentos orquestas
                orquideas ortigas orugas osadias osamentas oscuros ostras otonos ovejas ovillos
                oxigenos pabellones paces paciencias pactos padres padrinos paellas paisajes
                paisanos pajares pajaritas pajaros palabras palacios paladares palancas
                palestras paletas palizas palmas palmeras palomares palomas palomitas palos
                panaderias pancartas pandas pandillas paneles panes pantallas panteras panuelos
                papagayos papas papelerias papeles papiros paquetes paraisos parcelas paredes
                parejas parlamentos parques parroquias parteras partes pasados pasajes
                pasaportes pasarelas paseos pasillos pastas pasteles pastores patatas patinetes
                patios patos patrones patrullas pausas pavos payasos peajes peatones peceras
                peces pechos pedales pedazos pedestales pedregales pegamentos peines peliculas
                peligros pellizcos pelos pelotas peluches peluqueros pendientes pendulos
                penicilinas pensiones peonzas pepinos peras percheros perdices perezas perfiles
                perfumes pergaminos pericos perifollos periodicos perlas permisos perros
                persianas personajes personas pertigas pertinaces pesadillas pescados pescas
                pesebres pesos pestanas petalos petirrojos petroleos pezunas pianos piaras
                picaduras picaportes pichones pidgines piedades piedras pieles piernas pijamas
                pilares pilas pilotes pilotos pimientas pimientos pinacotecas pinas pinceles
                pinchazos pinguinos pinos pintores pinzas pioneros piramides piranas piratas
                piruetas pisadas piscinas pisos pistas pistolas pitillos pizarras pizarrones
                placas plagas planchas planes planetas planos plantas plantillas plasticos
                plataformas platanos platas platillos platos playas plazas plebeyos plegarias
                pleitos plomeros plumas poblaciones pobrezas poderes poemas poesias poetas
                poleas policias polillas pollitos pollos polos polvos pomadas pomelos pomos
                pompas ponches portales porterias porticos posadas postes postres potreros pozos
                prados precios precipicios predicadores prefectos pregones premios prensas
                presidentes prestamos presupuestos primaveras primos princesas principios
                prisiones privilegios probetas procesiones productos profesores profetas
                programas promesas pronosticos propinas propuestas protectores proverbios
                provincias pruebas psicologos publicidades pueblos puentes puertas puertos
                pulgas pulmones pulpas pulpitos pulpos pulseras punos puntos punzones pupitres
                purezas quehaceres quemaduras quesadillas quesos quetzales quimeras quimicas
                quinces quintos quioscos quirofanos quistes quitasoles rabadillas rabanos
                rabinos rabos racimos radares radiadores radios raices rajas ramas ramilletes
                rampas ranas ranchos ranuras rapaces rapideces rastrillos rastros ratas
                ratoneras ratones rayos razones realidades rebanos rebeldes recados recamaras
                recepciones recetas recibos recintos reclutas recompensas recorridos recreos
                recuerdos redacciones redes rediles reflectores reflejos reformas refugios
                regaderas regalos regatas regimenes regiones registros reglas regresos reinados
                reinas reinos relampagos relatos relevos relicarios relieves religiones relojes
                remedios remeros remolques remos renacuajos rencores rendiciones renuevos
                repartos repertorios repisas reportajes reposos represas republicas requesones
                rescates reservas resfriados resortes respuestas restaurantes resumenes retablos
                retenes retratos reuniones revanchas revistas revoluciones rezos riberas ricos
                rifles rigideces rincones rinones riquezas risas riscos ritmos rituales rivales
                robledos robles rocas rocios rodeos rodillas rodillos rojos rollos romances
                romerias rondas ropas rosales rosas roscas rosetas rostros rotondas rubores
                ruedas ruedos ruidos ruinas ruisenores rumores rutas sabados sabanas sabios
                sables sabores sacerdotes sacos sacrificios sacudidas sagaces sagas salamandras
                salas salchichas salerosos sales salidas salmones salones salsas saltos saludes
                sambas sanciones sandalias sandias sangres santuarios sapos sarampiones
                sarcofagos sardinas sargentos sartenes sastres satelites satiras saxofones sebos
                secadores secretarios secretos secuelas sedales sedas sedes segadores seguidores
                segundos sellos selvas semaforos semanas semblantes semillas senados senales
                sencilleces senderos senoras sensaciones sensateces sentencias sentidos
                sentinelas sepias sequias serenatas series serpentinas serpientes serruchos
                servicios servilletas sesiones setos sherpas sibilas sidras siegas sierras
                siestas sigilos siglos silbatos silencios sillas sillones siluetas silvestres
                simas simbolos simpatias sinfonias sintomas sirenas sirvientes sistemas sitios
                soberanos sobrinos sociedades socorros sofas soldadores soldados soledades soles
                soluciones sombras sombreros sombrillas sonajas sonatas sonidos sonrisas sopas
                sopletes sorbetes sorpresas sorteos sotanos subastas subidas submarinos
                suburbios sucesos sudores suegras sueldos suelos suenos sueros suertes sueteres
                sultanes suplementos surcos sures sustos susurros tabacos tablas tableros
                tablones taburetes tachos tacones tajadas talentos talleres talones tamanos
                tambores tamices tangerinas tanques tapaderas tapas tapetes tapicerias tapices
                taquillas tarantulas tardes tareas tarifas tarimas tarjetas tarros tartanas
                tatuajes tazas tazones teatros tebeos techos teclas tecnologias tejados
                tejedores tejones telas telefericos telefonos telescopios telones temas
                temblores temores templos temporadas tenaces tendederos tendones tenedores
                tenistas tentaculos teorias terminales termometros terneras terrazas terremotos
                terrenos territorios tertulias tesoros testigos texturas tiaras tiburones
                tiempos tierras tigres timbres timideces timidos timones tinajas tintas tinteros
                tintorerias tiovivos tiranos tiritas titanes titulos tizas toallas tobillos
                toboganes tocadores tocinos tolvas tomaduras tomates tonadas toneladas toneles
                topos torbellinos torcazas toreos tormentas torneos tornillos toros torpedos
                torrentes torreones torres tortillas tortugas tostadas trabajadores trabajos
                tradiciones traficos tragedias traiciones trajes trampas trampolines transportes
                tranvias trapecios trapos traseros tratados treboles treguas trenes trenzas
                triangulos tribunas tributos trigales trigos trillos trincheras trineos triunfos
                trofeos trombones trompetas troncos tropas trotes trovadores trozos trucos
                truenos trueques tuberias tubos tulipanes tumbas tumultos tuneles tunicas
                turbantes turbinas turismos turistas turnos turquesas turrones tutores ubres
                ultimos umbrales unanimidades unguentos unicornios unicos uniformes uniones
                universos urbanismos urbanos urgencias urnas urracas usuarios utensilios utopias
                vacantes vacas vacios vacunas vagabundos vagones vainas vajillas valientes
                vallas valles valores vampiros vanguardias vapores vaqueros variedades varillas
                vasallos vasos vecindarios vecinos vegetaciones vehiculos veintes vejeces
                vejigas velas veleros veloces velocidades venados venas vendavales vendedores
                venenos ventajas ventanas ventiladores veranos verbenas verdades verdes verdugos
                verdulerias veredas verguenzas vernices verrugas versiones vertigos vestibulos
                vestidos vestuarios vetas veteranos viaductos viajes vibraciones vicios victimas
                victorias vidas vidrieras vidrios viejos vientos vigilantes vikingos villanos
                villas vinagres vinagretas vinateros vinedos vinos violetas violines virgenes
                virtudes viseras visillos visitas vistas vitrales vitrinas viudeces viudos
                viveros vizcachas vocabularios voces volantes volcanes voluntades voluntarios
                voraces vuelos vueltas waffles xantinas xantofilas xenofilias xenofobias
                xenofobos xenones xerocopias xerofilos xerofitos xeroftalmias xerografias
                xilemas xilenos xilofagos xilofonos xilografias xilosas xoconostles yacimientos
                yates yeguas yemas yerbas yernos yescas yodos yogas yogures yucas yunques
                zafiros zaguanes zambullidas zanahorias zancadas zancos zanganos zanjas
                zapateros zapatos zarpas zarzas zarzuelas zebras zocalos zodiacos zonas
                zoologicos zopilotes zorras zorros zorzales zuecos zumbidos zurdos
            ]],
            ultra = [[
                abandonado abierto abrazado abrazando aburrido acabado acabando aceptado
                aceptando acogedor acompanado acompanando acordado acordando acostado acostando
                adivinado adivinando admirado admirando adorado adorando afilado afortunado
                agitado agradable agradecido agradeciendo agresivo alcanzado alcanzando alegrado
                alegrando almorzado almorzando alquilado alquilando amable amargo amplio andado
                andando anotado anotando ansioso apagado apagando aparecido apareciendo
                aplaudido aplaudiendo aprendido aprendiendo apretado apretando aprovechado
                aprovechando apuntado apuntando arreglado arreglando arriesgado artificial
                asistido asistiendo asustado asustando atacado atacando atento atravesado
                atravesando atrevido autentico avaro avisado avisando ayudado ayudando bailado
                bailando bajado bajando banado banando barato barrido barriendo bebido bebiendo
                bello besado besando bondadoso brillado brillando brillante bromeado bromeando
                bruto buscado buscando cabido cabiendo callado callando calvo caminado caminando
                cansado cantado cantando caprichoso cargado cargando carinoso caro casado
                casando cauteloso cavado cavando celebre cerrado cerrando cierto cobarde
                cocinado cocinando cogido cogiendo colgado colgando comenzado comenzando comico
                comido comiendo comodo complejo comprado comprando conducido conduciendo confuso
                conocido conociendo conseguido conseguyendo construido construyendo contado
                contando contento continuado continuando corrido corriendo cortado cortando
                cortes corto cosido cosiendo crecido creciendo creido creyendo criado criando
                cruel cruzado cruzando cuidadoso cuidando cumplido cumpliendo curado curando
                curioso debido debiendo decidido decidiendo dejado dejando delicado denso
                derramado derramando desayunado desayunando descalzo descansado descansando
                deseado deseando dibujado dibujando diferente dificil disfrutado disfrutando
                distante divertido dividido dividiendo doblado doblando dormido dudado dudando
                durmiendo educado educando elegante elegido eligiendo emocionante empezado
                empezando encendido encendiendo encontrado encontrando enfadado enfrentado
                enfrentando enganado enganando enorme ensenado ensenando entendido entendiendo
                entrado entrando entregado entregando enviado enviando equivocado equivocando
                erroneo escaso escogido escogiendo escondido escondiendo escuchado escuchando
                esforzado esperado esperando espeso esquiado esquiando estudiado estudiando
                evidente evitado evitando exacto excelente exotico explicado explicando extenso
                extrano fabricado fabricando facil falso faltado faltando familiar famoso
                fantastico fiel fingido fingiendo fino firmado firmando firme flexible flojo
                franco fregado fregando furioso ganando gaseoso gastado gastando generoso gentil
                glorioso goloso gordo grande gritado gritando guardado guardando guiado guiando
                gustado gustando habilidoso hablado hablando heredado heredando herido hervido
                hiriendo hirviendo honesto horrible hueco humedo ignorante igual imaginado
                imaginando imponente importante imposible increible inesperado infantil inmenso
                inmovil inteligente interesante inventado inventando invisible jugado jugando
                juntado juntando jurando justo lavado lavando leal lento levantado levantando
                leve limpio lindo liso llamado llamando llegado llegando llenado llenando
                llevado llevando llorado llorando llovido lloviendo loco luchado luchando
                magnifico maldito mandado mandando manso maravilloso marcado marcando mascado
                mascando medido medroso mejor mentido merecido mereciendo mezclado mezclando
                mezquino midiendo mintiendo mirado mirando misterioso moderno modesto mojado
                monstruoso mordido mordiendo mostrado mostrando movido moviendo mudado mudando
                nacido naciendo nadado nadando navegado navegando necesitado necesitando negado
                negando nervioso nombrado nombrando notado notando nublado nuevo numeroso
                obedecido obedeciendo obediente observado observando ocupado ocupando odiado
                odiando olvidado olvidando opaco orgulloso original paciente pagado pagando
                palido parado parando parecido pareciendo partido partiendo pasando paseado
                paseando pedido pegado pegando peligroso pensado pensando pequeno perdido
                perdiendo perdonado perdonando perezoso perfecto permitido permitiendo pesado
                pesando pescando picante pidiendo pintado pintando pisado pisando plantado
                plantando pobre poderoso practico precioso preguntado preguntando prendido
                prendiendo preocupado preocupando preparado preparando probado probando
                producido produciendo profundo prometido prometiendo protegido protegiendo
                proximo prudente pulido puliendo puntual puro quebrado quebrando quedado
                quedando quemado quemando querido queriendo quieto quitado quitando rapido raro
                rasgado rasgando realizado realizando recibido recibiendo recogido recogiendo
                recordado recordando recto redondo reflexionado regado regalado regalando
                regando repetido repitiendo rezado rezando rigido robado robando rudo sabido
                sabiendo sabroso sacado sacando sacudido sacudiendo salido saliendo saltado
                saltando saludable saludado saludando salvado salvaje salvando secado secando
                seguido seguro sensato sentado sentando separado separando serio servido
                siguiendo simpatico simple sincero sintiendo sirviendo solitario soltado
                soltando sombrio sonado sonando sonoliento soplado soplando subido subiendo
                sucio sufrido sufriendo sujetado sujetando supremo tapado tapando temido
                temiendo tenido teniendo terminado terminando tirado tirando tocado tocando
                tomado tomando tonto torcido torciendo trabajado trabajando traido tranquilo
                tratando trayendo triste util vago valido valiendo vencido venciendo vendido
                vendiendo verdadero viajado viajando vibrante vistiendo vivido viviendo vivo
                volado volando votado votando
            ]],
            longas = [[
                abastecimiento acompanamiento acontecimiento actualizacion agradecimiento
                alfabetizacion alimentacion aniversario aproximacion arqueologico arquitectura
                asistencia autenticidad automaticamente aventurero bibliografia bienvenida
                biodiversidad calculadora campeonato capacitacion caracteristica cardiologo
                centimetro ceremonial cinematografia circunstancia clasificacion colaboracion
                coleccionista combinacion complicacion comprension computadora concentracion
                condicionador conferencia confiabilidad confiteria congratulacion conmemoracion
                consecuentemente conservatorio consideracion constitucional construccion
                consumidor contabilidad contemporaneo continuidad contribucion conveniencia
                cooperacion coordinador corporacion correspondencia creatividad cronometrista
                cuadrilatero cumplimiento curiosidad definitivo delicadeza democratizacion
                demostracion departamento dermatologo desarrollo dimensionamiento disponibilidad
                distribucion diversidad documental dramaturgia educacional electricidad
                electrodomestico emergencia emprendedor entrenamiento entretenimiento
                equipamiento escolaridad establecimiento estacionamiento estructuracion
                evolucionista exclusividad experimental explicacion exploracion extraordinario
                fabricacion fantasmagorico festividad fiscalizacion fisioterapia fotografia
                funcionamiento fundamental generosidad geografico gerenciamiento gradualmente
                gratificacion harmonizacion hospitalidad identificacion iluminacion imaginacion
                implementacion importancia imposibilidad impresionante incentivador
                independencia independiente indicadores individualidad industrializacion
                inexperiencia infraestructura ingenieria inmigracion innovacion institucional
                integracion inteligencia interaccion internacional interrupcion investigacion
                jurisprudencia legislacion literatura locomocion luminosidad magnificencia
                manifestacion mantenimiento mecanizacion meteorologia meteorologo metodologia
                modernizacion motivacion movilizacion multiplicacion musicalidad naturalidad
                navegacion nomenclatura nutricionista observatorio ocurrencia oftalmologo
                operacional oportunista optimizacion organizacion organizador originalidad
                ornamentacion paleontologo paralelismo participacion particularidad pasatiempo
                pavimentacion penitenciaria percepcion periodicidad periodismo personalidad
                planificacion portabilidad potencialidad precipitacion preocupacion preparacion
                preservacion presidencia profesional programacion prosperidad protagonista
                psicologicamente realizacion recomendacion reconocimiento recuperacion
                refrigerador reglamento rehabilitacion relacionamiento remuneracion
                representacion reproduccion resistencia responsabilidad responsable restauracion
                satisfaccion secretaria senalizacion sensibilidad simplicidad simultaneamente
                solidaridad sostenibilidad sostenible supervivencia telecomunicacion terapeutico
                territorial testimonio tolerancia tradicional tranquilizante transbordador
                transformacion transmision transparencia transportador universidad urbanizacion
                utilizacion valorizacion vegetariano verificacion viabilidad vicepresidente
                visibilidad voluntariado
            ]],
        },
    }

    local textos = {
        pt = { escrever = "ESCREVER", aguardando = "Aguardando...", letra = "Letra", lento = "Lento",
               rapido = "Rápido", escrevendo = "Escrevendo...", pronto = "Pronto", sem = "Sem palavra" },
        en = { escrever = "WRITE", aguardando = "Waiting...", letra = "Letter", lento = "Slow",
               rapido = "Fast", escrevendo = "Writing...", pronto = "Done", sem = "No word" },
        es = { escrever = "ESCRIBIR", aguardando = "Esperando...", letra = "Letra", lento = "Lento",
               rapido = "Rápido", escrevendo = "Escribiendo...", pronto = "Listo", sem = "Sin palabra" },
    }

    -- Agrupa as palavras de cada idioma e camada pela letra inicial
    local CAMADAS = { "comuns", "extras", "plurais", "ultra", "longas" }
    local NOMES_NIVEL = { "COMUM", "GRANDE", "+PLURAIS", "ULTRA" }
    local bancos = {}
    for idioma, camadasTexto in pairs(pacotes) do
        bancos[idioma] = {}
        for _, camada in ipairs(CAMADAS) do
            bancos[idioma][camada] = {}
            for palavra in (camadasTexto[camada] or ""):gmatch("%S+") do
                local p = palavra:upper()
                local l = p:sub(1, 1)
                bancos[idioma][camada][l] = bancos[idioma][camada][l] or {}
                table.insert(bancos[idioma][camada][l], p)
            end
        end
    end

    -- Prefixos de 3 letras com pouquíssimas palavras no vocabulário (para a Festa do pet)
    local prefixosDificeis = {}
    do
        local contagem = {}
        for _, camadasIdioma in pairs(bancos) do
            for _, porLetra in pairs(camadasIdioma) do
                for _, lista in pairs(porLetra) do
                    for _, p in ipairs(lista) do
                        if #p >= 4 then
                            local pre = p:sub(1, 3)
                            contagem[pre] = (contagem[pre] or 0) + 1
                        end
                    end
                end
            end
        end
        for pre, n in pairs(contagem) do
            if n <= 2 then table.insert(prefixosDificeis, pre) end
        end
        table.sort(prefixosDificeis)
        for i = #prefixosDificeis, 2, -1 do -- embaralha
            local j = math.random(i)
            prefixosDificeis[i], prefixosDificeis[j] = prefixosDificeis[j], prefixosDificeis[i]
        end
    end

    ---------------------------------------------------------------- interface
    local function novo(classe, props, pai)
        local obj = Instance.new(classe)
        for k, v in pairs(props) do obj[k] = v end
        obj.Parent = pai
        return obj
    end

    local okPai, pai = pcall(function() return (gethui and gethui()) or game:GetService("CoreGui") end)
    if not okPai or not pai then pai = playerGui end
    local antiga = pai:FindFirstChild("AutoTyperUI")
    if antiga then antiga:Destroy() end

    local gui = novo("ScreenGui", { Name = "AutoTyperUI", ResetOnSpawn = false, DisplayOrder = 999 }, pai)
    local painel = novo("Frame", {
        Size = UDim2.fromOffset(210, 356), Position = UDim2.new(1, -226, 0, 40),
        BackgroundColor3 = Color3.fromRGB(20, 22, 30), BorderSizePixel = 0, Active = true, Draggable = true,
    }, gui)
    novo("UICorner", { CornerRadius = UDim.new(0, 8) }, painel)

    local function rotulo(texto, x, y, w, h, cor, tam, pai2)
        return novo("TextLabel", {
            Text = texto, Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h),
            BackgroundTransparency = 1, TextColor3 = cor, Font = Enum.Font.GothamBold, TextSize = tam,
        }, pai2)
    end
    local function botao(texto, x, y, w, h, cor, pai2)
        local b = novo("TextButton", {
            Text = texto, Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h),
            BackgroundColor3 = cor, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold,
            TextSize = 13, BorderSizePixel = 0,
        }, pai2)
        novo("UICorner", { CornerRadius = UDim.new(0, 5) }, b)
        return b
    end

    local titulo = rotulo("AutoTyper", 0, 0, 210, 26, Color3.new(1, 1, 1), 15, painel)
    titulo.BackgroundTransparency = 0
    titulo.BackgroundColor3 = Color3.fromRGB(200, 30, 40)
    novo("UICorner", { CornerRadius = UDim.new(0, 8) }, titulo)

    local cinza, azul = Color3.fromRGB(45, 50, 70), Color3.fromRGB(30, 150, 230)
    local botoesIdioma = {}
    for i, cod in ipairs({ "pt", "en", "es" }) do
        botoesIdioma[cod] = botao(cod:upper(), 6 + (i - 1) * 66, 32, 62, 24, cinza, painel)
    end

    local rPalavra = rotulo("", 6, 62, 198, 26, Color3.new(1, 1, 1), 16, painel)
    local btnAnt = botao("<", 6, 92, 30, 24, cinza, painel)
    local rLetra = botao("", 40, 92, 130, 24, Color3.fromRGB(30, 34, 48), painel)
    local btnProx = botao(">", 174, 92, 30, 24, cinza, painel)
    local btnEscrever = botao("", 6, 122, 198, 32, azul, painel)
    btnEscrever.TextSize = 15
    local rStatus = rotulo("", 6, 160, 198, 22, Color3.fromRGB(80, 220, 150), 13, painel)
    local btnLento = botao("", 6, 188, 62, 26, Color3.fromRGB(200, 40, 50), painel)
    local rMs = rotulo("", 72, 188, 66, 26, Color3.fromRGB(255, 200, 60), 14, painel)
    local btnRapido = botao("", 142, 188, 62, 26, Color3.fromRGB(40, 170, 80), painel)
    local btnRage = botao("RAGE", 6, 222, 96, 28, Color3.fromRGB(200, 40, 50), painel)
    local btnVocab = botao("", 6, 254, 96, 28, Color3.fromRGB(110, 60, 190), painel)
    local btnFaisca = botao("", 108, 222, 96, 28, Color3.fromRGB(230, 140, 30), painel)
    local btnPrefixo = botao("PREFIXO", 108, 254, 96, 28, azul, painel)
    local btnFesta = botao("", 6, 318, 126, 28, cinza, painel)
    local btnDiag = botao("DIAG", 138, 318, 66, 28, Color3.fromRGB(90, 90, 110), painel)
    for _, b in ipairs({ btnRage, btnVocab, btnFaisca, btnPrefixo, btnFesta, btnDiag }) do
        b.TextScaled = true
        novo("UITextSizeConstraint", { MaxTextSize = 13 }, b)
    end
    local btnApagar = botao("APAGAR", 6, 286, 62, 28, cinza, painel)
    local btnLimpar = botao("LIMPAR", 72, 286, 62, 28, cinza, painel)
    local btnEnter = botao("ENTER", 138, 286, 62, 28, cinza, painel)

    ---------------------------------------------------------------- botão de minimizar (móvel)
    local COR_ABERTO, COR_FECHADO = Color3.fromRGB(200, 30, 40), Color3.fromRGB(45, 50, 70)
    local btnMin = novo("TextButton", {
        Name = "Minimizar", Text = "AT", Size = UDim2.fromOffset(44, 44),
        Position = UDim2.new(1, -278, 0, 40), BackgroundColor3 = COR_ABERTO,
        TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, TextSize = 15,
        AutoButtonColor = false, BorderSizePixel = 0, Active = true,
    }, gui)
    novo("UICorner", { CornerRadius = UDim.new(1, 0) }, btnMin)

    local function alternarPainel()
        painel.Visible = not painel.Visible
        btnMin.BackgroundColor3 = painel.Visible and COR_ABERTO or COR_FECHADO
    end

    -- Toque curto = mostrar/esconder. Arrastar (mais de 6 px) = mover o botão sem alternar.
    local arrastando, moveu, toqueInicial, posInicial = false, false, nil, nil
    btnMin.InputBegan:Connect(function(entrada)
        if entrada.UserInputType == Enum.UserInputType.MouseButton1
            or entrada.UserInputType == Enum.UserInputType.Touch then
            arrastando, moveu = true, false
            toqueInicial, posInicial = entrada.Position, btnMin.Position
            entrada.Changed:Connect(function()
                if entrada.UserInputState == Enum.UserInputState.End then
                    arrastando = false
                    if not moveu then alternarPainel() end
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(entrada)
        if arrastando and (entrada.UserInputType == Enum.UserInputType.MouseMovement
            or entrada.UserInputType == Enum.UserInputType.Touch) then
            local delta = entrada.Position - toqueInicial
            if delta.Magnitude > 6 then moveu = true end
            if moveu then
                btnMin.Position = UDim2.new(
                    posInicial.X.Scale, posInicial.X.Offset + delta.X,
                    posInicial.Y.Scale, posInicial.Y.Offset + delta.Y
                )
            end
        end
    end)

    ---------------------------------------------------------------- lógica
    local sugestao = nil
    local sugestaoIdioma = nil
    local usadas = {}

    local function t() return textos[config.idioma] end

    local function atualizarTextos()
        local tx = t()
        btnEscrever.Text = tx.escrever
        btnLento.Text = tx.lento
        btnRapido.Text = tx.rapido
        rMs.Text = config.atrasoMs .. " ms"
        rLetra.Text = string.format("%s: %s (%s)", tx.letra, config.letra, config.auto and "auto" or "manual")
        if sugestao then
            local extra = ""
            if sugestaoIdioma and sugestaoIdioma ~= config.idioma then
                extra = " [" .. sugestaoIdioma:upper() .. "]"
            end
            rPalavra.Text = sugestao .. extra
        else
            rPalavra.Text = tx.sem
        end
        btnRage.Text = config.priorizarFinais and "RAGE: ON" or "RAGE: OFF"
        btnRage.BackgroundColor3 = config.priorizarFinais and Color3.fromRGB(200, 40, 50) or cinza
        btnVocab.Text = "VOCAB: " .. NOMES_NIVEL[config.nivelVocab]
        btnFaisca.Text = config.faisca and "FAÍSCA: ON" or "FAÍSCA: OFF"
        btnFaisca.BackgroundColor3 = config.faisca and Color3.fromRGB(230, 140, 30) or cinza
        btnFesta.Text = config.festaAuto and "FESTA: ARMADA" or "FESTA: OFF"
        btnFesta.BackgroundColor3 = config.festaAuto and Color3.fromRGB(40, 170, 80) or cinza
        for cod, b in pairs(botoesIdioma) do
            b.BackgroundColor3 = (cod == config.idioma) and azul or cinza
        end
    end

    local function terminaDificil(palavra)
        return config.finaisDificeis:find(palavra:sub(-1), 1, true) ~= nil
    end

    -- A palavra precisa começar com TODAS as letras iniciais da rodada e ser maior que elas
    local function combinaPrefixo(palavra)
        return #palavra > #config.letra and palavra:sub(1, #config.letra) == config.letra
    end

    local function camadaLigada(nome)
        if nome == "longas" then return config.faisca end -- palavras de 10+ letras só no modo FAÍSCA
        for i, c in ipairs(CAMADAS) do
            if c == nome then return i <= config.nivelVocab end
        end
        return false
    end

    -- Sorteia uma palavra não usada que comece com o prefixo atual.
    -- As etapas vão da mais forte para a mais fraca e só passa para a próxima se não achar nada:
    --   FAÍSCA + RAGE: 10+ letras terminando em letra difícil | FAÍSCA: 10+ letras
    --   RAGE: termina em letra difícil | qualquer palavra
    -- Em cada etapa vai das palavras comuns para as extras (camadas) e, dentro de cada
    -- camada, começa pelo idioma escolhido e passa aos outros (trocaAuto).
    -- Se todas as palavras daquele prefixo já foram usadas, zera a lista de usadas.
    local function sortear()
        local idiomas = { config.idioma }
        if config.trocaAuto then
            for _, cod in ipairs({ "pt", "en", "es" }) do
                if cod ~= config.idioma then table.insert(idiomas, cod) end
            end
        end
        local etapas = {}
        if config.faisca and config.priorizarFinais then
            table.insert(etapas, function(p) return #p >= config.faiscaMin and terminaDificil(p) end)
        end
        if config.faisca then
            table.insert(etapas, function(p) return #p >= config.faiscaMin end)
        end
        if config.priorizarFinais then table.insert(etapas, terminaDificil) end
        table.insert(etapas, function() return true end)

        local inicial = config.letra:sub(1, 1)
        for _ = 1, 2 do
            local candidatas = 0
            for n, aceita in ipairs(etapas) do
                for _, camada in ipairs(CAMADAS) do
                    if camadaLigada(camada) then
                        for _, cod in ipairs(idiomas) do
                            local lista = bancos[cod][camada][inicial]
                            if lista then
                                local livres = {}
                                for _, p in ipairs(lista) do
                                    if combinaPrefixo(p) then
                                        if n == #etapas then candidatas = candidatas + 1 end
                                        if not usadas[p] and aceita(p) then table.insert(livres, p) end
                                    end
                                end
                                if #livres > 0 then
                                    return livres[math.random(#livres)], cod
                                end
                            end
                        end
                    end
                end
            end
            if candidatas == 0 then return nil, nil end
            usadas = {}
        end
        return nil, nil
    end

    local function novaSugestao()
        sugestao, sugestaoIdioma = sortear()
        atualizarTextos()
    end

    local function definirLetra(l)
        local mudou = (l ~= config.letra)
        config.letra = l
        if mudou or not sugestao or usadas[sugestao] or not combinaPrefixo(sugestao) then
            novaSugestao()
        else
            atualizarTextos()
        end
    end

    local function visivel(obj)
        local atual = obj
        while atual do
            if atual:IsA("GuiObject") and not atual.Visible then return false end
            if (atual:IsA("ScreenGui") or atual:IsA("BillboardGui") or atual:IsA("SurfaceGui")) and not atual.Enabled then
                return false
            end
            atual = atual.Parent
        end
        return true
    end

    -- Palpite: junta os "tiles" de letras visíveis em linhas (por GUI e por altura),
    -- vota na letra inicial mais comum e usa a MENOR linha que começa com ela como
    -- prefixo (o jogo pode dar 1, 2 ou 3 letras iniciais). Se a linha for maior que
    -- maxPrefixo (provavelmente uma palavra inteira), usa só a primeira letra.
    local function raizDoGui(obj)
        local atual = obj
        while atual do
            if atual:IsA("LayerCollector") then return atual end
            atual = atual.Parent
        end
        return workspace
    end

    local function detectarLetra()
        local porRaiz = {}
        local function varrer(raiz)
            for _, obj in ipairs(raiz:GetDescendants()) do
                if obj:IsA("TextLabel") and #obj.Text == 1 and obj.Text:match("^%u$")
                    and not obj:IsDescendantOf(gui) and visivel(obj) then
                    local r = raizDoGui(obj)
                    porRaiz[r] = porRaiz[r] or {}
                    table.insert(porRaiz[r], {
                        x = obj.AbsolutePosition.X,
                        y = obj.AbsolutePosition.Y,
                        letra = obj.Text,
                    })
                end
            end
        end
        varrer(playerGui)
        varrer(workspace)

        local linhas = {} -- cada item é uma linha de tiles lida da esquerda para a direita
        for _, tiles in pairs(porRaiz) do
            table.sort(tiles, function(a1, b1) return a1.y < b1.y end)
            local atual, refY = {}, nil
            local function fechar()
                if #atual > 0 then
                    table.sort(atual, function(a1, b1) return a1.x < b1.x end)
                    local letras = {}
                    for _, tile in ipairs(atual) do table.insert(letras, tile.letra) end
                    local s = table.concat(letras)
                    -- ignora a fileira de "X" vermelhos (tentativas erradas): não é letra da rodada
                    if not (#s >= 2 and s:match("^X+$")) then
                        table.insert(linhas, s)
                    end
                end
                atual = {}
            end
            for _, tile in ipairs(tiles) do
                if refY and tile.y - refY > 6 then
                    fechar()
                    refY = nil
                end
                refY = refY or tile.y
                table.insert(atual, tile)
            end
            fechar()
        end

        -- palavras completas que já estão na tela (as dos outros jogadores) contam como usadas
        for _, s in ipairs(linhas) do
            if #s >= 4 and #s > config.maxPrefixo then usadas[s] = true end
        end

        local votos, melhor, max = {}, nil, 0
        for _, s in ipairs(linhas) do
            local l = s:sub(1, 1)
            votos[l] = (votos[l] or 0) + 1
            if votos[l] > max then
                max = votos[l]
                melhor = l
            end
        end
        if not melhor then return nil end

        local menor = nil
        for _, s in ipairs(linhas) do
            if s:sub(1, 1) == melhor and (not menor or #s < #menor) then menor = s end
        end
        if menor and #menor <= config.maxPrefixo then return menor end
        return melhor
    end

    local function pressionar(tecla)
        if not okVIM then return end
        pcall(function()
            VIM:SendKeyEvent(true, tecla, false, game)
            task.wait(0.01)
            VIM:SendKeyEvent(false, tecla, false, game)
        end)
    end

    local digitadas = 0 -- quantas letras o script digitou na última palavra

    -- Os toques/teclas simulados fazem alguns jogos esconderem o teclado da tela
    -- (acham que você está num teclado físico). Um toque no título do painel avisa
    -- que a entrada voltou a ser touch. É um toque em lugar inofensivo.
    local function restaurarTeclado()
        if not config.restaurarTeclado or not okVIM or not painel.Visible then return end
        pcall(function()
            local inset = GuiService:GetGuiInset()
            local centro = titulo.AbsolutePosition + titulo.AbsoluteSize / 2
            VIM:SendTouchEvent(1, 0, centro.X, centro.Y + inset.Y)
            task.wait(0.03)
            VIM:SendTouchEvent(1, 2, centro.X, centro.Y + inset.Y)
        end)
    end

    local function apagar(n)
        for _ = 1, n do
            pressionar(Enum.KeyCode.Backspace)
            task.wait(0.03)
        end
    end

    local function digitar(palavra)
        digitadas = 0
        local inicio = config.pularPrimeira and (#config.letra + 1) or 1
        for i = inicio, #palavra do
            local c = palavra:sub(i, i)
            if c:match("%a") then
                pressionar(Enum.KeyCode[c])
                digitadas = digitadas + 1
            end
            task.wait(config.atrasoMs / 1000)
        end
        if config.enter then pressionar(Enum.KeyCode.Return) end
        restaurarTeclado()
    end

    local escrevendo = false
    btnEscrever.MouseButton1Click:Connect(function()
        if escrevendo then return end
        escrevendo = true
        task.spawn(function()
            if config.auto then
                local l = detectarLetra()
                if l then definirLetra(l) end
            end
            if not sugestao then novaSugestao() end
            if sugestao then
                local palavra = sugestao
                rStatus.Text = t().escrevendo
                digitar(palavra)
                usadas[palavra] = true
                rStatus.Text = t().pronto
                novaSugestao()
            else
                rStatus.Text = t().sem
            end
            escrevendo = false
        end)
    end)

    for cod, b in pairs(botoesIdioma) do
        b.MouseButton1Click:Connect(function()
            config.idioma = cod
            usadas = {}
            novaSugestao()
            rStatus.Text = t().aguardando
        end)
    end

    local function moverLetra(d)
        local i = ALFABETO:find(config.letra:sub(1, 1), 1, true) or 1
        i = (i - 1 + d) % 26 + 1
        config.auto = false
        definirLetra(ALFABETO:sub(i, i))
    end
    btnAnt.MouseButton1Click:Connect(function() moverLetra(-1) end)
    btnProx.MouseButton1Click:Connect(function() moverLetra(1) end)
    rLetra.MouseButton1Click:Connect(function()
        config.auto = not config.auto
        atualizarTextos()
    end)

    btnLento.MouseButton1Click:Connect(function()
        config.atrasoMs = math.min(MAX_MS, config.atrasoMs + PASSO_MS)
        atualizarTextos()
    end)
    btnRapido.MouseButton1Click:Connect(function()
        config.atrasoMs = math.max(MIN_MS, config.atrasoMs - PASSO_MS)
        atualizarTextos()
    end)

    btnRage.MouseButton1Click:Connect(function()
        config.priorizarFinais = not config.priorizarFinais
        novaSugestao()
    end)

    btnVocab.MouseButton1Click:Connect(function()
        config.nivelVocab = config.nivelVocab % #NOMES_NIVEL + 1
        novaSugestao()
    end)

    btnApagar.MouseButton1Click:Connect(function()
        task.spawn(function()
            apagar(1)
            digitadas = math.max(0, digitadas - 1)
        end)
    end)
    btnLimpar.MouseButton1Click:Connect(function()
        task.spawn(function()
            apagar(digitadas) -- apaga só o que o script digitou; as letras iniciais do jogo ficam
            digitadas = 0
            rStatus.Text = t().aguardando
        end)
    end)
    btnEnter.MouseButton1Click:Connect(function()
        task.spawn(function() pressionar(Enum.KeyCode.Return) end)
    end)

    btnFaisca.MouseButton1Click:Connect(function()
        config.faisca = not config.faisca
        novaSugestao()
    end)

    -- PREFIXO: digita o próximo prefixo difícil de 3 letras (Festa: até 10 por vez)
    local idxPrefixo, usosFesta = 0, 0
    local function digitarProximoPrefixo()
        idxPrefixo = idxPrefixo % #prefixosDificeis + 1
        usosFesta = usosFesta % config.festaMax + 1
        local pre = prefixosDificeis[idxPrefixo]
        rStatus.Text = "Prefixo: " .. pre .. " (" .. usosFesta .. "/" .. config.festaMax .. ")"
        digitadas = 0
        for i = 1, #pre do
            pressionar(Enum.KeyCode[pre:sub(i, i)])
            digitadas = digitadas + 1
            task.wait(config.atrasoMs / 1000)
        end
        if config.enter then pressionar(Enum.KeyCode.Return) end
        restaurarTeclado()
    end

    btnPrefixo.MouseButton1Click:Connect(function()
        if escrevendo or #prefixosDificeis == 0 then return end
        escrevendo = true
        task.spawn(function()
            digitarProximoPrefixo()
            escrevendo = false
        end)
    end)

    -- FESTA automática: arme o botão quando estiver perto da Festa. A partida segue rodada a rodada:
    -- cada vez que o jogo pedir um prefixo (texto curto com "prefixo", veja festaPalavras) ele digita
    -- UM prefixo, espera o pedido sumir (fim da rodada) e só então espera o próximo pedido, até
    -- festaMax vezes. Se nada aparecer por festaTimeout segundos, desarma sozinho.
    local function simples(s)
        local mapa = { ["á"] = "a", ["à"] = "a", ["â"] = "a", ["ã"] = "a", ["é"] = "e", ["ê"] = "e",
                       ["í"] = "i", ["ó"] = "o", ["ô"] = "o", ["õ"] = "o", ["ú"] = "u", ["ç"] = "c" }
        return (s:lower():gsub(utf8.charpattern, function(c) return mapa[c] or c end))
    end

    local function textoDaFesta()
        for _, obj in ipairs(playerGui:GetDescendants()) do
            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Text ~= ""
                and #obj.Text <= config.festaTextoMax and not obj:IsDescendantOf(gui) and visivel(obj) then
                local txt = simples(obj.Text)
                for _, palavra in ipairs(config.festaPalavras) do
                    if txt:find(palavra, 1, true) then return obj.Text end
                end
            end
        end
        return nil
    end

    local festaRodando = false
    local function rodarFesta()
        if festaRodando then return end
        festaRodando = true
        task.spawn(function()
            local enviados, ultimoVisto, jaEnviou = 0, os.clock(), false
            rStatus.Text = "Festa: esperando o jogo pedir..."
            while config.festaAuto and enviados < config.festaMax do
                local agora = os.clock()
                if textoDaFesta() then
                    ultimoVisto = agora
                    if not jaEnviou and not escrevendo and #prefixosDificeis > 0 then
                        task.wait(config.festaEspera)
                        escrevendo = true
                        digitarProximoPrefixo()
                        escrevendo = false
                        enviados = enviados + 1
                        jaEnviou = true -- um prefixo por pedido; só digita de novo quando o pedido sumir e voltar
                        rStatus.Text = "Festa: " .. enviados .. "/" .. config.festaMax .. " (esperando a próxima rodada)"
                    end
                else
                    jaEnviou = false -- o pedido sumiu: a rodada acabou
                    if agora - ultimoVisto > config.festaTimeout then
                        rStatus.Text = "Festa: tempo esgotado"
                        break
                    end
                end
                task.wait(0.4)
            end
            if enviados >= config.festaMax then rStatus.Text = "Festa: concluída (" .. enviados .. "/" .. config.festaMax .. ")" end
            config.festaAuto = false
            festaRodando = false
            atualizarTextos()
        end)
    end

    btnFesta.MouseButton1Click:Connect(function()
        config.festaAuto = not config.festaAuto
        if config.festaAuto then rodarFesta() end
        atualizarTextos()
    end)

    -- DIAG: copia para a área de transferência todos os textos visíveis na tela (use durante a Festa)
    btnDiag.MouseButton1Click:Connect(function()
        local linhas = {}
        for _, obj in ipairs(playerGui:GetDescendants()) do
            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Text ~= ""
                and not obj:IsDescendantOf(gui) and visivel(obj) then
                table.insert(linhas, string.format('[%s] %s | "%s"', obj.ClassName, obj:GetFullName(), obj.Text:sub(1, 80)))
            end
        end
        local texto = table.concat(linhas, "\n")
        if setclipboard then
            setclipboard(texto)
            rStatus.Text = "DIAG copiado (" .. #linhas .. " textos)"
        else
            print(texto)
            rStatus.Text = "DIAG no console (F9)"
        end
    end)

    novaSugestao()
    rStatus.Text = t().aguardando
end)

if not sucesso then
    warn("Erro ao executar o script / Script error / Error al ejecutar el script: ", erro)
end
