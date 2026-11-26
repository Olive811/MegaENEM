// ============================================================
//  Template de questões — estética inspirada no Memorize Blog
//
//  Estrutura do sumário:
//    ENEM 2009                                  (heading nível 1)
//      Questão 12 · Química — Equilíbrio ...    (heading nível 2)
// ============================================================

// ---------- Fontes (com fallback) ----------
// Troque o primeiro nome da lista pela fonte que quiser usar.
#let fonte-texto = ("IBM Plex Sans", "Inter", "Liberation Sans", "DejaVu Sans")
#let fonte-mono  = ("IBM Plex Mono", "JetBrains Mono", "DejaVu Sans Mono")

// ---------- Cores base ----------
#let c-texto  = rgb("#111111")
#let c-suave  = rgb("#6b7280")
#let c-borda  = rgb("#e5e7eb")
#let c-fundo-conteudo = rgb("#f5f7fb")

// ---------- Macroáreas ----------
#let macroareas = (
  "natureza":   (bg: rgb("#dcfce7"), fg: rgb("#16a34a")),
  "humanas":    (bg: rgb("#ffedd5"), fg: rgb("#c2410c")),
  "linguagens": (bg: rgb("#dbeafe"), fg: rgb("#1d4ed8")),
  "matemática": (bg: rgb("#ede9fe"), fg: rgb("#6d28d9")),
  "redação":    (bg: rgb("#f3f4f6"), fg: rgb("#374151")),
)

// ---------- Níveis de dificuldade ----------
#let niveis = (
  "muito fácil":   (bg: rgb("#d1fae5"), fg: rgb("#047857")),
  "fácil":         (bg: rgb("#dcfce7"), fg: rgb("#16a34a")),
  "médio":         (bg: rgb("#fef9c3"), fg: rgb("#a16207")),
  "difícil":       (bg: rgb("#ffedd5"), fg: rgb("#c2410c")),
  "muito difícil": (bg: rgb("#fee2e2"), fg: rgb("#dc2626")),
)

// ---------- Cores dos cadernos do ENEM ----------
#let cadernos = (
  "azul":     rgb("#2563eb"),
  "amarelo":  rgb("#eab308"),
  "branco":   rgb("#d1d5db"),
  "rosa":     rgb("#ec4899"),
  "cinza":    rgb("#6b7280"),
  "verde":    rgb("#22c55e"),
  "laranja":  rgb("#f97316"),
)

// ---------- Balão (pill) ----------
#let pill(texto, bg, fg) = box(
  fill: bg,
  radius: 100pt,
  inset: (x: 9pt, y: 5pt),
  text(font: fonte-mono, size: 8pt, fill: fg, tracking: 0.05em, upper(texto)),
)

// ---------- Busca em dicionário (com mensagem de erro útil) ----------
#let buscar(dic, chave, nome) = {
  let k = lower(chave)
  if k in dic { dic.at(k) } else {
    panic("`" + nome + "` inválido: '" + chave + "'. Opções: " + dic.keys().join(", "))
  }
}

// ---------- Alternativas ----------
// Uso: #alternativas([texto A], [texto B], [texto C], [texto D], [texto E])
#let alternativas(..itens) = {
  let letras = ("A", "B", "C", "D", "E", "F")
  v(0.5em)
  for (i, item) in itens.pos().enumerate() {
    grid(
      columns: (auto, 1fr),
      column-gutter: 0.9em,
      align: (horizon, horizon),
      box(
        width: 1.6em, height: 1.2em, radius: 50%,
        stroke: 0.8pt + c-borda,
        align(center + horizon, text(font: fonte-mono, size: 8.5pt, weight: "semibold", letras.at(i))),
      ),
      item,
    )
    v(0.1em)
  }
}

// ============================================================
//  Configuração global do documento  →  #show: config
// ============================================================

