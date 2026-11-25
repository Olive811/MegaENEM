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

#secao-ano("ENEM PPL 2010")

// Questao 56

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito Fácil",
  numero: 56,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Cinética Química",
  nova-pagina: false,
)[
  Alguns fatores podem alterar a rapidez das reações químicas. A seguir destacam-se três exemplos no contexto da preparação e da conservação de alimentos:

  1. A maioria dos produtos alimentícios se conserva por muito mais tempo quando submetidos à refrigeração. Esse procedimento diminui a rapidez das reações que contribuem para a degradação de certos alimentos.

  2. Um procedimento muito comum utilizado em práticas de culinária é o corte dos alimentos para acelerar o seu cozimento, caso não se tenha uma panela de pressão.

  3. Na preparação de iogurtes, adicionam-se ao leite bactérias produtoras de enzimas que aceleram as reações envolvendo açúcares e proteínas lácteas.

  Com base no texto, quais são os fatores que influenciam a rapidez das transformações químicas relacionadas aos exemplos 1, 2 e 3, respectivamente?

  #alternativas(
    [Temperatura, superfície de contato e concentração.],
    [Concentração, superfície de contato e catalisadores.],
    [Temperatura, superfície de contato e catalisadores.],
    [Superfície de contato, temperatura e concentração.],
    [Temperatura, concentração e catalisadores.],
  )
]

#pagebreak()

// Questão 60

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito Fácil",
  numero: 60,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Matéria e suas transformações",
  nova-pagina: false,
)[
  O Brasil é um dos países que obtêm melhores resultados na reciclagem de latinhas de alumínio. O esquema a seguir representa as várias etapas desse processo:

  #v(1em)

  #align(center)[
    #image(
      "imagens/2010_PPL/q60_2010_ppl.png",
      width: 80%
    )
  ]

  #align(right)[
    #text(size: 8pt)[
      Disponível em: http://ambiente.hsw.uol.com.br. Acesso em: 27 abr. 2010 (adaptado).
    ]
  ]

  #v(1em)

  A temperatura do forno em que o alumínio é fundido é útil também porque

  #alternativas(
    [sublima outros metais presentes na lata],
    [evapora substâncias radioativas remanescentes.],
    [impede que o alumínio seja eliminado em altas temperaturas.],
    [desmagnetiza as latas que passaram pelo processo de triagem.],
    [queima os resíduos de tinta e outras substâncias presentes na lata.],
  )
]

#pagebreak()

// Questão 62

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 62,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Equilíbrio Químico",
  nova-pagina: false,
)[
  Às vezes, ao abrir um refrigerante, percebe-se que uma parte do produto vaza rapidamente pela extremidade do recipiente. A explicação para esse fato está relacionada à perturbação do equilíbrio químico existente entre alguns dos ingredientes do produto, de acordo com a equação:

  #v(1em)

  #align(center)[
    #text(size: 16pt)[
      $"CO"_2(g) + "H"_2"O""(l)" harpoons.rtlb "H"_2"CO"_3"(aq)"$
    ]
  ]

  #v(1em)

  A alteração do equilíbrio anterior, relacionada ao vazamento do refrigerante nas condições descritas, tem como consequência a

  #alternativas(
    [liberação de CO2 para o ambiente.],
    [elevação da temperatura do recipiente.],
    [elevação da pressão interna no recipiente.],
    [elevação da concentração de CO2 no líquido.],
    [formação de uma quantidade significativa de H2O.],
  )
]

// #pagebreak()

