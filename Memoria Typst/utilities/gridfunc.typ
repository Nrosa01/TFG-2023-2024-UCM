#let draw_grid(state) = {
  [
    #let stroke_map = state.at("stroke_map", default: ())
    #let color_map = state.color_map

    #let count = 0;
    #stack(
            dir: state.caption_alignment,
            spacing: 10pt,
            text(8pt)[#state.caption],
    grid(
                columns: state.columns, 
                row-gutter: state.at("gutter-row", default:  state.at("gutter", default: 5pt)),
                column-gutter: state.at("gutter-column", default: state.at("gutter", default: 5pt)),
                ..state.data.map(str => 
                    rect(
                      stroke: stroke_map.at(str, default: black),
                      width: state.at("cellsize", default: 10pt),
                      height: state.at("cellsize", default: 10pt),
                      fill: color_map.at(str, default: white)))))
  ]
}

#let draw_transition(state) = {
  [

                #stack(
                dir: ttb,
                spacing: 4pt,
                text(8pt)[#state.transition],
                state.at("transition_icon", default: $-->$))
           
  ]
}

#let grid_example(caption_text, states, vinit: 10pt, vend: 10pt) = {

v(vinit)
align(center + horizon)[
  #stack(
    dir: ltr,
    spacing: 20pt,

    ..states.slice(0, -1).map(state => 
       stack(
          dir: ltr,
          spacing: state.hspace,          
          draw_grid(state),
          draw_transition(state)
      )),
      draw_grid(states.at(-1))
      )

    #if caption_text != "" [
      #show figure.caption: emph
      #figure("",caption: [#caption_text])
    ]

    #v(vend)
]}