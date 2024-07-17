drop database validation_db;
create database validation_db;
use validation_db;


-- cnpj
/* o delimiter serve para criar uma nova forma de encerrar uma ação(nesse caso o //), assim como o ;, mas 
como essa ação se trata de um conjunto de ações é necessário esse mecanismo*/
delimiter //
create procedure cnpj_validator(in cnpj char(14), out resultado varchar(50))
/*dentro da procedure coloca-se uma variavel de entrada com 'in' e de saida com 'out'*/
begin

-- variaveis
-- aqui pode ser declarado uma variavel, int, char, varchar, float...
	declare peso1 int;
    declare peso2 int;
    declare x int;
    declare soma1 int;
    declare soma2 int;
    declare restost int;
	declare restost2 int;
    declare somat int;
    declare digito13 int;
    declare digito14 int;
    
    
     -- calculando o 13 digito
    set peso1 = 5;
    set peso2 = 9;
    set soma1 = 0;
    set soma2 = 0;
    set somat = 0;
    
    set x = 1;
    while x <= 4 do
        set soma1 = soma1 + cast(substring(cnpj, x, 1) as unsigned) * peso1;
        /*substring(cnpj, x, 1): Extrai o caractere da string cnpj na posição x. O 1 indica que estamos pegando apenas um caractere.
		cast(... as unsigned): Converte o caractere extraído para um valor inteiro sem sinal.*/
        set peso1 = peso1 - 1;
        set x = x + 1;
    end while;
    
    set x = 5;
	while x <= 12 do
        set soma2 = soma2 + cast(substring(cnpj, x, 1) as unsigned) * peso2;
        set peso2 = peso2 - 1;
        set x = x + 1;
    end while;
    
    set somat = soma1 + soma2;
    set restost = somat % 11;
    
    if restost < 2 then
		set digito13 = 0;
	else
		set digito13 = 11 - restost;
	end if;
    
    
    -- calculando o 14 digito
	set peso1 = 6;
    set peso2 = 9;
	set soma1 = 0;
    set soma2 = 0;
    set somat = 0;
    
    set x = 1;
    while x <= 5 do
        set soma1 = soma1 + cast(substring(cnpj, x, 1) as unsigned) * peso1;
        set peso1 = peso1 - 1;
        set x = x + 1;
    end while;
    
    set x = 6;
	while x <= 13 do
        set soma2 = soma2 + cast(substring(cnpj, x, 1) as unsigned) * peso2;
        set peso2 = peso2 - 1;
        set x = x + 1;
    end while;
    
    set somat = soma1 + soma2;
    set restost = somat % 11;
    
     if restost < 2 then
		set digito14 = 0;
	else
		set digito14 = 11 - restost;
		end if;
        
        
    -- verificando se o cnpj é valido    
	if digito13 = CasT(SUBSTRING(cnpj, 13, 1) as unsigned) and digito14 = CasT(SUBSTRING(cnpj, 14, 1) as unsigned) then
        set resultado = 'CNPJ válido';
    else
        set resultado = 'CNPJ inválido';
    end if;

    
end//
delimiter ;


call cnpj_validator('71053851000140', @resultado);
-- dentro dessas aspas simples coloca-se o cnpj desejado(parametro de entrada)
select @resultado;



-- email
DELIMITER $$

create procedure email_validator(in email VARCHAR(255), out resultado varchar(50))
begin
    if email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' then
    -- regra padrao email sql
        set resultado = 'email válido';
    else
        set resultado = 'email inválido';
    end if;
end $$
DELIMITER ;

-- Testando e-mail
call email_validator ('teste@@sla.com', @resultado); 
select @resultado;

-- nome
delimiter **
create procedure separa_nome(in nome_titular varchar(255))
begin
	declare ultimo_nome varchar(255);
    declare outros_nomes varchar(255);
    declare posicao_ultimo int;
    
    set posicao_ultimo = length(nome_titular) - locate(' ', REVERSE(nome_titular)) + 1;
    -- acha o último espaço da palavra e assim seleciona só o último nome pra inverter
    set ultimo_nome = SUBSTRING(nome_titular, posicao_ultimo);
    set outros_nomes = SUBSTRING(nome_titular, 1, posicao_ultimo - 1);
    
    select CONCAT(ultimo_nome, ', ', outros_nomes) AS NomeSeparado;
end **
delimiter ;


call separa_nome('Nome Sobrenome');

