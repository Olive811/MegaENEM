#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 55,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
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


// Referências

#align(right)[
  #text(size: 8pt)[
    #h(5em) texto
  ]
]  

// Imagem

#align(center)[
  #image(
    "imagens/2010_PPL/q80_2010_ppl.webp",
    width: 100%
  )
]