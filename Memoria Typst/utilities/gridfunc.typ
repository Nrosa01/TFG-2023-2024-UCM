#let grid_example(caption_text, color_map, states) = {

let slice = states.slice(0, -1)

align(center + horizon)[
  #stack(
    dir: ltr,
    spacing: 20pt,

    ..slice.map(state => 
       stack(
          dir: ltr,
          spacing: 20pt,

      stack(
        dir: ttb,
        spacing: 10pt,

        text(8pt)[#state.caption],
          grid(
              columns: state.columns, 
              gutter: 5pt, 
              ..state.data.map(str => 
              rect(
                  stroke: 1pt, 
                  width: 10pt, 
                  height: 10pt, 
                  fill: color_map.at(str))))),

          if state.transition.len() > 0
          {
              stack(
                dir: ttb,
                spacing: 4pt,
                text(8pt)[#state.transition],
                $-->$)
          }
          else 
          {
              $-->$
          },
      )),

      stack(
        dir: ttb,
        spacing: 10pt,

        if states.at(-1).caption.len() > 0
        {
          text(8pt)[#states.at(-1).caption]
            grid(
          columns: 6, 
          gutter: 5pt, 
          ..states.at(-1).data.map(str => 
              rect(
                stroke: 1pt, 
                width: 10pt, 
                height: 10pt, 
                fill: color_map.at(str))))
        }
        else
        {
           
          grid(
          columns: 6, 
          gutter: 5pt, 
          ..states.at(-1).data.map(str => 
              rect(
                stroke: 1pt, 
                width: 10pt, 
                height: 10pt, 
                fill: color_map.at(str))))
        },

        ))

    #show figure.caption: emph

    #figure("",caption: [#caption_text])
]}