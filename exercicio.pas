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
    novoValor: Integer;
    
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
        caminhaPrefixado(ponteiro^.esq);
        visita(ponteiro);
        caminhaPrefixado(ponteiro^.dir);
    end;   
end;

procedure caminhaPosfixado(ponteiro: ref);
begin
    if (ponteiro <> nil) then
    begin
        caminhaPrefixado(ponteiro^.esq);
        caminhaPrefixado(ponteiro^.dir);
        visita(ponteiro);
    end;   
end;

procedure lerNovoValor(var novoValor: Integer);
begin
    writeln('Digite o valor à ser inserido: ');
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
                lerNovoValor(novoValor);
                adicionaNodo(arvore, novoValor);
                end;
        end;
    end;
end.
