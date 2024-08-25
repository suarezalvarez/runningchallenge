library(ggplot2)

myplot = ggplot(data = data.frame(a = c(1,2,3),
                         b = c(2,4,6))) +
  aes(x = a , y = b) +
  geom_point() + 
  geom_smooth(method = "lm") +
  theme_bw() +
  theme(panel.grid = element_blank())
