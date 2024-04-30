// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let project(
  body,
) = {
  // Set the document's basic properties.
  set page(numbering: "1", number-align: center)
  set text(font: "New Computer Modern", lang: "es", hyphenate: false)
  show math.equation: set text(weight: 400)

  // Set paragraph spacing.
  show par: set block(above: 1.2em, below: 1.2em)

  set heading(numbering: "1.1")
  set par(leading: 0.75em)

  // Main body.
  set par(justify: true)

  body
}