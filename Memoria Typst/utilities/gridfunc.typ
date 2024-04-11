#let draw_grid(state) = {
  [
    #let stroke_map = state.at("stroke_map", default: ())
    #let color_map = state.at("color_map", default: (white, black, blue, red, green, yellow))

    #let count = 0;
    #stack(
            dir: state.caption_alignment,
            spacing: 10pt,
            text(8pt)[#state.caption],
    grid(
                columns: state.columns, 
                row-gutter: state.at("gutter-row", default:  state.at("gutter", default: 0pt)),
                column-gutter: state.at("gutter-column", default: state.at("gutter", default: 0pt)),
                ..state.data.map(str => 
                    rect(
                      stroke: stroke_map.at(str, default: black+0.3pt),
                      width: state.at("cellsize", default: 15pt),
                      height: state.at("cellsize", default: 15pt),
                      fill: color_map.at(str, default: white)))))
  ]
}

#let draw_grid_simple(state) = {
  [
    #let stroke_map = state.at("stroke_map", default: ())
    #let color_map = state.at("color_map", default: (white, black, blue, red, green, yellow))

    #let count = 0;
    #grid(
                columns: state.columns, 
                row-gutter: state.at("gutter-row", default:  state.at("gutter", default: 0pt)),
                column-gutter: state.at("gutter-column", default: state.at("gutter", default: 0pt)),
                ..state.data.map(str => 
                    rect(
                      stroke: stroke_map.at(str, default: black+0.3pt),
                      width: state.at("cellsize", default: 15pt),
                      height: state.at("cellsize", default: 15pt),
                      fill: color_map.at(str, default: white))))
  ]
}

#let draw_transition(state) = {
  [

                #stack(
                dir: ttb,
                spacing: 4pt,
                text(8pt)[#state.at("transition", default: "")],
                state.at("transition_icon", default: $-->$))
           
  ]
}

#let grid_example(caption_text, states, vinit: 0pt, vend: 10pt, alignment: center + horizon) = {
v(vinit)
align(alignment)[
#box()[
  #stack(
    dir: ltr,
    spacing: states.at(0).at("hspace", default: 20pt),

    ..states.slice(0, -1).map(state => 
       stack(
          dir: ltr,
          spacing: state.at("hspace", default: 20pt),          
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
]]}

#let grid_example_from(caption_text, states, vinit: 0pt, vend: 10pt) = {
v(vinit)
align(center)[
#box()[
  #set align(horizon)

  #stack(
    dir: ltr,
    spacing: states.at(0).at("hspace", default: 20pt),

    ..states.slice(0, -1).map(state => 
       stack(
          dir: ltr,
          spacing: state.at("hspace", default: 20pt),
          state,          
          draw_transition(state)
      )),
      states.at(-1)
      )

    #if caption_text != "" [
      #show figure.caption: emph
      #figure("",caption: [#caption_text])
    ]

    #v(vend)
]]}