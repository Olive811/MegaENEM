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