#let config(body) = {
  set page(paper: "a4", margin: (x: 2.2cm, y: 2.4cm), numbering: "1", number-align: center)
  set text(font: "Libron", size: 11pt, lang: "pt", fill: c-texto)
  set par(leading: 0.75em, spacing: 1.1em, justify: true)
  set heading(numbering: none)

  // Seção do ano (nível 1)
  show heading.where(level: 1): it => block(width: 100%, below: 1.4em, {
    align(center, text(size: 24pt, weight: "bold", tracking: -0.02em, it.body))
    v(0.3em)
    line(length: 100%, stroke: 1.2pt + c-texto)
  })

  // Sumário: a customização de entradas exige Typst >= 0.12.
  // Em versões anteriores o estilo é simplesmente ignorado (sem erro).
  let estilizar-sumario(corpo) = {
    if sys.version >= version(0, 12, 0) {
      show outline.entry.where(level: 1): it => {
        v(0.9em, weak: true)
        strong(it)
      }
      show outline.entry.where(level: 2): set text(size: 10pt)
      corpo
    } else {
      corpo
    }
  }

  estilizar-sumario(body)
}

// ============================================================
//  Seção do ano (aparece no sumário como nível 1)
// ============================================================
#let secao-ano(titulo) = {
  pagebreak(weak: true)
  heading(level: 1, titulo)
}

// ============================================================
//  Questão (aparece no sumário como nível 2)
// ============================================================
#let questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 1,
  prova: "ENEM",
  ano: 2009,
  caderno: none,       // ex.: "Azul"
  dia: none,           // ex.: 1
  conteudo: none,      // ex.: "Equilíbrio químico (hidrólise e efeito do pH)"
  nova-pagina: true,   // use false na 1ª questão logo após #secao-ano
  body,
) = {
  // O heading de sumário fica invisível no corpo: quem aparece é o título grande abaixo.
  show <questao-heading>: it => place(hide(it))

  let cm = buscar(macroareas, macroarea, "macroarea")
  let cn = buscar(niveis, nivel, "nivel")

  if nova-pagina { pagebreak(weak: true) }

  // --- Entrada do sumário: "Questão 12 · Química — Conteúdo" ---
  let texto-sumario = (
    "Questão " + str(numero) + " · " + disciplina
      + if conteudo != none { " — " + conteudo } else { "" }
  )
  [#heading(level: 2, texto-sumario) <questao-heading>]

  // --- Linha de balões ---
  grid(
    columns: 3,
    column-gutter: 9pt,
    align: horizon,
    pill(macroarea, cm.bg, cm.fg),
    text(font: fonte-mono, size: 9.5pt, fill: c-texto, disciplina),
    pill(nivel, cn.bg, cn.fg),
  )

  v(0.01em)

  // --- Título ---
  align(center)[
    #text(size: 20pt, weight: "bold", tracking: -0.02em)[Questão #numero — #prova #ano]
  ]

  v(0.01em)

  // --- Subtítulo: Caderno · Dia ---
  {
    let partes = ()
    if caderno != none { partes.push("Caderno " + caderno) }
    if dia != none { partes.push(str(dia) + "º Dia") }
    if partes.len() > 0 {
      let cor-caderno = if caderno != none and lower(caderno) in cadernos {
        cadernos.at(lower(caderno))
      } else { none }
      set text(size: 10.5pt, fill: c-suave)
      if cor-caderno != none {
        box(circle(radius: 3pt, fill: cor-caderno), baseline: 0pt)
        h(5pt)
      }
      partes.join(" · ")
    }
  }

  // --- Faixa extra: conteúdo exigido ---
  if conteudo != none {
    v(1.1em)
    block(
      width: 100%,
      fill: c-fundo-conteudo,
      stroke: (left: 2.5pt + cm.fg, rest: 0.6pt + c-borda),
      radius: 4pt,
      inset: (x: 12pt, y: 9pt),
      grid(
        columns: (auto, 1fr),
        column-gutter: 10pt,
        align: horizon,
        text(font: fonte-mono, size: 7.5pt, fill: c-suave, tracking: 0.06em, upper[Conteúdo exigido]),
        text(size: 10.5pt, weight: "medium", conteudo),
      ),
    )
  }

  v(0.9em)
  line(length: 100%, stroke: 0.6pt + c-borda)
  v(0.9em)

  // --- Corpo da questão ---
  body
}

// ============================================================
//  SEU DOCUMENTO COMEÇA AQUI
// ============================================================

#show: config

#secao-ano("ENEM 2011")

// Questão 50

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Difícil",
  numero: 50,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Termoquímica",
  nova-pagina: false,
)[
  Um dos problemas dos combustíveis que contêm carbono é que sua queima produz dióxido de carbono. Portanto, uma característica importante, ao se escolher um combustível, é analisar seu calor de combustão ($#sym.Delta"H"_c^°$), definido como a energia liberada na queima completa de um mol de combustível no estado padrão. O quadro seguinte relaciona algumas substâncias que contêm carbono e seu $#sym.Delta"H"_c^°$.

  #align(center)[
    #image(
      "imagens/2011/q50_2011.png",
      width: 80%
    )
  ]

  #align(right)[
    #text(size: 8pt)[
      #h(5em) ATKINS, P. *Princípios de Química.* Bookman, 2007 (adaptado).
    ]
  ]  

  Neste contexto, qual dos combustíveis, quando queimado completamente, libera mais dióxido de carbono no ambiente pela mesma quantidade de energia produzida?

  #alternativas(
    [Benzeno.], // a
    [Metano.], // b
    [Glicose.], // c
    [Octano.], // d
    [Etanol.], // e
  )
]

