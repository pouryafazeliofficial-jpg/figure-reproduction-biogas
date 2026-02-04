# 1. Load Libraries
library(ggplot2)

# 2. Load Data with cleaning
# استفاده از na.strings باعث می‌شود فضاهای خالی مستقیماً به عنوان مقدار گم شده شناسایی شوند
data <- read.csv("data/biogas_data.csv", na.strings = c("", " ", "NA"), strip.white = TRUE)

# تبدیل اجباری به عدد و حذف ردیف‌هایی که مشکل دارند
data$time <- as.numeric(data$time)
data$biogas <- as.numeric(data$biogas)

# حذف ردیف‌های خالی (اگر وجود داشته باشند)
data <- na.omit(data)

# 3. Create Figure A
# محاسبه نرخ روزانه (تفاوت بیوگاز تقسیم بر تفاوت زمان)
# ما از یک فرمول ساده برای پر کردن این ستون استفاده می‌کنیم
data$daily_rate <- data$biogas / (data$time + 1) 

# حالا چک کن ببین اضافه شد یا نه:
colnames(data)
plot_a <- ggplot(data, aes(x = time, y = biogas, color = treatment, group = treatment)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  labs(title = "Biogas Production Over Time",
       x = "Time (days)",
       y = "Cumulative Biogas (mL/cm2)",
       color = "Treatment") +
  theme_minimal()

# 4. Save the Plot
ggsave("figures/reproduced_figure_a.png", plot = plot_a, width = 6, height = 4, dpi = 300)

# 5. Show results
print(plot_a)
message("Success! Check your 'figures' folder.")

# 6. library 
library(patchwork)

# 7. create figure B (Daily Rate)
plot_b <-ggplot(data, aes(x= time, y= daily_rate, fill= treatment)) + 
  geom_col( position = "dodge") + 
  labs (title= "daily biogas rate", 
         x= "time(days)", 
         y= "Daily Rates(ml/day)",
         fill= "treatment") + 
           theme_minimal()
         
# 8. combine plots 
combined_plot <- plot_a + plot_b + 
plot_layout(guides="collect") +
plot_annotation(tag_levels="A")

# 9 . save final figure 
ggsave("figures/final_combined.png", plot= combined_plot, width = 10, height=5, dpi = 300 )

#10. result 
print(combined_plot)
