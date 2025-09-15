# NYC Taxis ETL Pipeline

## Visão Geral

Este projeto implementa um pipeline ETL completo para dados de corridas de táxi de Nova York, utilizando AWS Glue, S3 e Data Catalog, com arquitetura em camadas: Raw, Bronze, Silver e Gold.

## Arquitetura

- **Raw Layer**: Armazena os dados originais em S3 (`nyc-taxis-raw`).
- **Bronze Layer**: Dados espelhados da origem, porém atrelados a uma tabela para consulta no athena (`nyc-taxis-bronze`), tabelas Glue: `tb_green_taxi`, `tb_yellow_taxi`.
- **Silver Layer**: Dados com tipos corrigidos e enriquecidos em S3 (`nyc-taxis-silver`), tabelas Glue: `tb_green_taxi_silver`, `tb_yellow_taxi_silver`.
- **Gold Layer**: Dados analíticos empilhados de ambos os tipos de táxi em S3 (`nyc-taxis-gold`), tabela Glue: `tb_gold_taxi`.

## Buckets S3

- `nyc-taxis-raw`
- `nyc-taxis-bronze`
- `nyc-taxis-silver`
- `nyc-taxis-gold`
- `nyc-taxis-glue-scripts`

## Glue Jobs

- **Raw to Bronze**:
  - `job_green_raw_to_bronze`
  - `job_yellow_raw_to_bronze`
- **Bronze to Silver**:
  - `job_green_bronze_to_silver`
  - `job_yellow_bronze_to_silver`
- **Silver to Gold**:
  - `job_silver_to_gold` (empilha ambos os tipos e adiciona coluna `taxi_type`)

## Glue Workflow

- `nyc_taxi_etl_workflow`: Orquestra todos os jobs.

## Data Catalog

Todas as camadas possuem tabelas registradas no Glue Data Catalog, permitindo consultas via Athena.

## Athena

Usuários podem consultar os dados da camada Gold diretamente via Athena, utilizando a tabela `tb_gold_taxi`.

## Parâmetros

- O jobs são parametrizáveis por data (`--DATA`)

## Como Executar

1. Configure as credenciais do seu AWS CLI
2. Faça o deploy dos recursos com Terraform.
3. Inicie o workflow via AWS CLI:
   ```sh
   aws glue start-workflow-run --name nyc_taxi_etl_workflow
   ```
4. Consulte os dados na camada Gold via Athena.

## Diagrama

O fluxo segue:

```
S3 Raw → Glue Job → S3 Bronze → Glue Job → S3 Silver → Glue Job (empilhado) → S3 Gold → Data Catalog → Athena → Usuário
```

## Desenho da solução
![Diagrama do pipeline](/contents/diagramas.drawio.png)