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

// #outline(title: [Sumário], depth: 2)

#secao-ano("ENEM 2010")

// Questao 56

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Difícil",
  numero: 55,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Separação de Misturas",
  nova-pagina: false,
)[
  Em visita a uma usina sucroalcooleira, um grupo de alunos pôde observar a série de processos de beneficiamento da cana-de-açúcar, entre os quais se destacam:

  + A cana chega cortada da lavoura por meio de caminhões e é despejada em mesas alimentadoras que a conduzem para as moendas. Antes de ser esmagada para a retirada do caldo açucarado, toda a cana é transportada por esteiras e passada por um eletroimã para a retirada de materiais metálicos. 
  
  + Após se esmagar a cana, o bagaço segue para as caldeiras, que geram vapor e energia para toda a usina.

  + O caldo primário, resultante do esmagamento, é passado por filtros e sofre tratamento para transformar-se em açúcar refinado e etanol.  

  Com base nos destaques da observação dos alunos, quais operações físicas de separação de materiais foram realizadas nas etapas de beneficiamento da canade-açúcar?

  #alternativas(
    [Separação mecânica, extração, decantação],
    [Separação magnética, combustão, filtração.],
    [Separação magnética, extração, filtração.],
    [Imantação, combustão, peneiração.],
    [Imantação, destilação, filtração.],
  )
]

#pagebreak()

// Questão 59

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito fácil",
  numero: 59,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Química Ambiental",
  nova-pagina: false,
)[
  As cidades industrializadas produzem grandes proporções de gases como o $"CO"_2$, o principal gás causador do efeito estufa. Isso ocorre por causa da quantidade de combustíveis fósseis queimados, principalmente no transporte, mas também em caldeiras industriais. Além disso, nessas cidades concentram-se as maiores áreas com solos asfaltados e concretados, o que aumenta a retenção de calor, formando o que se conhece por “ilhas de calor”. Tal fenômeno ocorre porque esses materiais absorvem o calor e o devolvem para o ar sob a forma de radiação térmica.
  
  Em áreas urbanas, devido à atuação conjunta do efeito estufa e das “ilhas de calor”, espera-se que o consumo de energia elétrica.

  #alternativas(
    [diminua devido à utilização de caldeiras por indústrias metalúrgicas],
    [aumente devido ao bloqueio da luz do sol pelos gases do efeito estufa],
    [diminua devido à não necessidade de aquecer a água utilizada em indústrias.],
    [aumente devido à necessidade de maior refrigeração de indústrias e residências.],
    [diminua devido à grande quantidade de radiação térmica reutilizada.],
  )
]

#pagebreak()

// Questão 60

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Fácil",
  numero: 60,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Soluções: Propriedades Coligativas",
  nova-pagina: false,
)[
  A lavoura arrozeira na planície costeira da região sul do Brasil comumente sofre perdas elevadas devido à salinização da água de irrigação, que ocasiona prejuízos diretos, como a redução de produção da lavoura. Solos com processo de salinização avançado não são indicados, por exemplo, para o cultivo de arroz. As plantas retiram a água do solo quando as forças de embebição dos tecidos das raízes são superiores às forças com que a água é retida no solo.

  #align(right)[
    #text(size: 8pt)[
      WINKEL, H.L.; TSCHIEDEL, M. *Cultura do arroz: salinização de solos em cultivos de arroz.* Disponível em: http://agropage.tripod.com/saliniza.hml. Acesso em: 25 jun. 2010 (adaptado).
    ]
  ]

  A presença de sais na solução do solo faz com que seja dificultada a absorção de água pelas plantas, o que provoca o fenômeno conhecido por seca fisiológica, caracterizado pelo(a)

  #alternativas(
    [aumento da salinidade, em que a água do solo atinge uma concentração de sais maior que a das células das raízes das plantas, impedindo, assim, que a água seja absorvida.],
    [aumento da salinidade, em que o solo atinge um nível muito baixo de água, e as plantas não têm força de sucção para absorver a água],
    [diminuição da salinidade, que atinge um nível em que as plantas não têm força de sucção, fazendo com que a água não seja absorvida.],
    [aumento da salinidade, que atinge um nível em que as plantas têm muita sudação, não tendo força de sucção para superá-la.],
    [diminuição da salinidade, que atinge um nível em que as plantas ficam túrgidas e não têm força de sudação para superá-la.],
  )
]

