const db = require('../db');
const {customError} = require('../errors/custom');

async function post_formularios_cadastrados(
	id,
	data_comeco,
	data_fim,
	secoes,
){

	const client = await db.getClient();

	try {

		await client.query('BEGIN');

		const queryres = await client.query(
			`INSERT INTO
				formulario
			VALUES(
				DEFAULT,
				$1,
				$2,
				$3
			) RETURNING id;`,
			[ 
				id,
				data_comeco,
				data_fim
			]
		);

		const id_form = queryres.rows[0].id;
		const len_sec = secoes.length;

		for(let i=0;i<len_sec;i+=2){

			const queryres2 = await client.query(
				`INSERT INTO
					secao_quest
				VALUES(
					DEFAULT,
					$1,
					$2
				) RETURNING id;`,
				[ id_form, secoes[i] ]
			);

			const id_secao = queryres2.rows[0].id;
			const len_ques = secoes[i+1].length;

			for(let j=0;j<len_ques;j++)
				await client.query(
					`INSERT INTO
						quesito
					VALUES(
						DEFAULT,
						$1,
						$2
					);`,
					[ id_secao, secoes[i+1][j] ]
				);

		}

		await client.query('COMMIT');
		client.release();

		return;
		
	} catch(e) {

		await client.query('ROLLBACK');
		client.release();
		throw e;

	}

}

async function get_formularios_cadastrados(id_proj){
	try {
		const query_id_form = db.query(
			`SELECT f.id FROM
				formulario AS f
			INNER JOIN
				projeto AS p
			ON f.fk_proj = p.id
			WHERE p.id = $1;`,
			[ id_proj ]
		);
		const id_form = query_id_form.rows[0].id;
		const query_secao_quest = db.query(
			`SELECT sq.id, sq.nome_sec FROM
				secao_quest AS sq
			INNER JOIN formulario AS f
			ON sq.fk_form = f.id
			WHERE f.id = $1;`,
			[ id_form ]
		);
		let form;
		let form_i = 0;
		const secoes = query_secao_quest.rows;
		for(let i=0;i<secoes.length;i++){
			const query_quesito = db.query(
				`SELECT q.pergunta FROM
					quesito AS q
				INNER JOIN secao_quest AS sq
				ON q.fk_secao = sq.id
				WHERE sq.id = $1;`,
				[ secoes[i].id ]
			);
			form[form_i++] = secoes[i].nome_sec;
			form[form_i] = query_quesito.rows;
		}
		return form;
	} catch(e){
		throw e;
	}
}

module.exports = {

	post_formularios_cadastrados,
	get_formularios_cadastrados

};