// Questão 51

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Fácil",
  numero: 51,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Química Ambiental",
  nova-pagina: true,
)[
  Para evitar o desmatamento da Mata Atlântica nos arredores da cidade de Amargosa, no Recôncavo da Bahia, o Ibama tem atuado no sentido de fiscalizar, entre outras, as pequenas propriedades rurais que dependem da lenha proveniente das matas para a produção da farinha de mandioca, produto típico da região. Com isso, pequenos produtores procuram alternativas como o gás de cozinha, o que encarece a farinha.

  Uma alternativa viável, em curto prazo, para os produtores de farinha em Amargosa, que não cause danos à Mata Atlântica nem encareça o produto é a

  #alternativas(
    [construção, nas pequenas propriedades, de grandes fornos elétricos para torrar a mandioca.], // a
    [plantação, em suas propriedades, de árvores para serem utilizadas na produção de lenha.], // b
    [permissão, por parte do Ibama, da exploração da Mata Atlântica apenas pelos pequenos produtores.], // c
    [construção de biodigestores, para a produção de gás combustível a partir de resíduos orgânicos da região.], // d
    [coleta de carvão de regiões mais distantes, onde existe menor intensidade de fiscalização do Ibama.], // e
  )
]

// Questão 52

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 52,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Separação de Misturas",
  nova-pagina: true,
)[
  Belém é cercada por 39 ilhas, e suas populações convivem com  ameaças de doenças. O motivo, apontado por especialistas, é a poluição da água do rio, principal fonte de sobrevivência dos ribeirinhos. A diarreia é frequente nas crianças e ocorre como consequência da falta de saneamento básico, já que a população não tem acesso à água de boa qualidade. Como não há água potável, a alternativa é consumir a do rio.

  #align(right)[
    #text(size: 8pt)[
      #h(5em) *O Liberal.* 8 jul. 2008. Disponível em: http://www.oliberal.com.br
    ]
  ]  

  O procedimento adequado para tratar a água dos rios, a fim de atenuar os problemas de saúde causados por microrganismos a essas populações ribeirinhas é a

  #alternativas(
    [filtração], // a
    [cloração.], // b
    [coagulação], // c
    [fluoretação.], // d
    [decantação], // e
  )
]