#pagebreak()

// Questão 63

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Fácil",
  numero: 63,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Eletroquímica",
  nova-pagina: false,
)[
  O crescimento da produção de energia elétrica ao longo do tempo tem influenciado decisivamente o progresso da humanidade, mas também tem criado uma séria preocupação: o prejuízo ao meio ambiente. Nos próximos anos, uma nova tecnologia de geração de energia elétrica deverá ganhar espaço: as células a combustível hidrogênio/oxigênio.

  #align(right)[
    #text(size: 8pt)[
      VILLULLAS, H. M; TICIANELLI, E. A; GONZÁLEZ, E. R. *Química Nova Na Escola.* №15, maio 2002.
    ]
  ]

  #align(center)[
    #image(
      "imagens/2010/q63_2010.png",
      width: 60%
    )
  ]

  Com base no texto e na figura, a produção de energia elétrica por meio da célula a combustível hidrogênio/oxigênio diferencia-se dos processos convencionais porque

  #alternativas(
    [transforma energia química em energia elétrica, sem causar danos ao meio ambiente, porque o principal subproduto formado é a água.],
    [converte a energia química contida nas moléculas dos componentes em energia térmica, sem que ocorra a produção de gases poluentes nocivos ao meio ambiente.],
    [transforma energia química em energia elétrica, porém emite gases poluentes da mesma forma que a produção de energia a partir dos ombustíveis fósseis.],
    [converte energia elétrica proveniente dos combustíveis fósseis em energia química, retendo os gases poluentes produzidos no processo sem alterar a qualidade do meio ambiente.],
    [converte a energia potencial acumulada nas moléculas de água contidas no sistema em energia química, sem que ocorra a produção de gases poluentes nocivos ao meio ambiente.],
  )
]

#pagebreak()

// Questão 65

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 65,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Equilíbrio Químico",
  nova-pagina: false,
)[
  Enunciado_da_questaoAs misturas efervescentes, em pó ou em comprimidos, são comuns para a administração de vitamina C ou de medicamentos para azia. Essa forma farmacêutica sólida foi desenvolvida para facilitar o transporte, aumentar a estabilidade de substâncias e, quando em solução, acelerar a absorção do fármaco pelo organismo. 
  
  As matérias-primas que atuam na efervescência são, em geral, o ácido tartárico ou o ácido cítrico que reagem com um sal de caráter básico, como o bicarbonato de sódio ($"NaHCO"_3$), quando em contato com a água. A partir do contato da mistura efervescente com a água, ocorre uma série de reações químicas simultâneas: liberação de íons, formação de ácido e liberação do gás carbônico — gerando a efervescência.

  As equações a seguir representam as etapas da reação da mistura efervescente na água, em que foram omitidos os estados de agregação dos reagentes, e $"H"_3"A"$ representa o ácido cítrico.

  #align(center)[
    #box()[
      #set enum(numbering: "I-")

      + $"NaHCO"_3 arrow.r "Na"^+ + "HCO"_3^-$
      + $"H"_2"CO"_3 harpoons.rtlb "H"_2"O" + "CO"_2$
      + $"HCO"_3^- + "H"^+ harpoons.rtlb "H"_2"CO"_3$
      + $"H"_3"A" harpoons.rtlb 3"H"^+ + "A"^-$
    ]
  ]

  A ionização, a dissociação iônica, a formação do ácido e a liberação do gás ocorrem, respectivamente, nas seguintes etapas:

  #alternativas(
    [IV, I, II e III],
    [I, IV, III e II],
    [IV, III, I e II],
    [I, IV, II e III],
    [IV, I, III e II],
  )
]

#pagebreak()

