## ============================================================
## Chapter Four Analysis
## Awareness and Utilization of Counselling Services at UDSM
## ============================================================

suppressMessages(library(dplyr))
suppressMessages(library(ggplot2))
suppressMessages(library(scales))

options(scipen = 999)

df <- read.csv("survey_data.csv", stringsAsFactors = FALSE, na.strings = "")

cat("Rows:", nrow(df), "\n")

## ---------- 1. RECODING ----------

likert_map <- c("Strong disagree" = 1, "Disagree" = 2, "Neutral" = 3,
                "Agree" = 4, "Strong agree" = 5)

df$UnderstandTypes_n <- likert_map[df$Understand.Types]
df$KnowBenefits_n    <- likert_map[df$Know.Benefits]
df$InfoAccessible_n  <- likert_map[df$Info.Accessible]
df$UniPromotes_n     <- likert_map[df$Uni.Promotes]

## Composite Awareness Score (mean of 5 awareness items, scale 1-5)
df$AwarenessScore <- rowMeans(
  df[, c("Awareness.Rating", "UnderstandTypes_n", "KnowBenefits_n",
         "InfoAccessible_n", "UniPromotes_n")], na.rm = TRUE)

## Awareness Level (categorical) via tertiles
q <- quantile(df$AwarenessScore, probs = c(1/3, 2/3), na.rm = TRUE)
df$AwarenessLevel <- cut(df$AwarenessScore,
                          breaks = c(-Inf, q[1], q[2], Inf),
                          labels = c("Low", "Moderate", "High"))

df$EverUsed <- factor(df$Ever.Used, levels = c("No", "Yes"))
df$Gender   <- factor(df$Gender)
df$YearOfStudy <- factor(df$Year.of.Study,
                          levels = c("First year", "Second year", "Third year", "Fourth Year or above"))
df$College <- factor(df$College)

cat("\nTertile cut points for Awareness Score:\n"); print(q)

## ---------- 2. DESCRIPTIVE TABLES ----------

cat("\n--- Table 1: Demographic profile ---\n")
demo_tab <- function(varname, data=df){
  t <- table(data[[varname]])
  data.frame(Category = names(t), n = as.integer(t),
             Percent = round(100*as.integer(t)/sum(t),1))
}
gender_tab <- demo_tab("Gender")
year_tab   <- demo_tab("YearOfStudy")
college_tab<- demo_tab("College")
age_tab    <- demo_tab("Age")
print(gender_tab); print(age_tab); print(year_tab); print(college_tab)

cat("\n--- Table 2: Awareness & Utilization descriptive ---\n")
everheard_tab <- demo_tab("Ever.Heard")
everused_tab  <- demo_tab("Ever.Used")
awarelvl_tab  <- demo_tab("AwarenessLevel")
print(everheard_tab); print(everused_tab); print(awarelvl_tab)
cat("Mean Awareness Score:", round(mean(df$AwarenessScore, na.rm=TRUE),2),
    " SD:", round(sd(df$AwarenessScore, na.rm=TRUE),2), "\n")

write.csv(gender_tab, "tab_gender.csv", row.names = FALSE)
write.csv(age_tab, "tab_age.csv", row.names = FALSE)
write.csv(year_tab, "tab_year.csv", row.names = FALSE)
write.csv(college_tab, "tab_college.csv", row.names = FALSE)
write.csv(everheard_tab, "tab_everheard.csv", row.names = FALSE)
write.csv(everused_tab, "tab_everused.csv", row.names = FALSE)
write.csv(awarelvl_tab, "tab_awarelvl.csv", row.names = FALSE)

## ---------- 3. OBJECTIVE 1: Awareness vs Utilization (Chi-square) ----------

cat("\n--- Objective 1: Chi-square test: AwarenessLevel x EverUsed ---\n")
ct1 <- table(df$AwarenessLevel, df$EverUsed)
print(ct1)
chi1 <- chisq.test(ct1)
print(chi1)
cat("Expected counts:\n"); print(chi1$expected)