// Questão 54

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 54,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Soluções",
  nova-pagina: true,
)[
  Certas ligas estanho-chumbo com composição específica formam um eutético simples, o que significa que uma liga com essas características se comporta como uma substância pura, com um ponto de fusão definido, no caso 183°C. Essa é uma temperatura inferior mesmo ao ponto de fusão dos metais que compõem esta liga (o estanho puro funde a 232°C e o chumbo puro a 320°C), o que justifica sua ampla utilização na soldagem de componentes eletrônicos, em que o excesso de aquecimento deve sempre ser evitado. De acordo com as normas internacionais, os valores mínimo e máximo das densidades para essas ligas são de 8,74 g/mL e 8,82 g/mL, respectivamente. As densidades do estanho e do chumbo são 7,3 g/mL e 11,3 g/mL, respectivamente.

  Um lote contendo 5 amostras de solda estanho-chumbo foi analisado por um técnico, por meio da determinação de sua composição percentual em massa, cujos resultados estão mostrados no quadro a seguir.

  #align(center)[
    #image(
      "imagens/2011/q54_2011.png",
      width: 70%
    )
  ]

  #align(right)[
    #text(size: 8pt)[
      #h(5em) Disponível em: http://www.eletrica.ufpr.br.
    ]
  ]  

  Com base no texto e na análise realizada pelo técnico, as amostras que atendem às normas internacionais são

  #alternativas(
    [I e II.], // a
    [I e III.], // b
    [II e IV.], // c
    [III e V.], // d
    [IV e V.], // e
  )
]

// Questão 55

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 55,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Estrutura molecular e Forças intermoleculares",
  nova-pagina: true,
)[
  No processo de industrialização da mamona, além do óleo que contém vários ácidos graxos, é obtida uma massa orgânica, conhecida como torta de mamona. Esta massa tem potencial para ser utilizada como fertilizante para o solo e como complemento em rações animais devido a seu elevado valor proteico. No entanto, a torta apresenta compostos tóxicos e alergênicos diferentemente do óleo da mamona. Para que a torta possa ser utilizada na alimentação animal, é necessário um processo de descontaminação.

  #align(right)[
    #text(size: 8pt)[
      #h(5em) *Revista Química Nova na Escola.* V. 32, n° 1, 2010 (adaptado).
    ]
  ]  

  A característica presente nas substâncias tóxicas e alergênicas, que inviabiliza sua solubilização no óleo de mamona, é a

  #alternativas(
    [lipofilia.], // a
    [hidrofilia.], // b
    [hipocromia.], // c
    [cromatofilia.], // d
    [hiperpolarização.], // e
  )
]

// Questao 58

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 58,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Estrutura molecular e Forças intermoleculares",
  nova-pagina: true,
)[
  A pele humana, quando está bem hidratada, adquire boa elasticidade e aspecto macio e suave. Em contrapartida, quando está ressecada, perde sua elasticidade e se apresenta opaca e áspera. Para evitar o ressecamento da pele é necessário, sempre que possível, utilizar hidratantes umectantes, feitos geralmente à base de glicerina e polietilenoglicol:

  #align(center)[
    #image(
      "imagens/2011/q58_2011.webp",
      width: 80%
    )
  ]

  #align(right)[
    #text(size: 8pt)[
      #h(5em) Disponível em: http://www.brasilescola.com. Acesso em: 23 abr. 2010 (adaptado).
    ]
  ]

  A retenção de água na superfície da pele promovida pelos hidratantes é consequência da interação dos grupos hidroxila dos agentes umectantes com a umidade contida no ambiente por meio de

  #alternativas(
    [ligações iônicas.], // a
    [forças de London.], // b
    [ligações covalentes.], // c
    [forças dipolo-dipolo.], // d
    [ligações de hidrogênio.], // e
  )
]

// Questao 59

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Difícil",
  numero: 59,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Estrutura molecular e Forças intermoleculares",
  nova-pagina: true,
)[
  A cal (óxido de cálcio, CaO), cuja suspensão em água é muito usada como uma tinta de baixo custo, dá uma tonalidade branca aos troncos de árvores. Essa é uma prática muito comum em praças públicas e locais privados, geralmente usada para combater a proliferação de parasitas. Essa aplicação, também chamada de caiação, gera um problema: elimina microrganismos benéficos para a árvore.

  #align(right)[
    #text(size: 8pt)[
      #h(5em) Disponível em: http://super.abril.com.br. Acesso em: 1 abr. 2010 (adaptado).
    ]
  ]

  A destruição do microambiente, no tronco de árvores pintadas com cal, é devida ao processo de

  #alternativas(
    [difusão, pois a cal se difunde nos corpos dos seres do microambiente e os intoxica.], // a
    [osmose, pois a cal retira água do microambiente, tornando-o inviável ao desenvolvimento de microrganismos.], // b
    [oxidação, pois a luz solar que incide sobre o tronco ativa fotoquimicamente a cal, que elimina os seres vivos do microambiente.], // c
    [aquecimento, pois a luz do Sol incide sobre o tronco e aquece a cal, que mata os seres vivos do microambiente.], // d
    [vaporização, pois a cal facilita a volatilização da água para a atmosfera, eliminando os seres vivos do microambiente.], // e
  )
]

