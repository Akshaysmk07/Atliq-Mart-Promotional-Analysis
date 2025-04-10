# 📊 AtliQ Mart Festive Promotion Analysis

**Domain:** FMCG  
**Function:** Sales / Promotions  

---

## 📝 Problem Statement

AtliQ Mart, a leading retail chain with over 50 supermarkets in Southern India, ran massive promotional campaigns during **Diwali 2023** and **Sankranti 2024** across all stores on their **AtliQ branded products**.

The **Sales Director**, Bruce Haryali, urgently needs insights into the effectiveness of these promotions to inform the next cycle of campaign planning. Since the Analytics Manager, Tony, is tied up with another project, he has entrusted this analysis to **Peter Pandey**, AtliQ's enthusiastic Data Analyst.

---

## 🎯 Objective

To analyze and evaluate:
- The performance of different promotion types
- Store-level and product-level impact
- Campaign-specific effectiveness (Diwali vs Sankranti)
- Strategic recommendations for future promotions

---

## 🧾 Data Sources

| File Name           | Description                              |
|---------------------|------------------------------------------|
| `dim_campaigns.csv` | Campaign details (Diwali, Sankranti, etc.) |
| `dim_products.csv`  | Product metadata (name, category, etc.)  |
| `dim_stores.csv`    | Store information (city, region, ID)     |
| `fact_events.csv`   | Transactional sales and promo event data |

---

## 🗃️ Data Model

![Data Model](res/data%20model.png)

A star schema with `fact_events` at the center, connected to:
- `dim_stores`
- `dim_products`
- `dim_campaigns`

---

## 📈 Dashboards

Visual analysis conducted through three key dashboards:

1. **Store Performance Analysis**  
   ![Store Performance](res/Store%20Performance%20Analysis%20.png) 

2. **Promotion Type Analysis**  
   ![Promotion Type](res/Promotion%20Type%20Analysis.png)

3. **Product & Category Analysis**  
   ![Product & Category](res/Product%20%26%20Category%20Analysis.png)

---

## ✅ Final Strategic Recommendations

### 1. Refine Promotion Strategy
- **Double Down On:**
  - 🛍️ **BOGOF** – Drives the highest volume (+372K units)
  - 💸 **₹500 Cashback** – Delivers the highest revenue (₹91M)
- **Reconsider/Optimize:**
  - ❌ **% Discount Offers (25–50%)** – Resulted in losses (both revenue & volume)
  - ✅ Focus on value-driven offers rather than margin-eating discounts

---

### 2. Target High-Potential Stores & States
- **Top Performing Stores:** `STMYS-1`, `STBLR-7`, `STCHE-4`  
- **Top Performing States:** Madurai, Chennai, Bengaluru  
- **Action Items:**
  - Replicate success in similar stores
  - Support low performers via:
    - Localized promotions
    - Product assortment improvements
    - Inventory & display optimizations

---

### 3. Focus on High-Impact Categories
- **Boost Focus On:**
  - 🔌 **Home Appliances** – +628% volume, +265% revenue
  - 🛒 **Combo1 & Grocery** – Strong metrics across board
- **Reduce or Reposition:**
  - 🧴 **Personal Care** – Negative IR (-34%), poor performance
  - Suggest bundling or product reformulation

---

### 4. Product-Level Optimization
- **Boost Inventory & Visibility:**
  - Chakki Atta, Sunflower Oil, LED Bulbs, Immersion Rods
- **Reevaluate or Phase Out:**
  - Sonamasuri Rice (₹-1.4M)
  - Fusion Containers
  - Low-turnover lotions

---

### 5. Campaign Planning Insights
- **Diwali:** Leverage high-revenue **cashback** promotions
- **Sankranti:** Focus on volume-driven **BOGOF** offers
- Use historical **campaign-product fit** to fine-tune targeting and offer planning

---

## 🚀 Deliverables

- 📊 Dashboards (3 Pages)
- 📁 Data Model
- ✅ Strategic Recommendation Summary

---

