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

#outline(title: [Sumário], depth: 2)

#secao-ano("ENEM 2009")

// Questao 1

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Fácil",
  numero: 1,
  prova: "ENEM",
  ano: 2009,
  caderno: "Azul",
  dia: 1,
  conteudo: "Química Ambiental",
  nova-pagina: false,
)[
  A atmosfera terrestre é composta pelos gases nitrogênio ($N_2$) e oxigênio ($O_2$), que somam cerca de 99%, e por gases traços, entre eles o gás carbônico ($C O_2$), vapor de água ($H_2 O$), metano ($C H_4$), ozônio ($O_3$) e o óxido nitroso ($N_2 O$), que compõem o restante 1% do ar que respiramos. Os gases traços, por serem constituídos por pelo menos três átomos, conseguem absorver o calor irradiado pela Terra, aquecendo o planeta. Esse fenômeno, que acontece há bilhões de anos, é chamado de efeito estufa. A partir da Revolução Industrial (século XIX), a concentração de gases traços na atmosfera, em particular o $C O_2$, tem aumentado significativamente, o que resultou no aumento da temperatura em escala global. Mais recentemente, outro fator tornou-se diretamente envolvido no aumento da concentração de $C O_2$ na atmosfera: o desmatamento.

  #align(right)[
    #text(size: 8pt)[
      BROWN, I. F.; ALECHANDRE, A. S. Conceitos básicos sobre clima, carbono, florestas e comunidades. A.G. Moreira & S.  Schwartzman. As mudanças climáticas globais e os ecossistemas brasileiros. Brasília: Instituto de Pesquisa Ambiental da Amazônia, 2000 (adaptado).
    ]
  ]

  #alternativas(
    [reduzir o calor irradiado pela Terra mediante a substituição da produção primária pela industrialização refrigerada.],
    [promover a queima da biomassa vegetal, responsável pelo aumento do efeito estufa devido à produção de CH4.],
    [reduzir o desmatamento, mantendo-se, assim, o potencial da vegetação em absorver o $C O_2$ da atmosfera.],
    [aumentar a concentração atmosférica de $H_2 O$, molécula capaz de absorver grande quantidade de calor.],
    [remover moléculas orgânicas polares da atmosfera, diminuindo a capacidade delas de reter calor.],
  )
]

#pagebreak()

// Questao 12

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito difícil",
  numero: 12,
  prova: "ENEM",
  ano: 2009,
  caderno: "Azul",
  dia: 1,
  conteudo: "Equilíbrio químico",
  nova-pagina: false,
)[
  Sabões são sais de ácidos carboxílicos de cadeia longa utilizados com a finalidade de facilitar, durante processos de lavagem, a remoção de substâncias de baixa solubilidade em água, por exemplo, óleos e gorduras.

  #image("imagens/2009/q12_2009.png")

  Em solução, os ânions do sabão podem hidrolisar a água e, desse modo, formar o ácido carboxílico correspondente. Uma vez que o ácido carboxílico formado é pouco solúvel em água e menos eficiente na remoção de gorduras, o pH do meio deve ser controlado de maneira a evitar que o equilíbrio seja deslocado para a direita.

  $ C H_3 (C H_2)_16 C O O^- + H_2 O ⇌ C H_3 (C H_2)_16 C O O H + O H^- $

  Com base nas informações do texto, é correto concluir que os sabões atuam de maneira

  #alternativas(
    [mais eficiente em pH básico.],
    [mais eficiente em pH ácido.],
    [mais eficiente em pH neutro.],
    [eficiente em qualquer faixa de pH.],
    [mais eficiente em pH ácido ou neutro.],
  )
]

#pagebreak()

// Questão 15

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito difícil",
  numero: 15,
  prova: "ENEM",
  ano: 2009,
  caderno: "Azul",
  dia: 1,
  conteudo: "Eletroquímica",
  nova-pagina: false,
)[
  Para que apresente condutividade elétrica adequada a muitas aplicações, o cobre bruto obtido por métodos térmicos é purificado eletroliticamente. Nesse processo, o cobre bruto impuro constitui o ânodo da célula, que está imerso em uma solução de $"CuSO"_4$. À medida que o cobre impuro é oxidado no ânodo, íons $"Cu"^"2+"$ da solução são depositados na forma pura no cátodo. Quanto às impurezas metálicas, algumas são oxidadas, passando à solução, enquanto outras simplesmente se desprendem do ânodo e se sedimentam abaixo dele. As impurezas sedimentadas são posteriormente processadas, e sua comercialização gera receita que ajuda a cobrir os custos do processo. A série eletroquímica a seguir lista o cobre e alguns metais presentes como impurezas no cobre bruto de acordo com suas forças redutoras relativas.

  #align(center)[
    #image(
      "imagens/2009/Q15_2009.png",
      width: 35%
    )
  ]

  Entre as impurezas metálicas que constam na série apresentada, as que se sedimentam abaixo do ânodo de cobre são

  #alternativas(
    [Au, Pt, Ag, Zn, Ni e Pb.],
    [Au, Pt e Ag.],
    [Zn, Ni e Pb.],
    [Au e Zn.],
    [Ag e Pb.],
  )
]