# utilization rate by awareness level
util_by_level <- df %>% group_by(AwarenessLevel) %>%
  summarise(n = n(), Used = sum(EverUsed=="Yes"),
            UtilRate = round(100*Used/n,1))
print(util_by_level)
write.csv(util_by_level, "tab_util_by_level.csv", row.names=FALSE)

ct1_df <- as.data.frame(ct1)
names(ct1_df) <- c("AwarenessLevel","EverUsed","Freq")
write.csv(ct1_df, "tab_chisq_contingency.csv", row.names = FALSE)
cat("CHI1_STAT:", round(chi1$statistic,3), "\n")
cat("CHI1_DF:", chi1$parameter, "\n")
cat("CHI1_P:", signif(chi1$p.value,4), "\n")

# point-biserial / logistic single-predictor as supplementary check
glm0 <- glm(EverUsed ~ AwarenessScore, data = df, family = binomial)
cat("\nSimple logistic (EverUsed ~ AwarenessScore):\n")
print(summary(glm0)$coefficients)
cat("Odds ratio per 1-pt increase in Awareness Score:", round(exp(coef(glm0)[2]),3), "\n")

## ---------- 4. OBJECTIVE 2: Awareness differences by demographics ----------

cat("\n--- Objective 2a: t-test AwarenessScore by Gender ---\n")
t1 <- t.test(AwarenessScore ~ Gender, data = df)
print(t1)

gender_means <- df %>% group_by(Gender) %>%
  summarise(n=n(), Mean=round(mean(AwarenessScore,na.rm=TRUE),2),
            SD=round(sd(AwarenessScore,na.rm=TRUE),2))
print(gender_means)
write.csv(gender_means, "tab_gender_means.csv", row.names=FALSE)

cat("\n--- Objective 2b: ANOVA AwarenessScore by Year of Study ---\n")
aov1 <- aov(AwarenessScore ~ YearOfStudy, data = df)
print(summary(aov1))

year_means <- df %>% group_by(YearOfStudy) %>%
  summarise(n=n(), Mean=round(mean(AwarenessScore,na.rm=TRUE),2),
            SD=round(sd(AwarenessScore,na.rm=TRUE),2))
print(year_means)
write.csv(year_means, "tab_year_means.csv", row.names=FALSE)

av_sum <- summary(aov1)[[1]]
cat("ANOVA_F:", round(av_sum$`F value`[1],3), "\n")
cat("ANOVA_DF1:", av_sum$Df[1], " DF2:", av_sum$Df[2], "\n")
cat("ANOVA_P:", signif(av_sum$`Pr(>F)`[1],4), "\n")
cat("TTEST_t:", round(t1$statistic,3), " df:", round(t1$parameter,2),
    " p:", signif(t1$p.value,4), "\n")

## ---------- 5. OBJECTIVE 3: Perceptions / Barriers & multivariate model ----------

cat("\n--- Objective 3a: Barriers to utilization (non-users only, n=181) ---\n")
barrier_cols <- c("Barrier..Not.aware","Barrier..Lack.of.time","Barrier..Lack.of.trust",
                   "Barrier..Handle.alone","Barrier..Friends.family",
                   "Barrier..Not.accessible","Barrier..Other")
nonusers <- df %>% filter(EverUsed == "No")
barrier_freq <- sapply(barrier_cols, function(c) sum(as.numeric(nonusers[[c]]), na.rm=TRUE))
barrier_lab <- c("Not aware of services","Lack of time","Lack of trust / confidentiality concerns",
                  "Prefer to handle issues alone","Prefer friends/family support",
                  "Services not accessible","Other reasons")
barrier_tab <- data.frame(Barrier = barrier_lab, n = as.integer(barrier_freq),
                           Percent = round(100*barrier_freq/nrow(nonusers),1))
