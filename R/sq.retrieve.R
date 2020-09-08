#' @param taxa
#' @param genes
#' @param maxseqs
#' @param maxlength
#' @param export




library (rentrez)
library(pbapply)
species <- c(
  "Gyrinus marinus",
  "Tribolium castaneum",
  "Corydalus cornutus",
  "Xanthostigma xanthostigma",
  "Pseudomallada prasinus"
)

genes <- c('COI')



sq.retrieve <- function(taxa, genes, maxseqs=1, maxlength=5000, export=F) {
  Full_sequences <- lapply(seq_along(genes), function(y) {
    ret_seqs <- pblapply(seq_along(taxa), function(x) {
      targetsp <-
        paste0(taxa[x], " [Organism] ", genes[y], " 1:" , maxlength, "[SLEN]")

      res_rearch <-
        entrez_search(db = "nuccore",
                      term = targetsp,
                      retmax = maxseqs)

      if (length(res_rearch$ids) == 0) {
        return(list(
          taxa = taxa[x],
          gene = genes[y],
          data = F,
          sequences = NULL
        ))

      } else{
        res_seqs <-
          entrez_fetch(db = "nuccore",
                       id = res_rearch$ids,
                       rettype = "fasta")
        return(list(
          taxa = taxa[x],
          gene = genes[y],
          data = F,
          sequences = res_seqs
        ))
      }
    })
    names(ret_seqs) <- genes[y]
    ret_seqs
  })

  if(export==T){
  lapply(seq_along(genes), function(y) {
    lapply(seq_along(taxa), function(x) {
      write(
        Full_sequences[[y]][[x]]$sequences,
        paste0("Sequences/Full_dataset.fasta"),
        sep = "\n",
        append = TRUE
      )
    })
  })}else{
    return(Full_sequences)
  }
}

sq.retrieve(species, genes = genes)
