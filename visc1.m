function viscosity = visc1(amounts, sizes)
ex = 2.5;
uvmax = 0.605;
RFV = @(ratio, vliq) (1-uvmax-(1-uvmax)*vliq).*((1-ratio).^ex)+vliq+uvmax-1;
H = @(vfrac) (2*(1-vfrac)./(abs(1-vfrac)+(1-vfrac))).*(1-vfrac)^-(2.5*uvmax);
vliq = 1;
viscosity = 1;
for i=1:length(sizes)-1
    ratios(i) = sizes(i+1)/sizes(i);
end
for j=1:length(amounts)
    v = amounts(j);
    viscosity = viscosity*H(v/RFV(ratio(amounts, ratios, j, ex), vliq));
    vliq = vliq-v;
    if isinf(viscosity)
        viscosity = Inf;
    end
end
    function rat = ratio(amounts, ratios, n, ex)
        Ratio = @(FC, FM, c, m) FM-abs((FM-FC)*(c/(m+c))^(1/ex));
        rati = [1, 1, ratios];
        amt = [1, 0, amounts];
        rat = 1;
        for k=1:n
            rat = Ratio(rat*rati(k+1), rati(k+1), amt(k), amt(k+1));
        end
    end
end