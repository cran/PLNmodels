# common_samples fails on matrices with dimension names but conflicting names [plain]

    Code
      suppressWarnings(common_samples(`rownames<-`(counts, paste0("Sample_", 1:49)),
      covariates))
    Condition
      Error:
      x Conflicting sample names in `counts` matrix and `covariates` data frames
      i Sample names in `counts` matrix is <Sample_1/Sample_2/Sample_3/Sample_4/Sample_5/Sample_6/Sample_7/Sample_8/Sample_9/Sample_10/Sample_11/Sample_12/Sample_13/Sample_14/Sample_15/Sample_16/Sample_17/Sample_18/Sample_19/Sample_20/Sample_21/Sample_22/Sample_23/Sample_24/Sample_25/Sample_26/Sample_27/Sample_28/Sample_29/Sample_30/Sample_31/Sample_32/Sample_33/Sample_34/Sample_35/Sample_36/Sample_37/Sample_38/Sample_39/Sample_40/Sample_41/Sample_42/Sample_43/Sample_44/Sample_45/Sample_46/Sample_47/Sample_48/Sample_49> and in `covariates` is <1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30/31/32/33/34/35/36/37/38/39/40/41/42/43/44/45/46/47/48/49>.

# common_samples fails on matrices with dimension names but conflicting names [ansi]

    Code
      suppressWarnings(common_samples(`rownames<-`(counts, paste0("Sample_", 1:49)),
      covariates))
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[31mx[39m Conflicting sample names in `counts` matrix and `covariates` data frames
      [36mi[39m Sample names in `counts` matrix is [34m<Sample_1/Sample_2/Sample_3/Sample_4/Sample_5/Sample_6/Sample_7/Sample_8/Sample_9/Sample_10/Sample_11/Sample_12/Sample_13/Sample_14/Sample_15/Sample_16/Sample_17/Sample_18/Sample_19/Sample_20/Sample_21/Sample_22/Sample_23/Sample_24/Sample_25/Sample_26/Sample_27/Sample_28/Sample_29/Sample_30/Sample_31/Sample_32/Sample_33/Sample_34/Sample_35/Sample_36/Sample_37/Sample_38/Sample_39/Sample_40/Sample_41/Sample_42/Sample_43/Sample_44/Sample_45/Sample_46/Sample_47/Sample_48/Sample_49>[39m and in `covariates` is [34m<1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30/31/32/33/34/35/36/37/38/39/40/41/42/43/44/45/46/47/48/49>[39m.

# common_samples fails on matrices with dimension names but conflicting names [unicode]

    Code
      suppressWarnings(common_samples(`rownames<-`(counts, paste0("Sample_", 1:49)),
      covariates))
    Condition
      Error:
      ✖ Conflicting sample names in `counts` matrix and `covariates` data frames
      ℹ Sample names in `counts` matrix is <Sample_1/Sample_2/Sample_3/Sample_4/Sample_5/Sample_6/Sample_7/Sample_8/Sample_9/Sample_10/Sample_11/Sample_12/Sample_13/Sample_14/Sample_15/Sample_16/Sample_17/Sample_18/Sample_19/Sample_20/Sample_21/Sample_22/Sample_23/Sample_24/Sample_25/Sample_26/Sample_27/Sample_28/Sample_29/Sample_30/Sample_31/Sample_32/Sample_33/Sample_34/Sample_35/Sample_36/Sample_37/Sample_38/Sample_39/Sample_40/Sample_41/Sample_42/Sample_43/Sample_44/Sample_45/Sample_46/Sample_47/Sample_48/Sample_49> and in `covariates` is <1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30/31/32/33/34/35/36/37/38/39/40/41/42/43/44/45/46/47/48/49>.

# common_samples fails on matrices with dimension names but conflicting names [fancy]

    Code
      suppressWarnings(common_samples(`rownames<-`(counts, paste0("Sample_", 1:49)),
      covariates))
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[31m✖[39m Conflicting sample names in `counts` matrix and `covariates` data frames
      [36mℹ[39m Sample names in `counts` matrix is [34m<Sample_1/Sample_2/Sample_3/Sample_4/Sample_5/Sample_6/Sample_7/Sample_8/Sample_9/Sample_10/Sample_11/Sample_12/Sample_13/Sample_14/Sample_15/Sample_16/Sample_17/Sample_18/Sample_19/Sample_20/Sample_21/Sample_22/Sample_23/Sample_24/Sample_25/Sample_26/Sample_27/Sample_28/Sample_29/Sample_30/Sample_31/Sample_32/Sample_33/Sample_34/Sample_35/Sample_36/Sample_37/Sample_38/Sample_39/Sample_40/Sample_41/Sample_42/Sample_43/Sample_44/Sample_45/Sample_46/Sample_47/Sample_48/Sample_49>[39m and in `covariates` is [34m<1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30/31/32/33/34/35/36/37/38/39/40/41/42/43/44/45/46/47/48/49>[39m.

# common_samples find biggest subset of common samples and produces message. [plain]

    Code
      result <- common_samples(counts, covariates[1:35, ])
    Condition
      Warning:
      ! There are less samples in `counts` than in `covariates`.
      i <14> samples were dropped from the `counts` matrix for lack of associated `covariates`.
      i <There are 35> samples in the final data.frame.

# common_samples find biggest subset of common samples and produces message. [ansi]

    Code
      result <- common_samples(counts, covariates[1:35, ])
    Condition
      [1m[33mWarning[39m:[22m
      [1m[22m[33m![39m There are less samples in `counts` than in `covariates`.
      [36mi[39m [34m<14>[39m samples were dropped from the `counts` matrix for lack of associated `covariates`.
      [36mi[39m [34m<There are 35>[39m samples in the final data.frame.

# common_samples find biggest subset of common samples and produces message. [unicode]

    Code
      result <- common_samples(counts, covariates[1:35, ])
    Condition
      Warning:
      ! There are less samples in `counts` than in `covariates`.
      ℹ <14> samples were dropped from the `counts` matrix for lack of associated `covariates`.
      ℹ <There are 35> samples in the final data.frame.

# common_samples find biggest subset of common samples and produces message. [fancy]

    Code
      result <- common_samples(counts, covariates[1:35, ])
    Condition
      [1m[33mWarning[39m:[22m
      [1m[22m[33m![39m There are less samples in `counts` than in `covariates`.
      [36mℹ[39m [34m<14>[39m samples were dropped from the `counts` matrix for lack of associated `covariates`.
      [36mℹ[39m [34m<There are 35>[39m samples in the final data.frame.

# compute_offset fails with an informative error when given a data.frame [plain]

    Code
      compute_offset(counts, data.frame(counts))
    Condition
      Error in `compute_offset()`:
      ! `offset` must be an available scheme or a vector or matrix of offsets.
      x You supplied a data.frame for `offset`
      i Did you mean to supply a numeric matrix?
      i Try converting your data.frame to a matrix with `as.matrix()`.

# compute_offset fails with an informative error when given a data.frame [ansi]

    Code
      compute_offset(counts, data.frame(counts))
    Condition
      [1m[33mError[39m in `compute_offset()`:[22m
      [1m[22m[33m![39m `offset` must be an available scheme or a vector or matrix of offsets.
      [31mx[39m You supplied a data.frame for `offset`
      [36mi[39m Did you mean to supply a numeric matrix?
      [36mi[39m Try converting your data.frame to a matrix with `as.matrix()`.

# compute_offset fails with an informative error when given a data.frame [unicode]

    Code
      compute_offset(counts, data.frame(counts))
    Condition
      Error in `compute_offset()`:
      ! `offset` must be an available scheme or a vector or matrix of offsets.
      ✖ You supplied a data.frame for `offset`
      ℹ Did you mean to supply a numeric matrix?
      ℹ Try converting your data.frame to a matrix with `as.matrix()`.

# compute_offset fails with an informative error when given a data.frame [fancy]

    Code
      compute_offset(counts, data.frame(counts))
    Condition
      [1m[33mError[39m in `compute_offset()`:[22m
      [1m[22m[33m![39m `offset` must be an available scheme or a vector or matrix of offsets.
      [31m✖[39m You supplied a data.frame for `offset`
      [36mℹ[39m Did you mean to supply a numeric matrix?
      [36mℹ[39m Try converting your data.frame to a matrix with `as.matrix()`.

