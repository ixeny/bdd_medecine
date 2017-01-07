
--	Création des types

CREATE OR REPLACE TYPE indic_type AS OBJECT(
	id_indic NUMBER(38),
	description VARCHAR2(50)
);
/

CREATE OR REPLACE TYPE indication_tpe AS TABLE OF indic_type;
/

CREATE OR REPLACE TYPE contre_indic_type AS OBJECT(                    
	id_contre_indic NUMBER(38),
	description VARCHAR2(50)
);
/

CREATE OR REPLACE TYPE contre_indic_tpe AS TABLE OF contre_indic_type;
/

CREATE OR REPLACE TYPE maladie_type AS OBJECT(
	id_maladie NUMBER(38),
	nom_maladie VARCHAR2(50),
	maladie_mere NUMBER(38))
NOT FINAL;
/

CREATE OR REPLACE TYPE maladie_chronique_type UNDER maladie_type();
/

CREATE OR REPLACE TYPE maladie_passagere_type UNDER maladie_type();
/


--	Création des tables


CREATE TABLE maladie OF maladie_type(
	CONSTRAINT pkmaladie PRIMARY KEY (id_maladie),
	CONSTRAINT fk_MALADIE_MERE FOREIGN KEY (maladie_mere) REFERENCES maladie(id_maladie)
	);

CREATE TABLE maladie_chronique OF maladie_chronique_type(
	CONSTRAINT pkmaladiechronique PRIMARY KEY (id_maladie)
	);

CREATE TABLE maladie_passagere OF maladie_passagere_type(
	CONSTRAINT pkmaladiepassagere PRIMARY KEY (id_maladie)
	);

CREATE TABLE symptome(
	id_symptome NUMBER(38) CONSTRAINT pk_symptome_id PRIMARY KEY,
	nom_symptome VARCHAR2(50)
	);

CREATE TABLE avoir_symptome(
	id_maladie NUMBER(38) NOT NULL ,
	id_symptome NUMBER(38) NOT NULL ,
	PRIMARY KEY (id_maladie ,id_symptome),
	CONSTRAINT fk_maladie FOREIGN KEY (id_maladie) REFERENCES maladie(id_maladie),
	CONSTRAINT fk_symptome FOREIGN KEY (id_symptome) REFERENCES symptome(id_symptome)
	);

CREATE TABLE substance_active(
	id_substance NUMBER(38) CONSTRAINT pk_sub_act PRIMARY KEY ,
	nom_substance VARCHAR2(60)
	);

CREATE TABLE effet_indesirable(
	id_effet NUMBER(38) CONSTRAINT pk_effet_indesirable PRIMARY KEY ,
	nom_effet VARCHAR2(60)
	);

CREATE TABLE avoir_effet(
	id_effet NUMBER(38) NOT NULL ,
	id_substance NUMBER(38) NOT NULL ,
	PRIMARY KEY (id_effet ,id_substance),
	CONSTRAINT fk_avoir_effet FOREIGN KEY (id_effet) REFERENCES effet_indesirable(id_effet),
	CONSTRAINT fk_avoir_subst FOREIGN KEY (id_substance) REFERENCES substance_active(id_substance)
	);

CREATE TABLE interaction(
	id_actif NUMBER(38),
	id_passif NUMBER(38),
	CONSTRAINT pk_interaction primary key (id_actif, id_passif),
	CONSTRAINT fk_substance_interaction FOREIGN KEY (id_actif) REFERENCES substance_active(id_substance),
	);

CREATE TABLE notice(id_notice NUMBER(38) CONSTRAINT pk_notice PRIMARY KEY, 
	indications     indication_tpe,
	contre_indications contre_indic_tpe
	)NESTED TABLE indications STORE AS indications_table,
	NESTED TABLE contre_indications STORE AS contre_indic_table;

CREATE TABLE medicament(
	id_medicament NUMBER(38) CONSTRAINT pk_medicament_id PRIMARY KEY ,
	nom_medicament VARCHAR2(50),
	id_notice NUMBER(38),
	CONSTRAINT fk_notice_medic FOREIGN KEY (id_notice) REFERENCES notice(id_notice)
	);

CREATE TABLE medicament_substance(
	id_medicament NUMBER(38) NOT NULL ,
	id_substance NUMBER(38) NOT NULL ,
	PRIMARY KEY (id_substance, id_medicament),
	CONSTRAINT fk_cont_sub FOREIGN KEY (id_substance) REFERENCES substance_active(id_substance),
	CONSTRAINT fk_medic_cont FOREIGN KEY (id_medicament) REFERENCES medicament(id_medicament)
	);

CREATE TABLE laboratoire(
	id_labo NUMBER(38) CONSTRAINT pk_lab_id PRIMARY KEY,
	nom_labo VARCHAR2(50)
	);

CREATE TABLE medecin(id_medecin NUMBER(38) CONSTRAINT pk_medcin_id PRIMARY KEY,
	nom_medecin VARCHAR2(50),
	prenom_medecin VARCHAR2(50)
	);

CREATE TABLE patient(
	id_patient NUMBER(38) CONSTRAINT pk_pat_id PRIMARY KEY,
	nom_patient VARCHAR2(50),
	prenom_patient VARCHAR2(50),
	date_naiss date
	);

CREATE TABLE est_atteint_de(
	id_patient NUMBER(38),
	id_maladie NUMBER(38),
	PRIMARY KEY (id_patient, id_maladie),
	CONSTRAINT fk_atteint_patient FOREIGN KEY (id_patient) REFERENCES patient(id_patient),
	CONSTRAINT fk_atteint_maladie FOREIGN KEY (id_maladie) REFERENCES maladie_chronique(id_maladie)
	);

CREATE TABLE developper(
	id_medecin NUMBER(38) NOT NULL ,
	id_medicament NUMBER(38) NOT NULL ,
	id_labo NUMBER(38) NOT NULL ,
	PRIMARY KEY (id_medecin ,id_medicament, id_labo),
	CONSTRAINT fk_mdcin FOREIGN KEY (id_medecin) REFERENCES medecin(id_medecin),
	CONSTRAINT fk_mdcmnt FOREIGN KEY (id_medicament) REFERENCES medicament(id_medicament),
	CONSTRAINT fk_labo FOREIGN KEY (id_labo) REFERENCES laboratoire(id_labo)
	);

CREATE TABLE consultation(
	id_consultation NUMBER(38) CONSTRAINT pk_consultation PRIMARY KEY,
	id_medecin NUMBER(38) CONSTRAINT fk_consultation_medecin REFERENCES medecin(id_medecin),
	id_patient NUMBER(38) CONSTRAINT fk_consultation_patient REFERENCES patient(id_patient),
	date_consult DATE
);

CREATE TABLE observation(
	id_consultation NUMBER(38),
	id_symptome NUMBER(38),
	CONSTRAINT fk_obs_cons FOREIGN KEY (id_consultation) REFERENCES consultation(id_consultation),
	CONSTRAINT fk_obs_mal FOREIGN KEY (id_symptome) REFERENCES symptome(id_symptome),
	PRIMARY KEY (id_consultation, id_symptome)
);


CREATE TABLE traitement(
	id_medicament NUMBER(38),
	id_consultation NUMBER(38),
	duree NUMBER(10),
	CONSTRAINT fk_trait_medic FOREIGN KEY (id_medicament) REFERENCES medicament(id_medicament),
	CONSTRAINT fk_trait_consult FOREIGN KEY (id_consultation) REFERENCES consultation(id_consultation)
	);



--flag-----------------------------------------------------------------


