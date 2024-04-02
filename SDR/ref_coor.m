function [ ur,vr ] = ref_coor(us,vs,dD, MinZ, MaxZ,m_Height, m4_ProjMatrix,m5_ProjMatrix)
%REF_COOR Summary of this function goes here
%   Detailed explanation goes here
   zc=dD(vs,us);
   z=DepthLevelToZ(double(zc), MinZ, MaxZ);
   [x, y] = projUVZtoXY(m_Height, m4_ProjMatrix, us,vs , z);
   [ur,vr] = projXYZtoUV(m_Height, m5_ProjMatrix, x, y, z);


end

