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

#secao-ano("ENEM 2011 PPL")

// Questão 46

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito Fácil",
  numero: 46,
  prova: "ENEM PPL",
  ano: 2011,
  caderno: "Branco",
  dia: 1,
  conteudo: "Radioatividade",
  nova-pagina: false,
)[
  Os materiais radioativos emitem diferentes tipos de radiação. A radiação gama, por exemplo, por sua alta energia e penetração, consegue remover elétrons dos átomos dos tecidos internos e romper ligações químicas por ionização, podendo causar mutação no DNA. Já as partículas beta têm o mesmo efeito ionizante, mas atuam sobre as células da pele.

  #align(right)[
    #text(size: 8pt)[
      #h(16em) RODRIGUES JR., A. A. O que é radiação? E contaminação radioativa? Vamos esclarecer. *Física na Escola.* V. 8, n° 2, 2007. São Paulo: Sociedade Brasileira de Física (adaptado).
    ]
  ]

  Segundo o texto, um indivíduo irradiado por uma fonte radioativa é exposto ao risco de

  #alternativas(
    [transformar-se em um corpo radioativo.], // a
    [absorver a radiação e armazená-la.], // b
    [emitir radiação e contaminar outras pessoas.], // c
    [sofrer alterações gênicas e desenvolver câncer.], // d
    [transportar a radiação e contaminar outros ambientes.], // e
  )
]

// Questão 49

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito Fácil",
  numero: 49,
  prova: "ENEM PPL",
  ano: 2011,
  caderno: "Branco",
  dia: 1,
  conteudo: "Termoquímica",
  nova-pagina: true,
)[
  Considera-se combustível aquele material que, quando em combustão, consegue gerar energia. No caso dos biocombustíveis, suas principais vantagens de uso são a de serem oriundos de fontes renováveis e a de serem menos poluentes que os derivados de combustíveis fósseis. Por isso, no Brasil, tem-se estimulado o plantio e a industrialização de sementes oleaginosas para produção de biocombustíveis.

  No quadro, estão os valores referentes à energia produzida pela combustão de alguns biocombustíveis:

  // Imagem

  #align(center)[
    #image(
      "imagens/2011_ppl/q49_2011_ppl.png",
      width: 80%
    )
  ]

  // Referências

  #align(right)[
    #text(size: 8pt)[
      #h(5em) Disponível em: http://www.biodieselecooleo.com.br. Acesso em: 8 set. 2010 (adaptado).
    ]
  ]  

  Entre os diversos tipos de biocombustíveis apresentados no quadro, aquele que apresenta melhor rendimento energético em massa é proveniente

  #alternativas(
    [da soja.], // a
    [do dendê.], // b
    [do babaçu.], // c
    [da mamona.], // d
    [da cana-de-açúcar.], // e
  )
]

// Questão 50

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 50,
  prova: "ENEM PPL",
  ano: 2011,
  caderno: "Branco",
  dia: 1,
  conteudo: "Eletroquímica",
  nova-pagina: true,
)[
  Iniciativas do poder público para prevenir o uso de bebidas alcoólicas por motoristas, causa de muitos acidentes nas estradas do país, trouxeram à ordem do dia, não sem suscitar polêmica, o instrumento popularmente conhecido como bafômetro. Do ponto de vista de deteção e medição, os instrumentos normalmente usados pelas polícias rodoviárias do Brasil e de outros países utilizam o ar que os "suspeitos" sopram para dentro do aparelho, através de um tubo descartável, para promover a oxidação do etanol a etanal. O método baseia-se no princípio da pilha de combustível: o etanol é oxidado em meio ácido sobre um disco plástico poroso coberto com pó de platina (catalisador) e umedecido com ácido sulfúrico, sendo um eletrodo conectado a cada lado desse disco poroso. A corrente elétrica produzida, proporcional à concentração de álcool no ar expirado dos pulmões da pessoa testada, é lida numa escala que é proporcional ao teor de álcool no sangue. O esquema de funcionamento desse detector de etanol pode ser visto na figura.

  #align(center)[
    #image(
      "imagens/2011_ppl/q50_2011_ppl.webp",
      width: 100%
    )
  ]

  As reações eletroquímicas envolvidas no processo são:

  *Eletrodo A:* $"CH"_3"CH"_2"OH""(g)" arrow.r.long "CH"_3"CHO""(g)" + "2 H"^+"(aq)" + "2 e"^–$

  *Eletrodo B:* $ 1/2 "O"_2"(g)" + "2 H"^+"(aq)" + "2 e"^– arrow.r.long "H"_2"O""(l)"$

