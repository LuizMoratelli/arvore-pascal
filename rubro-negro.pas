program Arvores;
uses Crt;

type 
    ref = ^nodo;
    nodo = record
        dir: ref;
        esq: ref;
        val: Integer;
        cor: Byte;
    end;
    arrayInt = array[1..100] of Integer;
    
var 
    op: Byte;
    arvore: ref;
    valor, altura, qtdFolhas, valorBalanceamento: Integer;
    completa, removido: Boolean;
    listaNos: arrayInt;
    cListaNos: Integer;
    
{Inicializa-se à árvore}
procedure inicializaArvore(var arvore: ref);
begin
    arvore := nil;
end;
    
{Imprime o valor do ponteiro}
procedure visita(ponteiro: ref);
begin
    TextColor(ponteiro^.cor);
    writeln(ponteiro^.val);
    TextColor(WHITE);
end;

{Exibe o valor, anda à esquerda e depois à direita}
procedure caminhaPrefixado(ponteiro: ref);
begin
    if (ponteiro <> nil) then
    begin
        visita(ponteiro);
        caminhaPrefixado(ponteiro^.esq);
        caminhaPrefixado(ponteiro^.dir);
    end;   
end;

{Anda à esquerda, exibe o valor e depois à direita}
procedure caminhaInfixado(ponteiro: ref);
begin
    if (ponteiro <> nil) then
    begin
        caminhaInfixado(ponteiro^.esq);
        visita(ponteiro);
        caminhaInfixado(ponteiro^.dir);
    end;   
end;

{Anda à esquerda, à direita e depois exibe o valor}
procedure caminhaPosfixado(ponteiro: ref);
begin
    if (ponteiro <> nil) then
    begin
        caminhaPosfixado(ponteiro^.esq);
        caminhaPosfixado(ponteiro^.dir);
        visita(ponteiro);
    end;   
end;

{Lê valor do usuário}
procedure lerValor(var novoValor: Integer);
begin
    writeln('Digite o valor desejado: ');
    read(novoValor);
end;

{Adiciona um novo nó à arvore}
procedure adicionaNodo(var arvore: ref; valor: Integer);
begin
    {Se é um espaço vazio pode adicionar}
    if (arvore = nil) then
    begin
        new(arvore);
        arvore^.val := valor;
        arvore^.dir := nil;
        arvore^.esq := nil;
    end
    {Caso contrário procura pelo local adequado de inserção}
    else 
    begin
        {Se o valor à ser inserido for menor que o valor atual da árvore, locomove-se à esquerda}
        if (valor < arvore^.val) then
        begin
            adicionaNodo(arvore^.esq, valor);
        end
        {Se o valor à ser inserido for maior que o valor atual da árvore, locomove-se à direita}
        else if (valor > arvore^.val) then
        begin
            adicionaNodo(arvore^.dir, valor);
        end;
        {Em tese, não são adicionados valores repetidos à uma árvore}
        // E se for igual?
    end;
end;

{Informa o nível de um nó (distância entre a raíz e o nó)}
procedure informaNivel(ponteiro: ref; valor: Integer; nivel: Integer);
begin
    {Se o ponteiro chegar à um valor vazio, o valor de busca não foi encontrado}
    if (ponteiro = nil) then
    begin
        writeln('Valor não encontrado!');
    end
    else 
    begin
        {Caso o valor de busca seja igual ao valor atual é exibido seu nível}
        if (valor = ponteiro^.val) then
        begin
            writeln('Nível do valor (', valor, '): ', nivel);
        end
        {Caso contrário, locomove-se na árvore para encontrá-lo}
        else 
        begin
            nivel := nivel + 1;
            
            {Se o valor de busca for menor que o valor atual, locomove-se à esquerda}
            if (valor < ponteiro^.val) then
            begin
                informaNivel(ponteiro^.esq, valor, nivel);
            end
            {Se o valor de busca for maior que o valor atual, locomove-se à direita}
            else
            begin
                informaNivel(ponteiro^.dir, valor, nivel);
            end;
        end;
    end;
end;

{Calcula o nível de um ponteiro}
procedure calculaNivel(ponteiro: ref; valor: Integer; var nivel: Integer);
begin
    {Caso o valor seja diferente do valor de busca, é necessário buscá-lo}
    if (valor <> ponteiro^.val) then
    begin
        nivel := nivel + 1;
        
        {Se o valor de busca for menor que o valor atual, locomove-se à esquerda}
        if (valor < ponteiro^.val) then
        begin   
            calculaNivel(ponteiro^.esq, valor, nivel);
        end
        {Se o valor de busca for maior que o valor atual, locomove-se à direita}
        else
        begin
            calculaNivel(ponteiro^.dir, valor, nivel);
        end;
    end;
