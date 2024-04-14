#let state_01_ex1 =  (
                      caption: "1ª Generación",
                      caption_alignment: ttb,
                      hspace: 20pt,
                      transition: " ",
                      columns: 6,
                      color_map: (white, blue, red, black),
                      data:  (0, 0, 0, 0, 2, 0,
                              1, 2, 1, 0, 0, 0,
                              1, 0, 2, 0, 1, 3,
                              0, 0, 3, 0, 2, 3,
                              3, 3, 3, 3, 3, 3)
)

#let state_02_ex1 = (
                   caption: "2ª Generación",
                   caption_alignment: ttb,
                   hspace: 20pt,
                   transition: "",
                   columns: 6,
                   color_map: (white, blue, red, black),
                   data:  (0, 0, 0, 0, 0, 0,
                           1, 0, 0, 0, 2, 0,
                           0, 2, 3, 0, 0, 3,
                           1, 0, 3, 0, 3, 3,
                           3, 3, 3, 3, 3, 3)
)


#let state_01_ex2 =  (
                      caption: "Estado inicial",
                      caption_alignment: ttb,
                      hspace: 20pt,
                      transition: " ",
                      columns: 6,
                      data:  (0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0,
                              0, 0, 0, 1, 0, 0,
                              0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0)
)

#let state_02_ex2 = (
                   caption: "10ª Generación",
                   caption_alignment: ttb,
                   hspace: 20pt,
                   transition: " ",
                   columns: 6,
                   data:     (0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 1, 0,
                              0, 0, 1, 1, 0, 0,
                              0, 0, 1, 0, 0, 0,
                              0, 0, 0, 0, 0, 0)
)

#let state_03_ex2 = (
                   caption: "100ª Generación",
                   caption_alignment: ttb,
                   hspace: 20pt,
                   transition: " ",
                   columns: 6,
                   data:     (0, 0, 1, 1, 0, 0,
                              0, 1, 0, 0, 1, 0,
                              0, 0, 1, 1, 0, 0,
                              0, 1, 1, 0, 1, 0,
                              0, 0, 0, 1, 1, 0)
)


#let hspacewolfram = 7.5pt
#let cellsizewolfram = 8pt
#let gutterwolfram = 3.5pt
#let guttercolorwolfram = 2pt

#let rule30_01 = (
  caption: "0",
  caption_alignment: btt,
  hspace: hspacewolfram,
  transition: " ",
  transition_icon: "",
  columns: 3,
  data:(1,1,1,2,0,2),  
  cellsize: cellsizewolfram,
  gutter: gutterwolfram,
  gutter-column: guttercolorwolfram,
  stroke_map: (black+0.75pt, black+0.75pt, white+0.75pt),
  color_map: (white, black)
)

#let rule30_02 = (
  caption: "0",
  caption_alignment: btt,
  hspace: hspacewolfram,
  transition: " ",
  transition_icon: "",
  columns: 3,
  data:(1,1,0,2,0,2),  
  cellsize: cellsizewolfram,
  gutter: gutterwolfram,
  gutter-column: guttercolorwolfram,
  stroke_map: (black+0.75pt, black+0.75pt, white+0.75pt),
  color_map: (white, black)
)

#let rule30_03 = (
  caption: "0",
  caption_alignment: btt,
  hspace: hspacewolfram,
  transition: " ",
  transition_icon: "",
  columns: 3,
  data:(1,0,1,2,0,2),  
  cellsize: cellsizewolfram,
  gutter: gutterwolfram,
  gutter-column: guttercolorwolfram,
  stroke_map: (black+0.75pt, black+0.75pt, white+0.75pt),
  color_map: (white, black)
)

#let rule30_04 = (
  caption: "1",
  caption_alignment: btt,
  hspace: hspacewolfram,
  transition: " ",
  transition_icon: "",
  columns: 3,
  data:(1,0,0,2,1,2),  
  cellsize: cellsizewolfram,
  gutter: gutterwolfram,
  gutter-column: guttercolorwolfram,
  stroke_map: (black+0.75pt, black+0.75pt, white+0.75pt),
  color_map: (white, black)
)

