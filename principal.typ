// arquivo principal

#set page( 
    paper: "a4", 
    flipped: false, 
    margin: (x: 1.5cm, y: 2cm), 
) 

#show heading: set text(fill: rgb("#008000"))

#set text( 
    font: "Libron", 
    size: 10pt, 
    lang: "pt", 
)

#set par(justify: true)
#set heading(numbering: "1.1.")

// Capa
#include "capa.typ"

// Índice dos conteúdos
#include "conteudos_de_quimica.typ"

// 2009
#include "provas/2009.typ"

// 2010
#include "provas/2010.typ"