#pagebreak()

// Questão 26

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "difícil",
  numero: 26,
  prova: "ENEM",
  ano: 2009,
  caderno: "Azul",
  dia: 1,
  conteudo: "Equilíbrio químico",
  nova-pagina: false,
)[
  O processo de industrialização tem gerado sérios problemas de ordem ambiental, econômica e social, entre os quais se pode citar a chuva ácida. Os ácidos usualmente presentes em maiores proporções na água da chuva são o $H_2 C O_3$, formado pela reação do CO2 atmosférico com a água, o $H N O_3$, o $H N O_2$, o $H_2 S O_4$ e o $H_2 S O_3$. Esses quatro últimos são formados principalmente a partir da reação da água com os óxidos de nitrogênio e de enxofre gerados pela queima de combustíveis fósseis.

  A formação de chuva mais ou menos ácida depende não só da concentração do ácido formado, como também do tipo de ácido. Essa pode ser uma informação útil na elaboração de estratégias para minimizar esse problema ambiental. Se consideradas concentrações idênticas, quais dos ácidos citados no texto conferem maior acidez às águas das chuvas?

  #alternativas(
    [$H N O_3$ e $H N O_2$.],
    [$H_2 S O_4$ e $H_2 S O_3$.],
    [$H_2 S O_3$ e $H N O_2$.],
    [$H_2 S O_4$ e $H N O_3$.],
    [$H_2 C O_3$ e $H_2 S O_3$.],
  )
]

#pagebreak()

// Questão 29

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Difícil",
  numero: 29,
  prova: "ENEM",
  ano: 2009,
  caderno: "Azul",
  dia: 1,
  conteudo: "Equilíbrio químico (hidrólise e efeito do pH)",
  nova-pagina: false,
)[
  Os núcleos dos átomos são constituídos de prótons e nêutrons, sendo ambos os principais responsáveis pela sua massa. Nota-se que, na maioria dos núcleos, essas partículas não estão presentes na mesma proporção. O gráfico mostra a quantidade de nêutrons ( N ) em função da quantidade de prótons ( Z ) para os núcleos estáveis conhecidos.

  #align(center)[
    #image(
      "imagens/2009/q29_2009.png",
      width: 70%
    )
  ]

  #align(right)[
    #text(size: 8pt)[
      KAPLAN, I. Física Nuclear. Rio de Janeiro: Guanabara Dois, 1978 (adaptado).
    ]
  ]

  O antimônio é um elemento químico que possui 50 prótons e possui vários isótopos ― átomos que só se diferem pelo número de nêutrons. De acordo com o gráfico, os isótopos estáveis do antimônio possuem

  #alternativas(
    [entre 12 e 24 nêutrons a menos que o número de prótons.],
    [exatamente o mesmo número de prótons e nêutrons.],
    [entre 0 e 12 nêutrons a mais que o número de prótons.],
    [entre 12 e 24 nêutrons a mais que o número de prótons.],
    [entre 0 e 12 nêutrons a menos que o número de prótons.],
  )
]

#pagebreak()

// Questao 32

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito difícil",
  numero: 32,
  prova: "ENEM",
  ano: 2009,
  caderno: "Azul",
  dia: 1,
  conteudo: "Atomística",
  nova-pagina: false,
)[
  Considere um equipamento capaz de emitir radiação eletromagnética com comprimento de onda bem menor que a da radiação ultravioleta. Suponha que a radiação emitida por esse equipamento foi apontada para um tipo específico de filme fotográfico e entre o equipamento e o filme foi posicionado o pescoço de um indivíduo. Quanto mais exposto à radiação, mais escuro se torna o filme após a revelação. Após acionar o equipamento e revelar o filme, evidenciou-se a imagem mostrada na figura abaixo. 

  #align(center)[
    #image(
      "imagens/2009/q32_2009.png", 
      width: 55%
    )
  ]

  Dentre os fenômenos decorrentes da interação entre a radiação e os átomos do indivíduo que permitem a obtenção desta imagem inclui-se a

  #alternativas(
    [absorção da radiação eletromagnética e a consequente ionização dos átomos de cálcio, que se transformam em átomos de fósforo],
    [maior absorção da radiação eletromagnética pelos átomos de cálcio que por outros tipos de átomos],
    [maior absorção da radiação letromagnética pelos átomos de carbono que por átomos de cálcio.],
    [maior refração ao atravessar os átomos de carbono que os átomos de cálcio.],
    [maior ionização de moléculas de água que de átomos de carbono.]
  )
]