#let rule30_05 = (
  caption: "1",
  caption_alignment: btt,
  hspace: hspacewolfram,
  transition: " ",
  transition_icon: "",
  columns: 3,
  data:(0,1,1,2,1,2),
  cellsize: cellsizewolfram,
  gutter: gutterwolfram,
  gutter-column: guttercolorwolfram,
  stroke_map: (black+0.75pt, black+0.75pt, white+0.75pt),
  color_map: (white, black)
)

#let rule30_06 = (
  caption: "1",
  caption_alignment: btt,
  hspace: hspacewolfram,
  transition: " ",
  transition_icon: "",
  columns: 3,
  data:(0,1,0,2,1,2),
  cellsize: cellsizewolfram,
  gutter: gutterwolfram,
  gutter-column: guttercolorwolfram,
  stroke_map: (black+0.75pt, black+0.75pt, white+0.75pt),
  color_map: (white, black)
)

#let rule30_07 = (
  caption: "1",
  caption_alignment: btt,
  hspace: hspacewolfram,
  transition: " ",
  transition_icon: "",
  columns: 3,
  data:(0,0,1,2,1,2),
  cellsize: cellsizewolfram,
  gutter: gutterwolfram,
  gutter-column: guttercolorwolfram,
  stroke_map: (black+0.75pt, black+0.75pt, white+0.75pt),
  color_map: (white, black)
)

#let rule30_08 = (
  caption: "0",
  caption_alignment: btt,
  hspace: hspacewolfram,
  transition: " ",
  transition_icon: "",
  columns: 3,
  data:(0,0,0,2,0,2),
  cellsize: cellsizewolfram,
  gutter: gutterwolfram,
  gutter-column: guttercolorwolfram,
  stroke_map: (black+0.75pt, black+0.75pt, white+0.75pt),
  color_map: (white, black)
)

#let rule30_15gens = (
  caption: "",
  caption_alignment: ttb,
  transition: " ",
  transition_icon: "",
  columns: 33,
  data:(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,1,1,0,1,1,1,1,0,1,1,0,0,1,0,0,0,1,1,1,0,0,0,0,0,0,0,
        0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,1,0,1,1,1,1,0,1,1,0,0,1,0,0,0,0,0,0,
        0,0,0,0,0,1,1,0,1,1,1,1,0,0,1,1,0,1,0,0,0,0,1,0,1,1,1,1,0,0,0,0,0,
        0,0,0,0,1,1,0,0,1,0,0,0,1,1,1,0,0,1,1,0,0,1,1,0,1,0,0,0,1,0,0,0,0,
        0,0,0,1,1,0,1,1,1,1,0,1,1,0,0,1,1,1,0,1,1,1,0,0,1,1,0,1,1,1,0,0,0,),
  cellsize: 10pt,
  stroke_map: (0.2pt + black, 0.2pt +  black)
)

#let game_of_life_01 = (
  caption: "Estado inicial",
  caption_alignment: ttb,
  hspace: 15pt,
  transition: " ",
  columns: 6,
  data: (0, 0, 0, 0, 0, 0,
          0, 0, 0, 1, 0, 0,
          0, 1, 0, 1, 0, 0,
          0, 0, 1, 1, 0, 0,
          0, 0, 0, 0, 0, 0),
)

#let game_of_life_02 = (
  caption: "1ª Generación",
  caption_alignment: ttb,
  hspace: 15pt,
  transition: " ",
  columns: 6,
  data: (0, 0, 0, 0, 0, 0,
          0, 0, 1, 1, 0, 0,
          0, 1, 0, 1, 0, 0,
          0, 0, 1, 1, 0, 0,
          0, 0, 0, 0, 0, 0),
)

#let game_of_life_03 = (
  caption: "2ª Generación",
  caption_alignment: ttb,
  hspace: 15pt,
  transition: " ",
  columns: 6,
  data: (0, 0, 0, 0, 0, 0,
          0, 0, 0, 1, 0, 0,
          0, 1, 1, 1, 0, 0,
          0, 0, 1, 0, 0, 0,
          0, 0, 0, 0, 0, 0),
)

#let lagnton_cellsize = 10pt;
#let lagnton_hspace = 5pt;

#let langton_ant_01 = (
  caption: "1ª Generación",
  caption_alignment: ttb,
  hspace: lagnton_hspace,
  transition: " ",
  columns: 3,
  cellsize: lagnton_cellsize,
  color_map: (white, black, blue, red),
  data:  (0, 0, 0,
          0, 2, 0,
          0, 0, 0),
)

