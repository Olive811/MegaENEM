#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 00,
  prova: "ENEM PPL",
  ano: 2011,
  caderno: "Branco",
  dia: 1,
  conteudo: "Conteúdo",
  nova-pagina: true,
)[
  Enunciado_da_questao

  #alternativas(
    [], // a
    [], // b
    [], // c
    [], // d
    [], // e
  )
]

// Imagem

#align(center)[
  #image(
    "",
    width: 100%
  )
]

// Referências

#align(right)[
  #text(size: 8pt)[
    #h(5em) 
  ]
]  

///////////////////////
// Seção de Gabarito //
///////////////////////
#pagebreak()

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

// simbolos
// meia-risca: –