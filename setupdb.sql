CREATE TABLE IF NOT EXISTS usuario (
	id SERIAL PRIMARY KEY,
	username VARCHAR(60) NOT NULL,
	password VARCHAR(255) NOT NULL,
	email VARCHAR(60) NOT NULL,
	matricula VARCHAR(20) NOT NULL,
	is_aluno BOOLEAN DEFAULT FALSE NOT NULL,
	CONSTRAINT unique_name UNIQUE(username),
	CONSTRAINT unique_email UNIQUE(email)
);

CREATE TABLE IF NOT EXISTS disciplina (
	id SERIAL PRIMARY KEY,
	nome_disc VARCHAR(20) NOT NULL,
	prof_resp INT NOT NULL,
	CONSTRAINT refer_prof_resp FOREIGN KEY(prof_resp)
		REFERENCES usuario(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS disc_cad (
	disc_cad INT NOT NULL,
	disc_id INT NOT NULL,
	CONSTRAINT refer_disc_cad_us FOREIGN KEY(disc_cad)
		REFERENCES usuario(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT refer_disc_cad_disc FOREIGN KEY(disc_id)
		REFERENCES disciplina(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	PRIMARY KEY(disc_cad, disc_id)
);

CREATE TABLE IF NOT EXISTS projeto (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(20) NOT NULL,
	fk_disc INT,
	is_indiv BOOLEAN NOT NULL DEFAULT FALSE,
	is_pond BOOLEAN NOT NULL DEFAULT FALSE,
	peso_prof DOUBLE PRECISION,
	peso_alun DOUBLE PRECISION,
	data_apres DATE NOT NULL,
	CONSTRAINT refer_proj_disc FOREIGN KEY(fk_disc)
		REFERENCES disciplina(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS formulario (
	id SERIAL PRIMARY KEY,
	fk_proj INT,
	data_começo DATE NOT NULL,
	data_fim DATE NOT NULL,	
	CONSTRAINT refer_form_proj FOREIGN KEY (fk_proj)
		REFERENCES projeto(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS secao_quest(
	id SERIAL PRIMARY KEY,
	fk_form INT,
	nome_sec VARCHAR(20) NOT NULL,
	CONSTRAINT refer_sec_form FOREIGN KEY(fk_form)
		REFERENCES formulario(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS quesito(
	id SERIAL PRIMARY KEY,
	fk_secao INT,
	pergunta VARCHAR(255) NOT NULL,
	CONSTRAINT refer_ques_secao FOREIGN KEY(fk_secao)
		REFERENCES secao_quest(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS avaliador(
	fk_id_us INT NOT NULL,
	fk_id_proj 	INT NOT NULL,
	CONSTRAINT refer_aval_us FOREIGN KEY(fk_id_us)
		REFERENCES usuario(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT refer_aval_proj FOREIGN KEY(fk_id_proj)
		REFERENCES projeto(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	PRIMARY KEY(fk_id_us, fk_id_proj)
);

CREATE TABLE IF NOT EXISTS grupo(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(20) NOT NULL,
	tema VARCHAR(255) NOT NULL,
	fk_proj INT,
	CONSTRAINT refer_grupo_proj FOREIGN KEY(fk_proj)
		REFERENCES projeto(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS resultado(
	id SERIAL PRIMARY KEY,
	fk_grupo INT UNIQUE,
	result DOUBLE PRECISION,
	CONSTRAINT refer_result_grupo FOREIGN KEY(fk_grupo)
		REFERENCES grupo(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS us_gru (
	fk_us INT NOT NULL,
	fk_gru INT NOT NULL,
	CONSTRAINT refer_usgru_usuario FOREIGN KEY(fk_us)
		REFERENCES usuario(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT refer_usgru_grupo FOREIGN KEY(fk_gru)
		REFERENCES grupo(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	PRIMARY KEY(fk_us, fk_gru)
);

CREATE TABLE IF NOT EXISTS avaliacao(
	fk_avaliador INT NOT NULL,
	fk_grupo INT NOT NULL,
	nota DOUBLE PRECISION NOT NULL,
	CONSTRAINT refer_avaliacao_us FOREIGN KEY(fk_avaliador)
		REFERENCES usuario(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT refer_avaliacao_gru FOREIGN KEY(fk_grupo)
		REFERENCES grupo(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);