// Questão 73

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Difícil",
  numero: 73,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Estequiometria",
  nova-pagina: true,
)[
  Fator de emissão (carbon footprint) é um termo utilizado para expressar a quantidade de gases que contribuem para o aquecimento global, emitidos por uma fonte ou processo industrial específico. Pode-se pensar na quantidade de gases emitidos por uma indústria, uma cidade ou mesmo por uma pessoa. Para o gás $"CO"_2$, a relação pode ser escrita:

  #v(1em)

  #let fatorDeEmissao = $"Fator de emissão de" "CO"_2$
  #let numerador = $"Fator de emissão de"$
  #let co2 = $"CO"_2$
  #let denominador = $"Quantidade de material"$

  #align(center)[
    #text(size: 15pt)[
      $fatorDeEmissao$ = 
    ]
    #text(size: 22pt)[
      $frac(
        numerador co2,
        denominador
      )$
    ]
  ]

  #v(1em)

  O termo "quantidade de material" pode ser, por exemplo, a massa de material produzido em uma indústria ou a quantidade de gasolina consumida por um carro em um determinado período.

  No caso da produção do cimento, o primeiro passo é a obtenção do óxido de cálcio, a partir do aquecimento do calcário a altas temperaturas, de acordo com a reação:

  #align(center)[
    #text(size: 14pt)[
      $"CaCO"_3(s) → "CaO"(s)+ "CO"_2(g)$
    ]
  ]

  Uma vez processada essa reação, outros compostos inorgânicos são adicionados ao óxido de cálcio, tendo o cimento formado 62% de CaO em sua composição.

  *Dados*: Massas molares em g/mol - $"CO"_2$ = 44; $"CaCO"_3$ = 100 ; $"CaO"$ = 56.

  #align(right)[
    #text(size: 8pt)[
      TREPTOW, R. S. *Journal of Chemical Education*. v. 87 n° 2, fev. 2010 (adaptado).
    ]
  ]

  Considerando as informações apresentadas no texto, qual é, aproximadamente, o fator de emissão de $"CO"_2$ quando 1 tonelada de cimento for produzida, levando-se em consideração apenas a etapa de obtenção do óxido de cálcio?

  #alternativas(
    [$"4,9" times 10^"-4"$],
    [$"7,9" times 10^"-4"$],
    [$"3,8" times 10^"-1"$],
    [$"4,9" times 10^"-1"$],
    [$"7,9" times 10^"-1"$],
  )
]

// Questão 74

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 74,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Química Ambiental",
  nova-pagina: true,
)[
  Os oceanos absorvem aproximadamente um terço das emissões de $"CO"_2$ procedentes de atividades humanas, como a queima de combustíveis fósseis e as queimadas. O $"CO"_2$ combina-se com as águas dos oceanos, provocando uma alteração importante em suas propriedades. Pesquisas com vários organismos marinhos revelam que essa alteração nos oceanos afeta uma série de processos biológicos necessários para o desenvolvimento e a sobrevivência de várias espécies da vida marinha.

  A alteração a que se refere o texto diz respeito ao aumento



  #alternativas(
    [da acidez das águas dos oceanos.],
    [do estoque de pescado nos oceanos.],
    [da temperatura média dos oceanos.],
    [do nível das águas dos oceanos.],
    [da salinização das águas dos oceanos.],
  )
]

// Questão 75

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 75,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Equilíbrio Químico",
  nova-pagina: true,
)[
  O pH do solo pode variar em uma faixa significativa devido a várias causas. Por exemplo, o solo de áreas com chuvas escassas, mas com concentrações elevadas do sal solúvel carbonato de sódio ($"Na"_2"CO"_3$), torna-se básico devido à reação de hidrólise do íon carbonato, segundo o equilíbrio:

  #align(center)[
    #text(size: 16pt)[
      $"CO"_3^"2–""(aq)" + "H"_2"O""(l)" harpoons.rtlb "HCO"_3^-"(aq)" + "OH"^-"(aq)"$
    ]
  ]

  Esses tipos de solos são alcalinos demais para fins agrícolas e devem ser remediados pela utilização de aditivos químicos.

  #align(right)[
    #text(size: 8pt)[
      BAIRD, C. *Química ambiental*. São Paulo: Artmed, 1995 (adaptado).
    ]
  ]

  Suponha que, para remediar uma amostra desse tipo de solo, um técnico tenha utilizado como aditivo a cal virgem ($"CaO"$). Nesse caso, a remediação

  #alternativas(
    [foi realizada, pois o caráter básico da cal virgem promove o deslocamento do equilíbrio descrito para a direita, em decorrência da elevação de pH do meio.],
    [foi realizada, pois o caráter ácido da cal virgem promove o deslocamento do equilíbrio descrito para a esquerda, em decorrência da redução de pH do meio.],
    [não foi realizada, pois o caráter ácido da cal virgem promove o deslocamento do equilíbrio descrito para a direita, em decorrência da redução de pH do meio.],
    [não foi realizada, pois o caráter básico da cal virgem promove o deslocamento do equilíbrio descrito para a esquerda, em decorrência da elevação de pH do meio.],
    [não foi realizada, pois o caráter neutro da cal virgem promove o deslocamento do equilíbrio descrito para a esquerda, em decorrência da manutenção de pH do meio.],
  )
]

// Questão 76

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 76,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Equilíbrio Químico",
  nova-pagina: true,
)[
  O rótulo de uma garrafa de água mineral natural contém as seguintes informações:

  #v(1em)

  #align(center)[
    #image(
      "imagens/2010_PPL/q76_2010_ppl.png",
      width: 80%
    )
  ]

  #v(1em)

  As informações químicas presentes no rótulo de vários produtos permitem classificar o produto de várias formas, de acordo com seu gosto, seu cheiro, sua aparência, sua função, entre outras. As informações da tabela permitem concluir que essa água é

  #alternativas(
    [gasosa.],
    [insípida.],
    [levemente azeda.],
    [um pouco alcalina.],
    [radioativa na fonte.],
  )
]

