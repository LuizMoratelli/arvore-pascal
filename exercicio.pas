program Arvores;
uses Crt;

type 
    ref = ^nodo;
    nodo = record
        dir: ref;
        esq: ref;
        val: Integer;
    end;
    
var 
    op: Byte;
    arvore: ref;
    valor, altura, qtdFolhas: Integer;
    
procedure inicializaArvore(var arvore: ref);
begin
    arvore := nil;
end;
    
procedure visita(ponteiro: ref);
begin
    writeln(ponteiro^.val);
end;

procedure caminhaPrefixado(ponteiro: ref);
begin
    if (ponteiro <> nil) then
    begin
        visita(ponteiro);
        caminhaPrefixado(ponteiro^.esq);
        caminhaPrefixado(ponteiro^.dir);
    end;   
end;

procedure caminhaInfixado(ponteiro: ref);
begin
    if (ponteiro <> nil) then
    begin
        caminhaInfixado(ponteiro^.esq);
        visita(ponteiro);
        caminhaInfixado(ponteiro^.dir);
    end;   
end;

procedure caminhaPosfixado(ponteiro: ref);
begin
    if (ponteiro <> nil) then
    begin
        caminhaPosfixado(ponteiro^.esq);
        caminhaPosfixado(ponteiro^.dir);
        visita(ponteiro);
    end;   
end;

procedure lerValor(var novoValor: Integer);
begin
    writeln('Digite o valor desejado: ');
    read(novoValor);
end;

procedure adicionaNodo(var arvore: ref; valor: Integer);
begin
    if (arvore = nil) then
    begin
        new(arvore);
        arvore^.val := valor;
        arvore^.dir := nil;
        arvore^.esq := nil;
    end
    else 
    begin
        if (valor < arvore^.val) then
        begin
            adicionaNodo(arvore^.esq, valor);
        end
        else if (valor > arvore^.val) then
        begin
            adicionaNodo(arvore^.dir, valor);
        end;
        // E se for igual?
    end;
end;

procedure informaNivel(ponteiro: ref; valor: Integer; nivel: Integer);
begin
    if (ponteiro = nil) then
    begin
        writeln('Valor não encontrado!');
    end
    else 
    begin
        if (valor = ponteiro^.val) then
        begin
            writeln('Nível do valor (', valor, '): ', nivel);
        end
        else 
        begin
            nivel := nivel + 1;
            if (valor < ponteiro^.val) then
            begin
                informaNivel(ponteiro^.esq, valor, nivel);
            end
            else
            begin
                informaNivel(ponteiro^.dir, valor, nivel);
            end;
        end;
    end;
end;

procedure calculaAltura(ponteiro: ref; var altura: Integer);
var alturaDir, alturaEsq: Integer;
begin
    if (ponteiro <> nil) then
    begin
        alturaDir := altura + 1;
        alturaEsq := altura + 1;
        calculaAltura(ponteiro^.dir, alturaDir);
        calculaAltura(ponteiro^.esq, alturaEsq);
        
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

procedure informaFolhas(ponteiro: ref; var qtdFolhas: Integer);
begin
    if (ponteiro <> nil) then
    begin
        if ((ponteiro^.dir = nil) and (ponteiro^.esq = nil)) then
        begin
            writeln(ponteiro^.val, ' é uma folha');
            qtdFolhas := qtdFolhas + 1;
        end
        else 
        begin
            informaFolhas(ponteiro^.dir, qtdFolhas);
            informaFolhas(ponteiro^.esq, qtdFolhas);
        end;
    end;
end;

procedure informaAltura(ponteiro: ref; altura: Integer);
begin
    calculaAltura(arvore, altura);
    writeln(altura);
end;

procedure informaQtdFolhas(qtdFolhas: Integer);
begin
    writeln('Essa árvore possui ', qtdFolhas, ' folhas.');
end;

begin
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
        readln(op);
        case op of 
            1: begin
                caminhaPrefixado(arvore);
                end;
            2: begin
                caminhaInfixado(arvore);
                end;
            3: begin
                caminhaPosfixado(arvore);
                end;
            4: begin
                lerValor(valor);
                adicionaNodo(arvore, valor);
                end;
            5: begin
                lerValor(valor);
                informaNivel(arvore, valor, 0);
                end;
            6: begin
                informaAltura(arvore, altura);
                end;
            7: begin
                informaFolhas(arvore, qtdFolhas);
                informaQtdFolhas(qtdFolhas);
                end;
        end;
    end;
end.