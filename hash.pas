program Hash;
uses Crt;

const ArrayI = 0;
const ArrayF = 12;
type
    ref = ^node;
    node = record
        val: Integer;
        next: ref;
    end;
    arrayNode = array[ArrayI..ArrayF] of ref;
var 
    listaHash: arrayNode;
    ponteiro: ref;
    teste: Integer;
    op: Byte;
    value: Integer;

procedure iniciarListaHash(var listaHash: arrayNode);
var i: Integer;
begin
    for i := ArrayI to ArrayF do
    begin
        listaHash[i] := nil;
    end;
end;

procedure insereHash(var ponteiro: ref; value: Integer);
begin
    if (ponteiro <> nil) then
    begin
        insereHash(ponteiro^.next, value);
    end
    else 
    begin
        new(ponteiro);
        ponteiro^.val := value;
        ponteiro^.next := nil;
    end;
end;

procedure verificaInsereHash(var listaHash: arrayNode; value: Integer);
var resto: Integer;
begin
    resto := value MOD (ArrayF + 1);
    insereHash(listaHash[resto], value);
end;

procedure imprimePosicaoHash(ponteiro: ref);
begin
    if (ponteiro <> nil) then
    begin
        writeln('  n: "', ponteiro^.val,'"');
        imprimePosicaoHash(ponteiro^.next);
    end;
end;

procedure listagemHash(listaHash: arrayNode);
var i: Integer;
begin
    for i := ArrayI to ArrayF do
    begin
        writeln('Resto[', i, '] = {');
        imprimePosicaoHash(listaHash[i]);
        writeln('}');
    end;
end;

procedure removeHash(var ponteiro: ref; value: Integer);
var ponteiroAux: ref;
begin
    if (ponteiro <> nil) then
    begin
        if (ponteiro^.val = value) then
        begin
            ponteiroAux := ponteiro;
            ponteiro := ponteiro^.next;
            dispose(ponteiroAux);
        end
        else
        begin
            removeHash(ponteiro^.next, value);
        end;
    end
    else 
    begin
        writeln('Número não encontrado');
    end;
end;

procedure verificaRemoveHash(var listaHash: arrayNode; value: Integer);
var resto: Integer;
begin
    resto := value MOD (ArrayF + 1);
    removeHash(listaHash[resto], value);
end;

procedure lerValor(var value: Integer);
begin
    writeln('Digite o valor desejado: ');
    readln(value);
end;

begin
    iniciarListaHash(listaHash);
    op := 1;
    while(op <> 0) do
    begin
        ClrScr;
        writeln('0 - Sair'); 
        writeln('1 - Inserir');
        writeln('2 - Remover');
        writeln('3 - Listar');
        readln(op);
        case op of 
            1: begin
                lerValor(value);
                verificaInsereHash(listaHash, value);
            end;
            2: begin
                lerValor(value);
                verificaRemoveHash(listaHash, value);
            end;
            3: begin
                listagemHash(listaHash);
            end;
        end;
        writeln('<Enter> para continuar');
        readkey;
    end;
end.
