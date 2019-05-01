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
    arrayNode = array[ArrayI..ArrayF] of ^node;
var 
    listaHash: arrayNode;
    ponteiro: ref;
    teste: Integer;
    op: Byte;
    value: Integer;

{Inicia o Array apontando os ponteiros para nil}
procedure iniciarListaHash(var listaHash: arrayNode);
var i: Integer;
begin
    for i := ArrayI to ArrayF do
    begin
        listaHash[i] := nil;
    end;
end;

{Insere o valor informado na posição correta}
procedure insereHash(var ponteiro: ref; value: Integer);
begin
    {Se não for uma posição nula continua andando pela lista (recursividade)}
    if (ponteiro <> nil) then
    begin
        insereHash(ponteiro^.next, value);
    end
    {Se for um espaço nulo, insere}
    else 
    begin
        new(ponteiro);
        ponteiro^.val := value;
        ponteiro^.next := nil;
    end;
end;

{Verifica em qual lista encadeada do array o valor desejado será inserido}
procedure verificaInsereHash(var listaHash: arrayNode; value: Integer);
var resto: Integer;
begin
    {Será inserido na posição de acordo com o resto}
    resto := value MOD (ArrayF + 1);
    insereHash(listaHash[resto], value);
end;

{Imprime todos os valores da lista encadeada}
procedure imprimePosicaoHash(ponteiro: ref);
begin
    if (ponteiro <> nil) then
    begin
        writeln('  n: "', ponteiro^.val,'"');
        imprimePosicaoHash(ponteiro^.next);
    end;
end;

{Imprime todas as listas de acordo com o array}
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

{Remove }
procedure removeHash(var ponteiro: ref; value: Integer);
var ponteiroAux: ref;
begin
    {Caso o ponteiro atual não seja nulo}
    if (ponteiro <> nil) then
    begin
        {Se o valor for o procurado para deletar}
        if (ponteiro^.val = value) then
        begin
            {Auxiliar captura nó à ser deletado}
            ponteiroAux := ponteiro;
            {A referência do ponteiro passar a ser o próximo da lista}
            ponteiro := ponteiro^.next;
            {Retirado da memória o valor desejado}
            dispose(ponteiroAux);
        end
        else
        begin
            {Chama recursivamente até encontrar o valor desejado}
            removeHash(ponteiro^.next, value);
        end;
    end
    else 
    begin
        writeln('Número não encontrado');
    end;
end;

{Indica para função de remoção em qual lista encadeada o valor está presente}
procedure verificaRemoveHash(var listaHash: arrayNode; value: Integer);
var resto: Integer;
begin
    resto := value MOD (ArrayF + 1);
    removeHash(listaHash[resto], value);
end;

{lê uma entrada do usuário}
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