#let langton_ant_02 = (
  caption: "2ª Generación",
  caption_alignment: ttb,
  hspace: lagnton_hspace,
  transition: " ",
  columns: 3,
  cellsize: lagnton_cellsize,
  color_map: (white, black, blue, red),
  data:  (0, 0, 0,
          2, 1, 0,
          0, 0, 0),
)

#let langton_ant_03 = (
  caption: "3ª Generación",
  caption_alignment: ttb,
  hspace: lagnton_hspace,
  transition: " ",
  columns: 3,
  cellsize: lagnton_cellsize,
  color_map: (white, black, blue, red),
  data:  (0, 0, 0,
          1, 1, 0,
          2, 0, 0),
)

#let langton_ant_04 = (
  caption: "4ª Generación",
  caption_alignment: ttb,
  hspace: lagnton_hspace,
  transition: " ",
  columns: 3,
  cellsize: lagnton_cellsize,
  color_map: (white, black, blue, red),
  data:  (0, 0, 0,
          1, 1, 0,
          1, 2, 0),
)

#let langton_ant_05 = (
  caption: "5ª Generación",
  caption_alignment: ttb,
  hspace: lagnton_hspace,
  transition: " ",
  columns: 3,
  cellsize: lagnton_cellsize,
  color_map: (white, black, blue, red),
  data:  (0, 0, 0,
          1, 3, 0,
          1, 1, 0),
)

#let langton_ant_06 = (
  caption: "6ª Generación",
  caption_alignment: ttb,
  hspace: lagnton_hspace,
  transition: " ",
  columns: 3,
  cellsize: lagnton_cellsize,
  color_map: (white, black, blue, red),
  data:  (0, 0, 0,
          1, 0, 2,
          1, 1, 0),
)

#let luaimpl_ex1 = (
  caption: " ",
  caption_alignment: ttb,
  hspace: lagnton_hspace,
  transition: " ",
  columns: 4,
  color_map: (white, black, blue, red),
  cellsize: lagnton_cellsize,
  data:  (2, 0, 2, 0,
          3, 1, 3, 1,
          2, 0, 2, 0,
          3, 1, 3, 1),
)

#let luaimpl_ex2 = (
  caption: " ",
  caption_alignment: ttb,
  transition: " ",
  columns: 2,
  color_map: (white, black, blue, red),
  cellsize: lagnton_cellsize,
  data:  (2, 0,
          3, 1),
)

#let luaimpl_problem1_1_1 = (
  caption: "",
  caption_alignment: ttb,
  transition: "",
  columns: 4,
  color_map: (white, black, blue, red),
  cellsize: lagnton_cellsize,
  data:  (0, 0, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0),
)

#let luaimpl_problem1_1_2 = (
  caption: "",
  caption_alignment: ttb,
  transition: "",
  columns: 4,
  color_map: (white, black, blue, red),
  cellsize: lagnton_cellsize,
  data:  (0, 0, 0, 0,
          0, 0, 0, 0,
          0, 0, 1, 0,
          0, 0, 1, 0),
)

#let luaimpl_problem1_1_3 = (
  caption: "",
  caption_alignment: ttb,
  transition: "",
  columns: 4,
  color_map: (white, black, blue, red),
  cellsize: lagnton_cellsize,
  data:  (0, 0, 1, 0,
          0, 0, 1, 0,
          0, 0, 0, 0,
          0, 0, 0, 0),
)

#let luaimpl_problem1_1_4 = (
  caption: "",
  caption_alignment: ttb,
  transition: "",
  columns: 4,
  color_map: (white, black, blue, red),
  cellsize: lagnton_cellsize,
  data:  (0, 0, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0,
          0, 0, 1, 0),
)

#let luaimpl_problem1_1_5 = (
  caption: "",
  caption_alignment: ttb,
  transition: "",
  columns: 4,
  color_map: (white, black, blue, red),
  cellsize: lagnton_cellsize,
  data:  (0, 0, 1, 0,
          0, 0, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0),
)

#let luaimpl_problem1_1_6 = (
  caption: "",
  caption_alignment: ttb,
  transition: "",
  columns: 4,
  color_map: (white, black, blue, red),
  cellsize: lagnton_cellsize,
  data:  (0, 0, 0, 0,
          0, 0, 1, 0,
          0, 0, 0, 0,
          0, 0, 0, 0),
)