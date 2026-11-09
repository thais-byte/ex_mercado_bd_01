/* Lista de exercícios de Banco de Dados 1 - DQL Parte I: SELECT, WHERE, agregações e GROUP BY */
/* Enunciado das questões: 
Questão 01. Quantas linhas da tabela fato_vendas não têm cliente identificado (id_cliente
vazio)?
Questão 02. Quantos clientes diferentes aparecem na tabela fato_vendas?
Questão 03. Qual foi o faturamento total (soma de valor_total) de todas as vendas de 2025?
Questão 04. Liste, sem repetição e em ordem alfabética, as marcas dos produtos da categoria
Higiene.
Questão 05. Qual é o valor médio de valor_total das vendas do canal Aplicativo?
Questão 06. Quantos produtos da categoria Bebidas têm preco_tabela acima de R$ 10,00?
Questão 07. Mostre o nome, a marca e o preço de tabela do produto mais caro do catálogo. Em caso
de empate no preço, traga o primeiro em ordem alfabética de nome.
Questão 08. Quantos produtos existem em cada categoria? Ordene da categoria com mais produtos
para a com menos; em caso de empate, por nome da categoria (A–Z).
Questão 09. Qual é o preço médio de tabela de cada categoria? ordene do maior preço médio para o
menor.
Questão 10. Quantos clientes há em cada cidade? Mostre apenas as cidades com pelo menos 60
clientes, da maior quantidade para a menor; em caso de empate, por nome da cidade (A–Z).
Questão 11. Quantos clientes não informaram e-mail?
Questão 12. Quantas clientes do sexo feminino nasceram entre 01/01/1990 e 31/12/1999 ?
Questão 13. Quantos clientes têm Ana como primeiro nome? (Atenção: nomes como Analu ou Anabela
não contam.)
1
Questão 14. Quantas lojas existem em cada UF? Mostre apenas as UFs com mais de 3 lojas, da maior
quantidade para a menor.
Questão 15. Liste o nome, a cidade e a data de inauguração das lojas inauguradas antes de
01/01/2007, da mais antiga para a mais recente.
Questão 16. Qual foi o faturamento de cada canal de venda em 2025? Ordene do maior faturamento
para o menor.
Questão 17. Considerando apenas o canal Loja física, mostre, para cada forma de pagamento, a
quantidade de linhas de venda e o faturamento. Ordene do maior faturamento para o menor.
Questão 18. Quais são os 10 produtos (id_produto) com mais unidades vendidas (soma de
quantidade)? Ordene da maior soma para a menor; em caso de empate, pelo menor id_produto.
Questão 19. Quais são as 5 lojas (id_loja) com maior faturamento em 2024? Mostre o id_loja e o
faturamento, do maior para o menor.
Questão 20. Quantas linhas de venda cada loja (id_loja) tem? Mostre apenas as lojas com mais de
300 linhas, da maior quantidade para a menor.
Questão 21. Quais clientes (id_cliente) têm 70 ou mais linhas de venda? Mostre o id_cliente e
a quantidade, da maior para a menor; em caso de empate, pelo menor id_cliente. Desconsidere as
vendas sem cliente.
Questão 22. Quantas linhas de venda tiveram desconto (maior que zero) e qual foi o valor médio desse
desconto? Arredonde a média para 2 casas decimais.
Questão 23. Qual foi o menor e o maior valor_total de uma linha de venda em dezembro de
2025?
Questão 24. Quantas linhas de venda foram registradas no dia 24/12/2025 e qual foi o faturamento
desse dia?
Questão 25. Considerando as vendas do canal Site em 2025 que tiveram desconto, mostre:
id_venda, o valor bruto (quantidade × preco_unitario), o desconto, o valor_total e o percentual
de desconto sobre o valor bruto. Ordene do maior percentual para o menor; em caso de empate, pelo
menor id_venda. Mostre apenas as 10 primeiras linhas.
-> Questões elaboradas por Pedro Henrique Mello Pereira, docente do CEUB
*/

-- Questão 1

SELECT COUNT(*) AS total_clientes_nulos
FROM fato_vendas
WHERE id_cliente IS NULL

-- Questão 2

SELECT COUNT(DISTINCT id_cliente) AS total_clientes_diferentes
FROM fato_vendas

-- Questão 3

SELECT SUM(valor_total) AS faturamento_total
FROM fato_vendas

-- Questão 4

SELECT DISTINCT marca AS marcas_higiene
FROM dim_produto
WHERE categoria = 'Higiene'
ORDER BY marca ASC

-- Questão 5 

SELECT AVG(valor_total) AS media_aplicativo
FROM fato_vendas
WHERE canal = 'Aplicativo'

-- Questão 6

