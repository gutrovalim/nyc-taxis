## Qual a média de valor total (total_amount) recebido em um mês considerando todos os yellow táxis da frota?

```sql
SELECT
  AVG(total_amount) AS media_mensal_amount
FROM
  tb_gold_taxi
WHERE
  taxi_type = 'yellow'
  AND year_month = 202305;
```

| Mês      | Média Mensal Amount |
|----------|---------------------|
| 202305   | 28.962981777556617  |

Em média, cada corrida de yellow táxi foi de aproximadamente $28,96.

## Qual a média de passageiros (passenger_count) por cada hora do dia que pegaram táxi no mês de maio considerando todos os táxis da frota?

```sql
SELECT
  hour(pickup_datetime) AS hora,
  AVG(passenger_count) AS media_passageiros
FROM
  tb_gold_taxi
WHERE
  year_month = 202305
GROUP BY
  hour(pickup_datetime)
ORDER BY
  hora;
```

| Hora | Média de Passageiros |
|------|---------------------|
| 0    | 1.4104              |
| 1    | 1.4192              |
| 2    | 1.4357              |
| 3    | 1.4333              |
| 4    | 1.3875              |
| 5    | 1.2648              |
| 6    | 1.2353              |
| 7    | 1.2523              |
| 8    | 1.2645              |
| 9    | 1.2825              |
| 10   | 1.3177              |
| 11   | 1.3330              |
| 12   | 1.3470              |
| 13   | 1.3540              |
| 14   | 1.3594              |
| 15   | 1.3710              |
| 16   | 1.3695              |
| 17   | 1.3624              |
| 18   | 1.3581              |
| 19   | 1.3682              |
| 20   | 1.3799              |
| 21   | 1.4004              |
| 22   | 1.4100              |
| 23   | 1.4056              |

Ao longo de todas as horas do dia no mês de maio, a média de passageiros por corrida de táxi em Nova York ficou entre 1,2 e 1,4. Ou seja, a maioria das corridas tem apenas um passageiro, independentemente do horário.