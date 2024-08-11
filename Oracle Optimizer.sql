Oracle Optimizer

O Oracle Optimizer é um componente central do banco de dados Oracle, responsável por determinar a maneira mais eficiente de executar uma consulta SQL. Analisa as diferentes formas possíveis de acessar e processar os dados necessários e escolhe o plano de execução mais eficiente, levando em consideração fatores como tamanho da tabela, índices disponíveis, estatísticas dos dados e a própria estrutura.
Tipos de planos de execução

Nested Loops
Como Funciona: Uma técnica na qual, para cada linha da tabela externa, o Oracle procura uma correspondência na tabela interna. É eficaz para consultas que retornam um pequeno número de linhas. 
Quando usar: Geralmente usado quando uma tabela é pequena e a outra possui um índice apropriado, ou quando as condições de junção são seletivas.

Hash Joins:
Cria uma tabela hash na memória a partir da tabela menor (chamada de tabela de construção) e, em seguida, verifica a tabela maior (a tabela de teste) em busca de correspondências. É eficaz em grandes conjuntos de dados. 
Quando usar: Usado quando grandes volumes de dados devem ser combinados e não existem índices adequados, ou quando as tabelas são de tamanho semelhante.

Sort Merge Joins:
As tabelas são classificadas com base nas colunas de junção e depois combinadas. Isso pode ser eficaz para consultas que envolvem grandes conjuntos de dados que já estão classificados ou que precisam ser classificados. 
Quando usar: É útil quando as mesas são encomendadas antecipadamente ou quando o custo do sorteio é compensado pelo lucro do sindicato. 
Prático: analise planos de execução com EXPLAIN PLAN


### Create Table

```sql
-- Criação de Tabelas
CREATE TABLE employees (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(50),
    dept_id NUMBER
);

CREATE TABLE departments (
    dept_id NUMBER PRIMARY KEY,
    dept_name VARCHAR2(50)
);

CREATE INDEX idx_emp_dept_id ON employees(dept_id);

### Insert

-- Inserção de Dados
INSERT INTO departments (dept_id, dept_name) VALUES (1, 'HR');
INSERT INTO departments (dept_id, dept_name) VALUES (2, 'Finance');
INSERT INTO departments (dept_id, dept_name) VALUES (3, 'IT');

INSERT INTO employees (emp_id, emp_name, dept_id) VALUES (101, 'Alice', 1);
INSERT INTO employees (emp_id, emp_name, dept_id) VALUES (102, 'Bob', 2);
INSERT INTO employees (emp_id, emp_name, dept_id) VALUES (103, 'Charlie', 3);
INSERT INTO employees (emp_id, emp_name, dept_id) VALUES (104, 'David', 1);
INSERT INTO employees (emp_id, emp_name, dept_id) VALUES (105, 'Eve', 2);

COMMIT;

### Explain

-- Consulta usando Nested Loops
EXPLAIN PLAN FOR
SELECT e.emp_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Consulta usando Hash Join (Force a hash join)
EXPLAIN PLAN FOR
SELECT /*+ USE_HASH(d) */ e.emp_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Consulta usando Sort Merge Join (Force a sort merge join)
EXPLAIN PLAN FOR
SELECT /*+ USE_MERGE(d) */ e.emp_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

### Hash Join

O Hash Join foi escolhido porque pode ser mais eficiente em grandes volumes de dados. O Oracle cria uma tabela hash na memória para a tabela menor e então escaneia a tabela maior para encontrar correspondências.

### Sort Merge Join

O Sort Merge Join foi usado, o que é ideal quando as tabelas já estão ordenadas ou quando o custo de ordenar é compensado pelo ganho na junção.

### Conclusão

Os diferentes tipos de junções têm suas próprias vantagens dependendo do contexto, e o Oracle Optimizer escolhe a estratégia que melhor se adapta à situação com base nas estatísticas das tabelas e nas condições da consulta.