#' @rdname geom_percentogram
#' @export
StatQuantileBin <- ggplot2::ggproto("StatQuantileBin", ggplot2::StatBin,
  default_aes = ggplot2::aes(x = ggplot2::after_stat(density),
                             y = ggplot2::after_stat(density),
                             weight = 1),
  compute_group = function(self, data, scales,
                           binwidth = NULL, bins = 30, breaks = NULL,
                           trim = 0, type = 7, jitter_duplicates = FALSE,
                           closed = c("right", "left"), pad = FALSE,
                           flipped_aes = FALSE,
                           # The following arguments are not used, but must
                           # be listed so parameters are computed correctly
                           origin = NULL, right = NULL, drop = NULL,
                           width = NULL) {

    quantiles <- compute_quantiles(breaks = breaks,
                                   binwidth = binwidth,
                                   bins = bins,
                                   trim = trim)

    x <- ggplot2::flipped_names(flipped_aes)$x

    if (jitter_duplicates) {
      dup <- duplicated(data[[x]])
      data[[x]][dup] <- data[[x]][dup] + rnorm(sum(dup), sd = sd(data[[x]])*1e-5)
    }

    breaks <- quantile(data[[x]], quantiles, type = type)

    # If quantiles are too close, sometimes you get duplicates
    keep <- !duplicated(breaks)
    breaks <- breaks[keep]
    quantiles <- quantiles[keep]


    bins <- ggplot2::ggproto_parent(ggplot2::StatBin, self)$compute_group(
      data, scales,
      breaks = breaks,
      closed = closed, pad = pad,
      flipped_aes = FALSE)

    bins$quantile <- quantiles[-length(quantiles)]
    bins$flipped_aes <- flipped_aes
    bins$freq <- bins$count/nrow(data)
    ggplot2::flip_data(bins, flipped_aes)
  }
)



compute_quantiles <- function(breaks, binwidth, trim, bins) {
  if (is.null(breaks)) {  # If breaks is not provided, we need to compute them
    if (!is.null(binwidth)) {   # Either with binwidth
      trim <- trim/2
      quantiles <- seq(trim, 1 - trim, binwidth)
    } else {    # or the number of bins
      quantiles <- seq(trim, 1 - trim, length.out = bins + 1)
    }
  } else {
    quantiles <- breaks
  }

  return(quantiles)
}