// Questão 67

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Difícil",
  numero: 67,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Termoquímica",
  nova-pagina: false,
)[
  O abastecimento de nossas necessidades energéticas futuras dependerá certamente do desenvolvimento de tecnologias para aproveitar a energia solar com maior eficiência. A energia solar é a maior fonte de energia mundial. Num dia ensolarado, por exemplo, aproximadamente 1 kJ de energia solar atinge cada metro quadrado da superfície terrestre por segundo. No entanto, o aproveitamento dessa energia é difícil porque ela é diluída (distribuída por uma área muito extensa) e oscila com o horário e as condições climáticas. O uso efetivo da energia solar depende de formas de estocar a energia coletada para uso posterior.

  #align(right)[
    #text(size: 8pt)[
    BROWN, T. *Química a Ciência Central.* São Paulo: Pearson Prentice Hall, 2005.
    ]
  ]

  Atualmente, uma das formas de se utilizar a energia solar tem sido armazená-la por meio de processos químicos endotérmicos que mais tarde podem ser revertidos para liberar calor. Considerando a reação: $"CH"_"4" "(g)" + "H"_2"O""(v)" + "calor" harpoons.rtlb "CO"(g) + 3 "H"_2(g)$ e analisando-a como potencial mecanismo para o aproveitamento posterior da energia solar, conclui-se que se trata de uma estratégia

  #alternativas(
    [insatisfatória, pois a reação apresentada não permite que a energia presente no meio externo seja absorvida pelo sistema para ser utilizada posteriormente.],
    [insatisfatória, uma vez que há formação de gases poluentes e com potencial poder explosivo, tornando-a uma reação perigosa e de difícil controle.],
    [insatisfatória, uma vez que há formação de gás CO que não possui conteúdo energético passível de ser aproveitado posteriormente e é considerado um gás poluente],
    [satisfatória, uma vez que a reação direta ocorre com absorção de calor e promove a formação das substâncias combustíveis que poderão ser utilizadas posteriormente para obtenção de energia e realização de trabalho útil.],
    [satisfatória, uma vez que a reação direta ocorre com liberação de calor havendo ainda a formação das substâncias combustíveis que poderão ser utilizadas posteriormente para obtenção de energia e realização de trabalho útil.],
  )
]

#pagebreak()

// Questão 69

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Difícil",
  numero: 69,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Termoquímica",
  nova-pagina: false,
)[
  No que tange à tecnologia de combustíveis alternativos, muitos especialistas em energia acreditam que os alcoóis vão crescer em importância em um futuro próximo. Realmente, alcoóis como metanol e etanol têm encontrado alguns nichos para uso doméstico como combustíveis há muitas décadas e, recentemente, vêm obtendo uma aceitação cada vez maior como aditivos, ou mesmo como substitutos para gasolina em veículos. Algumas das propriedades físicas desses combustíveis são mostradas no quadro seguinte.

  #align(center)[
    #image(
      "imagens/2010/q69_2010.png",
      width: 80%
    )
  ]

  #align(right)[
    #text(size: 8pt)[
      BAIRD, C. *Química Ambiental.* São Paulo: Artmed, 1995 (adaptado).
    ]
  ]

  *Dados:* 
  Massas molares em g/mol: H=1,0 ; C=12,0 ; O=16,0.

  Considere que, em pequenos volumes, o custo de produção de ambos os alcoóis seja o mesmo. Dessa forma, do ponto de vista econômico, é mais vantajoso utilizar

  #alternativas(
    [metanol, pois sua combustão completa fornece aproximadamente 22,7 kJ de energia por litro de combustível queimado.],
    [etanol, pois sua combustão completa fornece aproximadamente 29,7 kJ de energia por litro de combustível queimado. ],
    [metanol, pois sua combustão completa fornece aproximadamente 17,9 MJ de energia por litro de combustível queimado. ],
    [etanol, pois sua combustão completa fornece aproximadamente 23,5 MJ de energia por litro de combustível queimado. ],
    [etanol, pois sua combustão completa fornece aproximadamente 33,7 MJ de energia por litro de combustível queimado. ],
  )
]