// Questões 77

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 77,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Tabela Periódica",
  nova-pagina: true,
)[
  O cádmio, presente nas baterias, pode chegar ao solo quando esses materiais são descartados de maneira irregular no meio ambiente ou quando são incinerados. Diferentemente da forma metálica, os íons $"Cd"^"2+"$ são extremamente perigosos para o organismo, pois eles podem substituir íons $"Ca"^"2+"$, ocasionando uma doença degenerativa nos ossos, tornando-os muito porosos e causando dores intensas nas articulações. Podem ainda inibir enzimas ativadas pelo cátion $"Zn"^"2+"$, que são extremamente importantes para o funcionamento dos rins. A figura mostra a variação do raio de alguns metais e seus respectivos cátions.

  #align(center)[
    #image(
      "imagens/2010_PPL/q77_2010_ppl.png",
      width: 55%
    )
      
      *FIGURA 1:* Raios atômicos e iônicos de alguns metais.
  ]

  #align(right)[
    #text(size: 8pt)[
      #h(20em) ATKINS, P; JONES, L. *Princípios de química:* Questionando a vida moderna e o meio ambiente. Porto Alegre: Bookman, 2001 (adaptado).
    ]
  ]

  Com base no texto, a toxicidade do cádmio em sua forma iônica é consequência de esse elemento

  #alternativas(
    [apresentar baixa energia de ionização, o que favorece a formação do íon e facilita sua ligação a outros compostos.],
    [possuir tendência de atuar em processos biológicos mediados por cátions metálicos com cargas que variam de +1 a +3.],
    [possuir raio e carga relativamente próximos aos de íons metálicos que atuam nos processos biológicos, causando interferência nesses processos.],
    [apresentar raio iônico grande, permitindo que ele cause interferência nos processos biológicos em que, normalmente, íons menores participam.],
    [apresentar carga +2, o que permite que ele cause interferência nos processos biológicos em que, normalmente, íons com cargas menores participam.],
  )
]

// Questão 79

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 79,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Forças Intermoleculares",
  nova-pagina: true,
)[
  Vários materiais, quando queimados, podem levar à formação de dioxinas, um composto do grupo dos organoclorados. Mesmo quando a queima ocorre em incineradores, há liberação de substâncias derivadas da dioxina no meio ambiente. Tais compostos são produzidos em baixas concentrações, como resíduos da queima de matéria orgânica em presença de produtos que contenham cloro. Como consequência de seu amplo espalhamento no meio ambiente, bem como de suas propriedades estruturais, as dioxinas sofrem magnificação trófica na cadeia alimentar. Mais de 90% da exposição humana às dioxinas é atribuída aos alimentos contaminados ingeridos. A estrutura típica de uma dioxina está apresentada a seguir:

  #align(center)[
    #image(
      "imagens/2010_PPL/q79_2010.svg",
      width: 40%
    )
  ]

  A molécula do 2,3,7,8 - TCDD é popularmente conhecida pelo nome 'dioxina', sendo a mais tóxica dos 75 isômeros de compostos clorados de dibenzo-p-dioxina existentes.

  #align(right)[
    #text(size: 8pt)[
      #h(20em) FADINI, P. S; FADINI, A. A. B. Lixo: desafios e compromissos. *Cadernos Temáticos de Química Nova na Escola*, São Paulo, n. 1, maio 2001 (adaptado).
    ]
  ]

  Com base no texto e na estrutura apresentada, as propriedades químicas das dioxinas que permitem sua bioacumulação nos organismos estão relacionadas ao seu caráter

  #alternativas(
    [básico, pois a eliminação de materiais alcalinos é mais lenta do que a dos ácidos.],
    [ácido, pois a eliminação de materiais ácidos é mais lenta do que a dos alcalinos.],
    [redutor, pois a eliminação de materiais redutores é mais lenta do que a dos oxidantes.],
    [lipofílico, pois a eliminação de materiais lipossolúveis é mais lenta do que a dos hidrossolúveis.],
    [hidrofílico, pois a eliminação de materiais hidrossolúveis é mais lenta do que a dos lipossolúveis.],
  )
]