// Questão 62

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito Difícil",
  numero: 62,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Estequiometria | Química Ambiental",
  nova-pagina: true,
)[
  A eutrofização é um processo em que rios, lagos e mares adquirem níveis altos de nutrientes, especialmente fosfatos e nitratos, provocando posterior acúmulo de matéria orgânica em decomposição. Os nutrientes são assimilados pelos produtores primários e o crescimento desses é controlado pelo nutriente limítrofe, que é o elemento menos disponível em relação à abundância necessária à sobrevivência dos organismos vivos. O ciclo representado na figura seguinte reflete a dinâmica dos nutrientes em um lago.

  // Imagem

  #align(center)[
    #image(
      "imagens/2011/q62_2011.webp",
      width: 60%
    )
  ]

  // Referências

  #align(right)[
    #text(size: 8pt)[
      #h(5em) SPIRO, T. G.; STIGLIANI, W. M. *Química Ambiental.* São Paulo: Pearson Education do Brasil, 2008 (adaptado).
    ]
  ]  

  A análise da água de um lago que recebe a descarga de águas residuais provenientes de lavouras adubadas revelou as concentrações dos elementos carbono (21,2 mol/L), nitrogênio (1,2 mol/L) e fósforo (0,2 mol/L). Nessas condições, o nutriente limítrofe é o

  #alternativas(
    [C.], // a
    [N.], // b
    [P.], // c
    [$"CO"_2$.], // d
    [$"PO"_4^"3–"$.], // e
  )
]

// Questão 72

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 72,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Funções Orgânicas",
  nova-pagina: true,
)[
  A bile é produzida pelo fígado, armazenada na vesícula biliar e tem papel fundamental na digestão de lipídeos. Os sais biliares são esteroides sintetizados no fígado a partir do colesterol, e sua rota de síntese envolve várias etapas. Partindo do ácido cólico representado na figura, ocorre a formação dos ácidos glicocólico e taurocólico; o prefixo glico- significa a presença de um resíduo do aminoácido glicina e o prefixo tauro-, do aminoácido taurina.

  // Imagem

  #align(center)[
    #image(
      "imagens/2011/q72_2011.webp",
      width: 60%
    )
  ]

  // Referências

  #align(right)[
    #text(size: 8pt)[
      #h(5em) UCKO, D. A. Química para as Ciências da Saúde: uma Introdução à Química Geral, Orgânica e Biológica. São Paulo: Manole, 1992 (adaptado).
    ]
  ]  

  A combinação entre o ácido cólico e a glicina ou taurina origina a função amida, formada pela reação entre o grupo amina desses aminoácidos e o grupo

  #alternativas(
    [carboxila do ácido cólico.], // a
    [aldeído do ácido cólico.], // b
    [hidroxila do ácido cólico.], // c
    [cetona do ácido cólico.], // d
    [éster do ácido cólico.], // e
  )
]