end;

{Calcula à altura da árvore}
procedure calculaAltura(ponteiro: ref; var altura: Integer);
var alturaDir, alturaEsq: Integer;
begin
    {Se o ponteiro atual existir}
    if (ponteiro <> nil) then
    begin
        {Calcula a altura da àrvore da esquerda e direita adicionando-as em 1 -> http://prntscr.com/lal8ny}    
        alturaDir := altura + 1;
        alturaEsq := altura + 1;
        calculaAltura(ponteiro^.dir, alturaDir);
        calculaAltura(ponteiro^.esq, alturaEsq);
        
        {O que mais possuir altura será definido como a nova altura}
        if (alturaDir > alturaEsq) then
        begin
            altura := alturaDir;
        end
        else
        begin
            altura := alturaEsq;
        end;
    end;
end;

{Imprime o valor das folhas}
procedure informaFolhas(ponteiro: ref; var qtdFolhas: Integer);
begin
    {Se não for nulo}
    if (ponteiro <> nil) then
    begin
        {E não tiver folhas: é uma folha}
        if ((ponteiro^.dir = nil) and (ponteiro^.esq = nil)) then
        begin
            writeln(ponteiro^.val, ' é uma folha');
            qtdFolhas := qtdFolhas + 1;
        end
        {Caso contrário, busca pelas folhas}
        else 
        begin
            informaFolhas(ponteiro^.dir, qtdFolhas);
            informaFolhas(ponteiro^.esq, qtdFolhas);
        end;
    end;
end;

{Imprime a altura da árvore}
procedure informaAltura(ponteiro: ref; altura: Integer);
begin
    calculaAltura(arvore, altura);
    writeln('A altura da árvore é: ', altura);
end;

{Imprime a quantidade de folhas}
procedure informaQtdFolhas(qtdFolhas: Integer);
begin
    writeln('Essa árvore possui ', qtdFolhas, ' folhas.');
end;

{Verifica se a árvore é completa}
procedure verificaCompleta(raiz, ponteiro: ref; var completa: Boolean; altura: Integer);
var nivelPonteiro: Integer;
begin
    {Se o ponteiro não for nulo, verifica seu nível}
    if (ponteiro <> nil) then
    begin
        nivelPonteiro := 1;
        calculaNivel(raiz, ponteiro^.val, nivelPonteiro);
    end;
    
    {Se o ponteiro for nulo, esse ponteiro é "completo"}
    if (ponteiro = nil) then
    begin
        completa := true;
        exit;
    end;
     
    {Se tiver ambos os filhos e for da altura final da árvore esse ponteiro é "completo"}
    if ((ponteiro^.dir = nil) and (ponteiro^.esq = nil) and (altura = nivelPonteiro)) then
    begin
        completa := true;
        exit;
    end;

    {Se nenhum dos filhos for nulo, continua percorrendo}
    if ((ponteiro^.dir <> nil) and (ponteiro^.esq <> nil)) then
    begin
        verificaCompleta(raiz, ponteiro^.dir, completa, altura);
    
        {Apenas percorre o outro lado caso o primeiro não seja incompleto}
        if (completa = true) then
        begin
            verificaCompleta(raiz, ponteiro^.esq, completa, altura);
        end;

        exit;
    end;
    
    {Caso não entre em nenhum caso acima, o ponteiro é "incompleto", ocasionando em uma árvore incompleta}
    completa := false;
end;

{Informa se a árvore é completa ou não}
procedure informaCompleta(arvore: ref; var completa: Boolean; altura: Integer);
begin
    completa := false;
    verificaCompleta(arvore, arvore, completa, altura);
    
    if (completa = true) then
    begin
        writeln('Árvore completa!');
    end
    else
    begin
         writeln('Árvore incompleta!');
    end;
end;

{Auxilia na remoção do nó que foi trocado}
procedure auxiliaRemoveNodo(var ponteiro: ref; direcao: String);
begin
    {Mantém na recursividade enquanto o ponteiro for diferente de nulo}
    if (ponteiro <> nil) then
    begin
        {Se a direção é direita (sub-arvore da esquerda)}
        if (direcao = 'dir') then
        begin
            {Locomove até enquanto tiver próximo valor à direita}
            if (ponteiro^.dir <> nil) then
            begin
                auxiliaRemoveNodo (ponteiro^.dir, 'dir');
            end
            {Quando não tiver mais, limpa o atual}
            else
            begin
                ponteiro := nil;
            end;
        end
        {Se a direção é esquerda (sub-arvore da direita)}
        else 
        begin
            {Locomove até enquanto tiver próximo valor à esquerda}
            if (ponteiro^.esq <> nil) then
            begin
                auxiliaRemoveNodo (ponteiro^.esq, 'esq');
            end
            {Quando não tiver mais, limpa o atual}
            else
            begin
                ponteiro := nil;
            end;
        end
    end;
end;

{Remove um nó específico da árvore}
procedure removeNodo(var arvore: ref; valor: Integer; var removido: Boolean);
var troca: ref;
begin  
    {Se o ponteiro atual não for nulo}
    if (arvore <> nil) then
    begin
        {Caminha para direita caso o valor de busca seja maior que o atual}
        if(valor > arvore^.val) then
        begin
            removeNodo(arvore^.dir, valor, removido);
        end
        {Caminha para esquerda caso o valor de busca seja menor que o atual}
        else if (valor < arvore^.val) then
        begin
            removeNodo(arvore^.esq, valor, removido);
        end
        else 
        begin 
            {Remove se for uma folha}
            if ((arvore^.esq = nil) and (arvore^.dir = nil)) then
            begin
                removido := true;
                arvore := nil;
            end
            {Caso contrario se tiver uma filho à esquerda, troca pelo elemento mais à direita desse filho}
            else if (arvore^.esq <> nil) then
            begin
                {troca o mais à direita da sub-arvore da esquerda}
                troca := arvore^.esq;
                while (troca^.dir <> nil) do
                begin
                    troca := troca^.dir;
                end;
                
                {O nó que será retirado recebe o valor do que ficará no lugar}
                arvore^.val := troca^.val;
                
                {Se o nó à esquerda for o que será trocado}
                if (arvore^.esq^.val = troca^.val) then 
                begin
                    {Se houver um elemento à esquerda do elemento à esquerda ele é recebido pelo nó de troca}
                    if (arvore^.esq^.esq <> nil) then
                    begin
                        arvore^.esq := troca^.esq;
                    end
                    else 
                    begin
                        arvore^.esq := nil;
                    end;  
                end
                else
                begin
                    auxiliaRemoveNodo (arvore^.esq, 'dir'); 
                end;
                
                troca := nil;
                removido := true;
            end
            {Caso contrario se tiver um filho à direita, troca pelo elemento mais à esquerda desse filho}
            else if (arvore^.dir <> nil) then
            begin
                {troca o mais à esquerda da sub-arvore da direita}
                troca := arvore^.dir;
                while (troca^.esq <> nil) do
                begin
                    troca := troca^.esq;
                end;
                
                {O nó que será retirado recebe o valor do que ficará no lugar}
                arvore^.val := troca^.val;
                
                {Se o nó à direita for o que será trocado}
                if (arvore^.dir^.val = troca^.val) then 
                begin
                    {Se houver um elemento à direita do elemento à direita ele é recebido pelo nó de troca}
                    if (arvore^.dir^.dir <> nil) then
                    begin
                        arvore^.dir := troca^.dir;
                    end
                    else 
                    begin
                        arvore^.dir := nil;
                    end; 
                end
                else
                begin
                    auxiliaRemoveNodo (arvore^.dir, 'esq'); 
                end;
                
                troca := nil;
                removido := true;
            end;
        end;
    end;
end;

{Informa se o valor solicitado pode ser removido}
procedure informaRemovido(var arvore: ref; valor: Integer; removido: Boolean);
begin
    removeNodo(arvore, valor, removido);
    
    if (removido = true) then
    begin
        writeln('Valor removido com sucesso!');
    end
    else 
    begin
        writeln('Valor não encontrado!');
    end;
end;

{Reune todos os valores da arvore em um array}
procedure listarNos(ponteiro: ref; var listaNos: arrayInt; var cListaNos: Integer);
begin
    if (ponteiro <> nil) then
    begin
        listarNos(ponteiro^.esq, listaNos, cListaNos);
        cListaNos := cListaNos + 1;
        listaNos[cListaNos] := ponteiro^.val;
        listarNos(ponteiro^.dir, listaNos, cListaNos);
    end;   
end;

procedure balancearArvore(var arvore: ref; listaNos: arrayInt; min, max: Integer);
var posicao: Integer;
begin
    posicao := round((max + min)/2);
    {Sempre pega a posição do meio e adiciona ela como a nova raiz/subraiz}
    if (posicao <> 0) then 
    begin
        adicionaNodo(arvore, listaNos[posicao]);
    end;
    {Chama recursivamente, desde que a posicao seja diferente do minimo, pois caso seja igual é que só tem 1 numero (sem meio)}
    if (posicao <> min) then
    begin
        {Garante que o valor não extrapolará os existentes}
        if (posicao - 1 >= min) then
        begin
            balancearArvore (arvore^.esq, listaNos, min, posicao - 1);
        end;

        {Garante que o valor não extrapolará os existentes}
        if (posicao + 1 <= max) then 
        begin 
            balancearArvore (arvore^.dir, listaNos, posicao + 1, max);
        end;
    end;
end;

{Retorna o nível para usá-lo na coloração}
procedure retornaNivel(ponteiro: ref; valor: Integer; var nivel: Integer);
begin
    if (ponteiro <> nil) then
    begin
        {Caso o valor de busca seja igual ao valor atual é exibido seu nível}
        if (valor <> ponteiro^.val) then
        begin
            nivel := nivel + 1;
            
            {Se o valor de busca for menor que o valor atual, locomove-se à esquerda}
            if (valor < ponteiro^.val) then
            begin
                retornaNivel(ponteiro^.esq, valor, nivel);
            end
            {Se o valor de busca for maior que o valor atual, locomove-se à direita}
            else
            begin
                retornaNivel(ponteiro^.dir, valor, nivel);
            end;
        end;
    end;
end;

{Função para colorir a arvore}
procedure colorirArvore(var arvore: ref; raiz: ref);
var nivel: Integer;
begin
    nivel := 0;
    if (arvore <> nil) then
    begin
        retornaNivel(raiz, arvore^.val, nivel);
        if (nivel MOD 2 = 0) then 
        begin
            arvore^.cor := BLACK;
        end
        else
        begin
            arvore^.cor := RED;
        end;

        colorirArvore(arvore^.esq, raiz);
        colorirArvore(arvore^.dir, raiz);
    end;
end;

{Faz todos os procedimentos de organização e coloração da arvore}
procedure executaBalanceamentoArvore(var arvore: ref; var listaNos: arrayInt; var cListaNos: Integer);
begin
    cListaNos := 0;
    listarNos(arvore, listaNos, cListaNos);
    { Fazer função pra remove tudo }
    arvore := nil;
    balancearArvore(arvore, listaNos, 1, cListaNos);
    colorirArvore(arvore, arvore);
end;

begin
    TextColor(WHITE);
    TextBackground(BLUE);
    op:= 1;
    inicializaArvore(arvore);
    while op <> 0 do
    begin
        ClrScr;
        writeln('0 - Sair'); 
        writeln('1 - Caminha Pré-fixado');
        writeln('2 - Caminha In-fixado');
        writeln('3 - Caminha Pós-fixado');
        writeln('4 - Insere na Árvore');
        writeln('5 - Nivel na Árvore');
        writeln('6 - Altura da Árvore');
        writeln('7 - Folhas da Árvore');
        writeln('8 - Verifica se a Árvore é completa');
        writeln('9 - Remove da Árvore');
        readln(op);
        case op of 
            1: begin
                writeln('Caminho Prefixado: ');
                caminhaPrefixado(arvore);
            end;
            2: begin
                writeln('Caminho Infixado: ');
                caminhaInfixado(arvore);
            end;
            3: begin
                writeln('Caminho Pósfixado: ');
                caminhaPosfixado(arvore);
            end;
            4: begin
                lerValor(valor);
                adicionaNodo(arvore, valor);
                executaBalanceamentoArvore(arvore, listaNos, cListaNos);
            end;
            5: begin
                lerValor(valor);
                informaNivel(arvore, valor, 1);
            end;
            6: begin
                altura := 0;
                informaAltura(arvore, altura);
            end;
            7: begin
                qtdFolhas := 0;
                informaFolhas(arvore, qtdFolhas);
                informaQtdFolhas(qtdFolhas);
            end;
            8: begin
                altura := 0;
                calculaAltura(arvore, altura);
                informaCompleta(arvore, completa, altura);
            end;
            9: begin
                lerValor(valor);
                informaRemovido(arvore, valor, removido);
                executaBalanceamentoArvore(arvore, listaNos, cListaNos);
            end;
        end;
        
        writeln('<Enter> para continuar');
        readkey;
    end;
end.