#align(right)[
  #text(size: 8pt)[
    #h(5em) BRAATHEN, P. C. Hálito culpado: o princípio químico do bafômetro. *Química nova na escola.* São Paulo, n° 5, maio 1997 (adaptado).
  ]
]  
  

  No estudo das pilhas, empregam-se códigos e nomenclaturas próprias da Química, visando caracterizar os materiais, as reações e os processos envolvidos. Nesse contexto, a pilha que compõe o bafômetro apresenta o

  #alternativas(
    [eletrodo A como cátodo.], // a
    [etanol como agente oxidante.], // b
    [eletrodo B como polo positivo.], // c
    [gás oxigênio como agente redutor.], // d
    [fluxo de elétrons do eletrodo B para o eletrodo A.], // e
  )
]

// Questão 51

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito Difícil",
  numero: 51,
  prova: "ENEM PPL",
  ano: 2011,
  caderno: "Branco",
  dia: 1,
  conteudo: "Termoquímica",
  nova-pagina: true,
)[
  A reciclagem exerce impacto considerável sobre a eficiência energética. Embora restaurar materiais que foram descartados também consuma energia, é possível que essa energia seja substancialmente menor. O gráfico seguinte indica a quantidade de energia necessária para a produção de materiais primários e reciclados. A maioria dos metais ocorre na crosta terrestre como óxidos que devem ser reduzidos para recuperar o metal elementar, o que consome grande quantidade de energia. As entalpias-padrão de formação dos óxidos de alumínio e ferro são, respectivamente: –1675,7 kJ/mol e –824,2 kJ/mol.

  // Imagem

  #align(center)[
    #image(
      "imagens/2011_ppl/q51_2011_ppl.png",
      width: 45%
    )
  ]

  // Referências

  #align(right)[
    #text(size: 8pt)[
      SPIRO, T. G.; STIGLIANI, W. M. *Química Ambiental.* São Paulo: Pearson Education do Brasil, 2008 (adaptado).
    ]
  ]  

  A energia gasta na obtenção do alumínio a partir do seu material primário é maior do que a do aço, porque o alumínio

  #alternativas(
    [forma seu óxido absorvendo menos energia que o ferro.], // a
    [requer 200 vezes mais energia para ser isolado do seu minério do que o ferro.], // b
    [requer praticamente o dobro de energia para ser isolado do seu óxido do que requer o ferro, no estado padrão.], // c
    [apresenta entalpia de formação no seu óxido menor do que a entalpia do ferro.], // d
    [apresenta somente uma valência constante, enquanto o ferro pode apresentar normalmente duas valências.], // e
  )
]

// Questão 57

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Difícil",
  numero: 57,
  prova: "ENEM PPL",
  ano: 2011,
  caderno: "Branco",
  dia: 1,
  conteudo: "Química Orgânica: Reações Orgânicas",
  nova-pagina: true,
)[
  O biodiesel é um biocombustível que pode ser obtido a partir do processo químico em que óleos ou gorduras são transformados em ésteres metílicos ou etílicos de ácidos graxos. Suas principais vantagens de uso relacionam-se principalmente ao fato de serem oriundos de fontes renováveis e produzirem muito menos poluição do que os derivados de combustíveis fósseis. A figura seguinte mostra, de forma esquemática, o processo de produção de biodiesel a partir do óleo de soja:

  // Imagem

  #align(center)[
    #image(
      "imagens/2011_ppl/q57_2011_ppl.webp",
      width: 60%
    )
  ]

  // Referências

  #align(right)[
    #text(size: 8pt)[
      #h(5em) Disponível em: http://www.proteinasdesoja.com.br.
    ]
  ]  

  De acordo com o descrito, a etapa que representa efetivamente a formação das moléculas orgânicas combustíveis que compõem o biodiesel está representada na figura pelo número

  #alternativas(
    [1.], // a
    [2.], // b
    [3.], // c
    [4.], // d
    [5.], // e
  )
]

