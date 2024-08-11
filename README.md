Oracle Optimizer Project

Este projeto tem como objetivo explorar e entender o Oracle Optimizer, um componente central do banco de dados Oracle responsável por determinar a maneira mais eficiente de executar uma consulta SQL. O projeto inclui a criação de tabelas, inserção de dados e análise de planos de execução usando diferentes técnicas de junção (Nested Loops, Hash Joins e Sort Merge Joins). Através do uso do comando EXPLAIN PLAN, o projeto oferece uma visão prática de como o Oracle Optimizer escolhe o plano de execução mais eficiente.

Detalhes do Projeto

Oracle Optimizer

O Oracle Optimizer é responsável por determinar a forma mais eficiente de executar uma consulta SQL. Ele analisa diferentes formas de acessar e processar os dados necessários e escolhe o plano de execução mais eficiente, considerando fatores como tamanho da tabela, índices disponíveis, estatísticas dos dados e a estrutura da consulta.

Tipos de Planos de Execução

    Nested Loops

        Como Funciona: Para cada linha da tabela externa, o Oracle procura uma correspondência na tabela interna. É eficaz para consultas que retornam um pequeno número de linhas.
        Quando Usar: Geralmente usado quando uma tabela é pequena e a outra possui um índice apropriado ou quando as condições de junção são seletivas.

    Hash Joins

        Como Funciona: Cria uma tabela hash na memória a partir da tabela menor e verifica a tabela maior em busca de correspondências. É eficaz em grandes conjuntos de dados.
        Quando Usar: Usado quando grandes volumes de dados devem ser combinados e não existem índices adequados ou quando as tabelas são de tamanho semelhante.
    
    Sort Merge Joins

        Como Funciona: As tabelas são classificadas com base nas colunas de junção e depois combinadas. É eficaz para consultas que envolvem grandes conjuntos de dados já classificados ou que precisam ser classificados.
        Quando Usar: Útil quando as tabelas são ordenadas antecipadamente ou quando o custo de ordenar é compensado pelo ganho na junção.

Scripts SQL

    Criação de Tabelas

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
```

    Inserção de Dados

```sql
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
```

    Geração de Planos de Execução

```sql
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
```

Análise dos Planos de Execução

Hash Join

O Hash Join foi escolhido porque pode ser mais eficiente em grandes volumes de dados. O Oracle cria uma tabela hash na memória para a tabela menor e então escaneia a tabela maior para encontrar correspondências. Essa técnica é útil quando não existem índices adequados ou quando as tabelas são de tamanho semelhante.

Sort Merge Join

O Sort Merge Join foi usado, o que é ideal quando as tabelas já estão ordenadas ou quando o custo de ordenar é compensado pelo ganho na junção. Isso pode ser vantajoso em grandes conjuntos de dados onde a ordenação prévia ou forçada melhora a eficiência da junção.

Conclusão

Os diferentes tipos de junções têm suas próprias vantagens dependendo do contexto. O Oracle Optimizer escolhe a estratégia que melhor se adapta à situação com base nas estatísticas das tabelas e nas condições da consulta. Compreender esses planos e técnicas permite otimizar consultas para melhorar o desempenho do banco de dados.
