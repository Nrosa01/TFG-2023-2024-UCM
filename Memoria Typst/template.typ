// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let project(
  title: "",
  titleEng: "",
  degree: "",
  course: "",
  abstract: [],
  authors: (),
  directors: (),
  date: none,
  body,
) = {
  // Set the document's basic properties.
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: center)
  set text(font: "New Computer Modern", lang: "es", hyphenate: false)
  show math.equation: set text(weight: 400)

  // Set paragraph spacing.
  show par: set block(above: 1.2em, below: 1.2em)

  set heading(numbering: "1.1")
  set par(leading: 0.75em)

  align(center + horizon)[
    
  #block(text(weight: 1000, 1.5em, course))

  #block(text(weight: 700, 1.0em, rgb(77,77,77), degree))

    #v(2.2em, weak: true)

  // Title row.
  #align(center)[
    #rect(stroke: (top: 1pt, bottom: 1pt), inset: 20pt)[
      #block(text(weight: 700, 1.5em, title))
      #v(10pt)
      #block(text(weight: 700, 1.0em, rgb(77,77,77), titleEng))
    ]
    #v(2.2em, weak: true)
    // #date
  ]


  #pad(
    align(center)[
     #image("images/escudoUCM.svg", width: 25%)
    #v(-0.5em, weak: true)
     Universidad Complutense de Madrid
    ]
  )


  #v(2.5em, weak: true)
  // Author information.
    Alumnos
  #pad(
    x: 2em,
    stack(spacing: 8pt,
        ..authors.map(author => align(center, strong(author))))
  )

      Dirección
  #pad(
    x: 2em,
    stack(spacing: 8pt,
        ..directors.map(author => align(center, strong(author))))
  )

  #align(center)[
    #v(1.5em, weak: true)
    #date
  ]

  // Abstract.
  // #pad(
  //   x: 2em,
  //   top: 1em,
  //   bottom: 1.5em,
  //   align(center)[
  //     #heading(
  //       outlined: false,
  //       numbering: none,
  //       text(0.85em, smallcaps[Abstract]),
  //     )
  //     #abstract
  //   ],
  // )
  ]


  pagebreak()

  // Main body.
  set par(justify: true)

  body
}