#pagebreak()

// Questão 36

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito difícil",
  numero: 36,
  prova: "ENEM",
  ano: 2009,
  caderno: "Azul",
  dia: 1,
  conteudo: "Propriedades de compostos orgânicos",
  nova-pagina: false,
)[
  O uso de protetores solares em situações de grande exposição aos raios solares como, por exemplo, nas praias, é de grande importância para a saúde. As moléculas ativas de um protetor apresentam, usualmente, anéis aromáticos conjugados com grupos carbonila, pois esses sistemas são capazes de absorver a radiação ultravioleta mais nociva aos seres humanos. A conjugação é definida como a ocorrência de alternância entre ligações simples e duplas em uma molécula. Outra propriedade das moléculas em questão é apresentar, em uma de suas extremidades, uma parte apolar responsável por reduzir a solubilidade do composto em água, o que impede sua rápida remoção quando do contato com a água.

  De acordo com as considerações do texto, qual das moléculas apresentadas a seguir é a mais adequada para funcionar como molécula ativa de protetores solares?

  #alternativas(
    [
      #image(
        "imagens/2009/q36_2009_a.png",
        width: 40%
      )
    ],
    [
      #image(
        "imagens/2009/q36_2009_b.png",
        width: 40%
      )
    ],
    [
      #image(
        "imagens/2009/q36_2009_c.png",
        width: 40%
      )
    ],
    [
      #image(
        "imagens/2009/q36_2009_d.png",
        width: 40%
      )
    ],
    [
      #image(
        "imagens/2009/q36_2009_e.png",
        width: 40%
      )
    ],
  )
]

#pagebreak()

// Questão 44

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito Difícil",
  numero: 44,
  prova: "ENEM",
  ano: 2009,
  caderno: "Azul",
  dia: 1,
  conteudo: "Separação de Misturas",
  nova-pagina: false,
)[
  O álcool hidratado utilizado como combustível veicular é obtido por meio da destilação fracionada de soluções aquosas geradas a partir da fermentação de biomassa. Durante a destilação, o teor de etanol da mistura é aumentado, até o limite de 96% em massa.

  Considere que, em uma usina de produção de etanol, 800 kg de uma mistura etanol/água com concentração 20% em massa de etanol foram destilados, sendo obtidos 100 kg de álcool hidratado 96% em massa de etanol. A partir desses dados, é correto concluir que a destilação em questão gerou um resíduo com uma concentração de etanol em massa

  #alternativas(
    [de 0%.],
    [de 8,0%.],
    [entre 8,4% e 8,6%.],
    [entre 9,0% e 9,2%.],
    [entre 13% e 14%.],
  )
]

#pagebreak()

#questao(
  macroarea: "Natureza",
  disciplina: "Química",
  nivel: "Muito difícil",
  numero: 43,
  prova: "ENEM",
  ano: 2009,
  caderno: "Azul",
  dia: 1,
  conteudo: "Termoquímica",
  nova-pagina: false,
)[
  Nas últimas décadas, o efeito estufa tem-se intensificado de maneira preocupante, sendo esse efeito muitas vezes atribuído à intensa liberação de $C O_2$ durante a queima de combustíveis fósseis para geração de energia. O quadro traz as entalpias-padrão de combustão a 25°C ($Δ H_"25"^"0"$) do metano, do butano e do octano.

  #align(center)[
    #image(
      "imagens/2009/q43_2009.png",
      width: 80%
    )
  ]

  À medida que aumenta a consciência sobre os impactos ambientais relacionados ao uso da energia, cresce a importância de se criar políticas de incentivo ao uso de combustíveis mais eficientes. Nesse sentido, considerando-se que o metano, o butano e o octano sejam representativos do gás natural, do gás liquefeito de petróleo (GLP) e da gasolina, respectivamente, então, a partir dos dados fornecidos, é possível concluir que, do ponto de vista da quantidade de calor obtido por mol de $C O_2$ gerado, a ordem crescente desses três combustíveis é

  #alternativas(
    [gasolina, GLP e gás natural.],
    [gás natural, gasolina e GLP.],
    [gasolina, gás natural e GLP.],
    [gás natural, GLP e gasolina.],
    [GLP, gás natural e gasolina. ],
  )
]

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
    [ 1], [C], [Química Ambiental], [Fácil],
    [12], [A], [Equilíbrio Químico], [Muito Difícil],
    [15], [B], [Eletroquímica], [Muito Difícil],
    [26], [D], [Equilíbrio Químico], [Difícil],
    [29], [D], [Atomística], [Difícil],
    [32], [B], [Atomística], [Difícil],
    [36], [E], [Propriedades de compostos orgânicos], [Muito Difícil],
    [43], [A], [Termoquímica], [Muito Difícil],
    [44], [D], [Separação de Misturas], [Muito Difícil],
  )
]
