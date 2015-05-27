MGPLVM software
Version 0.111		Wednesday 13 Mar 2013 at 15:47

The MGPLVM toolbox is an implementation of mixtures of Gaussian process latent variable models.

Version 0.111
-------------

First public release of software triggered by several people asking about mixtures of GPLVMs.

Version 0.11
------------

Second release for submission to ICML 2008. 

Fix bug in NIPS submission where <s>^\pi terms were being multiplied by d.
Revamp code to make use of GP toolbox to ease later use of FITC approximation.
Add infinite mixture models alla "An Alternative Infinite Mixture of GP Experts" by Meeds and Osindero. Add variant of infinite mixture models where posterior is constrained.

Version 0.1
-------------

Release of software for submission to NIPS 2007.



MATLAB Files
------------

Matlab files associated with the toolbox are:

mgplvmGatingLogLikeGradientTest.m: Test gradients of gating.
mgplvmComputeInitAssignment.m: Compute an inital assignment for the mixtures.
mgplvmCreate.m: Create a MGPLVM model.
demVowels90Mgplvm1.m: Demonstrate mixtues of DPPCA on vowels90 data, with back-constraints
mgplvmOptions.m: Return default options for mixtures of GP-LVM.
mgplvmLogLikeGradients.m: Compute gradients for the MGPLVM model.
mgplvmPlotClusters.m: plots the cluster labels associated with the latent space.
mgplvmGatingLogLikeGradient.m: Compute the gradients of gates of a MGPLVM model.
mgplvmEstep.m: Run the variational E step for the MGPLVM model.
mgplvmLogLikelihood.m: Log likelihood of a mixtures of GP-LVM model.
mgplvmDynamicsRun.m: Runs auto regressive dynamics in a forward manner.
mgplvmPosteriorMeanVar.m: Mean and variances of the posterior at points given by X.
mgplvmExtractParam.m: Extract a parameter vector from a MGPLVM model.
demBrendanMgplvm1.m: Model the face data with a 2-D RBF GPLVM.
demOil100Mgplvm1.m: Demonstrate mixtues of DPPCA on oil100 data, with back-constraints
mgplvmPrintPlotClusters.m: plots the cluster labels associated with the latent space.
mgplvmUpdateS.m: Update the S values and associated activepoints.
mgplvmGatingProbabilities.m: Compute the gating probabilities for the
mgplvmLoadResult.m: Load a previously saved result.
mgplvmWriteResult.m: Write a MGPLVM result.
mgplvmDisplay.m: Display an MGPLVM model.
mgplvmLatentPriorLogLikelihood.m: Compute likelihood of prior in latent space.
mgplvmComputeS.m: Compute the expectation of the indicator matrix.
mgplvmTest.m: Test the gradients of the MGPLVM model.
mgplvmGradient.m: Mixtures of GP-LVM gradient wrapper.
demOilMgplvm3.m: Demonstrate mixtues of RBF GPLVM on oil data, with back-constraints
kernCreate.m: Initialise a kernel structure.
mgplvmComputePi.m: Compute the expectations of the component priors.
demStickMgplvm1.m: Model the stick man using an linear kernel and dynamics.
mgplvmComponentPosteriorMeanVar.m: Mean and variance under each component of the mixture model.
mgplvmToolboxes.m: Load in the relevant toolboxes for mgplvm.
mgplvmLatentPriorLogLikeGradients.m: Compute gradients of prior in latent space.
translateKernCompute.m: Compute the TRANSLATE kernel given the parameters and X.
mgplvmExpandParam.m: Expand a parameter vector into a MGPLVM model.
mgplvmDeconstruct.m: break MGPLVM in pieces for saving.
demStickMgplvm2.m: Model the stick man using an RBF kernel and dynamics.
mgplvmOptimise.m: Optimise the mixtures of GP-LVM.
mgplvmEMOptimise.m: Optimise the mixture model using the EM algorithm.
mgplvmReconstruct.m: Reconstruct an MGPLVM from component parts.
demOilMgplvm2.m: Demonstrate mixtues of DPPCA on oil data, with back-constraints
demOilMgplvm1.m: Demonstrate mixtues of DPPCA on oil data, with back-constraints
mgplvmResultsDynamic.m: Load a results file and visualise them.
mgplvmObjective.m: Wrapper function for mixtures of GP-LVM objective.