SELECT COUNT(*) AS quantidade_bebida_maiorque10
FROM dim_produto
WHERE preco_tabela > 10
AND categoria = 'Bebidas'

-- Questão 7 

SELECT nome_produto, marca, preco_tabela
FROM dim_produto
ORDER BY preco_tabela DESC, nome_produto ASC
LIMIT 1 

-- Questão 8 

SELECT DISTINCT categoria,
	COUNT(*) AS produtos_por_categoria
FROM dim_produto
GROUP BY categoria
ORDER BY produtos_por_categoria DESC, categoria ASC

-- Questão 9

SELECT DISTINCT categoria,
	ROUND(AVG(preco_tabela), 2) AS media_preco
FROM dim_produto
GROUP BY categoria
ORDER BY media_preco DESC

-- Questão 10 
SELECT DISTINCT cidade,
	COUNT(*) AS clientes_na_cidade
FROM dim_cliente
GROUP BY cidade
HAVING COUNT(*) > 60
ORDER BY clientes_na_cidade DESC, cidade ASC

-- Questão 11

SELECT COUNT(id_cliente)
FROM dim_cliente
WHERE email IS NULL

-- Questão 12

SELECT COUNT(id_cliente)
FROM dim_cliente
WHERE sexo = 'F'
AND data_nascimento BETWEEN '1990-01-01' AND '1999-12-31'

-- Questão 13

SELECT COUNT(id_cliente)
FROM dim_cliente
WHERE nome LIKE 'Ana %'

-- Questão 14

SELECT DISTINCT uf,
	COUNT(*) AS lojas_por_uf
FROM dim_loja
GROUP BY uf
HAVING COUNT(*) > 3
ORDER BY lojas_por_uf DESC

-- Questão 15

SELECT nome_loja, cidade, data_inauguracao
FROM dim_loja
WHERE data_inauguracao < '2007-01-01'
ORDER BY data_inauguracao ASC

-- Questão 16 

SELECT DISTINCT canal,
	ROUND(SUM(valor_total), 2) AS faturamento_canal
FROM fato_vendas
GROUP BY canal
ORDER BY ROUND(SUM(valor_total), 2) DESC

-- Questão 17

SELECT DISTINCT forma_pagamento,
	COUNT(*) AS vendas_por_formadepagamento,
	ROUND(SUM(valor_total), 2) AS faturamento_por_formadepagamento
FROM fato_vendas
WHERE canal = 'Loja física'
GROUP BY forma_pagamento
ORDER BY ROUND(SUM(valor_total), 2) DESC

-- Questão 18 

SELECT DISTINCT id_produto,
	SUM(quantidade) AS quantidade_total_produto
FROM fato_vendas
GROUP BY id_produto
ORDER BY SUM(quantidade) DESC, id_produto ASC
LIMIT 10

-- Questão 19

SELECT DISTINCT id_loja,
	SUM(valor_total) AS faturamento
FROM fato_vendas
WHERE data_venda BETWEEN '2024-01-01' AND '2024-12-30'
GROUP BY id_loja
ORDER BY SUM(valor_total) DESC
LIMIT 5

-- Questão 20

SELECT DISTINCT id_loja,
	COUNT(*) AS venda_por_loja
FROM fato_vendas
GROUP BY id_loja
HAVING COUNT(*) > 300
ORDER BY COUNT(*) DESC

-- Questão 21

SELECT DISTINCT id_cliente,
	COUNT(*) AS vendas_por_cliente
FROM fato_vendas
WHERE id_cliente IS NOT NULL
GROUP BY id_cliente
HAVING COUNT(*) >= 70
ORDER BY COUNT(*) DESC, id_cliente ASC

-- Questão 22

SELECT COUNT(desconto) AS linhas_com_desconto,
	ROUND(AVG(desconto), 2) AS media_descontos
FROM fato_vendas

-- Questão 23

SELECT MAX(valor_total) AS maximo,
	MIN(valor_total) AS minimo
FROM fato_vendas
WHERE data_venda BETWEEN '2025-12-01' AND '2025-12-30'

-- Questão 24 

SELECT COUNT(*) AS vendas_no_dia,
	SUM(valor_total) AS faturamento_no_dia
FROM fato_vendas
WHERE data_venda = '2025-12-24'

-- Questão 25

SELECT id_venda, 
	quantidade*preco_unitario AS valor_bruto,
	desconto,
	valor_total,
	(desconto/(quantidade*preco_unitario))*100 AS porcentagem_desconto
FROM fato_vendas
WHERE canal = 'Site'
	AND data_venda BETWEEN '2025-01-01' AND '2025-12-30'
	AND desconto <> 0
ORDER BY (desconto/(quantidade*preco_unitario))*100 DESC, id_venda ASC
LIMIT 10

-- Vendo tabela completa
SELECT *
FROM  fato_vendas