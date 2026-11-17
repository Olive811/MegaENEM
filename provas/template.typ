#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito difícil",
  numero: 55,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Separação de Misturas",
  nova-pagina: false,
)[
  Enunciado_da_questao

  #alternativas(
    [A],
    [B],
    [C],
    [D],
    [E],
  )
]

#pagebreak()

///////////////////////
// Seção de Gabarito //
///////////////////////

#align(center)[
  #text(size: 1.5em)[
    == Gabarito
  ]
  #v(1em)

  #table(
    columns: 4,
    inset: 8pt,
    stroke: none,
    fill: (x, y) =>
      if y == 0 { rgb("#f5f7fb") }
      else if calc.odd(y) { white }
      else { rgb("#fafafa") },
    table.header[*Questao*][*Resposta*][*Conteúdo*][*Dificuldade*],
    [XX], [Y], [WWWWWWWWW], [ZZZZZ],
    [XX], [Y], [WWWWWWWWW], [ZZZZZ],
    [XX], [Y], [WWWWWWWWW], [ZZZZZ],
    [XX], [Y], [WWWWWWWWW], [ZZZZZ],
    [XX], [Y], [WWWWWWWWW], [ZZZZZ],
    [XX], [Y], [WWWWWWWWW], [ZZZZZ],
    [XX], [Y], [WWWWWWWWW], [ZZZZZ],
    [XX], [Y], [WWWWWWWWW], [ZZZZZ],
    [XX], [Y], [WWWWWWWWW], [ZZZZZ],
  )
]
