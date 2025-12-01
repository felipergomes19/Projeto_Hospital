use hospital_bd;
 
 SELECT (sexo),count(sexo) FROM paciente 
GROUP BY sexo 
ORDER BY count(sexo) 
; 

SELECT COUNT(*) AS Quantidade_Pacientes
FROM Paciente;

SELECT 
    (SELECT COUNT(*) FROM Funcionario WHERE id_cargo = 1) AS Medicos,
    (SELECT COUNT(*) FROM Funcionario WHERE id_cargo = 2) AS Enfermeiros,
    (SELECT COUNT(*) FROM Funcionario WHERE id_cargo = 3) AS Estoquistas;
    
select id_funcionario, count(*) as quantos_consultas
from consulta
group by id_funcionario;

select id_consulta,avg(temperatura)
from consulta
group by id_consulta;

select id_consulta,temperatura
from consulta
where temperatura > 38;