-- ATENÇÃO: reseta (apaga) o banco Hospital_BD e recria tudo limpo
DROP DATABASE IF EXISTS Hospital_BD;
CREATE DATABASE Hospital_BD CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE Hospital_BD;

-- Desliga checagens de FK para garantir drop/creation sem bloqueios
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Consulta;
DROP TABLE IF EXISTS Receita;
DROP TABLE IF EXISTS Estoque_remedio;
DROP TABLE IF EXISTS Remedio;
DROP TABLE IF EXISTS Sala;
DROP TABLE IF EXISTS Especialidade_medico;
DROP TABLE IF EXISTS Especialidade_enfermeiro;
DROP TABLE IF EXISTS Funcionario;
DROP TABLE IF EXISTS Cargo;
DROP TABLE IF EXISTS Paciente;

SET FOREIGN_KEY_CHECKS = 1;

-- ==========================
-- Criação das tabelas (ordem correta)
-- ==========================

CREATE TABLE Cargo (
    id_cargo INT NOT NULL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Paciente (
    id_paciente INT NOT NULL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sexo VARCHAR(20) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    data_nascimento DATE NOT NULL,
    CPF CHAR(11) NOT NULL UNIQUE,
    CEP CHAR(8) NOT NULL UNIQUE,
    complemento_endereco VARCHAR(10) NOT NULL,
    endereco VARCHAR(120) NOT NULL,
    RG CHAR(9) NOT NULL,
    UF_paciente CHAR(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Funcionario (
    id_funcionario INT NOT NULL PRIMARY KEY,
    id_cargo INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    sexo VARCHAR(20) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    data_nascimento DATE NOT NULL,
    CPF CHAR(11) NOT NULL UNIQUE,
    CEP CHAR(8) NOT NULL,
    complemento_endereco VARCHAR(10) NOT NULL,
    endereco VARCHAR(120) NOT NULL,
    RG CHAR(9) NOT NULL,
    UF_funcionario CHAR(2) NOT NULL,
    COREN VARCHAR(20),
    CRM VARCHAR(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Especialidade_enfermeiro (
    id_especialidade_enfermeiro INT NOT NULL PRIMARY KEY,
    id_funcionario INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    UNIQUE (id_funcionario, nome),
    CONSTRAINT fk_esp_enf_func FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Especialidade_medico (
    id_especialidade_medico INT NOT NULL PRIMARY KEY,
    id_funcionario INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    UNIQUE (id_funcionario, nome),
    CONSTRAINT fk_esp_med_func FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Sala (
    id_sala INT NOT NULL PRIMARY KEY,
    id_funcionario INT NOT NULL,
    CONSTRAINT fk_sala_func FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Remedio (
    id_remedio INT NOT NULL PRIMARY KEY,
    id_paciente INT NOT NULL,
    nome_remedio VARCHAR(100) NOT NULL,
    quantidade_ingerida VARCHAR(100) NOT NULL,
    CONSTRAINT fk_remedio_paciente FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Estoque_remedio (
    id_estoque INT NOT NULL PRIMARY KEY,
    id_remedio INT NOT NULL,
    id_funcionario INT NOT NULL,
    quantidade INT NOT NULL,
    data_entrada DATE NOT NULL,
    data_validade DATE NOT NULL,
    CONSTRAINT fk_estoque_remedio_remedio FOREIGN KEY (id_remedio) REFERENCES Remedio(id_remedio),
    CONSTRAINT fk_estoque_remedio_func FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Receita (
    id_receita INT NOT NULL PRIMARY KEY,
    id_remedio INT NOT NULL,
    id_paciente INT NOT NULL,
    id_funcionario INT NOT NULL,
    data_emissao DATE NOT NULL,
    quantidade VARCHAR(50) NOT NULL,
    dosagem VARCHAR(50) NOT NULL,
    periodo_consumo VARCHAR(20) NOT NULL,
    UF_paciente CHAR(2) NOT NULL,
    UF_funcionario CHAR(2) NOT NULL,
    CONSTRAINT fk_receita_remedio FOREIGN KEY (id_remedio) REFERENCES Remedio(id_remedio),
    CONSTRAINT fk_receita_paciente FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    CONSTRAINT fk_receita_funcionario FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Consulta (
    id_consulta INT NOT NULL PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_funcionario INT NOT NULL,
    id_sala INT NOT NULL,
    id_receita INT NOT NULL,
    temperatura DECIMAL(4,1) NOT NULL,
    pressao_arterial VARCHAR(7) NOT NULL,
    frequencia_cardiaca INT NOT NULL,
    diagnostico VARCHAR(200) NOT NULL,
    data_hora DATETIME NOT NULL,
    CONSTRAINT fk_consulta_paciente FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    CONSTRAINT fk_consulta_funcionario FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario),
    CONSTRAINT fk_consulta_sala FOREIGN KEY (id_sala) REFERENCES Sala(id_sala),
    CONSTRAINT fk_consulta_receita FOREIGN KEY (id_receita) REFERENCES Receita(id_receita)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Grupo Fernando vai do 1 ao 50

-- Grupo Fernando
INSERT INTO Paciente (id_paciente, nome, sexo, telefone, data_nascimento, CPF, CEP, complemento_endereco, endereco, RG, UF_paciente) VALUES
(1, 'Ana Souza', 'Feminino', '(11)98877-1234', '1985-04-12', '12345678901', '01001000', 'Ap 12', 'Rua das Flores, 100', '123456789', 'SP'),
(2, 'Carlos Pereira', 'Masculino', '(21)99777-5678', '1990-07-25', '12345678902', '01002001', 'Casa 3', 'Av. Brasil, 200', '223456789', 'RJ'),
(3, 'Juliana Lima', 'Feminino', '(31)98222-1111', '1978-02-10', '12345678903', '01003002', 'Bl 2', 'Rua Minas, 50', '323456789', 'MG'),
(4, 'Rafael Gomes', 'Masculino', '(41)98111-9999', '1988-11-30', '12345678904', '01004003', 'Ap 101', 'Rua Paraná, 300', '423456789', 'PR'),
(5, 'Mariana Castro', 'Feminino', '(51)99123-4567', '1995-09-05', '12345678905', '01005004', 'Casa 5', 'Av. Central, 400', '523456789', 'RS'),
(6, 'Pedro Fernandes', 'Masculino', '(61)99900-8765', '1982-03-19', '12345678906', '01006005', 'Ap 22', 'Rua Brasília, 22', '623456789', 'DF'),
(7, 'Camila Oliveira', 'Feminino', '(71)98888-6543', '2000-06-14', '12345678907', '01007006', 'Casa 7', 'Av. Salvador, 77', '723456789', 'BA'),
(8, 'Rodrigo Santos', 'Masculino', '(81)98765-4321', '1993-08-20', '12345678908', '01008007', 'Bl 3', 'Rua Recife, 12', '823456789', 'PE'),
(9, 'Beatriz Almeida', 'Feminino', '(91)98654-7890', '1975-12-01', '12345678909', '01009008', 'Ap 45', 'Rua Pará, 300', '923456789', 'PA'),
(10, 'Gustavo Ribeiro', 'Masculino', '(85)98555-1234', '1989-05-18', '12345678910', '01010009', 'Casa 10', 'Av. Ceará, 55', '133456789', 'CE'),
(11, 'Fernanda Costa', 'Feminino', '(62)98444-6789', '1992-09-27', '12345678911', '01011010', 'Ap 8', 'Rua Goiás, 18', '233456789', 'GO'),
(12, 'Lucas Martins', 'Masculino', '(31)98333-4567', '1984-07-02', '12345678912', '01012011', 'Bl 6', 'Rua Ouro Preto, 66', '333456789', 'MG'),
(13, 'Patrícia Mendes', 'Feminino', '(41)98222-1111', '1997-03-08', '12345678913', '01013012', 'Casa 2', 'Av. Curitiba, 12', '433456789', 'PR'),
(14, 'Thiago Rocha', 'Masculino', '(51)98111-2222', '1979-10-22', '12345678914', '01014013', 'Ap 9', 'Rua Porto Alegre, 90', '533456789', 'RS'),
(15, 'Larissa Barros', 'Feminino', '(11)98777-3333', '1996-01-29', '12345678915', '01015014', 'Bl 1', 'Rua Paulista, 1200', '633456789', 'SP'),
(16, 'Diego Carvalho', 'Masculino', '(21)98666-4444', '1987-04-16', '12345678916', '01016015', 'Casa 11', 'Av. Atlântica, 500', '733456789', 'RJ'),
(17, 'Aline Ferreira', 'Feminino', '(31)98555-5555', '1983-11-09', '12345678917', '01017016', 'Ap 15', 'Rua Mariana, 44', '833456789', 'MG'),
(18, 'Bruno Nascimento', 'Masculino', '(71)98444-6666', '1991-06-21', '12345678918', '01018017', 'Casa 9', 'Av. Pelourinho, 99', '933456789', 'BA'),
(19, 'Vanessa Duarte', 'Feminino', '(81)98333-7777', '1986-09-13', '12345678919', '01019018', 'Bl 7', 'Rua Recife Antigo, 70', '143456789', 'PE'),
(20, 'Felipe Moreira', 'Masculino', '(61)98222-8888', '1994-12-31', '12345678920', '01020019', 'Ap 100', 'Rua JK, 200', '243456789', 'DF'),
(21, 'Sofia Cardoso', 'Feminino', '(91)98111-9999', '1972-05-15', '12345678921', '01021020', 'Casa 13', 'Av. Amazônia, 13', '343456789', 'PA'),
(22, 'Eduardo Lima', 'Masculino', '(85)98777-1234', '1981-02-08', '12345678922', '01022021', 'Ap 22', 'Rua Fortaleza, 221', '443456789', 'CE'),
(23, 'Paula Silva', 'Feminino', '(62)98666-5678', '1998-07-01', '12345678923', '01023022', 'Bl 4', 'Rua Goiânia, 55', '543456789', 'GO'),
(24, 'Renato Teixeira', 'Masculino', '(31)98555-8765', '1980-08-19', '12345678924', '01024023', 'Casa 20', 'Av. Pampulha, 77', '643456789', 'MG'),
(25, 'Luana Pires', 'Feminino', '(41)98444-4321', '1999-10-05', '12345678925', '01025024', 'Ap 33', 'Rua das Araucárias, 33', '743456789', 'PR'),
(26, 'Mateus Faria', 'Masculino', '(51)98333-6543', '1985-11-12', '12345678926', '01026025', 'Casa 8', 'Rua Bento Gonçalves, 88', '843456789', 'RS'),
(27, 'Isabela Tavares', 'Feminino', '(11)98222-7890', '1993-01-23', '12345678927', '01027026', 'Bl 2', 'Rua Vergueiro, 450', '943456789', 'SP'),
(28, 'Leonardo Dias', 'Masculino', '(21)98111-2345', '1977-06-04', '12345678928', '01028027', 'Ap 40', 'Av. Copacabana, 300', '153456789', 'RJ'),
(29, 'Carolina Moraes', 'Feminino', '(31)98765-8888', '2001-02-17', '12345678929', '01029028', 'Casa 14', 'Rua Diamantina, 200', '253456789', 'MG'),
(30, 'André Rezende', 'Masculino', '(71)98654-2222', '1990-03-14', '12345678930', '01030029', 'Ap 55', 'Av. Bahia, 77', '353456789', 'BA'),
(31, 'Débora Batista', 'Feminino', '(81)98543-9999', '1982-07-30', '12345678931', '01031030', 'Casa 5', 'Rua Olinda, 150', '453456789', 'PE'),
(32, 'Ricardo Azevedo', 'Masculino', '(61)98432-1234', '1979-05-25', '12345678932', '01032031', 'Bl 3', 'Rua Planalto, 60', '553456789', 'DF'),
(33, 'Gabriela Cunha', 'Feminino', '(91)98321-5678', '1997-09-11', '12345678933', '01033032', 'Ap 18', 'Av. Belém, 33', '653456789', 'PA'),
(34, 'Marcelo Pinto', 'Masculino', '(85)98210-7654', '1986-11-03', '12345678934', '01034033', 'Casa 21', 'Rua Ceará, 121', '753456789', 'CE'),
(35, 'Tatiane Ramos', 'Feminino', '(62)98109-9876', '1974-04-28', '12345678935', '01035034', 'Ap 77', 'Av. Goiânia, 411', '853456789', 'GO'),
(36, 'Victor Barcellos', 'Masculino', '(31)98098-3456', '1988-01-09', '12345678936', '01036035', 'Casa 32', 'Rua Ouro Branco, 78', '953456789', 'MG'),
(37, 'Priscila Duarte', 'Feminino', '(41)97987-1111', '1995-12-19', '12345678937', '01037036', 'Bl 6', 'Rua das Araucárias, 12', '163456789', 'PR'),
(38, 'Otávio Monteiro', 'Masculino', '(51)97876-2222', '1973-06-16', '12345678938', '01038037', 'Ap 11', 'Av. Farroupilha, 200', '263456789', 'RS'),
(39, 'Bianca Lopes', 'Feminino', '(11)97765-3333', '1992-03-21', '12345678939', '01039038', 'Casa 19', 'Rua Augusta, 700', '363456789', 'SP'),
(40, 'Henrique Melo', 'Masculino', '(21)97654-4444', '1981-07-08', '12345678940', '01040039', 'Ap 12', 'Av. Flamengo, 80', '463456789', 'RJ'),
(41, 'Cláudia Rezende', 'Feminino', '(31)97543-5555', '1976-05-27', '12345678941', '01041040', 'Bl 5', 'Rua Mariana, 177', '563456789', 'MG'),
(42, 'Alexandre Borges', 'Masculino', '(71)97432-6666', '2000-09-02', '12345678942', '01042041', 'Casa 22', 'Av. Salvador, 222', '663456789', 'BA'),
(43, 'Natália Farias', 'Feminino', '(81)97321-7777', '1998-11-14', '12345678943', '01043042', 'Ap 9', 'Rua Recife, 99', '763456789', 'PE'),
(44, 'Douglas Barros', 'Masculino', '(61)97210-8888', '1971-01-06', '12345678944', '01044043', 'Casa 18', 'Rua JK, 88', '863456789', 'DF'),
(45, 'Patrícia Xavier', 'Feminino', '(91)97109-9999', '1994-08-28', '12345678945', '01045044', 'Bl 7', 'Av. Belém, 70', '963456789', 'PA'),
(46, 'Fernando Assis', 'Masculino', '(85)97098-1234', '1978-10-22', '12345678946', '01046045', 'Ap 10', 'Rua Ceará, 50', '173456789', 'CE'),
(47, 'Juliana Prado', 'Feminino', '(62)96987-2345', '1989-02-03', '12345678947', '01047046', 'Casa 24', 'Av. Goiânia, 120', '273456789', 'GO'),
(48, 'Daniel Correia', 'Masculino', '(31)96876-3456', '1996-12-30', '12345678948', '01048047', 'Bl 8', 'Rua Ouro Preto, 200', '373456789', 'MG'),
(49, 'Carla Monteiro', 'Feminino', '(41)96765-4567', '1984-06-11', '12345678949', '01049048', 'Ap 5', 'Rua Curitiba, 321', '473456789', 'PR'),
(50, 'Rogério Fonseca', 'Masculino', '(51)96654-5678', '1970-09-07', '12345678950', '01050049', 'Casa 30', 'Av. Porto Alegre, 77', '573456789', 'RS');

-- Grupo Fernando
INSERT INTO Cargo (id_cargo, nome) VALUES
(1, 'Médico'),
(2, 'Enfermeiro'),
(3, 'Estoquista');

-- Grupo Fernando
INSERT INTO Funcionario (id_funcionario, id_cargo, nome, sexo, telefone, data_nascimento, CPF, CEP, complemento_endereco, endereco, RG, UF_funcionario, COREN, CRM) VALUES
(1, 1, 'Eduarda Meireles', 'Feminino', '(11)97011-2233', '1988-04-17', '33333333331', '15000001', 'Ap 11', 'Rua das Acácias, 101', '101112223', 'SP', NULL, '300001'),
(2, 1, 'Leonardo Figueiredo', 'Masculino', '(21)97122-3344', '1979-08-25', '33333333332', '15000002', 'Casa 4', 'Av. Rio Branco, 204', '202223334', 'RJ', NULL, '300002'),
(3, 1, 'Marina Lopes', 'Feminino', '(31)97233-4455', '1991-01-11', '33333333333', '15000003', 'Bl 7', 'Rua Ouro Verde, 56', '303334445', 'MG', NULL, '300003'),
(4, 1, 'Thiago Souza', 'Masculino', '(41)97344-5566', '1986-11-12', '33333333334', '15000004', 'Ap 21', 'Rua Paraná, 303', '404445556', 'PR', NULL, '300004'),
(5, 1, 'Carla Martins', 'Feminino', '(51)97455-6677', '1994-05-03', '33333333335', '15000005', 'Casa 8', 'Av. Central, 405', '505556667', 'RS', NULL, '300005'),
(6, 1, 'Ricardo Almeida', 'Masculino', '(61)97566-7788', '1983-03-19', '33333333336', '15000006', 'Ap 2', 'Rua Brasília, 22', '606667778', 'DF', NULL, '300006'),
(7, 1, 'Fernanda Carvalho', 'Feminino', '(71)97677-8899', '1996-06-14', '33333333337', '15000007', 'Casa 10', 'Av. Salvador, 77', '707778889', 'BA', NULL, '300007'),
(8, 1, 'Vitor Nascimento', 'Masculino', '(81)97788-9900', '1992-08-20', '33333333338', '15000008', 'Bl 5', 'Rua Recife, 12', '808889900', 'PE', NULL, '300008'),
(9, 1, 'Juliana Ribeiro', 'Feminino', '(91)97899-0011', '1980-12-01', '33333333339', '15000009', 'Ap 12', 'Rua Pará, 305', '909990011', 'PA', NULL, '300009'),
(10, 1, 'Gustavo Fernandes', 'Masculino', '(85)97900-1122', '1989-05-18', '33333333340', '15000010', 'Casa 11', 'Av. Ceará, 55', '101101122', 'CE', NULL, '300010'),

(11, 1, 'Amanda Teixeira', 'Feminino', '(62)97011-2233', '1993-09-27', '33333333341', '15000011', 'Ap 5', 'Rua Goiás, 18', '111212233', 'GO', NULL, '300011'),
(12, 1, 'Lucas Pereira', 'Masculino', '(31)97122-3344', '1984-07-02', '33333333342', '15000012', 'Bl 6', 'Rua Ouro Preto, 66', '121323344', 'MG', NULL, '300012'),
(13, 1, 'Patrícia Farias', 'Feminino', '(41)97233-4455', '1997-03-08', '33333333343', '15000013', 'Casa 12', 'Av. Curitiba, 12', '131434455', 'PR', NULL, '300013'),
(14, 1, 'Thiago Rocha', 'Masculino', '(51)97344-5566', '1979-10-22', '33333333344', '15000014', 'Ap 9', 'Rua Porto Alegre, 90', '141545566', 'RS', NULL, '300014'),
(15, 1, 'Larissa Souza', 'Feminino', '(11)97455-6677', '1996-01-29', '33333333345', '15000015', 'Bl 1', 'Rua Paulista, 1200', '151656677', 'SP', NULL, '300015'),
(16, 1, 'Diego Carvalho', 'Masculino', '(21)97566-7788', '1987-04-16', '33333333346', '15000016', 'Casa 11', 'Av. Atlântica, 500', '161767788', 'RJ', NULL, '300016'),
(17, 1, 'Aline Ferreira', 'Feminino', '(31)97677-8899', '1983-11-09', '33333333347', '15000017', 'Ap 15', 'Rua Mariana, 44', '171878899', 'MG', NULL, '300017'),
(18, 1, 'Bruno Nascimento', 'Masculino', '(71)97788-9900', '1991-06-21', '33333333348', '15000018', 'Casa 9', 'Av. Pelourinho, 99', '181989900', 'BA', NULL, '300018'),
(19, 1, 'Vanessa Duarte', 'Feminino', '(81)97899-0011', '1986-09-13', '33333333349', '15000019', 'Bl 7', 'Rua Recife Antigo, 70', '192001122', 'PE', NULL, '300019'),
(20, 1, 'Felipe Moreira', 'Masculino', '(61)97900-1122', '1994-12-31', '33333333350', '15000020', 'Ap 100', 'Rua JK, 200', '202112233', 'DF', NULL, '300020'),

(21, 2, 'Sofia Cardoso', 'Feminino', '(91)97011-3335', '1972-05-15', '33333333351', '16000021', 'Casa 13', 'Av. Amazônia, 13', '212223344', 'PA', 'COREN3001', NULL),
(22, 2, 'Renata Moura', 'Feminino', '(85)99111-3344', '1982-03-12', '55555555552', '18000022', 'Ap 11', 'Rua das Palmeiras, 120', '101234567', 'CE', 'COREN4002', NULL),
(23, 2, 'Felipe Andrade', 'Masculino', '(62)99222-4455', '1995-06-18', '55555555553', '18000023', 'Bl 7', 'Rua das Orquídeas, 34', '112345678', 'GO', 'COREN4003', NULL),
(24, 2, 'Camila Freitas', 'Feminino', '(31)99333-5566', '1987-09-22', '55555555554', '18000024', 'Casa 5', 'Av. Afonso Pena, 77', '123456789', 'MG', 'COREN4004', NULL),
(25, 2, 'Rafael Torres', 'Masculino', '(41)99444-6677', '1992-11-15', '55555555555', '18000025', 'Ap 33', 'Rua das Araucárias, 56', '134567890', 'PR', 'COREN4005', NULL),
(26, 2, 'Juliana Santos', 'Feminino', '(51)99555-7788', '1985-02-28', '55555555556', '18000026', 'Casa 8', 'Rua Bento Gonçalves, 88', '145678901', 'RS', 'COREN4006', NULL),
(27, 2, 'Lucas Ribeiro', 'Masculino', '(11)99666-8899', '1990-01-10', '55555555557', '18000027', 'Bl 2', 'Rua Vergueiro, 450', '156789012', 'SP', 'COREN4007', NULL),
(28, 2, 'Sofia Oliveira', 'Feminino', '(21)99777-9900', '1979-04-05', '55555555558', '18000028', 'Ap 40', 'Av. Copacabana, 300', '167890123', 'RJ', 'COREN4008', NULL),
(29, 2, 'Matheus Lima', 'Masculino', '(31)99888-1011', '2000-07-17', '55555555559', '18000029', 'Casa 14', 'Rua Diamantina, 200', '178901234', 'MG', 'COREN4009', NULL),
(30, 2, 'Bianca Costa', 'Feminino', '(71)99999-2122', '1991-03-24', '55555555560', '18000030', 'Ap 55', 'Av. Bahia, 77', '189012345', 'BA', 'COREN4010', NULL),

(31, 2, 'Vinicius Carvalho', 'Masculino', '(81)90000-3233', '1983-07-02', '55555555561', '18000031', 'Casa 5', 'Rua Olinda, 150', '190123456', 'PE', 'COREN4011', NULL),
(32, 2, 'Isabela Martins', 'Feminino', '(61)91111-4344', '1980-05-19', '55555555562', '18000032', 'Bl 3', 'Rua Planalto, 60', '201234567', 'DF', 'COREN4012', NULL),
(33, 2, 'Eduardo Cunha', 'Masculino', '(91)92222-5455', '1996-09-11', '55555555563', '18000033', 'Ap 18', 'Av. Belém, 33', '212345678', 'PA', 'COREN4013', NULL),
(34, 2, 'Larissa Pinto', 'Feminino', '(85)93333-6566', '1987-11-03', '55555555564', '18000034', 'Casa 21', 'Rua Ceará, 121', '223456789', 'CE', 'COREN4014', NULL),
(35, 2, 'Bruno Barros', 'Masculino', '(62)94444-7677', '1976-04-28', '55555555565', '18000035', 'Ap 77', 'Av. Goiânia, 411', '234567890', 'GO', 'COREN4015', NULL),
(36, 2, 'Priscila Rocha', 'Feminino', '(31)95555-8788', '1989-01-09', '55555555566', '18000036', 'Casa 32', 'Rua Ouro Branco, 78', '245678901', 'MG', 'COREN4016', NULL),
(37, 2, 'Daniela Nascimento', 'Feminino', '(41)96666-9899', '1997-12-19', '55555555567', '18000037', 'Bl 6', 'Rua das Araucárias, 12', '256789012', 'PR', 'COREN4017', NULL),
(38, 2, 'Felipe Monteiro', 'Masculino', '(51)97777-1010', '1975-06-16', '55555555568', '18000038', 'Ap 11', 'Av. Farroupilha, 200', '267890123', 'RS', 'COREN4018', NULL),
(39, 2, 'Mariana Lopes', 'Feminino', '(11)98888-2121', '1994-03-21', '55555555569', '18000039', 'Casa 19', 'Rua Augusta, 700', '278901234', 'SP', 'COREN4019', NULL),
(40, 2, 'Rodrigo Melo', 'Masculino', '(21)99999-3232', '1982-07-08', '55555555570', '18000040', 'Ap 12', 'Av. Flamengo, 80', '289012345', 'RJ', 'COREN4020', NULL),


(41, 3, 'Cláudia Rezende', 'Feminino', '(31)91234-5559', '1978-05-27', '22222222261', '16000041', 'Bl 5', 'Rua Mariana, 177', '424223344', 'MG', NULL, NULL),
(42, 3, 'Lucas Borges', 'Masculino', '(71)92345-6660', '1998-09-02', '22222222262', '16000042', 'Casa 22', 'Av. Salvador, 222', '434334455', 'BA', NULL, NULL),
(43, 3, 'Flavia Farias', 'Feminino', '(81)93456-7771', '2000-11-14', '22222222263', '16000043', 'Ap 9', 'Rua Recife, 99', '444445566', 'PE', NULL, NULL),
(44, 3, 'Daniel Barros', 'Masculino', '(61)94567-8882', '1973-01-06', '22222222264', '16000044', 'Casa 18', 'Rua JK, 88', '454556677', 'DF', NULL, NULL),
(45, 3, 'Neusa Xavier', 'Feminino', '(91)95678-9993', '1995-08-28', '22222222265', '16000045', 'Bl 7', 'Av. Belém, 70', '464667788', 'PA', NULL, NULL),
(46, 3, 'Fernando Assis', 'Masculino', '(85)96789-1235', '1980-10-22', '22222222266', '16000046', 'Ap 10', 'Rua Ceará, 50', '474778899', 'CE', NULL, NULL),
(47, 3, 'Mariana Prado', 'Feminino', '(62)97890-2346', '1990-02-03', '22222222267', '16000047', 'Casa 24', 'Av. Goiânia, 120', '484889900', 'GO', NULL, NULL),
(48, 3, 'Joao Correia', 'Masculino', '(31)98901-3457', '1993-12-30', '22222222268', '16000048', 'Bl 8', 'Rua Ouro Preto, 200', '494990011', 'MG', NULL, NULL),
(49, 3, 'Amanda pinto', 'Feminino', '(41)99012-4568', '1986-06-11', '22222222269', '16000049', 'Ap 5', 'Rua Curitiba, 321', '505001122', 'PR', NULL, NULL),
(50, 3, 'Leonardo Fiani', 'Masculino', '(51)90123-5679', '1975-09-07', '22222222270', '16000050', 'Casa 30', 'Av. Porto Alegre, 77', '515112233', 'RS', NULL, NULL);


-- Grupo Fernando
INSERT INTO Especialidade_enfermeiro (id_especialidade_enfermeiro, id_funcionario, nome) VALUES
(1, 21, 'Enfermagem em Clínica Médica'),
(2, 22, 'Enfermagem Cirúrgica'),
(3, 23, 'Enfermagem em Emergência e Urgência'),
(4, 24, 'Enfermagem em Terapia Intensiva'),
(5, 25, 'Enfermagem Obstétrica'),
(6, 26, 'Enfermagem Pediátrica'),
(7, 27, 'Enfermagem em Saúde Mental'),
(8, 28, 'Enfermagem em Oncologia'),
(9, 29, 'Enfermagem em Nefrologia'),
(10, 30, 'Enfermagem em Clínica Médica'),

(11, 31, 'Enfermagem Cirúrgica'),
(12, 32, 'Enfermagem em Emergência e Urgência'),
(13, 33, 'Enfermagem em Terapia Intensiva'),
(14, 34, 'Enfermagem Obstétrica'),
(15, 35, 'Enfermagem Pediátrica'),
(16, 36, 'Enfermagem em Saúde Mental'),
(17, 37, 'Enfermagem em Oncologia'),
(18, 38, 'Enfermagem em Nefrologia'),
(19, 39, 'Enfermagem em Clínica Médica'),
(20, 40, 'Enfermagem Cirúrgica');

-- Grupo Fernando
INSERT INTO Especialidade_medico (id_especialidade_medico, id_funcionario, nome) VALUES
(1, 1, 'Clínica médica'),
(2, 2, 'Cirurgia geral'),
(3, 3, 'Pediatria'),
(4, 4, 'Ginecologia'),
(5, 5, 'Ortopedia'),
(6, 6, 'Cardiologia'),
(7, 7, 'Neurologia'),
(8, 8, 'Anestesiologia'),
(9, 9, 'Radiologia'),
(10, 10, 'Emergência'),

(11, 11, 'Clínica médica'),
(12, 12, 'Cirurgia geral'),
(13, 13, 'Pediatria'),
(14, 14, 'Ginecologia'),
(15, 15, 'Ortopedia'),
(16, 16, 'Cardiologia'),
(17, 17, 'Neurologia'),
(18, 18, 'Anestesiologia'),
(19, 19, 'Radiologia'),
(20, 20, 'Emergência');

-- Grupo Fernando
INSERT INTO Sala (id_sala, id_funcionario) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20);

-- Grupo Fernando
INSERT INTO Remedio (id_remedio, id_paciente, nome_remedio, quantidade_ingerida) VALUES
(1, 1, 'Ibuprofeno', '1 comprimido'), 
(2, 2, 'Dipirona', '20 mL'), 
(3, 3, 'Dramin B6', '1 comprimido'), 
(4, 4, 'Omeprazol', '1 cápsula'), 
(5, 5, 'Pantoprazol', '1 comprimido'), 
(6, 6, 'Dorflex', '1 comprimido'), 
(7, 7, 'Neosaldina', '1 comprimido'),
(8, 8, 'Ibuprofeno', '2 comprimidos'), 
(9, 9, 'Dipirona', '15 mL'), 
(10, 10, 'Dramin B6', '1 comprimido'), 
(11, 11, 'Omeprazol', '1 cápsula'), 
(12, 12, 'Pantoprazol', '2 comprimidos'), 
(13, 13, 'Dorflex', '1 comprimido'), 
(14, 14, 'Neosaldina', '2 comprimidos'),
(15, 15, 'Ibuprofeno', '1 comprimido'),
(16, 16, 'Dipirona', '10 mL'),
(17, 17, 'Dramin B6', '2 comprimidos'),
(18, 18, 'Omeprazol', '1 cápsula'),
(19, 19, 'Pantoprazol', '1 comprimido'),
(20, 20, 'Dorflex', '2 comprimidos'),
(21, 21, 'Neosaldina', '1 comprimido'),
(22, 22, 'Ibuprofeno', '2 comprimidos'),
(23, 23, 'Dipirona', '20 mL'),
(24, 24, 'Dramin B6', '1 comprimido'),
(25, 25, 'Omeprazol', '1 cápsula'),
(26, 26, 'Pantoprazol', '2 comprimidos'),
(27, 27, 'Dorflex', '1 comprimido'),
(28, 28, 'Neosaldina', '1 comprimido'),
(29, 29, 'Ibuprofeno', '1 comprimido'),
(30, 30, 'Dipirona', '15 mL'),
(31, 31, 'Dramin B6', '1 comprimido'),
(32, 32, 'Omeprazol', '1 cápsula'),
(33, 33, 'Pantoprazol', '1 comprimido'),
(34, 34, 'Dorflex', '2 comprimidos'),
(35, 35, 'Neosaldina', '2 comprimidos'),
(36, 36, 'Ibuprofeno', '1 comprimido'),
(37, 37, 'Dipirona', '10 mL'),
(38, 38, 'Dramin B6', '1 comprimido'),
(39, 39, 'Omeprazol', '1 cápsula'),
(40, 40, 'Pantoprazol', '1 comprimido'),
(41, 41, 'Dorflex', '1 comprimido'),
(42, 42, 'Neosaldina', '1 comprimido'),
(43, 43, 'Ibuprofeno', '2 comprimidos'),
(44, 44, 'Dramin B6', '1 comprimido'),
(45, 45, 'Omeprazol', '1 cápsula'),
(46, 46, 'Pantoprazol', '1 comprimido'),
(47, 47, 'Dorflex', '2 comprimidos'),
(48, 48, 'Neosaldina', '1 comprimido'),
(49, 49, 'Ibuprofeno', '1 comprimido');

-- Grupo Fernando
INSERT INTO Estoque_remedio (id_estoque, id_remedio, id_funcionario, quantidade, data_entrada, data_validade) VALUES
(1, 1, 41, 50, '2025-08-01', '2026-08-01'),
(2, 2, 42, 30, '2025-08-03', '2026-08-03'),
(3, 3, 43, 40, '2025-08-05', '2026-08-05'),
(4, 4, 44, 25, '2025-08-07', '2026-08-07'),
(5, 5, 45, 60, '2025-08-09', '2026-08-09'),
(6, 6, 46, 35, '2025-08-11', '2026-08-11'),
(7, 7, 47, 45, '2025-08-13', '2026-08-13'),
(8, 1, 48, 55, '2025-08-15', '2026-08-15'),
(9, 2, 49, 20, '2025-08-17', '2026-08-17'),
(10, 3, 50, 70, '2025-08-19', '2026-08-19'),

(11, 4, 41, 60, '2025-08-21', '2026-08-21'),
(12, 5, 42, 30, '2025-08-23', '2026-08-23'),
(13, 6, 43, 40, '2025-08-25', '2026-08-25'),
(14, 7, 44, 25, '2025-08-27', '2026-08-27'),
(15, 1, 45, 50, '2025-08-29', '2026-08-29'),
(16, 2, 46, 35, '2025-08-31', '2026-08-31'),
(17, 3, 47, 45, '2025-09-02', '2026-09-02'),
(18, 4, 48, 55, '2025-09-04', '2026-09-04'),
(19, 5, 49, 20, '2025-09-06', '2026-09-06'),
(20, 6, 50, 70, '2025-09-08', '2026-09-08'),

(21, 7, 41, 60, '2025-09-10', '2026-09-10'),
(22, 1, 42, 30, '2025-09-12', '2026-09-12'),
(23, 2, 43, 40, '2025-09-14', '2026-09-14'),
(24, 3, 44, 25, '2025-09-16', '2026-09-16'),
(25, 4, 45, 50, '2025-09-18', '2026-09-18'),
(26, 5, 46, 35, '2025-09-20', '2026-09-20'),
(27, 6, 47, 45, '2025-09-22', '2026-09-22'),
(28, 7, 48, 55, '2025-09-24', '2026-09-24'),
(29, 1, 49, 20, '2025-09-26', '2026-09-26'),
(30, 2, 50, 70, '2025-09-28', '2026-09-28'),

(31, 3, 41, 60, '2025-09-30', '2026-09-30'),
(32, 4, 42, 30, '2025-10-02', '2026-10-02'),
(33, 5, 43, 40, '2025-10-04', '2026-10-04'),
(34, 6, 44, 25, '2025-10-06', '2026-10-06'),
(35, 7, 45, 50, '2025-10-08', '2026-10-08'),
(36, 1, 46, 35, '2025-10-10', '2026-10-10'),
(37, 2, 47, 45, '2025-10-12', '2026-10-12'),
(38, 3, 48, 55, '2025-10-14', '2026-10-14'),
(39, 4, 49, 20, '2025-10-16', '2026-10-16'),
(40, 5, 50, 70, '2025-10-18', '2026-10-18'),

(41, 6, 41, 60, '2025-10-20', '2026-10-20'),
(42, 7, 42, 30, '2025-10-22', '2026-10-22'),
(43, 1, 43, 40, '2025-10-24', '2026-10-24'),
(44, 2, 44, 25, '2025-10-26', '2026-10-26'),
(45, 3, 45, 50, '2025-10-28', '2026-10-28'),
(46, 4, 46, 35, '2025-10-30', '2026-10-30'),
(47, 5, 47, 45, '2025-11-01', '2026-11-01'),
(48, 6, 48, 55, '2025-11-03', '2026-11-03'),
(49, 7, 49, 20, '2025-11-05', '2026-11-05'),
(50, 1, 50, 70, '2025-11-07', '2026-11-07');

-- Grupo Fernando
INSERT INTO Receita (id_receita, id_remedio, id_paciente, id_funcionario, data_emissao, quantidade, dosagem, periodo_consumo, UF_paciente, UF_funcionario) VALUES
(1, 1, 1, 1, '2025-01-10', '1 comprimido', '1x ao dia', '5 dias', 'SP', 'RJ'),
(2, 2, 2, 2, '2025-02-12', '20 mL', '2x ao dia', '7 dias', 'RJ', 'SP'),
(3, 3, 3, 3, '2025-03-05', '1 comprimido', '1x ao dia', '10 dias', 'MG', 'MG'),
(4, 4, 4, 4, '2025-04-18', '1 cápsula', '2x ao dia', '5 dias', 'BA', 'BA'),
(5, 5, 5, 5, '2025-05-20', '1 comprimido', '3x ao dia', '7 dias', 'RS', 'RS'),
(6, 6, 6, 6, '2025-06-15', '1 comprimido', '1x ao dia', '10 dias', 'SC', 'SC'),
(7, 7, 7, 7, '2025-07-10', '1 comprimido', '2x ao dia', '5 dias', 'PR', 'PR'),
(8, 1, 8, 8, '2025-01-22', '2 comprimidos', '1x ao dia', '7 dias', 'SP', 'RJ'),
(9, 2, 9, 9, '2025-02-28', '15 mL', '3x ao dia', '10 dias', 'RJ', 'SP'),
(10, 3, 10, 10, '2025-03-14', '1 comprimido', '2x ao dia', '5 dias', 'MG', 'MG'),

(11, 4, 11, 11, '2025-04-25', '1 cápsula', '1x ao dia', '7 dias', 'BA', 'BA'),
(12, 5, 12, 12, '2025-05-30', '1 comprimido', '3x ao dia', '10 dias', 'RS', 'RS'),
(13, 6, 13, 13, '2025-06-07', '2 comprimidos', '2x ao dia', '5 dias', 'SC', 'SC'),
(14, 7, 14, 14, '2025-07-19', '1 comprimido', '1x ao dia', '7 dias', 'PR', 'PR'),
(15, 1, 15, 15, '2025-01-03', '1 comprimido', '3x ao dia', '10 dias', 'SP', 'RJ'),
(16, 2, 16, 16, '2025-02-16', '20 mL', '1x ao dia', '5 dias', 'RJ', 'SP'),
(17, 3, 17, 17, '2025-03-29', '1 comprimido', '2x ao dia', '7 dias', 'MG', 'MG'),
(18, 4, 18, 18, '2025-04-10', '1 cápsula', '3x ao dia', '10 dias', 'BA', 'BA'),
(19, 5, 19, 19, '2025-05-22', '1 comprimido', '1x ao dia', '5 dias', 'RS', 'RS'),
(20, 6, 20, 20, '2025-06-05', '1 comprimido', '2x ao dia', '7 dias', 'SC', 'SC'),

(21, 7, 21, 1, '2025-07-17', '2 comprimidos', '3x ao dia', '10 dias', 'PR', 'PR'),
(22, 1, 22, 2, '2025-01-29', '1 comprimido', '1x ao dia', '5 dias', 'SP', 'RJ'),
(23, 2, 23, 3, '2025-02-14', '20 mL', '2x ao dia', '7 dias', 'RJ', 'SP'),
(24, 3, 24, 4, '2025-03-26', '1 comprimido', '1x ao dia', '10 dias', 'MG', 'MG'),
(25, 4, 25, 5, '2025-04-08', '1 cápsula', '3x ao dia', '5 dias', 'BA', 'BA'),
(26, 5, 26, 6, '2025-05-20', '1 comprimido', '1x ao dia', '7 dias', 'RS', 'RS'),
(27, 6, 27, 7, '2025-06-02', '2 comprimidos', '2x ao dia', '10 dias', 'SC', 'SC'),
(28, 7, 28, 8, '2025-07-14', '1 comprimido', '3x ao dia', '5 dias', 'PR', 'PR'),
(29, 1, 29, 9, '2025-01-06', '1 comprimido', '1x ao dia', '7 dias', 'SP', 'RJ'),
(30, 2, 30, 10, '2025-02-18', '15 mL', '2x ao dia', '10 dias', 'RJ', 'SP'),

(31, 3, 31, 11, '2025-03-01', '1 comprimido', '3x ao dia', '5 dias', 'MG', 'MG'),
(32, 4, 32, 12, '2025-04-13', '1 cápsula', '1x ao dia', '7 dias', 'BA', 'BA'),
(33, 5, 33, 13, '2025-05-25', '1 comprimido', '2x ao dia', '10 dias', 'RS', 'RS'),
(34, 6, 34, 14, '2025-06-07', '2 comprimidos', '3x ao dia', '5 dias', 'SC', 'SC'),
(35, 7, 35, 15, '2025-07-19', '1 comprimido', '1x ao dia', '7 dias', 'PR', 'PR'),
(36, 1, 36, 16, '2025-01-11', '1 comprimido', '2x ao dia', '10 dias', 'SP', 'RJ'),
(37, 2, 37, 17, '2025-02-23', '20 mL', '3x ao dia', '5 dias', 'RJ', 'SP'),
(38, 3, 38, 18, '2025-03-05', '1 comprimido', '1x ao dia', '7 dias', 'MG', 'MG'),
(39, 4, 39, 19, '2025-04-17', '1 cápsula', '2x ao dia', '10 dias', 'BA', 'BA'),
(40, 5, 40, 20, '2025-05-29', '1 comprimido', '3x ao dia', '5 dias', 'RS', 'RS'),

(41, 6, 41, 1, '2025-06-10', '2 comprimidos', '1x ao dia', '7 dias', 'SC', 'SC'),
(42, 7, 42, 2, '2025-07-22', '1 comprimido', '2x ao dia', '10 dias', 'PR', 'PR'),
(43, 1, 43, 3, '2025-01-04', '1 comprimido', '3x ao dia', '5 dias', 'SP', 'RJ'),
(44, 2, 44, 4, '2025-02-16', '15 mL', '1x ao dia', '7 dias', 'RJ', 'SP'),
(45, 3, 45, 5, '2025-03-28', '1 comprimido', '2x ao dia', '10 dias', 'MG', 'MG'),
(46, 4, 46, 6, '2025-04-09', '1 cápsula', '3x ao dia', '5 dias', 'BA', 'BA'),
(47, 5, 47, 7, '2025-05-21', '1 comprimido', '1x ao dia', '7 dias', 'RS', 'RS'),
(48, 6, 48, 8, '2025-06-02', '2 comprimidos', '2x ao dia', '10 dias', 'SC', 'SC'),
(49, 7, 49, 9, '2025-07-14', '1 comprimido', '3x ao dia', '5 dias', 'PR', 'PR'),
(50, 1, 50, 10, '2025-01-26', '1 comprimido', '1x ao dia', '7 dias', 'SP', 'RJ');

-- Grupo Fernando
INSERT INTO Consulta (id_consulta, id_paciente, id_funcionario, id_sala, id_receita, temperatura, pressao_arterial, frequencia_cardiaca, diagnostico, data_hora) VALUES
(1, 1, 1, 5, 1, 36.2, '120/80', 75, 'Gripe comum', '2025-01-10 08:30:00'),
(2, 2, 2, 3, 2, 36.8, '110/70', 80, 'Dor de cabeça', '2025-02-12 09:15:00'),
(3, 3, 3, 7, 3, 37.5, '130/85', 90, 'Infecção urinária', '2025-03-05 10:00:00'),
(4, 4, 4, 2, 4, 36.6, '115/75', 70, 'Gastrite', '2025-04-18 14:20:00'),
(5, 5, 5, 1, 5, 37.9, '125/80', 85, 'Sinusite', '2025-05-20 11:45:00'),
(6, 6, 6, 4, 6, 38.2, '118/78', 72, 'Febre viral', '2025-06-15 13:30:00'),
(7, 7, 7, 8, 7, 36.9, '122/82', 88, 'Dor muscular', '2025-07-10 15:00:00'),
(8, 8, 8, 6, 8, 37.3, '135/85', 95, 'Infecção de garganta', '2025-01-22 09:50:00'),
(9, 9, 9, 9, 9, 39.0, '110/70', 78, 'Alergia', '2025-02-28 10:30:00'),
(10, 10, 10, 10, 10, 36.5, '120/80', 82, 'Resfriado', '2025-03-14 11:10:00'),

(11, 11, 11, 11, 11, 36.7, '115/75', 76, 'Dor abdominal', '2025-04-25 12:00:00'),
(12, 12, 12, 12, 12, 38.5, '125/80', 85, 'Infecção de ouvido', '2025-05-30 13:15:00'),
(13, 13, 13, 13, 13, 37.8, '130/85', 92, 'Gripe', '2025-06-07 14:40:00'),
(14, 14, 14, 14, 14, 36.3, '110/70', 70, 'Dor nas costas', '2025-07-19 08:20:00'),
(15, 15, 15, 15, 15, 39.2, '120/78', 80, 'Conjuntivite', '2025-01-03 09:00:00'),
(16, 16, 16, 16, 16, 36.4, '118/76', 74, 'Febre baixa', '2025-02-16 10:30:00'),
(17, 17, 17, 17, 17, 37.7, '125/82', 86, 'Gastrite leve', '2025-03-29 11:50:00'),
(18, 18, 18, 18, 18, 38.8, '115/75', 72, 'Dor de garganta', '2025-04-10 13:10:00'),
(19, 19, 19, 19, 19, 39.5, '130/85', 90, 'Infecção respiratória', '2025-05-22 14:30:00'),
(20, 20, 20, 20, 20, 36.9, '110/70', 78, 'Alergia leve', '2025-06-05 15:50:00'),

(21, 21, 1, 1, 21, 37.6, '120/80', 84, 'Dor de cabeça intensa', '2025-07-17 08:40:00'),
(22, 22, 2, 2, 22, 36.2, '115/75', 76, 'Febre e mal-estar', '2025-01-29 09:20:00'),
(23, 23, 3, 3, 23, 38.3, '125/80', 88, 'Infecção de pele', '2025-02-14 10:10:00'),
(24, 24, 4, 4, 24, 36.7, '110/70', 70, 'Dor abdominal leve', '2025-03-26 11:00:00'),
(25, 25, 5, 5, 25, 39.0, '130/85', 92, 'Gripe forte', '2025-04-08 12:45:00'),
(26, 26, 6, 6, 26, 37.1, '115/75', 78, 'Dor nas articulações', '2025-05-20 13:25:00'),
(27, 27, 7, 7, 27, 38.0, '125/80', 85, 'Sinusite leve', '2025-06-02 14:15:00'),
(28, 28, 8, 8, 28, 36.8, '110/70', 72, 'Alergia respiratória', '2025-07-14 15:05:00'),
(29, 29, 9, 9, 29, 37.9, '120/78', 80, 'Dor de garganta forte', '2025-01-06 08:55:00'),
(30, 30, 10, 10, 30, 36.6, '118/76', 74, 'Febre baixa persistente', '2025-02-18 09:45:00'),

(31, 31, 11, 11, 31, 38.1, '125/82', 88, 'Infecção viral', '2025-03-01 10:35:00'),
(32, 32, 12, 12, 32, 36.9, '115/75', 72, 'Dor nas costas leve', '2025-04-13 11:25:00'),
(33, 33, 13, 13, 33, 39.5, '130/85', 95, 'Gripe e tosse', '2025-05-25 12:15:00'),
(34, 34, 14, 14, 34, 36.3, '110/70', 70, 'Dor muscular', '2025-06-07 13:05:00'),
(35, 35, 15, 15, 35, 37.2, '120/78', 82, 'Conjuntivite aguda', '2025-07-19 14:55:00'),
(36, 36, 16, 16, 36, 36.4, '118/76', 76, 'Febre baixa e dor', '2025-01-11 08:15:00'),
(37, 37, 17, 17, 37, 38.7, '125/82', 88, 'Gastrite persistente', '2025-02-23 09:05:00'),
(38, 38, 18, 18, 38, 37.5, '115/75', 72, 'Dor de garganta leve', '2025-03-05 10:55:00'),
(39, 39, 19, 19, 39, 38.2, '130/85', 90, 'Infecção respiratória leve', '2025-04-17 11:45:00'),
(40, 40, 20, 20, 40, 36.9, '110/70', 76, 'Alergia sazonal', '2025-05-29 12:35:00'),

(41, 41, 1, 1, 41, 37.8, '120/80', 82, 'Dor de cabeça persistente', '2025-06-10 08:25:00'),
(42, 42, 2, 2, 42, 36.5, '115/75', 76, 'Febre baixa', '2025-07-22 09:15:00'),
(43, 43, 3, 3, 43, 38.0, '125/80', 88, 'Infecção de pele leve', '2025-01-04 10:05:00'),
(44, 44, 4, 4, 44, 36.7, '115/75', 72, 'Dor abdominal leve', '2025-02-16 10:55:00'),
(45, 45, 5, 5, 45, 39.3, '130/85', 92, 'Gripe', '2025-03-28 11:45:00'),
(46, 46, 6, 6, 46, 36.9, '110/70', 74, 'Dor nas articulações', '2025-04-09 12:35:00'),
(47, 47, 7, 7, 47, 37.4, '120/78', 80, 'Sinusite leve', '2025-05-21 13:25:00'),
(48, 48, 8, 8, 48, 36.8, '118/76', 76, 'Alergia respiratória', '2025-06-02 14:15:00'),
(49, 49, 9, 9, 49, 37.9, '125/80', 84, 'Dor de garganta leve', '2025-07-14 15:05:00'),
(50, 50, 10, 10, 50, 36.6, '115/75', 72, 'Febre baixa persistente', '2025-01-26 08:45:00');