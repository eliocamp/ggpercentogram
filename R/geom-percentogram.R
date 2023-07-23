#' Equal probability histogram
#'
#' A histogram in which each bin has the same number of observations and is
#' drawn to have an equal area.
#'
#' @inheritParams ggplot2::geom_histogram
#' @param stat The statistical transformation to use on the data for this layer,
#' either as a ggproto Geom subclass or as a string naming the stat stripped of
#'  the stat_ prefix (e.g. "count" rather than "stat_count").
#' @param binwidth The width of the bins expressed in the percentage of data
#' hold in each bin.
#' @param breaks Alternatively, you can supply a numeric vector giving the bin
#'  boundaries in quantiles. Overrides `binwidth` and `bins`.
#' @param trim If breaks are expressed with `bins` or `binwidth`, the
#' percentogram will plot quantiles `seq(trim, 1 - trim, length.out = bins + 1)`
#' or `seq(trim, 1 - trim, binwidth)`, respectively. This effectively removes
#' `trim/2` percentage of the data and it's useful to plot very long-tailed distributions.
#' @param jitter_duplicates Logical indicating whether to add random jitter to
#' duplicate points. The jitter is `1e-5` of the standard deviation of the data.
#' When the data has many duplicates, the computed quantiles don't actually have
#' the same ammount of observations.
#' @param type Numeric indicating the quantile method to use. See [stats::quantile()]
#'
#' @examples
#' library(ggplot2)
#'
#' ggplot(diamonds, aes(carat)) +
#'   geom_percentogram()
#'
#' ggplot(diamonds, aes(carat)) +
#'   geom_percentogram(bins = 20)
#'
#' # Each bin contains 10% of the observations
#' # (this is the same as `bins = 10`)
#' ggplot(diamonds, aes(carat)) +
#'   geom_percentogram(binwidth = 0.1)
#'
#' # User-defined cuantiles.
#' ggplot(diamonds, aes(carat)) +
#'   geom_percentogram(breaks = c(0, 0.1, 0.25, 0.5, 0.6, 0.8, 0.9, 0.99, 1),
#'                     color = "black")
#'
#' # For long-tailed distributions, trim a bit off the extremes.
#' ggplot(diamonds, aes(carat)) +
#'   geom_percentogram(trim = 0.01)
#'
#' # When the data has duplicates, quantiles don't actually contain equal number
#' # of observations.
#' ggplot(diamonds, aes(carat)) +
#'   geom_percentogram(bins = 20, aes(y = after_stat(count)))
#'
#' # `jitter_duplicates` add a bit of noise to the duplicates to get
#' # more even counts
#' ggplot(diamonds, aes(carat)) +
#'   geom_percentogram(bins = 20, jitter_duplicates = TRUE,
#'                  aes(y = after_stat(count)))
#'
#' ggplot(diamonds, aes(carat)) +
#'   geom_percentogram(jitter_duplicates = TRUE, bins = 20)
#'
#' ggplot(diamonds, aes(carat)) +
#'   geom_percentogram(aes(fill = after_stat(cut_number(quantile, 4))),
#'                     jitter_duplicates = TRUE, bins = 20)
#'
#'
#' @export
geom_percentogram <- function (mapping = NULL, data = NULL, stat = StatQuantileBin, position = "stack",
          ..., binwidth = NULL, bins = NULL, breaks = NULL, trim = 0, type = 7, jitter_duplicates = FALSE,
          na.rm = FALSE, orientation = NA,
          show.legend = NA, inherit.aes = TRUE) {
  ggplot2::layer(data = data, mapping = mapping, stat = stat, geom = ggplot2::GeomBar,
        position = position, show.legend = show.legend, inherit.aes = inherit.aes,
        params = rlang::list2(binwidth = binwidth, bins = bins, na.rm = na.rm,
                       orientation = orientation, pad = FALSE,  trim = trim,
                       type = type, jitter_duplicates = jitter_duplicates, ...))
}


