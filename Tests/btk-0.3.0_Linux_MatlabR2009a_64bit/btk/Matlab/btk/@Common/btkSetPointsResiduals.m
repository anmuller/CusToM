function btkSetPointsResiduals(h. r) %#ok
%BTKSETPOINTSRESIDUALS Sets points' residuals from a matrix
% 
%  BTKSETPOINTSRESIDUALS(H, R) uses the matrix R to sets points' residuals.
%  The number of rows of the matrix corresponds to the number of frames in the acquisition. 
%  The number of columns of this matrix corresponds to the number of points.
%  The biomechanical acquisition handle H is represented as a double and can
%  be only used with the btk* functions.

%  Author: A. Barré
%  Copyright 2009-2013 Biomechanical ToolKit (BTK).

% The following comment, MATLAB compiler pragma, is necessary to avoid 
% compiling this M-file instead of linking against the MEX-file.  Don't remove.
%# mex

error(generatemsgid('NotSupported'),'MEX file for BTKSETPOINTSRESIDUALS not found');

% [EOF] btkSetPointsResiduals.m
