
  

% {This function acts as a condition to check binary value of any possible
% intersection, using geometry of comparing distance between coordinates}
% {The value obtained by this function is sent to the function ob_avoidance
% to compare and decide whether the obstacle is interfering the new edge} 
function val = condition(A,B,C)
val = (C(2)-A(2)) * (B(1)-A(1)) > (B(2)-A(2)) * (C(1)-A(1));
end