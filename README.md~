@Sylvia Wong (sylviahqy@gmail.com)
----------------------------------------------------
dataset: *.mat 

feature:
    - lbp_algorithms: return LBP descriptors
    - color
    - gabor

utils
    -@timetic (Time utils)
    -computeSimilarityMatrix.m
    -return_distance.m
    -slmetric_pw.m : pwmetrics_cimp.mexw32, pwmetrics_cimp.mex64
    -preRun.m
    -randId.m
    eval: 
        - evaluate_results.m
        - plot_CMC.m
        - plot_EPC.m
        - plot_ROC.m
        - produce_CMC.m
        - produce_EPC.m
        - produce_ROC.m