// Questao 75

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Fácil",
  numero: 75,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Equilíbrio Químico",
  nova-pagina: true,
)[
  Os refrigerantes têm-se tornado cada vez mais o alvo de políticas públicas de saúde. Os de cola apresentam ácido fosfórico, substância prejudicial à fixação de cálcio, o mineral que é o principal componente da matriz dos dentes. A cárie é um processo dinâmico de desequilíbrio do processo de desmineralização dentária, perda de minerais em razão da acidez. Sabese que o principal componente do esmalte do dente é um sal denominado hidroxiapatita. O refrigerante, pela presença da sacarose, faz decrescer o pH do biofilme (placa bacteriana), provocando a desmineralização do esmalte dentário. Os mecanismos de defesa salivar levam de 20 a 30 minutos para normalizar o nível do pH , remineralizando o dente. A equação química seguinte representa esse processo:

  // Imagem

  #align(center)[
    #image(
      "imagens/2011/q75_2011.png",
      width: 90%
    )
  ]

  // Referências

  #align(right)[
    #text(size: 8pt)[
      #h(18em) GROISMAN, S. *Impacto do refrigerante nos dentes é avaliado sem tirá-lo da dieta.* Disponível em: http://www.isaude.net. Acesso em: 1 maio 2010 (adaptado).
    ]
  ] 

  Considerando que uma pessoa consuma refrigerantes diariamente, poderá ocorrer um processo de desmineralização dentária, devido ao aumento da concentração de

  #alternativas(
    [$"OH"^–$, que reage com os íons $"Ca"^"2+"$, deslocando o equilíbrio para a direita.], // a
    [$"H"^+$, que reage com as hidroxilas $"OH"^–$, deslocando o equilíbrio para a direita.], // b
    [$"OH"^–$, que reage com os íons $"Ca"^"2+"$, deslocando o equilíbrio para a esquerda.], // c
    [$"H"^+$, que reage com as hidroxilas $"OH"^–$, deslocando o equilíbrio para a esquerda.], // d
    [$"Ca"^"2+"$, que, que reage com as hidroxilas $"OH"^–$, deslocando o equilíbrio para a esquerda.], // e
  )
]

// Questão 81

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito Fácil",
  numero: 81,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Estequiometria",
  nova-pagina: true,
)[
  O peróxido de hidrogênio é comumente utilizado como antisséptico e alvejante. Também pode ser empregado em trabalhos de restauração de quadros enegrecidos e no clareamento de dentes. Na presença de soluções ácidas de oxidantes, como o permanganato de potássio, este óxido decompõe-se, conforme a equação a seguir:

  #v(1em)

  $
    "5 ""H"_2"O"_2"(aq)" 
    + "2 ""KMnO"_4"(aq)" 
    + "3 ""H"_2"SO"_4"(aq)" 
    arrow.r.long 
    "5 ""O"_2"(g)" 
    + "2 ""MnSO"_4"(aq)" 
    + "K"_2"SO"_4"(aq)" 
    + "8 ""H"_2"O""(l)"
  $

  #v(1em)

  #align(right)[
    #text(size: 8pt)[
      #h(5em) ROCHA-FILHO, R. C. R.; SILVA, R. R. *Introdução aos Cálculos da Química.* São Paulo: McGraw-Hill, 1992.
    ]
  ]  

  #v(1em)

  De acordo com a estequiometria da reação descrita, a quantidade de permanganato de potássio necessária para reagir completamente com 20,0 mL de uma solução 0,1 mol/L de peróxido de hidrogênio é igual a

  #alternativas(
    [2,0 × 10⁰ mol.], // a
    [2,0 × 10⁻³ mol.], // b
    [8,0 × 10⁻¹ mol.], // c
    [8,0 × 10⁻⁴ mol.], // d
    [5,0 × 10⁻³ mol.], // e
  )
]

// Questão 83

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 83,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Química Ambiental",
  nova-pagina: true,
)[
  O etanol é considerado um biocombustível promissor, pois, sob o ponto de vista do balanço de carbono, possui uma taxa de emissão praticamente igual a zero. Entretanto, esse não é o único ciclo biogeoquímico associado à produção de etanol. O plantio da cana- de-açúcar, matéria-prima para a produção de etanol, envolve a adição de macronutrientes como enxofre, nitrogênio, fósforo e potássio, principais elementos envolvidos no crescimento de um vegetal.

  #align(right)[
    #text(size: 8pt)[
      #h(5em) *Revista Química Nova na Escola.* no 28, 2008
    ]
  ]  

  O nitrogênio incorporado ao solo, como consequência da atividade descrita anteriormente, é transformado em nitrogênio ativo e afetará o meio ambiente, causando

  #alternativas(
    [o acúmulo de sais insolúveis, desencadeando um processo de salinificação do solo.], // a
    [a eliminação de microrganismos existentes no solo responsáveis pelo processo de desnitrificação.], // b
    [a contaminação de rios e lagos devido à alta solubilidade de íons como $"NO"^"3–"$ e $"NH"^"4+"$ em água.], // c
    [a diminuição do pH do solo pela presença de $"NH"_3$, que reage com a água, formando o $"NH"_4"OH"$ (aq).], // d
    [a diminuição da oxigenação do solo, uma vez que o nitrogênio ativo forma espécies químicas do tipo $"NO"_2$, $"NO"^"3–"$, $"N"_2"O"$.], // e
  )
]

