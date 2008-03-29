function mgplvmDisplay(model, spaceNum)

% MGPLVMDISPLAY Display an MGPLVM model.
% FORMAT
% DESC displays a given mixtures of GP-LVM in human readable form.
% ARG model : the mixtures of GP-LVM to display.
%
% FORMAT does the same as above, but indents the display according to the amount specified.
% ARG model : the mixtures of GP-LVM to display.
% ARG spacing : how many spaces to indent the display of the mixtures of GP-LVM by.
%
% SEEALSO modelDisplay, kernDisplay
%
% COPYRIGHT Neil D. Lawrence and Raquel Urtasun, 2007

% MGPLVM


if nargin > 1
  spacing = repmat(32, 1, spaceNum);
else
  spaceNum = 0;
  spacing = [];
end
spacing = char(spacing);
fprintf(spacing);
fprintf('Mixtures of GP-LVM model:\n')
fprintf(spacing);
fprintf('  Components: %d\n', model.M)
fprintf(spacing);
fprintf('  Number of data points: %d\n', model.N);
fprintf(spacing);
fprintf('  Input dimension: %d\n', model.q);
fprintf(spacing);
fprintf('  Output dimension: %d\n', model.d);
fprintf(spacing);
fprintf('  beta: %2.4f\n', model.beta)
for m = 1:model.M
  fprintf(spacing);
  fprintf('  Kernel %d:\n', m)
  kernDisplay(model.comp{m}.kern, 4+spaceNum);
end
if isfield(model, 'dynamics') & ~isempty(model.dynamics)
  fprintf(spacing);
  fprintf('Dynamics model:\n')
  modelDisplay(model.dynamics, 2+spaceNum);
end
if isfield(model, 'back') & ~isempty(model.back)
  fprintf(spacing);
  fprintf('Back constraining model:\n')
  modelDisplay(model.back, 2+spaceNum);
end