// Questão 80

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 80,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Funções Orgânicas",
  nova-pagina: true,
)[
  A curcumina, substância encontrada no pó amareloalaranjado extraído da raiz da curcuma ou açafrão-daíndia (Curcuma longa), aparentemente, pode ajudar a combater vários tipos de câncer, o mal de Parkinson e o de Alzheimer e até mesmo retardar o envelhecimento. Usada há quatro milênios por algumas culturas orientais, apenas nos últimos anos passou a ser investigada pela ciência ocidental.

  #align(center)[
    #image(
      "imagens/2010_PPL/q80_2010_ppl.webp",
      width: 100%
    )
  ]

  #align(right)[
    #text(size: 8pt)[
      #h(5em) ANTUNES, M. G. L. Neurotoxicidade induzida pelo quimioterápico cisplatina: possíveis efeitos citoprotetores dos antioxidantes da dieta curcumina e coenzima Q10. *Pesquisa FAPESP*. São Paulo, n. 168, fev. 2010 (adaptado).
    ]
  ]

  Na estrutura da curcumina, identificam-se grupos característicos das funções

  #alternativas(
    [éter e álcool.],
    [éter e fenol.],
    [éster e fenol.],
    [aldeído e enol.],
    [aldeído e éster.],
  )
]

// Questão 82

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 82,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Química Ambiental",
  nova-pagina: true,
)[
  Os corais que formam o banco dos Abrolhos, na Bahia, podem estar extintos até 2050 devido a uma epidemia. Por exemplo, os corais-cérebro já tiveram cerca de 10% de sua população afetada pela praga-branca, a mais prevalente das seis doenças identificadas em Abrolhos, causada provavelmente por uma bactéria. Os cientistas atribuem a proliferação das patologias ao aquecimento global e à poluição marinha. O aquecimento global reduziria a imunidade dos corais ou estimularia os patógenos causadores desses males, trazendo novos agentes infecciosos.

  #align(right)[
    #text(size: 8pt)[
      #h(5em) FURTADO, F. Peste branca no mar. *Ciência hoje.* Rio de Janeiro, v. 42, n. 251, ago. 2008 (adaptado).
    ]
  ]  

  A fim de combater a praga-branca, a medida mais apropriada, segura e de efeitos mais duradouros seria

  #alternativas(
    [aplicar antibióticos nas águas litorâneas de Abrolhos.],
    [substituir os aterros sanitários por centros de reciclagem de lixo.],
    [introduzir nas águas de Abrolhos espécies que se alimentem da bactéria causadora da doença.],
    [aumentar, mundialmente, o uso de transportes coletivos e diminuir a queima de derivados de petróleo.],
    [criar uma lei que proteja os corais, impedindo que mergulhadores e turistas se aproximem deles e os contaminem.],
  )
]

// Questão 83

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 83,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Estequiometria",
  nova-pagina: true,
)[
  O flúor é usado de forma ampla na prevenção de cáries. Por reagir com a hidroxiapatita $["Ca"_10("PO"_4)_6"(OH)"_2]$ presente nos esmaltes dos dentes, o flúor forma a fluorapatita $["Ca"_10("PO"_4)_6"F"_2]$, um mineral mais resistente ao ataque ácido decorrente da ação de bactérias específicas presentes nos açúcares das placas que aderem aos dentes.

  #align(right)[
    #text(size: 8pt)[
      #h(5em) Disponível em: http://www.odontologia.com.br. Acesso em: 27 jul. 2010 (adaptado).
    ]
  ] 

  A reação de dissolução da hidroxiapatita é:

  $
    ["Ca"_10("PO"_4)_6("OH")_2]"(s) "
    + 8 "H"^+"(aq)" 
    #sym.arrow.r
    10 "Ca"^"2+""(aq)"
    + 6 "HPO"_4^"2–""(aq)"
    + 2 "H"_2"O""(l)"
  $

  *Dados:* Massas molares em g/mol — $["Ca"_10("PO"_4)_6"(OH)"_2]$ = 1004; $"HPO"_4^"2–"$ = 96 ; Ca = 40.

  Supondo-se que o esmalte dentário seja constituído exclusivamente por hidroxiapatita, o ataque ácido que dissolve completamente 1 mg desse material ocasiona a formação de, aproximadamente,

  #alternativas(
    [0,14 mg de íons totais.], // a
    [0,40 mg de íons totais.], // b
    [0,58 mg de íons totais.], // c
    [0,97 mg de íons totais.], // d
    [1,01 mg de íons totais.], // e
  )
]