// Questão 85

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito Fácil",
  numero: 85,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Química Ambiental",
  nova-pagina: true,
)[
  Um dos processos usados no tratamento do lixo é a incineração, que apresenta vantagens e desvantagens. Em São Paulo, por exemplo, o lixo é queimado a altas temperaturas e parte da energia liberada é transformada em energia elétrica. No entanto, a incineração provoca a emissão de poluentes na atmosfera.

  Uma forma de minimizar a desvantagem da incineração, destacada no texto, é

  #alternativas(
    [aumentar o volume do lixo incinerado para aumentar a produção de energia elétrica.], // a
    [fomentar o uso de filtros nas chaminés dos incineradores para diminuir a poluição do ar.], // b
    [aumentar o volume do lixo para baratear os custos operacionais relacionados ao processo.], // c
    [fomentar a coleta seletiva de lixo nas cidades para aumentar o volume de lixo incinerado.], // d
    [diminuir a temperatura de incineração do lixo para produzir maior quantidade de energia elétrica.], // e
  )
]

// Questão 90

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito Fácil",
  numero: 90,
  prova: "ENEM",
  ano: 2011,
  caderno: "Azul",
  dia: 1,
  conteudo: "Química Ambiental",
  nova-pagina: true,
)[
  // Imagem

  #align(center)[
    #image(
      "imagens/2011/q90_2011.webp",
      width: 65%
    )
  ]
  
  De acordo com o relatório “A grande sombra da pecuária” (_Livestock’s Long Shadow_), feito pela Organização das Nações Unidas para a Agricultura e a Alimentação, o gado é responsável por cerca de 18% do aquecimento global, uma contribuição maior que a do setor de transportes.

  // Referências

  #align(right)[
    #text(size: 8pt)[
      #h(5em) Disponível em: www.conpet.gov.br. Acesso em: 22 jun. 2010.
    ]
  ]  
  
  A criação de gado em larga escala contribui para o aquecimento global por meio da emissão de

  #alternativas(
    [metano durante o processo de digestão.], // a
    [óxido nitroso durante o processo de ruminação.], // b
    [clorofluorcarbono durante o transporte de carne.], // c
    [óxido nitroso durante o processo respiratório.], // d
    [dióxido de enxofre durante o consumo de pastagens.], // e
  )
]

///////////////////////
// Seção de Gabarito //
///////////////////////
#pagebreak()

#align(center)[
  #text(size: 1.5em)[
    == Gabarito 2011
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
    [50], [C], [Termoquímica], [Difícil],
    [51], [D], [Química Ambiental], [Fácil],
    [51], [B], [Separação de Misturas], [Médio],
    [54], [C], [Soluções], [Médio],
    [55], [B], [Estrutura molecular e Forças Intermolares], [Muito Difícil],
    [58], [E], [Estrutura molecular e Forças Intermolares], [Médio],
    [59], [B], [Estrutura molecular e Forças Intermolares], [Difícil],
    [62], [B], [Química Ambiental | Estequiometria], [Difícil],
    [72], [A], [Funções Orgânicas], [Médio],
    [75], [B], [Equilíbrio Químico], [Fácil],
    [81], [D], [Estequiometria], [Muito Fácil],
    [83], [C], [Química Ambiental], [Médio],
    [85], [B], [Química Ambiental], [Muito Fácil],
    [90], [A], [Química Ambiental], [Muito Fácil],
  )
]