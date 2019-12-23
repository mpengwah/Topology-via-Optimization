function plot_variance(variance_mea,ind)
figure;
plot(variance_mea,'.','MarkerSize',15);title('Variance Plots for Pairwise Distances')
xlabel('Position in Distance Matrix of Leaf Nodes')
ylabel('Variance');grid on
for i=1:length(variance_mea)
    txt = sprintf('%d,%d',ind(i,1),ind(i,2));
    text(i,variance_mea(i),txt);
end
end