#pagebreak()

// Questao 73

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito difícil",
  numero: 73,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Estequiometria",
  nova-pagina: false,
)[
  A composição média de uma bateria automotiva esgotada é de aproximadamente 32% Pb, 3% PbO, 17% $"PbO"_2$ e 36% $"PbSO"_4$. A média de massa da pasta residual de uma bateria usada é de 6 kg, onde 19% é $"PbO"_2$, 60% $"PbSO"_4$ e 21% Pb. Entre todos os compostos de chumbo presentes na pasta, o que mais preocupa é o sulfato de chumbo (II), pois nos processos pirometalúrgicos, em que os compostos de chumbo (placas das baterias) são fundidos, há a conversão de sulfato em dióxido de enxofre, gás muito poluente. Para reduzir o problema das emissões de $"SO"_2$(g), a indústria pode utilizar uma planta mista, ou seja, utilizar o processo hidrometalúrgico, para a dessulfuração antes da fusão do composto de chumbo. Nesse caso, a redução de sulfato presente no PbSO4 é feita via lixiviação com solução de carbonato de sódio ($"Na"_2"CO"_3$) 1 M a 45° C, em que se obtém o carbonato de chumbo (II) com rendimento de 91 %. Após esse processo, o material segue para a fundição para obter o chumbo metálico.

  #align(center)[
    $"PbSO"_4 + "Na"_2"CO"_3 arrow.r "PbCO"_3 + "Na"_2"SO"_4$
  ]

  Dados: Massas Molares em g/mol Pb = 207; S=32; Na = 23; O=16 ; C=12

  #align(right)[
    #text(size: 8pt)[
      ARAÚJO, R. V. V.; TINDADE, R. B. E.; SOARES, P. S. M. *Reciclagem de chumbo de bateria automotiva:* estudo de caso.   Disponível em: http://www.iqsc.usp.br. Acesso em: 17 abr. 2010 (adaptado).
    ]
  ]

  Segundo as condições do processo apresentado para a obtenção de carbonato de chumbo (II) por meio da lixiviação por carbonato de sódio e considerando uma massa de pasta residual de uma bateria de 6 kg, qual quantidade aproximada, em quilogramas, de $"PbCO"_3$ é obtida?

  #alternativas(
    [1,7 kg],
    [1,9 kg],
    [2,9 kg],
    [3,3 kg],
    [3,6 kg],
  )
]

#pagebreak()

// Questao 74

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito difícil",
  numero: 74,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Eletroquímica",
  nova-pagina: false,
)[
  A eletrólise é muito empregada na indústria com o objetivo de reaproveitar parte dos metais sucateados. O cobre, por exemplo, é um dos metais com maior rendimento no processo de eletrólise, com uma recuperação de aproximadamente 99,9%. Por ser um metal de alto valor comercial e de múltiplas aplicações, sua recuperação torna-se viável economicamente.

  Suponha que, em um processo de recuperação de cobre puro, tenha-se eletrolisado uma solução de sulfato de cobre (II) ($"CuSO"_4$) durante 3 h, empregando-se uma corrente elétrica de intensidade igual a 10 A. A massa de cobre puro recuperada é de aproximadamente Dados: Constante de Faraday F = 96500 C / mol; Massa molar em g/mol: Cu = 63,5.

  #alternativas(
    [0,02 g],
    [0,04 g],
    [2,40 g],
    [35,5 g],
    [71,0 g],
  )
]

#pagebreak()