// Questão 69

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 69,
  prova: "ENEM PPL",
  ano: 2011,
  caderno: "Branco",
  dia: 1,
  conteudo: "Radioatividade",
  nova-pagina: true,
)[
  Radioisótopos são frequentemente utilizados em diagnósticos por imagem. Um exemplo é aplicação de iodo-131 para detectar possíveis problemas associados à glândula tireoide. Para o exame, o paciente incorpora o isótopo radioativo pela ingestão de iodeto de potássio, o qual se concentrará na região a ser analisada. Um detector de radiação varre a região e um computador constrói a imagem que irá auxiliar no diagnóstico. O radioisótopo em questão apresenta um tempo de meia-vida igual a 8 minutos e emite radiação gama e partículas beta em seu decaimento radioativo.

  #align(right)[
  #text(size: 8pt)[
    #h(5em) *Química nuclear na medicina.* Disponível em: www.qmc.ufsc.br. Acesso em: 28 jul. 2010 (adaptado).
  ]
]  

  No decaimento radioativo do iodo-131, tem-se a

  #alternativas(
    [produção de uma partícula subatômica com carga positiva.], // a
    [possibilidade de sua aplicação na datação de fósseis.], // b
    [formação de um elemento químico com diferente número de massa.], // c
    [emissão de radiação que necessita de um meio material para se propagar.], // d
    [redução de sua massa a um quarto da massa inicial em menos de meia hora.], // e
  )
]

// Questão 73

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 73,
  prova: "ENEM PPL",
  ano: 2011,
  caderno: "Branco",
  dia: 1,
  conteudo: "Eletroquímica",
  nova-pagina: true,
)[
  A matéria-prima básica para a fabricação de calçados plásticos é a resina de PVC. A seguir é apresentado o fluxograma de fabricação do PVC e sua fórmula química.

  Siglas: PVC - policloreto de vinila; EDC - dicloro etano; MVC - monocloreto de vinila

  // Imagem

  #align(center)[
    #image(
      "imagens/2011_ppl/q73_2011_ppl.webp",
      width: 80%
    )
  ]

  // Referências

  #align(right)[
    #text(size: 8pt)[
      #h(5em) Disponível em: http://ri.grendene.com.br. Acesso em: 15 jun. 2011 (adaptado). 
    ]
  ]  

  Para a produção do PVC, a obtenção do cloro é proveniente do processo de

  #alternativas(
    [destilação.], // a
    [eletrólise.], // b
    [fusão ígnea.], // c
    [filtração a vácuo.], // d
    [precipitação fracionada.], // e
  )
]

// Questão 76

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Fácil",
  numero: 76,
  prova: "ENEM PPL",
  ano: 2011,
  caderno: "Branco",
  dia: 1,
  conteudo: "Radioatividade",
  nova-pagina: true,
)[
  Com a crescente demanda de energia elétrica, decorrente do modo de vida da sociedade moderna, tornou-se necessário que mais de uma fonte de energia seja estudada e aplicada, levando-se em conta os impactos ambientais e sociais a serem gerados em curto e longo prazo. Com isso, o uso da energia nuclear tem sido muito debatido no mundo. O questionamento principal é se valerá a pena construir centrais de produção nuclear ou é preferível investir em outros tipos de energias que sejam renováveis.

  #align(right)[
    #text(size: 8pt)[
      #h(32em) Disponível em: http://energiaeambiente.wordpress.com. http://www.comciencia.br. Acesso em: 27 jan. 2009 (adaptado).
    ]
  ]  

  Um argumento favorável ao uso da energia nuclear é o fato de

  #alternativas(
    [seu preço de instalação ser menor que o das demais fontes de energia.], // a
    [o tratamento de seus rejeitos ser um processo simples.], // b
    [de ser uma energia limpa, de baixo custo, que não causa impactos ambientais.], // c
    [ser curto o tempo de atividade dos resíduos produzidos na sua geração.], // d
    [ser uma energia limpa embora não seja renovável.], // e
  )
]

// Questão 78

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito Difícil",
  numero: 78,
  prova: "ENEM PPL",
  ano: 2011,
  caderno: "Branco",
  dia: 1,
  conteudo: "Estequiometria",
  nova-pagina: true,
)[
  Três amostras de minérios de ferro de regiões distintas foram analisadas e os resultados, com valores aproximados, estão na tabela:

  #align(center)[
    #image(
      "imagens/2011_ppl/q78_2011_ppl.png",
      width: 100%
    )
  ]

  Considerando que as impurezas são inertes aos compostos envolvidos, as reações de redução do minério de ferro com carvão, de formas simplificadas, são:

  #text(size: 16pt)[
    $
      "2 Fe"_2"O"_3 + "3 C"
      arrow.r.long
      "4 Fe" + "3 CO"_2
    $

    $
      "2 FeO" + "C"
      arrow.r.long
      "2 Fe" + "CO"_2
    $

    $
      "Fe"_3"O"_4 + "2 C"
      arrow.r.long
      "3 Fe" + "2 CO"_2
    $
  ]

  *Dados:* Massas molares (g/mol): C = 12; O = 16; Fe = 56; FeO = 72; $"Fe"_2"O"_3$ = 160; $"Fe"_3"O"_4$ = 232.

  Os minérios que apresentam, respectivamente, a maior pureza e o menor consumo de carvão por tonelada de ferro produzido são os das regiões:

  #alternativas(
    [A com 75 % e C com 143 kg.], // a
    [B com 80 % e A com 161 kg.], // b
    [C com 85 % e B com 107 kg.], // c
    [A com 90 % e B com 200 kg.], // d
    [B com 95 % e A com 161 kg.], // e
  )
]

