function [ow] = okubo_weiss(Ux,Uy,Vx,Vy)
   

sn = Ux - Vy ;
    ss = Vx + Uy ;
    w  = Vx - Uy ;
    ow = sn.^2 + ss.^2 - w.^2;
end