// Questao 77

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 77,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Química Orgânica: Reações Orgânicas",
  nova-pagina: false,
)[
  No ano de 2004, diversas mortes de animais por envenenamento no zoológico de São Paulo foram evidenciadas. Estudos técnicos apontam suspeita de intoxicação por monofluoracetato de sódio, conhecido como composto 1080 e ilegalmente comercializado como raticida. O monofluoracetato de sódio é um derivado do ácido monofluoracético e age no organismo dos mamíferos bloqueando o ciclo de Krebs, que pode levar à parada da respiração celular oxidativa e ao acúmulo de amônia na circulação.

  #align(center)[
    #image(
      "imagens/2010/q77_2010.svg",
      width: 50%
    )
  ]

  #align(right)[
    #text(size: 8pt)[
      Disponível em: http://www1.folha.uol.com.br. Acesso em: 05 ago. 2010 (adaptado).
    ]
  ]

  O monofluoracetato de sódio pode ser obtido pela

  #alternativas(
    [desidratação do ácido monofluoracético, com liberação de água.],
    [hidrólise do ácido monofluoracético, sem formação de água.],
    [perda de íons hidroxila do ácido monofluoracético, com liberação de hidróxido de sódio.],
    [neutralização do ácido monofluoracético usando hidróxido de sódio, com liberação de água.],
    [substituição dos íons hidrogênio por sódio na estrutura do ácido monofluoracético, sem formação de água.],
  )
]

#pagebreak()

// Questao 79

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 79,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Estequimetria",
  nova-pagina: false,
)[
  As mobilizações para promover um planeta melhor para as futuras gerações são cada vez mais frequentes. A maior parte dos meios de transporte de massa é atualmente movida pela queima de um combustível fóssil. A título de exemplificação do ônus causado por essa prática, basta saber que um carro produz, em média, cerca de 200 g de dióxido de carbono por km percorrido.

  #align(right)[
    #text(size: 8pt)[
      Revista Aquecimento Global. Ano 2, n° 8. Publicação do Instituto Brasileiro de Cultura Ltda.
    ]
  ]

  Um dos principais constituintes da gasolina é o octano ($"C"_8"H"_18$). Por meio da combustão do octano é possível a liberação de energia, permitindo que o carro entre em movimento. A equação que representa a reação química desse processo demonstra que

  #alternativas(
    [no processo há liberação de oxigênio, sob a forma de $"O"_2$.],
    [o coeficiente estequiométrico para a água é de 8 para 1 do octano.],
    [no processo há consumo de água, para que haja liberação de energia.],
    [o coeficiente estequiométrico para o oxigênio é de 12,5 para 1 do octano.],
    [o coeficiente estequiométrico para o gás carbônico é de 9 para 1 do octano],
  )
]

#pagebreak()

// Questao 80

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Difícil",
  numero: 80,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Química Orgânica: Funções Orgânicas",
  nova-pagina: false,
)[
  Os pesticidas modernos são divididos em várias classes, entre as quais se destacam os organofosforados, materiais que apresentam efeito tóxico agudo para os seres humanos. Esses pesticidas contêm um átomo central de fósforo ao qual estão ligados outros átomos ou grupo de átomos como oxigênio, enxofre, grupos metoxi ou etoxi, ou um radical orgânico de cadeia longa. Os organofosforados são divididos em três subclasses: *Tipo A*, na qual o enxofre não se incorpora na molécula; *Tipo B*, na qual o oxigênio, que faz dupla ligação com fósforo, é substituído pelo enxofre; e *Tipo C*, no qual dois oxigênios são substituídos por enxofre.

  #align(right)[
    #text(size: 8pt)[
      BAIRD, C. *Química Ambiental*. Bookmam, 2005.
    ]
  ]

  Um exemplo de pesticida organofosforado *Tipo B*, que apresenta grupo etoxi em sua fórmula estrutural, está representado em:

  #alternativas(
    [
      #image(
        "imagens/2010/q80_2010_a.png",
        width: 30%
      )
    ],
    [
      #image(
        "imagens/2010/q80_2010_b.png",
        width: 30%
      )
    ],
    [
      #image(
        "imagens/2010/q80_2010_c.png",
        width: 30%
      )
    ],
    [
      #image(
        "imagens/2010/q80_2010_d.png",
        width: 50%
      )
    ],
    [
      #image(
        "imagens/2010/q80_2010_e.png",
        width: 50%
      )
    ],
  )
]

#pagebreak()

