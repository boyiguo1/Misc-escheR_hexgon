library(hexSticker)
library(escheR)
stopifnot("Update to escheR > 1.2.0" = packageVersion("escheR") >= "1.2.0")
library(STexampleData)

# Prep Data
spe <- Visium_humanDLPFC()
spe <- spe[, spe$in_tissue == 1]
spe <- spe[, !is.na(spe$ground_truth)]

p <- make_escheR(spe)

spe$counts_MOBP <- counts(spe)[which(rowData(spe)$gene_name=="MOBP"),]

p_complete <- make_escheR(spe) |> 
  add_fill(var = "counts_MOBP") |> 
  add_ground(var = "ground_truth", stroke = 0.5) +
  scale_fill_gradient(low = "white", high = "black") +
  theme(legend.position = "none")

p_fill <- make_escheR(spe) |> 
  add_fill(var = "counts_MOBP") +
  scale_fill_gradient(low = "white", high = "blue") +
  theme(legend.position = "none")

p_ground<- make_escheR(spe) |> 
  add_ground(var = "ground_truth", stroke = 0.5) +
  theme(legend.position = "none")

p_symbol<- make_escheR(spe) |> 
  add_symbol(var = "ground_truth", stroke = 0.5) +
  theme(legend.position = "none")

list("complete" = p_complete, 
     "fill" = p_fill, 
     "ground" = p_ground, 
     "symbol" = p_symbol) |> 
  purrr::iwalk(~ggsave(plot = .x, filename = here::here("Figure", paste0(.y, ".pdf")),
                       width = 5, height = 5))


imgurl <- here::here("Figure/ensemble.png")
sticker(
  imgurl, package="escheR", 
  p_x = 1, p_y =1.6, p_size=20, p_color = "black",
  s_x=0.9, s_y=0.85, s_width=1, s_height=1,
  h_fill = "white",
  filename="escheR_hex_sticker.png"#, spotlight = TRUE
)

