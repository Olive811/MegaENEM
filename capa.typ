
// ==========================================
// CAPA — MAPEAMENTO DE QUÍMICA NO ENEM
// ==========================================

#let azul = rgb("#174A70")
#let verde = rgb("#168B79")
#let cinza = rgb("#64748B")
#let claro = rgb("#EAF1F5")

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2cm),
)

// Identificação superior
#align(center)[
  #text(size: 10pt, weight: "bold", fill: azul)[
    MATERIAL DE ESTUDO E ANÁLISE
  ]

  #v(0.3cm)

  #line(length: 65%, stroke: 1.2pt + verde)
]

// Espaçamento superior
#v(1.5cm)

// Área reservada para a logo
#align(center)[
  #rect(
    width: 12cm,
    height: 5cm,
    radius: 5pt,
    stroke: 1pt + rgb("#2c3d51"),
    fill: claro,
  )[
    #align(center + horizon)[
      #image("Logotipo_do_Enem.svg.webp")
    ]
  ]
]

#v(1.5cm)

// Título principal
#align(center)[
  #text(
    size: 25pt,
    weight: "bold",
    fill: azul,
  )[
    Megacompilado das Questões
  ]

  #v(0.2cm)

  #text(
    size: 27pt,
    weight: "bold",
    fill: verde,
  )[
    de Química no ENEM 
    
    (2009 a 2026)
  ]

  #v(0.6cm)

  #line(length: 35%, stroke: 2pt + verde)

  #v(0.5cm)

  #text(size: 12pt, fill: cinza)[
    Mapeamento histórico das questões de
    Ciências da Natureza — 2009 a 2026
  ]
]

#v(0.5em)

// Descrição do documento
#align(center)[
  #block(
    width: 85%,
    inset: 12pt,
    radius: 4pt,
    fill: rgb("#F4F7F9"),
  )[
    #text(size: 10pt, fill: azul)[
      Compilação de todas as questões de Química do ENEM (normal e PPL) desde 2009 até 2026 e categorização por conteúdo
    ]
  ]
]

#v(0.5em)

// Autor e data
#align(center)[
  #text(size: 12pt, weight: "bold", fill: azul)[
    Prof. Klauber Gabriel

    Professor de Química da EEEP Prof. Luiza de Teodoro Vieira
  ]

  #v(0.2cm)

  #text(size: 12pt, fill: cinza)[
    Atualizado em 10 de novembro de 2026
  ]

  #v(0.5cm)

  #line(length: 65%, stroke: 0.8pt + verde)

  #v(0.3cm)

  #text(size: 11.5pt, fill: cinza)[
    _Omnis sapientia a Domino Deo est et cum illo fuit semper et est ante aevum._ - Ecclesiasticus I, 1
  ]
]