// Questão 79

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Fácil",
  numero: 79,
  prova: "ENEM PPL",
  ano: 2011,
  caderno: "Branco",
  dia: 1,
  conteudo: "Química Orgânica: Hidrocarbonetos",
  nova-pagina: true,
)[
  A explosão de uma plataforma de petróleo em frente à costa americana e o vazamento de cerca de mil barris de petróleo por dia no mar provocaram um desastre ambiental. Uma das estratégias utilizadas pela Guarda Costeira para dissipar a mancha negra foi um recurso simples: fogo. A queima da mancha de petróleo para proteger a costa provocará seus próprios problemas ambientais, criando enormes nuvens de fumaça tóxica e deixando resíduos no mar e no ar.

  #align(right)[
    #text(size: 8pt)[
      #h(20em) HIRST, M. *Depois de vazamento, situação de petroleira britânica se complica.* BBC. Disponível em: http://www.bbc.co.uk. Acesso em: 1 maio 2010 (adaptado).
    ]
  ]  

  Além da poluição das águas provocada pelo derramamento de óleo no mar, a queima do petróleo provoca a poluição atmosférica formando uma nuvem negra denominada fuligem, que é proveniente da combustão

  #alternativas(
    [completa de hidrocarbonetos.], // a
    [incompleta de hidrocarbonetos.], // b
    [completa de compostos sulfurados.], // c
    [incompleta de compostos sulfurados.], // d
    [completa de compostos nitrogenados.], // e
  )
]

// Questão 81

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 81,
  prova: "ENEM PPL",
  ano: 2011,
  caderno: "Branco",
  dia: 1,
  conteudo: "Química Orgânica: Propriedades dos compostos orgânicas",
  nova-pagina: true,
)[
  As chamadas estruturas metal-orgânicas são cristais metálicos porosos e estáveis, capazes de absorver e comprimir gases em espaços ínfimos. Um grama deste material, se espalhado, ocuparia uma área de pelo menos 5000 m². Os cientistas esperam que o uso de tais materiais contribua para a produção de energias mais limpas e de métodos para a captura de gases do efeito estufa.

  #align(right)[
    #text(size: 8pt)[
      #h(5em) Disponível em: http://www1.folha.uol.com.br. Acesso em: 20 jul. 2010 (adaptado).
    ]
  ]  

  A maior eficiência destes materiais em absorver gás carbônico é consequência

  #alternativas(
    [da alta estabilidade dos cristais metálicos.], // a
    [da alta densidade apresentada pelos materiais.], // b
    [da capacidade de comprimir os gases ocupando grandes áreas.], // c
    [da grande superfície de contato entre os cristais porosos e o gás carbônico.], // d
    [do uso de grande quantidade de materiais para absorver grande quantidade de gás.], // e
  )
]

///////////////////////
// Seção de Gabarito //
///////////////////////
#pagebreak()

#align(center)[
  #text(size: 1.5em)[
    == Gabarito 2011 PPL
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
    table.header[*Questão*][*Resposta*][*Conteúdo*][*Dificuldade*],
    [46], [D], [Radioatividade], [Muito Fácil],
    [49], [A], [Termoquímica], [Muito Fácil],
    [50], [C], [Eletroquímica], [Médio],
    [51], [D], [Termoquímica], [Muito Difícil],
    [57], [A], [Reações Orgânicas], [Difícil],
    [69], [E], [Radioatividade], [Médio],
    [73], [B], [Eletroquímica], [Médio],
    [76], [E], [Radioatividade], [Fácil],
    [78], [C], [Estequiometria], [Muito Difícil],
    [79], [B], [Funções Orgânicas: Hidrocarbonetos], [Fácil],
    [81], [D], [Química Orgânica: Propriedade dos compostos Orgânicos], [Médio],
  )
]