// Questao 82

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Difícil",
  numero: 82,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Eletroquímica",
  nova-pagina: false,
)[
  As baterias de Ni-Cd muito utilizadas no nosso cotidiano não devem ser descartadas em lixos comuns uma vez que uma considerável quantidade de cádmio é volatilizada e emitida para o meio ambiente quando as baterias gastas são incineradas como componente do lixo. Com o objetivo de evitar a emissão de cádmio para a atmosfera durante a combustão é indicado que seja feita a reciclagem dos materiais dessas baterias. 
  
  Uma maneira de separar o cádmio dos demais compostos presentes na bateria é realizar o processo de lixiviação ácida. Nela, tanto os metais (Cd, Ni e eventualmente Co) como os hidróxidos de íons metálicos $"Cd(OH)"_2$(s), $"Ni(OH)"_2$(s), $"Co(OH)"_2$(s) presentes na bateria, reagem com uma mistura ácida e são solubilizados. Em função da baixa seletividade (todos os íons metálicos são solubilizados), após a digestão ácida, é realizada uma etapa de extração dos metais com solventes orgânicos de acordo com a reação:

  #v(1em)

  #align(center)[
    $"M"^"2+" ""_"(aq)" 
    + 2 "HR" ""_"(org)" 
    harpoons.rtlb 
    "MR"_"2" ""_"(org)" 
    + 2 "H"^"+" ""_"(aq)"$
  ]

  #v(1em)

  Onde :
  $"M"^"2+" = "Cd"^"2+" , "Ni"^"2+" "ou" "Co"^"2+"$

  HR = $"C"_16"H"_34–"PO"_2"H"$ : identificado no gráfico por *X*

  HR = $"C"_12"H"_12–"PO"_2"H"$ : identificado no gráfico por *Y*
  
  O gráfico mostra resultado da extração utilizando os solventes orgânicos *X* e *Y* em diferentes pH.

  #align(center)[
    #image(
      "imagens/2010/q82_2010.png",
      width: 60%
    )
  ]

  #align(right)[
    #text(size: 8pt)[
      Disponível em: http://www.scielo.br. Acesso em 28 abr. 2010.
    ]
  ]

  A reação descrita no texto mostra o processo de extração dos metais por meio da reação com moléculas orgânicas, *X* e *Y*. Considerando-se as estruturas de *X* e *Y* e o processo de separação descrito, pode-se  firmar que

  #alternativas(
    [as moléculas *X* e *Y* atuam como extratores catiônicos uma vez que a parte polar da molécula troca o íon $"H"^+$ pelo cátion do metal.],
    [as moléculas *X* e *Y* atuam como extratores aniônicos uma vez que a parte polar da molécula troca o íon $"H"^+$ pelo cátion do metal.],
    [as moléculas *X* e *Y* atuam como extratores  catiônicos uma vez que a parte apolar da molécula troca o íon $"PO"_2^"2-"$ pelo cátion do metal.],
    [as moléculas *X* e *Y* atuam como extratores aniônicos uma vez que a parte polar da molécula troca o íon $"PO"_2^"2-"$ pelo cátion do metal.],
    [as moléculas *X* e *Y* fazem ligações com os íons metálicos resultando em compostos com caráter apolar o que justifica a eficácia da extração.],
  )
]

#pagebreak()

// Questao 83

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 83,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Soluções: Concentração Molar",
  nova-pagina: false,
)[
  Ao colocar um pouco de açúcar na água e mexer até a obtenção de uma só fase, prepara-se uma solução. O mesmo acontece ao se adicionar um pouquinho de sal à água e misturar bem. Uma substância capaz de dissolver o soluto é denominada solvente; por exemplo, a água é um solvente para o açúcar, para o sal e para várias outras substâncias. A figura a seguir ilustra essa citação.

  #align(center)[
    #image(
      "imagens/2010/q83_2010.png",
      width: 60%
    )
  ]

  #align(right)[
    #text(size: 8pt)[
      Disponível em: www.sobiologia.com.br. Acesso em: 27 abr. 2010.
    ]
  ]

  Suponha que uma pessoa, para adoçar seu cafezinho, tenha utilizado 3,42 g de sacarose (massa molar igual a 342 g / mol ) para uma xícara de 50 mL do líquido. Qual é a concentração final, em mol/L, de sacarose nesse cafezinho?

  #alternativas(
    [0,02],
    [0,2],
    [2],
    [200],
    [2000],
  )
]