barrier_tab <- barrier_tab[order(-barrier_tab$n),]
print(barrier_tab)
write.csv(barrier_tab, "tab_barriers.csv", row.names=FALSE)

cat("\n--- Objective 3b: Multivariate logistic regression of Ever Used ---\n")
## Year of Study is dropped from this model: the First-Year cell (n=2, 0 users)
## produces quasi-complete separation; Year-level differences are already
## addressed under Objective/RQ 2 via ANOVA on Awareness Score.
glm1 <- glm(EverUsed ~ AwarenessScore + Gender, data = df, family = binomial)
print(summary(glm1))
or_tab <- data.frame(
  Predictor = names(coef(glm1)),
  Estimate = round(coef(glm1),3),
  OR = round(exp(coef(glm1)),3),
  p_value = round(summary(glm1)$coefficients[,4],4)
)
print(or_tab)
write.csv(or_tab, "tab_logit.csv", row.names=FALSE)
cat("Null deviance:", round(glm1$null.deviance,2), " Residual deviance:", round(glm1$deviance,2), "\n")
cat("AIC:", round(AIC(glm1),2), "\n")

## ---------- 6. PLOTS (3 total) ----------

theme_set(theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face="bold", size=12.5, margin = margin(b=10)),
        panel.grid.minor = element_blank(),
        plot.margin = margin(t=10, r=14, b=8, l=8)))

## Plot 1: Utilization rate by Awareness Level (Objective 1 / RQ1)
p1 <- ggplot(util_by_level, aes(x = AwarenessLevel, y = UtilRate, fill = AwarenessLevel)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  geom_text(aes(label = paste0(UtilRate,"%\n(n=",Used,"/",n,")")), vjust = -0.3, size = 3.6) +
  scale_fill_manual(values = c("Low"="#BFD7EA","Moderate"="#5B9BD5","High"="#1F4E79")) +
  scale_y_continuous(limits = c(0, max(util_by_level$UtilRate)*1.35), labels = function(x) paste0(x,"%")) +
  labs(title = "Utilization Rate of Counselling Services\nby Awareness Level",
       x = "Awareness Level", y = "Utilization Rate (%)")
ggsave("plot1_utilization_by_awareness.png", p1, width = 6.5, height = 4.5, dpi = 300)

## Plot 2: Awareness Score by Gender and Year of Study (Objective 2 / RQ2)
p2 <- ggplot(df, aes(x = YearOfStudy, y = AwarenessScore, fill = Gender)) +
  geom_boxplot(outlier.size = 1, alpha = 0.85) +
  scale_fill_manual(values = c("Female"="#E89AAE","Male"="#5B9BD5")) +
  labs(title = "Awareness Score by Gender and Year of Study",
       x = "Year of Study", y = "Composite Awareness Score (1-5)") +
  theme(axis.text.x = element_text(angle = 20, hjust = 1))
ggsave("plot2_awareness_by_gender_year.png", p2, width = 7, height = 4.7, dpi = 300)

## Plot 3: Barriers to utilization among non-users (Objective 3 / RQ3)
barrier_tab$Barrier <- factor(barrier_tab$Barrier, levels = rev(barrier_tab$Barrier))
p3 <- ggplot(barrier_tab, aes(x = Barrier, y = Percent)) +
  geom_col(fill = "#1F4E79", width = 0.65) +
  geom_text(aes(label = paste0(Percent,"%")), hjust = -0.15, size = 3.6) +
  coord_flip() +
  scale_y_continuous(limits = c(0, max(barrier_tab$Percent)*1.25)) +
  labs(title = "Reported Barriers to Utilization\nAmong Non-Users (n = 181)",
       x = NULL, y = "Percent of Non-Users (%)")
ggsave("plot3_barriers.png", p3, width = 7, height = 4.3, dpi = 300)

cat("\nDone. Plots saved.\n")
