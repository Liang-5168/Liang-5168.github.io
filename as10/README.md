
---

## 二、實際「怎麼繳交」比較安全？

### 1️⃣ 在自己電腦上確認

1. 打開 **RStudio**（或你用的 R IDE）。
2. 新增一個 R Markdown：  
   - File → New File → R Markdown… → 選「Document」，按 OK。  
   - 刪掉預設內容，改貼上上面這整份 `.Rmd`。
3. 存檔，例如：`border_scroll_story.Rmd`。  
4. 按 Knit（編譯成 HTML）看一下成果，確認畫面 OK。

> 注意：影片要跟 knit 出來的 HTML 放在**同一個資料夾**，檔名要是：  
> `C0564.mp4`, `C0581.mp4`, `C0583.mp4`, `C0595.mp4`。

---

### 2️⃣ 如果作業系統一次只能上傳一個檔案

最常見老師說的那句：

> 「不能同時上傳兩個！？那可以試試上傳 RMD，然後在評論中留下連結」

你就可以這樣做：

1. **上傳檔案的地方：**
   - 上傳這個 `border_scroll_story.Rmd`（你的原始碼）。
2. **讓老師看到實際網頁：**
   - 把 knit 出來的 HTML + 影片，放到一個可以分享的地方，例如：
     - GitHub Pages  
     - Netlify  
     - 或直接壓縮成 zip 傳到 Google Drive，設「有連結的人可看」  
   - 複製那個網址
3. **在作業平台的「留言／評論」區打：**

   ```text
   Scroll story demo 連結：
   https://xxxxx（你的 HTML 頁面或雲端壓縮檔連結）

   本次作業的 R Markdown 原始碼已上傳為 border_scroll_story.Rmd。