#pagebreak()

// Questao 89

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito Fácil",
  numero: 89,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Química Ambiental",
  nova-pagina: false,
)[
  Deseja-se instalar uma estação de geração de energia elétrica em um município localizado no interior de um pequeno vale cercado de altas montanhas de difícil acesso. A cidade é cruzada por um rio, que é fonte de água para consumo, irrigação das lavouras de subsistência e pesca. Na região, que possui pequena extensão territorial, a incidência solar é alta o ano todo. A estação em questão irá abastecer apenas o município apresentado.

  Qual forma de obtenção de energia, entre as apresentadas, é a mais indicada para ser implantada nesse município de modo a causar o menor impacto ambiental?

  #alternativas(
    [Termelétrica, pois é possível utilizar a água do rio no sistema de refrigeração.],
    [Eólica, pois a geografia do local é própria para a captação desse tipo de energia.],
    [Nuclear, pois o modo de resfriamento de seus sistemas não afetaria a população.],
    [Fotovoltaica, pois é possível aproveitar a energia solar que chega à superfície do local.],
    [Hidrelétrica, pois o rio que corta o município é suficiente para abastecer a usina construída.],
  )
]

#pagebreak()

// Questao 90

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Fácil",
  numero: 90,
  prova: "ENEM",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Separação de Misturas",
  nova-pagina: false,
)[
  O lixão que recebia 130 toneladas de lixo e contaminava a região com o seu chorume (líquido derivado da decomposição de compostos orgânicos) foi recuperado, transformando-se em um aterro sanitário controlado, mudando a qualidade de vida e a paisagem e proporcionando condições dignas de trabalho para os que dele subsistiam.

  #align(right)[
    #text(size: 8pt)[
      *Revista Promoção da Saúde da Secretaria de Políticas de Saúde.* Ano 1, n° 4, dez. 2000 (adaptado).
    ]
  ]

  Quais procedimentos técnicos tornam o aterro sanitário mais vantajoso que o lixão, em relação às problemáticas abordadas no texto?

  #alternativas(
    [O lixo é recolhido e incinerado pela combustão a altas temperaturas.],
    [O lixo hospitalar é separado para ser enterrado e sobre ele, colocada cal virgem],
    [O lixo orgânico e inorgânico é encoberto, e o chorume canalizado para ser tratado e neutralizado.],
    [O lixo orgânico é completamente separado do lixo inorgânico, evitando a formação de chorume.],
    [O lixo industrial é separado e acondicionado de forma adequada, formando uma bolsa de resíduos],
  )
]

#pagebreak()

///////////////////////
// Seção de Gabarito //
///////////////////////

#align(center)[
  #text(size: 1.5em)[
    == Gabarito 2010
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
    [55], [C], [Separação de misturas], [Difícil],
    [59], [D], [Química Ambiental], [Muito Fácil],
    [60], [A], [Soluções], [Fácil],
    [63], [A], [Eletroquímica], [Fácil],
    [65], [E], [Equilíbrio Químico], [Médio],
    [67], [D], [Termoquímica], [Difícil],
    [69], [D], [Termoquímica], [Difícil],
    [73], [C], [Estequiometria], [Muito Difícil],
    [74], [D], [Eletroquímica], [Muito Difícil],
    [77], [D], [Química Orgânica: Reações Orgânicas], [Médio],
    [79], [D], [Estequiometria], [Médio],
    [80], [E], [Química Orgânica: Funções Orgânicas], [Difícil],
    [82], [A], [Eletroquímica], [Difícil],
    [83], [B], [Soluções: Concentração Molar], [Médio],
    [89], [D], [Química Ambiental], [Muito Fácil],
    [90], [C], [Química Ambiental], [Fácil]
  )
]