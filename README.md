# Streaming Subscription Churn Analysis

End-to-end churn analysis for a fictional streaming subscription service — Python (cleaning + EDA), SQL (business questions), and Tableau (interactive dashboard) to uncover why customers cancel and which segments are highest risk.

> **Note:** This project uses a synthetic dataset modeled on streaming subscription services (not actual Netflix data), used to practice churn analysis end-to-end.

**Live Dashboard:** [View on Tableau Public](https://public.tableau.com/app/profile/rahaf.eltayeb/viz/streaming_churn_dashboard/Dashboard1?publish=yes)

![Dashboard Screenshot](https://github.com/Rahaf-Eltayeb/streaming-subscription-churn-analysis/blob/main/notebooks/dashboard_screenshot.png)

---

## Project Overview

A streaming subscription service has a 50.3% customer churn rate. This project investigates **why customers churn**, **which segments are highest risk**, and **how much revenue is at stake** — using a full pipeline from raw, messy data through to a published interactive dashboard.

## Tools Used

- **Python** (pandas) — data cleaning, exploratory data analysis
- **SQL** (SQL Server / T-SQL) — business question queries
- **Tableau Public** — interactive dashboard

## Repository Structure

```
streaming-subscription-churn-analysis/
├── data/
│   ├── raw/
│   │   └── streaming_churn_raw.xlsx
│   └── processed/
│       └── netflix_churn_clean.csv
├── notebooks/
│   ├── 01_data_cleaning.ipynb
│   └── 02_eda.ipynb
├── sql/
│   └── 03_sql_analysis.sql
├── tableau/
│   ├── streaming_churn_dashboard.twbx
│   └── dashboard_screenshot.png
└── README.md
```

## Data Cleaning

The raw dataset (5,000 customers, 14 columns) had two real data quality issues:

1. **`watch_hours` formatting bug** — values were stored as mixed time formats due to an Excel date-serialization glitch (e.g. `1900-01-01 11:31:12` instead of `11:31:12`). Fixed by parsing and converting to decimal hours.
2. **`avg_watch_time_per_day` was entirely broken** — investigated via row-to-row diffs and found every value was a mechanical autofill artifact (+1 per row, wrapping at 24), not real customer data. Dropped the column entirely rather than clean fabricated data.
3. One row (0.02% of data) had a genuinely missing value and was dropped.

Final clean dataset: **4,999 customers, 13 columns**, no nulls, no duplicates.

## Key Findings

### 1. Engagement — not demographics — predicts churn
| Metric | Stayed | Churned |
|---|---|---|
| Avg. watch hours | 10.3 | 5.8 |
| Avg. days since last login | 22 | 38 |

Age, region, and device showed **no meaningful relationship** with churn (all clustered within ~3 points of the 50% baseline). Correlation analysis confirmed: `last_login_days` (+0.47) and `watch_hours` (−0.36) were by far the strongest predictors — everything else was noise.

### 2. Risk segmentation: a 3.3% → 88.2% spread
Combining the two strongest predictors (low watch hours **and** long time since login) into a risk segment produced a dramatic separation:

| Risk Segment | Customers | Churn Rate |
|---|---|---|
| Low Risk | 1,479 | 3.3% |
| Medium Risk | 2,519 | 62.8% |
| High Risk | 1,001 | **88.2%** |

This means the business can identify its highest-risk 1,001 customers with high confidence, using just two simple engagement signals — before they cancel.

### 3. Churn rate by plan
| Plan | Churn Rate |
|---|---|
| Basic | 61.8% |
| Standard | 45.5% |
| Premium | 43.7% |

### 4. Revenue at risk tells a different story than churn rate
| Plan | Churned Customers | Monthly Revenue at Risk |
|---|---|---|
| Premium | 740 | **$13,312.60** |
| Standard | 748 | $10,464.52 |
| Basic | 1,027 | $9,232.73 |

Despite having the *lowest* churn rate, **Premium accounts for the most revenue at risk** — each Premium customer is worth more, so losing fewer of them still costs more overall. A churn-rate-only view would have misdirected priorities toward Basic.

### 5. Payment method shows a moderate effect
Crypto (59.7%) and Gift Card (57.8%) users churn more than Credit Card (43.6%) and Debit Card (43.7%) users — a real but secondary signal compared to engagement.

## Dashboard

The interactive Tableau dashboard lets you filter by Subscription Plan, Risk Segment, Region, and Device, and includes:
- KPI summary (customers, churn rate, MRR, MRR at risk)
- Churn rate by risk segment (color-coded)
- Revenue at risk by plan
- Engagement comparison (watch hours & last login, churned vs. stayed)
- Popularity breakdown (top plan, device, genre, payment method)