// Questão 87

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 87,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Soluções",
  nova-pagina: true,
)[
  Devido ao seu alto teor de sais, a água do mar é imprópria para o consumo humano e para a maioria dos usos da água doce. No entanto, para a indústria, a água do mar é de grande interesse, uma vez que os sais presentes podem servir de matérias-primas importantes para diversos processos. Nesse contexto, devido a sua simplicidade e ao seu baixo potencial de impacto ambiental, o método da precipitação fracionada tem sido utilizado para a obtenção dos sais presentes na água do mar.

  *Tabela 1:* Solubilidade em água de alguns compostos presentes na água do mar a 25ºC

  #align(center)[
    #image(
      "imagens/2010_PPL/q87_2010_ppl.png",
      width: 80%
    )
  ]

  #align(right)[
    #text(size: 8pt)[
      #h(12em) Pitombo, L.R.M.; Marcondes, M.E.R.; GEPEC. Grupo de pesquisa em Educação em Química. *Química e Sobrevivência*: Hidrosfera Fonte de Materiais. São Paulo: EDUSP, 2005 (adaptado).
    ]
  ]  

  Suponha que uma indústria objetiva separar determinados sais de uma amostra de água do mar a 25°C, por meio da precipitação fracionada. Se essa amostra contiver somente os sais destacados na tabela, a seguinte ordem de precipitação será verificada:

  #alternativas(
    [Carbonato de cálcio, sulfato de cálcio, cloreto de sódio e sulfato de magnésio, cloreto de magnésio e, por último, brometo de sódio.], // a
    [Brometo de sódio, cloreto de magnésio, cloreto de sódio e sulfato de magnésio, sulfato de cálcio e, por último, carbonato de cálcio.], // b
    [Cloreto de magnésio, sulfato de magnésio e cloreto de sódio, sulfato de cálcio, carbonato de cálcio e, por último, brometo de sódio.], // c
    [Brometo de sódio, carbonato de cálcio, sulfato de cálcio, cloreto de sódio e sulfato de magnésio e, por último, cloreto de magnésio.], // d
    [Cloreto de sódio, sulfato de magnésio, carbonato de cálcio, sulfato de cálcio, cloreto de magnésio e, por último, brometo de sódio.], // e
  )
]

// Questão 89

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Médio",
  numero: 89,
  prova: "ENEM PPL",
  ano: 2010,
  caderno: "Azul",
  dia: 1,
  conteudo: "Atomística",
  nova-pagina: true,
)[
  Cientistas da Austrália descobriram um meio de produzir roupas que se limpam sozinhas. A equipe de pesquisadores usou nanocristais de dióxido de titânio ($"TiO"_2$) que, sob ação da luz solar, são capazes de decompor as partículas de sujeira na superfície de um tecido. O estudo apresentou bons resultados com fibras de algodão e seda. Nesses casos, foram removidas manchas de vinho, bastante resistentes. A nanocamada protetora poderá ser útil na prevenção de infecções em hospitais, uma vez que o dióxido de titânio também mostrou ser eficaz na destruição das paredes celulares de microrganismos que provocam infecções. O termo nano vem da unidade de medida nanômetro, que é a bilionésima parte de 1 metro.

  #align(right)[
    #text(size: 8pt)[
      #h(5em) *Veja.* Especial Tecnologia. São Paulo: Abril, set. 2008 (adaptado).
    ]
  ]  

  A partir dos resultados obtidos pelos pesquisadores em relação ao uso de nanocristais de dióxido de titânio na produção de tecidos e considerando uma possível utilização dessa substância no combate às infecções hospitalares, pode-se associar que os nanocristais de dióxido de titânio

  #alternativas(
    [são pouco eficientes em ambientes fechados e escuros.], // a
    [possuem dimensões menores que as de seus átomos formadores.], // b
    [são pouco eficientes na remoção de partículas de sujeira de natureza orgânica.], // c
    [destroem microrganismos causadores de infecções, por meio de osmose celular.], // d
    [interagem fortemente com material orgânico devido à sua natureza apolar.], // e
  )
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
    [56], [C], [Cinética Química], [Muito Fácil],
    [60], [E], [Matéria e suas transformações], [Muito Fácil],
    [62], [A], [Equilíbrio Químico], [Médio],
    [73], [D], [Estequiometria], [Difícil],
    [74], [A] ,[Química Ambiental], [Médio],
    [75], [D], [Equilíbrio Químico], [Médio],
    [76], [D], [Equilíbrio Químico], [Médio],
    [77], [C], [Tabela Periódica], [Médio],
    [79], [D], [Forças Intermoleculares], [Médio],
    [80], [B], [Funções Orgânicas], [Médio],
    [82], [D], [Química Ambiental], [Médio],
    [83], [D], [Estequiometria], [Médio],
    [87], [A], [Soluções], [Médio],
    [89], [A], [Atomística], [Médio],
  )
]
